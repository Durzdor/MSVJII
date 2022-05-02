// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "IceShader"
{
	Properties
	{
		_FrozenAmount("FrozenAmount", Range( 0 , 1)) = 0
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 5.2
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_FresnelScale("FresnelScale", Float) = 3
		_FresnelPower("FresnelPower", Range( 0.001 , 10)) = 2.5
		_IceTint("IceTint", Color) = (0.4669811,1,0.9418058,0)
		_TextureSample6("Texture Sample 6", 2D) = "bump" {}
		_DeformationIntensity("DeformationIntensity", Float) = 0
		_TopBallMaxBloat("TopBallMaxBloat", Range( 0 , 3)) = 0
		_IceMaskTile("IceMaskTile", Float) = 1
		_IceMaskOffset("IceMaskOffset", Float) = 0.5
		_TextureSample5("Texture Sample 5", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _FrozenAmount;
		uniform sampler2D _TextureSample5;
		uniform float _IceMaskTile;
		uniform float _IceMaskOffset;
		uniform float _TopBallMaxBloat;
		uniform float _DeformationIntensity;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _IceTint;
		uniform sampler2D _TextureSample6;
		uniform float4 _TextureSample6_ST;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float IceSlider5 = _FrozenAmount;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float4 appendResult29 = (float4(ase_worldNormal.x , ase_worldNormal.y , 0.0 , 0.0));
			float4 OffsetMask35 = tex2Dlod( _TextureSample5, float4( (( _IceMaskTile * appendResult29 )*1.0 + _IceMaskOffset).xy, 0, 0.0) );
			float YMaskTop45 = saturate( ( ase_vertexNormal.y * 3.0 ) );
			float4 VertexOffset60 = ( float4( ase_vertexNormal , 0.0 ) * saturate( ( ( IceSlider5 * ( float4( ase_vertexNormal , 0.0 ) * OffsetMask35 ) ) + ( YMaskTop45 * (0.0 + (IceSlider5 - 0.0) * (_TopBallMaxBloat - 0.0) / (1.0 - 0.0)) ) ) ) * _DeformationIntensity );
			v.vertex.xyz += VertexOffset60.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color1 = IsGammaSpace() ? float4(0,1,0.8666668,0) : float4(0,1,0.7230555,0);
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float4 lerpResult8 = lerp( color1 , tex2D( _TextureSample1, uv_TextureSample1 ) , float4( 0,0,0,0 ));
			float IceSlider5 = _FrozenAmount;
			float4 lerpResult11 = lerp( lerpResult8 , tex2D( _TextureSample1, uv_TextureSample1 ) , IceSlider5);
			float4 Emissiojn113 = lerpResult11;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV16 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode16 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV16, _FresnelPower ) );
			float4 Emission223 = ( ( ( tex2D( _TextureSample1, uv_TextureSample1 ) * fresnelNode16 ) * IceSlider5 ) * _IceTint );
			float2 uv_TextureSample6 = i.uv_texcoord * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
			o.Emission = ( ( Emissiojn113 + Emission223 ) * UnpackNormal( tex2D( _TextureSample6, uv_TextureSample6 ) ).b ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

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
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
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
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
0;497;1110;504;5576.813;496.3669;3.084841;True;False
Node;AmplifyShaderEditor.CommentaryNode;38;-3184.288,-1184.069;Inherit;False;1373.648;336;Ice Mask Offset;7;31;30;29;32;33;34;35;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;28;-3425.614,-866.0362;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;31;-3112.367,-1134.069;Inherit;False;Property;_IceMaskTile;IceMaskTile;15;0;Create;True;0;0;0;False;0;False;1;2.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-3134.288,-1044.393;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2839.509,-946.6086;Inherit;False;Property;_IceMaskOffset;IceMaskOffset;16;0;Create;True;0;0;0;False;0;False;0.5;0.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2917.367,-1091.069;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;46;-3098.595,-763.5093;Inherit;False;1091.763;627.6178;Y masks;8;41;36;39;42;40;44;45;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalVertexDataNode;72;-3881.524,-124.1525;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;6;-4127.485,-398.5115;Inherit;False;583.552;181.1998;Ice Slider;2;4;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;32;-2680.367,-1097.069;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4092.554,-330.8048;Inherit;False;Property;_FrozenAmount;FrozenAmount;1;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-2398.367,-1104.069;Inherit;True;Property;_TextureSample5;Texture Sample 5;17;0;Create;True;0;0;0;False;0;False;-1;None;6862774a2bf8b174fa4e56cf98fa9370;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-3027.896,-403.0027;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-2049.64,-1062.872;Inherit;False;OffsetMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1282.764,618.5483;Inherit;False;Property;_FresnelPower;FresnelPower;9;0;Create;True;0;0;0;False;0;False;2.5;3;0.001;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;44;-2538.71,-399.9607;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1303.764,518.5483;Inherit;False;Property;_FresnelScale;FresnelScale;8;0;Create;True;0;0;0;False;0;False;3;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-3790.711,-334.6592;Inherit;False;IceSlider;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-3598.541,577.3392;Inherit;False;5;IceSlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-2249.832,-393.8915;Inherit;True;YMaskTop;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;16;-971.3757,466.9371;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-3852.632,255.0091;Inherit;False;35;OffsetMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;14;-1098.744,232.5292;Inherit;True;Property;_TextureSample3;Texture Sample 3;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;9;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;75;-3499.982,708.0374;Inherit;False;Property;_TopBallMaxBloat;TopBallMaxBloat;14;0;Create;True;0;0;0;False;0;False;0;0.04306813;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-676.3757,303.9371;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-3340.961,436.2674;Inherit;False;45;YMaskTop;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-3576.526,172.4914;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-1422.161,-409.3304;Inherit;False;Constant;_Color0;Color 0;0;1;[HDR];Create;True;0;0;0;False;0;False;0,1,0.8666668,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;20;-676.6313,466.5811;Inherit;False;5;IceSlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-1472.844,-214.9682;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;0;False;0;False;-1;None;d0f3df0139396444b8826a7386e7d5a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;53;-3351.54,556.5394;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-3245.344,92.62056;Inherit;False;5;IceSlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-492.0314,332.6811;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;10;-972.0512,-192.4137;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;9;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;8;-1029.564,-318.0024;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-668.4095,14.96186;Inherit;False;5;IceSlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-3046.344,154.6206;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;-515.4314,535.4808;Inherit;False;Property;_IceTint;IceTint;10;0;Create;True;0;0;0;False;0;False;0.4669811,1,0.9418058,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-3077.959,464.9927;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2838.362,347.4517;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-278.8315,339.1812;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;-488.4803,-289.9711;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;57;-2615.818,357.1839;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-108.5313,371.6811;Inherit;False;Emission2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;58;-2689.655,170.4638;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-211.9572,-271.0312;Inherit;False;Emissiojn1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-2522.674,484.5064;Inherit;False;Property;_DeformationIntensity;DeformationIntensity;13;0;Create;True;0;0;0;False;0;False;0;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2376.14,345.4514;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;159.9761,-124.727;Inherit;False;23;Emission2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;161.3743,-253.3638;Inherit;False;13;Emissiojn1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;70;527.5023,11.28141;Inherit;True;Property;_TextureSample6;Texture Sample 6;12;0;Create;True;0;0;0;False;0;False;-1;None;5b58b39172978db498bf164806d10904;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;695.0784,-175.1092;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-2180.039,368.9164;Inherit;False;VertexOffset;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;41;-2489.807,-656.0581;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;-201.7664,-607.9136;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-3858.31,145.3911;Inherit;False;42;Ymask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-2255.344,-673.1381;Inherit;True;Ymask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2667.777,-660.5179;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;945.3131,-59.80722;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-2901.282,-713.5093;Inherit;False;5;IceSlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;1066.844,93.08504;Inherit;False;60;VertexOffset;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-21.6344,-576.6189;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2;-687.8223,-816.6957;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;73daeadbe0065014f8bdeca883bc64a2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;26;-363.2312,-432.0152;Inherit;False;5;IceSlider;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-3048.595,-655.5189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-679.0719,-613.397;Inherit;True;Property;_TextureSample4;Texture Sample 4;11;0;Create;True;0;0;0;False;0;False;-1;None;5b58b39172978db498bf164806d10904;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1362.662,-178.4551;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;IceShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;5.2;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;2;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;28;1
WireConnection;29;1;28;2
WireConnection;30;0;31;0
WireConnection;30;1;29;0
WireConnection;32;0;30;0
WireConnection;32;2;33;0
WireConnection;34;1;32;0
WireConnection;37;0;72;2
WireConnection;35;0;34;0
WireConnection;44;0;37;0
WireConnection;5;0;4;0
WireConnection;45;0;44;0
WireConnection;16;2;17;0
WireConnection;16;3;18;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;48;0;72;0
WireConnection;48;1;49;0
WireConnection;53;0;52;0
WireConnection;53;4;75;0
WireConnection;19;0;15;0
WireConnection;19;1;20;0
WireConnection;8;0;1;0
WireConnection;8;1;9;0
WireConnection;50;0;51;0
WireConnection;50;1;48;0
WireConnection;54;0;55;0
WireConnection;54;1;53;0
WireConnection;56;0;50;0
WireConnection;56;1;54;0
WireConnection;21;0;19;0
WireConnection;21;1;22;0
WireConnection;11;0;8;0
WireConnection;11;1;10;0
WireConnection;11;2;12;0
WireConnection;57;0;56;0
WireConnection;23;0;21;0
WireConnection;13;0;11;0
WireConnection;59;0;58;0
WireConnection;59;1;57;0
WireConnection;59;2;69;0
WireConnection;62;0;63;0
WireConnection;62;1;64;0
WireConnection;60;0;59;0
WireConnection;41;0;39;0
WireConnection;24;0;2;0
WireConnection;24;1;25;0
WireConnection;24;2;26;0
WireConnection;42;0;41;0
WireConnection;39;0;40;0
WireConnection;39;1;36;0
WireConnection;71;0;62;0
WireConnection;71;1;70;3
WireConnection;27;0;24;0
WireConnection;36;0;72;2
WireConnection;0;2;71;0
WireConnection;0;11;61;0
ASEEND*/
//CHKSM=AEC778920A654CF665DE8385232C0734DE9E8C1F