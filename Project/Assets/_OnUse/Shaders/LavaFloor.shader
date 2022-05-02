// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LavaFloor"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		[HDR]_AlbedoTint("AlbedoTint", Color) = (0,0,0,0)
		[HDR]_EmissionTint("EmissionTint", Color) = (0,0,0,0)
		_GlowTime("GlowTime", Float) = 0
		_MinGlowIntensity("MinGlowIntensity", Float) = 0
		_MaxGlowIntensity("MaxGlowIntensity", Float) = 0
		_FresnelBias("FresnelBias", Range( 0 , 1)) = 0
		_FresnelPower("FresnelPower", Float) = 0
		[HDR]_FresnelTint("FresnelTint", Color) = (0,0,0,0)
		_BallEffectRadius("BallEffectRadius", Range( 0.001 , 10)) = 0
		[HDR]_BallEffectEmissionColor("BallEffectEmissionColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _AlbedoTint;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float4 _EmissionTint;
		uniform float _GlowTime;
		uniform float _MinGlowIntensity;
		uniform float _MaxGlowIntensity;
		uniform float4 _FresnelTint;
		uniform float _FresnelBias;
		uniform float _FresnelPower;
		uniform float3 BallPos;
		uniform float _BallEffectRadius;
		uniform float4 _BallEffectEmissionColor;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float temp_output_7_0 = saturate( ( 1.0 - step( ( tex2D( _TextureSample0, uv_TextureSample0 ).r + 0.0 ) , 0.49 ) ) );
			float AlbedoMask9 = ( 1.0 - temp_output_7_0 );
			o.Albedo = ( AlbedoMask9 * _AlbedoTint ).rgb;
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float EmissionMask10 = temp_output_7_0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV27 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode27 = ( 0.0 + _FresnelBias * pow( 1.0 - fresnelNdotV27, _FresnelPower ) );
			o.Emission = ( float4( UnpackNormal( tex2D( _TextureSample1, uv_TextureSample1 ) ) , 0.0 ) * ( ( EmissionMask10 * _EmissionTint * (_MinGlowIntensity + (sin( ( _Time.y * _GlowTime ) ) - -1.0) * (_MaxGlowIntensity - _MinGlowIntensity) / (1.0 - -1.0)) ) + ( _FresnelTint * saturate( fresnelNode27 ) ) + ( ( EmissionMask10 * ( 1.0 - saturate( ( distance( BallPos , ase_worldPos ) / _BallEffectRadius ) ) ) ) * _BallEffectEmissionColor ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
0;497;1110;504;719.5064;150.7065;2.561773;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-1678.104,173.9302;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;342b7149489aefc449c3af2d82e42cab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-1351.761,-145.3737;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;52;-224.1269,1403.612;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;43;-263.7232,1175.617;Inherit;False;Global;BallPos;BallPos;10;0;Create;True;0;0;0;False;0;False;0,0,0;0,0.2372251,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;3;-1060.16,-132.4696;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.49;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-714.9589,-120.7203;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;190.8764,1494.078;Inherit;False;Property;_BallEffectRadius;BallEffectRadius;10;0;Create;True;0;0;0;False;0;False;0;0.48;0.001;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;45;32.4035,1187.718;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;53;359.0121,1218.972;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;7;-528.6399,-117.8805;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1499.83,788.4117;Inherit;False;Property;_GlowTime;GlowTime;4;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;21;-1479.067,680.4412;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-187.2764,1001.607;Inherit;False;Property;_FresnelPower;FresnelPower;8;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1263.125,726.121;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-247.8425,-90.56519;Inherit;True;EmissionMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-187.2764,905.6065;Inherit;False;Property;_FresnelBias;FresnelBias;7;0;Create;True;0;0;0;False;0;False;0;0.192;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;50;594.2126,1222.362;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;769.8903,1224.505;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;27;100.7235,841.6065;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;728.1857,813.4903;Inherit;False;10;EmissionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-565.7717,918.0576;Inherit;False;Property;_MaxGlowIntensity;MaxGlowIntensity;6;0;Create;True;0;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-577.4724,829.6529;Inherit;False;Property;_MinGlowIntensity;MinGlowIntensity;5;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;20;-965.482,709.405;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;1109.72,791.356;Inherit;False;Property;_BallEffectEmissionColor;BallEffectEmissionColor;11;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0.4788556,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;32;375.2447,844.6384;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;8;-291.0915,-440.7224;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-307.2678,512.5928;Inherit;False;Property;_EmissionTint;EmissionTint;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;36;388.6585,588.0283;Inherit;False;Property;_FresnelTint;FresnelTint;9;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,0.1598859,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;17;-281.6799,424.712;Inherit;False;10;EmissionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;939.941,842.494;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-283.1911,722.7296;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;60.32468,-427.0569;Inherit;False;AlbedoMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;158.5316,370.3037;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;768.6436,462.5218;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;1175.177,590.8945;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;49.76764,-63.49465;Inherit;False;9;AlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;1030.228,322.106;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-266.3374,200.63;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;a4837e8a16ccdff44983285fcf844240;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;80.11414,10.47787;Inherit;False;Property;_AlbedoTint;AlbedoTint;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.2924528,0.05888203,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;279.0142,-71.42214;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1263.895,234.8361;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1633.662,87.30496;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;LavaFloor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;2;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;3;0;2;0
WireConnection;4;0;3;0
WireConnection;45;0;43;0
WireConnection;45;1;52;0
WireConnection;53;0;45;0
WireConnection;53;1;54;0
WireConnection;7;0;4;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;10;0;7;0
WireConnection;50;0;53;0
WireConnection;51;0;50;0
WireConnection;27;2;29;0
WireConnection;27;3;30;0
WireConnection;20;0;22;0
WireConnection;32;0;27;0
WireConnection;8;0;7;0
WireConnection;58;0;57;0
WireConnection;58;1;51;0
WireConnection;24;0;20;0
WireConnection;24;3;25;0
WireConnection;24;4;26;0
WireConnection;9;0;8;0
WireConnection;16;0;17;0
WireConnection;16;1;18;0
WireConnection;16;2;24;0
WireConnection;33;0;36;0
WireConnection;33;1;32;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;35;0;16;0
WireConnection;35;1;33;0
WireConnection;35;2;59;0
WireConnection;14;0;13;0
WireConnection;14;1;15;0
WireConnection;61;0;5;0
WireConnection;61;1;35;0
WireConnection;0;0;14;0
WireConnection;0;2;61;0
ASEEND*/
//CHKSM=AD18AF7C9BF65DACE37FDDB0212D462307A9F203