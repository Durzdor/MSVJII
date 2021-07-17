// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FactoryBallShader"
{
	Properties
	{
		_NormalMap("NormalMap", 2D) = "bump" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (1.098039,0,0.1647059,0)
		_InterLine("InterLine", Float) = 0.05
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Step("Step", Range( 0 , 1)) = 0.06
		[NoScaleOffset]_Texture0("Texture 0", 2D) = "white" {}
		_TextureTiling("TextureTiling", Vector) = (0,0,0,0)
		_PanDirection("PanDirection", Vector) = (0,0,0,0)
		_TilingSpeed("TilingSpeed", Float) = 0
		_VariationTime("VariationTime", Float) = 0
		_MaskXStripesAmount("MaskXStripesAmount", Float) = 0
		_DeformationIntensity("DeformationIntensity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _MaskXStripesAmount;
		uniform float _VariationTime;
		uniform sampler2D _Texture0;
		uniform float _TilingSpeed;
		uniform float2 _PanDirection;
		uniform float2 _TextureTiling;
		uniform float _InterLine;
		uniform float _Step;
		uniform float _DeformationIntensity;
		uniform sampler2D _NormalMap;
		uniform float4 _EmissionColor;
		uniform float _Metallic;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime27 = _Time.y * _VariationTime;
			float mulTime25 = _Time.y * _TilingSpeed;
			float2 uv_TexCoord18 = v.texcoord.xy * _TextureTiling;
			float2 panner22 = ( mulTime25 * _PanDirection + uv_TexCoord18);
			float4 tex2DNode1 = tex2Dlod( _Texture0, float4( panner22, 0, 0.0) );
			float EmissionPattern9 = saturate( step( ( tex2DNode1.r + _InterLine ) , _Step ) );
			float ScalesMask43 = ( 1.0 - EmissionPattern9 );
			float VertexOffset45 = ( ( sin( ( ( ase_vertex3Pos.z * _MaskXStripesAmount ) + (0.0 + (sin( mulTime27 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + mulTime27 ) ) * ScalesMask43 ) * _DeformationIntensity );
			float3 temp_cast_0 = (VertexOffset45).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime25 = _Time.y * _TilingSpeed;
			float2 uv_TexCoord18 = i.uv_texcoord * _TextureTiling;
			float2 panner22 = ( mulTime25 * _PanDirection + uv_TexCoord18);
			o.Normal = UnpackNormal( tex2D( _NormalMap, panner22 ) );
			float4 tex2DNode1 = tex2D( _Texture0, panner22 );
			o.Albedo = tex2DNode1.rgb;
			float EmissionPattern9 = saturate( step( ( tex2DNode1.r + _InterLine ) , _Step ) );
			o.Emission = ( _EmissionColor * EmissionPattern9 ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
71;305;1920;1009;677.1381;89.82797;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;24;-1755.465,-446.4583;Inherit;False;Property;_TilingSpeed;TilingSpeed;9;0;Create;True;0;0;0;False;0;False;0;1.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-1997.283,-785.3737;Inherit;False;Property;_TextureTiling;TextureTiling;7;0;Create;True;0;0;0;False;0;False;0,0;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;23;-1806.165,-642.7574;Inherit;False;Property;_PanDirection;PanDirection;8;0;Create;True;0;0;0;False;0;False;0,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;25;-1540.965,-456.858;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1612.984,-804.4741;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;16;-1512.482,-130.9734;Inherit;True;Property;_Texture0;Texture 0;6;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;5c5dc6d07550a7248b40407bbd127600;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;22;-1226.363,-777.9571;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-668.4983,-172.8356;Inherit;False;Property;_InterLine;InterLine;2;0;Create;True;0;0;0;False;0;False;0.05;0.049;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1005.254,-127.7646;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;5c5dc6d07550a7248b40407bbd127600;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-591.551,-352.0978;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-440.0541,-181.6016;Inherit;False;Property;_Step;Step;5;0;Create;True;0;0;0;False;0;False;0.06;0.056;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-694.3232,-1129.221;Inherit;False;Property;_VariationTime;VariationTime;10;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;3;-366.9984,-459.0357;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.06;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;6;-161.4983,-461.8356;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;-457.7231,-1142.221;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;48.88662,-459.451;Inherit;False;EmissionPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-412.8146,-1387.82;Inherit;False;Property;_MaskXStripesAmount;MaskXStripesAmount;11;0;Create;True;0;0;0;False;0;False;0;205.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;31;-419.0148,-1572.202;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;26;-285.1225,-1134.121;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;328.213,-594.7805;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-29.63014,-1546.788;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;30;-95.23427,-1138.824;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;529.2366,-606.362;Inherit;False;ScalesMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;432.2465,-1502.552;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;34;590.4719,-1517.07;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;576.8364,-1228.163;Inherit;False;43;ScalesMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;965.7165,-1231.356;Inherit;False;Property;_DeformationIntensity;DeformationIntensity;12;0;Create;True;0;0;0;False;0;False;0;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;873.5254,-1487.906;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;1178.916,-1471.856;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-972.0558,375.1872;Inherit;False;Property;_EmissionColor;EmissionColor;1;1;[HDR];Create;True;0;0;0;False;0;False;1.098039,0,0.1647059,0;0,1.304119,0.5325722,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;11;-1018.456,621.5872;Inherit;False;9;EmissionPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;1337.886,-1485.312;Inherit;True;VertexOffset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1018.858,142.8038;Inherit;True;Property;_NormalMap;NormalMap;0;0;Create;True;0;0;0;False;0;False;-1;None;1f85e721d83bf9d46a23456a6584a3dd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;46;597.8345,326.5483;Inherit;False;45;VertexOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-684.0563,490.3872;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;13;19.10273,407.0492;Inherit;False;Property;_Metallic;Metallic;3;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;24.45424,482.3871;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;940.1764,-225.408;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;FactoryBallShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;24;0
WireConnection;18;0;21;0
WireConnection;22;0;18;0
WireConnection;22;2;23;0
WireConnection;22;1;25;0
WireConnection;1;0;16;0
WireConnection;1;1;22;0
WireConnection;8;0;1;1
WireConnection;8;1;5;0
WireConnection;3;0;8;0
WireConnection;3;1;15;0
WireConnection;6;0;3;0
WireConnection;27;0;28;0
WireConnection;9;0;6;0
WireConnection;26;0;27;0
WireConnection;38;0;9;0
WireConnection;32;0;31;3
WireConnection;32;1;33;0
WireConnection;30;0;26;0
WireConnection;43;0;38;0
WireConnection;35;0;32;0
WireConnection;35;1;30;0
WireConnection;35;2;27;0
WireConnection;34;0;35;0
WireConnection;36;0;34;0
WireConnection;36;1;44;0
WireConnection;47;0;36;0
WireConnection;47;1;48;0
WireConnection;45;0;47;0
WireConnection;2;1;22;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;12;0
WireConnection;0;3;13;0
WireConnection;0;4;14;0
WireConnection;0;11;46;0
ASEEND*/
//CHKSM=53E0F955EFE28F6AE1C278B4000B78BEE3E414A8