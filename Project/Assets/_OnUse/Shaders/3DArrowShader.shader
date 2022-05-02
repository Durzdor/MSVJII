// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "3DArrowShader"
{
	Properties
	{
		[HDR]_EmissionTint("EmissionTint", Color) = (9.189588,4.865076,0,0)
		_LineAmount("LineAmount", Float) = 0
		_TopMaskFalloff("TopMaskFalloff", Float) = 0
		_LineMoveSpeed("LineMoveSpeed", Float) = 1
		_TopMaskIntensity("TopMaskIntensity", Float) = 0
		_DetailEmissionTint("DetailEmissionTint", Color) = (0,1,0.8982549,0)
		_DepthFadeDistance("DepthFadeDistance", Float) = 0
		[HDR]_DepthFadeColor("DepthFadeColor", Color) = (0.1320755,0,0.1177229,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float4 _EmissionTint;
		uniform float _TopMaskFalloff;
		uniform float _TopMaskIntensity;
		uniform float _LineAmount;
		uniform float _LineMoveSpeed;
		uniform float4 _DetailEmissionTint;
		uniform float4 _DepthFadeColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFadeDistance;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_worldPos = i.worldPos;
			float mulTime21 = _Time.y * _LineMoveSpeed;
			float temp_output_15_0 = saturate( sin( ( ( ase_worldPos.z * _LineAmount ) + mulTime21 ) ) );
			float temp_output_55_0 = saturate( ( ( pow( saturate( ase_vertex3Pos.y ) , _TopMaskFalloff ) * _TopMaskIntensity ) * temp_output_15_0 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth58 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth58 = abs( ( screenDepth58 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) );
			float temp_output_62_0 = ( 1.0 - saturate( distanceDepth58 ) );
			o.Emission = ( ( _EmissionTint * ( 1.0 - temp_output_55_0 ) ) + ( _DetailEmissionTint * temp_output_55_0 ) + ( _DepthFadeColor * temp_output_62_0 ) ).rgb;
			o.Alpha = ( temp_output_15_0 + temp_output_62_0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
0;0;1920;1019;-1716.984;904.3884;1.702528;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;10;1076.942,724.0392;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;22;1171.528,1196.054;Inherit;False;Property;_LineMoveSpeed;LineMoveSpeed;3;0;Create;True;0;0;0;False;0;False;1;13.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;1010.253,986.9553;Inherit;False;Property;_LineAmount;LineAmount;1;0;Create;True;0;0;0;False;0;False;0;28.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;21;1345.408,1128.913;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;1367.165,794.2697;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;42;976.1748,-21.1736;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;20;1636.793,792.364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;1383.687,198.3363;Inherit;False;Property;_TopMaskFalloff;TopMaskFalloff;2;0;Create;True;0;0;0;False;0;False;0;4.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;45;1181.344,24.87611;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;14;1783.615,790.0323;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;1627.011,236.4936;Inherit;False;Property;_TopMaskIntensity;TopMaskIntensity;4;0;Create;True;0;0;0;False;0;False;0;4.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;46;1539.23,27.6522;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;2754.053,550.2222;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;6;0;Create;True;0;0;0;False;0;False;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1877.658,24.2882;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;1980.591,779.3923;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;58;2995.321,480.1392;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;2343.211,59.33553;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;61;3254.273,448.0346;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;55;2558.603,-5.270327;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;2088.508,-649.3195;Inherit;False;Property;_EmissionTint;EmissionTint;0;1;[HDR];Create;True;0;0;0;False;0;False;9.189588,4.865076,0,0;0,0.1167646,1.495299,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;56;2781.81,-382.7516;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;2522.23,-303.0467;Inherit;False;Property;_DetailEmissionTint;DetailEmissionTint;5;0;Create;True;0;0;0;False;0;False;0,1,0.8982549,0;0,1,0.8982549,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;62;3353.637,247.7004;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;63;3096.031,-19.07399;Inherit;False;Property;_DepthFadeColor;DepthFadeColor;7;1;[HDR];Create;True;0;0;0;False;0;False;0.1320755,0,0.1177229,0;0.1320755,0,0.1177229,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;3439.942,30.29932;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;3019.678,-523.3887;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;3000.387,-294.5164;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;3431.438,-467.1315;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;3648.483,-149.7529;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4013.484,-485.1475;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;3DArrowShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;22;0
WireConnection;9;0;10;3
WireConnection;9;1;13;0
WireConnection;20;0;9;0
WireConnection;20;1;21;0
WireConnection;45;0;42;2
WireConnection;14;0;20;0
WireConnection;46;0;45;0
WireConnection;46;1;47;0
WireConnection;48;0;46;0
WireConnection;48;1;49;0
WireConnection;15;0;14;0
WireConnection;58;0;59;0
WireConnection;50;0;48;0
WireConnection;50;1;15;0
WireConnection;61;0;58;0
WireConnection;55;0;50;0
WireConnection;56;0;55;0
WireConnection;62;0;61;0
WireConnection;64;0;63;0
WireConnection;64;1;62;0
WireConnection;57;0;1;0
WireConnection;57;1;56;0
WireConnection;52;0;53;0
WireConnection;52;1;55;0
WireConnection;39;0;57;0
WireConnection;39;1;52;0
WireConnection;39;2;64;0
WireConnection;60;0;15;0
WireConnection;60;1;62;0
WireConnection;0;2;39;0
WireConnection;0;9;60;0
ASEEND*/
//CHKSM=2D1503859EAC4F0869AB983B9E989E429F7FB08A