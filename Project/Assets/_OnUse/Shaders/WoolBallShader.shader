// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WoolBall"
{
	Properties
	{
		[NoScaleOffset]_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[NoScaleOffset]_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_Tint("Tint", Color) = (0,0,0,0)
		[NoScaleOffset]_fabric_0008_roughness_2k("fabric_0008_roughness_2k", 2D) = "white" {}
		[NoScaleOffset]_fabric_0008_base_color_2k("fabric_0008_base_color_2k", 2D) = "white" {}
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_EmissionIntensity("EmissionIntensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample1;
		uniform float4 _Tint;
		uniform sampler2D _fabric_0008_base_color_2k;
		uniform float4 _EmissionColor;
		uniform float _EmissionIntensity;
		uniform sampler2D _fabric_0008_roughness_2k;
		uniform sampler2D _TextureSample0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample12 = i.uv_texcoord;
			float3 tex2DNode2 = UnpackNormal( tex2D( _TextureSample1, uv_TextureSample12 ) );
			o.Normal = tex2DNode2;
			float2 uv_fabric_0008_base_color_2k13 = i.uv_texcoord;
			o.Albedo = ( _Tint * tex2D( _fabric_0008_base_color_2k, uv_fabric_0008_base_color_2k13 ) ).rgb;
			o.Emission = ( tex2DNode2.g * _EmissionColor * _EmissionIntensity ).rgb;
			float2 uv_fabric_0008_roughness_2k11 = i.uv_texcoord;
			o.Smoothness = tex2D( _fabric_0008_roughness_2k, uv_fabric_0008_roughness_2k11 ).r;
			float2 uv_TextureSample01 = i.uv_texcoord;
			o.Occlusion = tex2D( _TextureSample0, uv_TextureSample01 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
14;37;1906;982;636.1564;271.6137;1;True;False
Node;AmplifyShaderEditor.SamplerNode;13;-331.2592,-290.0191;Inherit;True;Property;_fabric_0008_base_color_2k;fabric_0008_base_color_2k;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;d4d1563165f96ad4bb78a8cb3ae67672;d4d1563165f96ad4bb78a8cb3ae67672;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-223.0828,-524.1995;Inherit;False;Property;_Tint;Tint;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,1,0.08387089,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-426.6444,-29.99059;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;29c9456704da737418b61f01f277e89d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-33.89261,121.3499;Inherit;False;Property;_EmissionColor;EmissionColor;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5725281,1,0.495283,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;20.35779,358.6951;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;348.2098,-212.0451;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;330.8065,493.2701;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;f9f3d0a8190aa1f4bb8b320a39046e5f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;644.9203,745.4107;Inherit;True;Property;_fabric_0008_roughness_2k;fabric_0008_roughness_2k;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;1af7b4bf648bd994aa39a722e7726b8e;1af7b4bf648bd994aa39a722e7726b8e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;271.2656,184.0768;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;985.7552,-22.79144;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;WoolBall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.001;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;4;1;13;0
WireConnection;15;0;2;2
WireConnection;15;1;14;0
WireConnection;15;2;16;0
WireConnection;0;0;4;0
WireConnection;0;1;2;0
WireConnection;0;2;15;0
WireConnection;0;4;11;1
WireConnection;0;5;1;1
ASEEND*/
//CHKSM=96C74714609AC61F487DF8A3BD2BEFEBA23B036B