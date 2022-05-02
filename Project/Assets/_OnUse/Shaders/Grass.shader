// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Grass"
{
	Properties
	{
		_Grass01_Albedo("Grass01_Albedo", 2D) = "white" {}
		_Grass01_Normal("Grass01_Normal", 2D) = "bump" {}
		_Grass01_Occlusion("Grass01_Occlusion", 2D) = "white" {}
		_TipEffectIntensity("TipEffectIntensity", Float) = 0.5
		_WindDir("WindDir", Vector) = (1,0,0,0)
		_WindSpeed("WindSpeed", Float) = 0.3
		_MovementIntensity("MovementIntensity", Float) = 0.68
		_WindDirection("WindDirection", Vector) = (1,1,0,0)
		_WindStrength("WindStrength", Float) = 1.13
		_TipEffectFalloff("TipEffectFalloff", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float3 _WindDir;
		uniform float _TipEffectFalloff;
		uniform float _TipEffectIntensity;
		uniform float _WindSpeed;
		uniform float2 _WindDirection;
		uniform float _MovementIntensity;
		uniform float _WindStrength;
		uniform sampler2D _Grass01_Normal;
		uniform float4 _Grass01_Normal_ST;
		uniform sampler2D _Grass01_Albedo;
		uniform float4 _Grass01_Albedo_ST;
		uniform sampler2D _Grass01_Occlusion;
		uniform float4 _Grass01_Occlusion_ST;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime8 = _Time.y * _WindSpeed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult47 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner48 = ( mulTime8 * _WindDirection + appendResult47);
			float simplePerlin2D12 = snoise( panner48*_MovementIntensity );
			simplePerlin2D12 = simplePerlin2D12*0.5 + 0.5;
			v.vertex.xyz += ( _WindDir * ( pow( ase_vertex3Pos.y , _TipEffectFalloff ) * _TipEffectIntensity ) * saturate( ( ( simplePerlin2D12 - 0.4 ) * _WindStrength ) ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Grass01_Normal = i.uv_texcoord * _Grass01_Normal_ST.xy + _Grass01_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Grass01_Normal, uv_Grass01_Normal ) );
			float2 uv_Grass01_Albedo = i.uv_texcoord * _Grass01_Albedo_ST.xy + _Grass01_Albedo_ST.zw;
			float4 tex2DNode2 = tex2D( _Grass01_Albedo, uv_Grass01_Albedo );
			o.Albedo = tex2DNode2.rgb;
			float2 uv_Grass01_Occlusion = i.uv_texcoord * _Grass01_Occlusion_ST.xy + _Grass01_Occlusion_ST.zw;
			o.Occlusion = tex2D( _Grass01_Occlusion, uv_Grass01_Occlusion ).r;
			o.Alpha = tex2DNode2.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v, customInputData );
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
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
0;24;1906;995;3066.842;1030.221;2.555938;True;False
Node;AmplifyShaderEditor.CommentaryNode;5;-2355.784,1088.417;Inherit;False;1593.304;493.8015;Wind Sway;12;17;15;14;13;12;10;46;47;48;7;8;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;46;-2334.9,1119.738;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;7;-2205.429,1502.432;Inherit;False;Property;_WindSpeed;WindSpeed;5;0;Create;True;0;0;0;False;0;False;0.3;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;8;-1997.582,1476.938;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-2148.635,1125.001;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;9;-2124.102,1344.666;Inherit;False;Property;_WindDirection;WindDirection;7;0;Create;True;0;0;0;False;0;False;1,1;1,0.4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;10;-1801.057,1456.989;Inherit;False;Property;_MovementIntensity;MovementIntensity;6;0;Create;True;0;0;0;False;0;False;0.68;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;48;-1831.8,1137.944;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;12;-1572.889,1144.448;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1482.911,1445.221;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;6;-1569.859,488.3422;Inherit;False;991.6638;431.4902;TopMask;7;24;20;26;27;29;30;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1547.763,793.5317;Inherit;False;Property;_TipEffectFalloff;TipEffectFalloff;9;0;Create;True;0;0;0;False;0;False;2;2.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-1273.425,1146.83;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;27;-1549.778,595.9244;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1149.913,1473.888;Inherit;False;Property;_WindStrength;WindStrength;8;0;Create;True;0;0;0;False;0;False;1.13;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-989.2372,1163.587;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;29;-1335.883,607.7651;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1279.166,831.131;Inherit;False;Property;_TipEffectIntensity;TipEffectIntensity;3;0;Create;True;0;0;0;False;0;False;0.5;1.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;26;-926.4161,507.6646;Inherit;False;Property;_WindDir;WindDir;4;0;Create;True;0;0;0;False;0;False;1,0,0;1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1077.894,648.6746;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;-800.9846,956.2159;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-737.1964,604.1199;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;4;-329.114,0.006804943;Inherit;True;Property;_Grass01_Occlusion;Grass01_Occlusion;2;0;Create;True;0;0;0;False;0;False;-1;e19ec2a1f2c1df340aabaaaf1d8b6741;e19ec2a1f2c1df340aabaaaf1d8b6741;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-330.414,-187.1932;Inherit;True;Property;_Grass01_Normal;Grass01_Normal;1;0;Create;True;0;0;0;False;0;False;-1;e031e487d0803524b981dad56a1d90c6;e031e487d0803524b981dad56a1d90c6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-336.9141,-382.1932;Inherit;True;Property;_Grass01_Albedo;Grass01_Albedo;0;0;Create;True;0;0;0;False;0;False;-1;4188a9f5cacb8a54aa76e21640ad6576;4188a9f5cacb8a54aa76e21640ad6576;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;603.3271,-145.2001;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Grass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;0
WireConnection;47;0;46;1
WireConnection;47;1;46;3
WireConnection;48;0;47;0
WireConnection;48;2;9;0
WireConnection;48;1;8;0
WireConnection;12;0;48;0
WireConnection;12;1;10;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;17;0;14;0
WireConnection;17;1;15;0
WireConnection;29;0;27;2
WireConnection;29;1;30;0
WireConnection;31;0;29;0
WireConnection;31;1;20;0
WireConnection;22;0;17;0
WireConnection;24;0;26;0
WireConnection;24;1;31;0
WireConnection;24;2;22;0
WireConnection;0;0;2;0
WireConnection;0;1;3;0
WireConnection;0;5;4;1
WireConnection;0;9;2;4
WireConnection;0;11;24;0
ASEEND*/
//CHKSM=F8228CAD5C5EA200DD59F3140D95158888785ABA