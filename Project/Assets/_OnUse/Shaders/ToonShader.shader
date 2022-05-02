// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BallShader"
{
	Properties
	{
		_ASEOutlineColor( "Outline Color", Color ) = (0,0,0,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 0
		_BaseColor("BaseColor", Color) = (0,1,0.2531309,0)
		_Step1Border("Step1Border", Range( 0 , 1)) = 0.57
		_Step2Border("Step2Border", Float) = 0.83
		_2ndBorderIntensity("2ndBorderIntensity", Range( 0 , 1)) = 0.48
		_NoiseAbundance("NoiseAbundance", Range( 0 , 1)) = 0.09
		_NoiseTiling("NoiseTiling", Float) = 23.09
		_Float0("Float 0", Float) = 1
		_Shade3Intensity("Shade3Intensity", Float) = 0.31
		_NormalMap("NormalMap", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		float4 _ASEOutlineColor;
		float _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _ASEOutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _BaseColor;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _Step1Border;
		uniform float _Step2Border;
		uniform float _2ndBorderIntensity;
		uniform float _Float0;
		uniform float _Shade3Intensity;
		uniform float _NoiseTiling;
		uniform float _NoiseAbundance;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode109 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi114 = gi;
			float3 diffNorm114 = WorldNormalVector( i , tex2DNode109 );
			gi114 = UnityGI_Base( data, 1, diffNorm114 );
			float3 indirectDiffuse114 = gi114.indirect.diffuse + diffNorm114 * 0.0001;
			float dotResult79 = dot( float4( ase_worldlightDir , 0.0 ) , ( float4( (WorldNormalVector( i , tex2DNode109 )) , 0.0 ) * ( ase_lightColor * float4( ( indirectDiffuse114 + ase_lightAtten ) , 0.0 ) ) ) );
			float temp_output_86_0 = saturate( ( 1.0 - dotResult79 ) );
			float temp_output_82_0 = step( temp_output_86_0 , _Step1Border );
			float temp_output_84_0 = step( temp_output_86_0 , _Step2Border );
			float temp_output_94_0 = ( temp_output_82_0 + ( ( temp_output_84_0 - temp_output_82_0 ) * _2ndBorderIntensity ) + ( ( step( temp_output_86_0 , _Float0 ) - temp_output_84_0 ) * _Shade3Intensity ) );
			float simplePerlin2D95 = snoise( i.uv_texcoord*_NoiseTiling );
			simplePerlin2D95 = simplePerlin2D95*0.5 + 0.5;
			c.rgb = ( _BaseColor * ( temp_output_94_0 + ( step( simplePerlin2D95 , _NoiseAbundance ) * temp_output_94_0 ) ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;0;1920;1019;-1153.046;135.7143;1.524417;False;False
Node;AmplifyShaderEditor.SamplerNode;109;-10.99599,544.884;Inherit;True;Property;_NormalMap;NormalMap;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;110;397.6035,1031.22;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;114;413.8748,843.53;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;113;610.0204,687.8022;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;115;721.9753,829.2304;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;858.4755,743.4305;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;80;675.4761,463.5724;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;78;808.71,207.3274;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;975.8928,506.9886;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;79;1155.127,242.1454;Inherit;True;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;81;1379.588,291.2719;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;86;1536.577,292.5765;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;1592.783,582.0749;Inherit;False;Property;_Step2Border;Step2Border;2;0;Create;True;0;0;0;False;0;False;0.83;0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;1565.213,89.01416;Inherit;False;Property;_Step1Border;Step1Border;1;0;Create;True;0;0;0;False;0;False;0.57;0.57;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;1586.682,907.2265;Inherit;False;Property;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;82;1840.663,238.4677;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;102;1833.279,758.3972;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;84;1777.146,476.8273;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;87;2151.995,485.5467;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;2271.268,699.0675;Inherit;False;Property;_2ndBorderIntensity;2ndBorderIntensity;3;0;Create;True;0;0;0;False;0;False;0.48;0.48;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;2341.072,1054.005;Inherit;False;Property;_Shade3Intensity;Shade3Intensity;7;0;Create;True;0;0;0;False;0;False;0.31;0.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;104;2154.248,800.5879;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;98;2918.71,681.986;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;99;2985.747,832.3918;Inherit;False;Property;_NoiseTiling;NoiseTiling;5;0;Create;True;0;0;0;False;0;False;23.09;23.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;2564.892,800.6905;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;2514.072,500.5675;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;3312.24,881.802;Inherit;False;Property;_NoiseAbundance;NoiseAbundance;4;0;Create;True;0;0;0;False;0;False;0.09;0.09;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;95;3227.702,648.0475;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;2964.248,242.1716;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;100;3527.311,648.4291;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;3705.103,519.5462;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;3737.024,235.4639;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;3579.521,-30.61167;Inherit;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;0,1,0.2531309,0;0,1,0.2531309,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;3885.859,186.5988;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4363.53,44.66566;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;BallShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;True;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;114;0;109;0
WireConnection;115;0;114;0
WireConnection;115;1;110;0
WireConnection;116;0;113;0
WireConnection;116;1;115;0
WireConnection;80;0;109;0
WireConnection;90;0;80;0
WireConnection;90;1;116;0
WireConnection;79;0;78;0
WireConnection;79;1;90;0
WireConnection;81;0;79;0
WireConnection;86;0;81;0
WireConnection;82;0;86;0
WireConnection;82;1;83;0
WireConnection;102;0;86;0
WireConnection;102;1;103;0
WireConnection;84;0;86;0
WireConnection;84;1;85;0
WireConnection;87;0;84;0
WireConnection;87;1;82;0
WireConnection;104;0;102;0
WireConnection;104;1;84;0
WireConnection;105;0;104;0
WireConnection;105;1;106;0
WireConnection;88;0;87;0
WireConnection;88;1;92;0
WireConnection;95;0;98;0
WireConnection;95;1;99;0
WireConnection;94;0;82;0
WireConnection;94;1;88;0
WireConnection;94;2;105;0
WireConnection;100;0;95;0
WireConnection;100;1;101;0
WireConnection;108;0;100;0
WireConnection;108;1;94;0
WireConnection;107;0;94;0
WireConnection;107;1;108;0
WireConnection;93;0;77;0
WireConnection;93;1;107;0
WireConnection;0;13;93;0
ASEEND*/
//CHKSM=5771BBF17E054E425F38098B6229C89C94431236