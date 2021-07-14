// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ExternalLavaShader"
{
	Properties
	{
		_WaveIntensity("WaveIntensity", Float) = 0
		_TextureTiling("TextureTiling", Vector) = (10,10,0,0)
		_LavaMoveScale("LavaMoveScale", Float) = 0
		_NoiseScale("NoiseScale", Float) = 0
		[NoScaleOffset]_LavaTex("LavaTex", 2D) = "white" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (1,1,1,0)
		_LavaSpotsFalloff("LavaSpotsFalloff", Float) = 1.25
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _LavaMoveScale;
		uniform float _NoiseScale;
		uniform float _WaveIntensity;
		uniform float4 _EmissionColor;
		uniform sampler2D _LavaTex;
		uniform float2 _TextureTiling;
		uniform float _LavaSpotsFalloff;


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
			float mulTime22 = _Time.y * _LavaMoveScale;
			float2 _Vector1 = float2(0.2,0);
			float2 panner28 = ( mulTime22 * _Vector1 + v.texcoord.xy);
			float simplePerlin2D24 = snoise( panner28*_NoiseScale );
			simplePerlin2D24 = simplePerlin2D24*0.5 + 0.5;
			v.vertex.xyz += ( float3(0,1,0) * simplePerlin2D24 * _WaveIntensity );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime22 = _Time.y * _LavaMoveScale;
			float2 _Vector1 = float2(0.2,0);
			float2 uv_TexCoord18 = i.uv_texcoord * _TextureTiling;
			float2 panner19 = ( mulTime22 * _Vector1 + uv_TexCoord18);
			float4 tex2DNode32 = tex2D( _LavaTex, panner19 );
			float grayscale52 = Luminance(tex2DNode32.rgb);
			float temp_output_53_0 = step( pow( grayscale52 , _LavaSpotsFalloff ) , 0.21 );
			float AlbedoMask63 = saturate( temp_output_53_0 );
			float4 lerpResult67 = lerp( ( _EmissionColor * saturate( ( 1.0 - temp_output_53_0 ) ) ) , ( tex2DNode32 * AlbedoMask63 ) , float4( 0,0,0,0 ));
			o.Emission = lerpResult67.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;0;1920;1019;734.0922;1230.24;1.799536;True;False
Node;AmplifyShaderEditor.RangedFloatNode;23;-1339.88,276.5108;Inherit;False;Property;_LavaMoveScale;LavaMoveScale;2;0;Create;True;0;0;0;False;0;False;0;0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-1482.254,-309.1936;Inherit;False;Property;_TextureTiling;TextureTiling;1;0;Create;True;0;0;0;False;0;False;10,10;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1247.146,-331.0721;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;20;-1259.825,99.92609;Inherit;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;0;False;0;False;0.2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;22;-1125.48,276.5108;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;19;-825.6288,-331.0063;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;32;-561.8138,-364.2023;Inherit;True;Property;_LavaTex;LavaTex;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;b09edec1b635f534fb12033da4d723c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;52;22.68323,-425.6017;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;238.1458,-332.8073;Inherit;False;Property;_LavaSpotsFalloff;LavaSpotsFalloff;7;0;Create;True;0;0;0;False;0;False;1.25;1.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;57;424.2554,-426.0998;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;53;677.6324,-428.5441;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;62;685.1983,-669.2125;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;911.9022,-686.9293;Inherit;False;AlbedoMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-515.1411,-20.51957;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;54;823.8131,-401.4469;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;1215.332,-580.2347;Inherit;False;Property;_EmissionColor;EmissionColor;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;2.996078,0.09411765,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;64;430.2038,135.8491;Inherit;False;63;AlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;28;-206.3383,151.1697;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-14.81488,299.2679;Inherit;False;Property;_NoiseScale;NoiseScale;3;0;Create;True;0;0;0;False;0;False;0;10.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;59;1074.452,-333.6508;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;24;181.8442,118.5991;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;316.9611,563.0107;Inherit;False;Property;_WaveIntensity;WaveIntensity;0;0;Create;True;0;0;0;False;0;False;0;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;835.483,81.66825;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1457.724,-411.5132;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;12;282.446,389.8162;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;66;581.2156,246.0429;Inherit;False;Property;_OriginalColorIntensity;OriginalColorIntensity;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;1740.271,-352.0667;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;544.5452,424.1416;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2298.947,-433.9108;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;ExternalLavaShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;21;0
WireConnection;22;0;23;0
WireConnection;19;0;18;0
WireConnection;19;2;20;0
WireConnection;19;1;22;0
WireConnection;32;1;19;0
WireConnection;52;0;32;0
WireConnection;57;0;52;0
WireConnection;57;1;58;0
WireConnection;53;0;57;0
WireConnection;62;0;53;0
WireConnection;63;0;62;0
WireConnection;54;0;53;0
WireConnection;28;0;27;0
WireConnection;28;2;20;0
WireConnection;28;1;22;0
WireConnection;59;0;54;0
WireConnection;24;0;28;0
WireConnection;24;1;29;0
WireConnection;65;0;32;0
WireConnection;65;1;64;0
WireConnection;56;0;60;0
WireConnection;56;1;59;0
WireConnection;67;0;56;0
WireConnection;67;1;65;0
WireConnection;13;0;12;0
WireConnection;13;1;24;0
WireConnection;13;2;17;0
WireConnection;0;2;67;0
WireConnection;0;11;13;0
ASEEND*/
//CHKSM=22435B540D3F3A806724BF13336B411929375BF0