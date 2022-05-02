// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlagShader"
{
	Properties
	{
		_LinesAmount("LinesAmount", Float) = 0
		_WaveIntensity("WaveIntensity", Range( 0 , 1)) = 0.5
		[HDR]_Tint("Tint", Color) = (0,0,0,0)
		_NoiseScale("NoiseScale", Float) = 29.4
		_Metallic("Metallic", Float) = 0
		_Smoothness("Smoothness", Float) = 0
		_EmissionIntensity("EmissionIntensity", Float) = 0
		_NoiseTimeScale("NoiseTimeScale", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			half filler;
		};

		uniform float _LinesAmount;
		uniform float _NoiseTimeScale;
		uniform float _NoiseScale;
		uniform float _WaveIntensity;
		uniform float4 _Tint;
		uniform float _EmissionIntensity;
		uniform float _Metallic;
		uniform float _Smoothness;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime2 = _Time.y * 2.0;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime65 = _Time.y * _NoiseTimeScale;
			float simpleNoise56 = SimpleNoise( ( ase_vertex3Pos + mulTime65 ).xy*_NoiseScale );
			v.vertex.xyz += ( float3(0,0,1) * sin( ( mulTime2 + ( ase_vertex3Pos.x * _LinesAmount ) ) ) * saturate( ( 1.0 - step( (ase_vertex3Pos).x , 0.05 ) ) ) * simpleNoise56 * _WaveIntensity );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_70_0 = _Tint;
			o.Albedo = temp_output_70_0.rgb;
			o.Emission = ( _Tint * _EmissionIntensity ).rgb;
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
0;0;1920;1019;1665.345;-114.8103;1;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;7;-2241.451,110.2917;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;13;-1898.616,121.9632;Inherit;True;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1360.345,667.8103;Inherit;False;Property;_NoiseTimeScale;NoiseTimeScale;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2085.619,329.869;Inherit;False;Property;_LinesAmount;LinesAmount;0;0;Create;True;0;0;0;False;0;False;0;52.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2068.63,-23.80273;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1843.05,315.6956;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-1910.63,-17.80273;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;14;-1460.115,198.4632;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;64;-1247.436,457.6681;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;65;-1234.063,605.7192;Inherit;False;1;0;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1577.73,3.863161;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-964.3523,518.6401;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;15;-1204.622,192.9738;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-983.231,686.6133;Inherit;False;Property;_NoiseScale;NoiseScale;3;0;Create;True;0;0;0;False;0;False;29.4;29.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;259.1545,55.32375;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;6;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;16;-840.8078,-318.4553;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;68;166.4454,610.3607;Inherit;False;Property;_WaveIntensity;WaveIntensity;1;0;Create;True;0;0;0;False;0;False;0.5;0.38;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;56;-765.0349,489.3379;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;69;-948.7165,143.1696;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;70;165.4135,-192.6886;Inherit;False;Property;_Tint;Tint;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.1749774,0.1462264,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;1;-1307.325,-125.0325;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;689.5847,204.1415;Inherit;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;0;False;0;False;0;0.306;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;419.0544,7.223724;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;548.2185,364.9507;Inherit;True;5;5;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;72;713.5847,287.1412;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;0;False;0;False;0;0.229;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;979.1699,84.09922;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;FlagShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;2;7.06;25;True;1;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;7;0
WireConnection;8;0;7;1
WireConnection;8;1;9;0
WireConnection;2;0;3;0
WireConnection;14;0;13;0
WireConnection;65;0;75;0
WireConnection;11;0;2;0
WireConnection;11;1;8;0
WireConnection;66;0;64;0
WireConnection;66;1;65;0
WireConnection;15;0;14;0
WireConnection;56;0;66;0
WireConnection;56;1;59;0
WireConnection;69;0;15;0
WireConnection;1;0;11;0
WireConnection;73;0;70;0
WireConnection;73;1;74;0
WireConnection;23;0;16;0
WireConnection;23;1;1;0
WireConnection;23;2;69;0
WireConnection;23;3;56;0
WireConnection;23;4;68;0
WireConnection;0;0;70;0
WireConnection;0;2;73;0
WireConnection;0;3;71;0
WireConnection;0;4;72;0
WireConnection;0;11;23;0
ASEEND*/
//CHKSM=2204E781C8480B37DD50CD41124A2E6471B2BA8E