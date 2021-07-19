// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Electricty"
{
	Properties
	{
		_ElectricityDir("ElectricityDir", Vector) = (0,1,0,0)
		[HDR]_LightningColor("LightningColor", Color) = (2,1.72549,0,0)
		_ElectricityDir2("ElectricityDir2", Vector) = (0,-1,0,0)
		_ElectricScale("ElectricScale", Float) = 6.37
		_ElectricScale2("ElectricScale2", Float) = 6.37
		_ElectricitySpeed("ElectricitySpeed", Float) = 1
		_ElectricitySpeed2("ElectricitySpeed2", Float) = 1
		_ElectricityBoltWidth("ElectricityBoltWidth", Range( 0 , 1)) = 0.1294118
		_ElecttrictyPower("ElecttrictyPower", Float) = 3.81
		_ElectrictyBoltWidth2("ElectrictyBoltWidth2", Range( 0 , 1)) = 0.65
		_DeformationIntensity("DeformationIntensity", Float) = 0
		[HDR]_SecondaryEmissionColor("SecondaryEmissionColor", Color) = (1,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _ElectricitySpeed2;
		uniform float2 _ElectricityDir2;
		uniform float _ElectricScale2;
		uniform float _ElectricitySpeed;
		uniform float2 _ElectricityDir;
		uniform float _ElectricScale;
		uniform float _ElecttrictyPower;
		uniform float _ElectrictyBoltWidth2;
		uniform float _ElectricityBoltWidth;
		uniform float _DeformationIntensity;
		uniform float4 _LightningColor;
		uniform float4 _SecondaryEmissionColor;


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
			float mulTime25 = _Time.y * _ElectricitySpeed2;
			float2 panner23 = ( mulTime25 * _ElectricityDir2 + v.texcoord.xy);
			float simplePerlin2D29 = snoise( panner23*_ElectricScale2 );
			simplePerlin2D29 = simplePerlin2D29*0.5 + 0.5;
			float mulTime13 = _Time.y * _ElectricitySpeed;
			float2 panner10 = ( mulTime13 * _ElectricityDir + v.texcoord.xy);
			float simplePerlin2D2 = snoise( panner10*_ElectricScale );
			simplePerlin2D2 = simplePerlin2D2*0.5 + 0.5;
			float temp_output_33_0 = pow( ( simplePerlin2D29 + simplePerlin2D2 ) , _ElecttrictyPower );
			float MainMask103 = saturate( ( step( temp_output_33_0 , _ElectrictyBoltWidth2 ) - step( temp_output_33_0 , _ElectricityBoltWidth ) ) );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 temp_output_69_0 = ( MainMask103 * ase_vertex3Pos * _DeformationIntensity );
			v.vertex.xyz += temp_output_69_0;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime25 = _Time.y * _ElectricitySpeed2;
			float2 panner23 = ( mulTime25 * _ElectricityDir2 + i.uv_texcoord);
			float simplePerlin2D29 = snoise( panner23*_ElectricScale2 );
			simplePerlin2D29 = simplePerlin2D29*0.5 + 0.5;
			float mulTime13 = _Time.y * _ElectricitySpeed;
			float2 panner10 = ( mulTime13 * _ElectricityDir + i.uv_texcoord);
			float simplePerlin2D2 = snoise( panner10*_ElectricScale );
			simplePerlin2D2 = simplePerlin2D2*0.5 + 0.5;
			float temp_output_33_0 = pow( ( simplePerlin2D29 + simplePerlin2D2 ) , _ElecttrictyPower );
			float MainMask103 = saturate( ( step( temp_output_33_0 , _ElectrictyBoltWidth2 ) - step( temp_output_33_0 , _ElectricityBoltWidth ) ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 temp_output_69_0 = ( MainMask103 * ase_vertex3Pos * _DeformationIntensity );
			float4 Rays108 = ( float4( saturate( ( 1.0 - temp_output_69_0 ) ) , 0.0 ) * _SecondaryEmissionColor );
			o.Emission = ( ( _LightningColor * MainMask103 ) + Rays108 ).rgb;
			float temp_output_105_0 = MainMask103;
			o.Alpha = temp_output_105_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;42;1906;977;2180.591;1950.538;4.075461;True;False
Node;AmplifyShaderEditor.CommentaryNode;83;-1573.368,342.7497;Inherit;False;1297.98;664.4868;Noise Gen 2;7;14;13;4;10;12;2;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;82;-1561.748,-489.2723;Inherit;False;1179.646;664.4867;Noise Gen 1;7;27;25;26;24;23;28;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1511.748,26.00295;Inherit;False;Property;_ElectricitySpeed2;ElectricitySpeed2;6;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1523.368,858.025;Inherit;False;Property;_ElectricitySpeed;ElectricitySpeed;5;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;4;-1486.462,664.9533;Inherit;False;Property;_ElectricityDir;ElectricityDir;0;0;Create;True;0;0;0;False;0;False;0,1;-0.1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1381.96,392.7497;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;25;-1320.164,-9.348873;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-1474.842,-167.0684;Inherit;False;Property;_ElectricityDir2;ElectricityDir2;2;0;Create;True;0;0;0;False;0;False;0,-1;0.1,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1370.341,-439.2723;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;13;-1331.784,822.6732;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;23;-965.5052,-150.7559;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-964.5805,892.2364;Inherit;False;Property;_ElectricScale;ElectricScale;3;0;Create;True;0;0;0;False;0;False;6.37;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;10;-977.1247,681.2657;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-952.961,60.21437;Inherit;False;Property;_ElectricScale2;ElectricScale2;4;0;Create;True;0;0;0;False;0;False;6.37;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-539.388,601.3553;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;29;-646.1017,-174.9797;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;105.2963,430.9934;Inherit;False;Property;_ElecttrictyPower;ElecttrictyPower;8;0;Create;True;0;0;0;False;0;False;3.81;2.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-123.1732,175.9665;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;333.7525,411.3734;Inherit;False;Property;_ElectricityBoltWidth;ElectricityBoltWidth;7;0;Create;True;0;0;0;False;0;False;0.1294118;0.2235294;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;33;284.6923,148.6695;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;469.2278,550.8558;Inherit;False;Property;_ElectrictyBoltWidth2;ElectrictyBoltWidth2;9;0;Create;True;0;0;0;False;0;False;0.65;0.38;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;16;580.8634,86.41481;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;61;1020.146,314.2218;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;63;1305.082,149.2822;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;104;1518.671,70.63654;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;1598.089,-76.42849;Inherit;False;MainMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;2552.257,434.0182;Inherit;False;Property;_DeformationIntensity;DeformationIntensity;10;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;2368.047,-235.7769;Inherit;False;103;MainMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;67;1711.902,470.0343;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;2871.676,123.9196;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;110;3156.858,297.9943;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;109;3404.676,264.0485;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;97;3330.996,640.0428;Inherit;False;Property;_SecondaryEmissionColor;SecondaryEmissionColor;11;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;1.56179,0.03683466,0.305376,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;3632.299,266.713;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;2366.68,-558.9542;Inherit;False;Property;_LightningColor;LightningColor;1;1;[HDR];Create;True;0;0;0;False;0;False;2,1.72549,0,0;0.6107488,0.396507,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;3841.75,270.0703;Inherit;False;Rays;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;2873.723,-254.2579;Inherit;False;108;Rays;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;2711.368,-536.6727;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;3095.904,-453.6468;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4065.525,-384.6333;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;Electricty;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;27;0
WireConnection;13;0;14;0
WireConnection;23;0;24;0
WireConnection;23;2;26;0
WireConnection;23;1;25;0
WireConnection;10;0;11;0
WireConnection;10;2;4;0
WireConnection;10;1;13;0
WireConnection;2;0;10;0
WireConnection;2;1;12;0
WireConnection;29;0;23;0
WireConnection;29;1;28;0
WireConnection;32;0;29;0
WireConnection;32;1;2;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;16;0;33;0
WireConnection;16;1;17;0
WireConnection;61;0;33;0
WireConnection;61;1;62;0
WireConnection;63;0;61;0
WireConnection;63;1;16;0
WireConnection;104;0;63;0
WireConnection;103;0;104;0
WireConnection;69;0;105;0
WireConnection;69;1;67;0
WireConnection;69;2;80;0
WireConnection;110;0;69;0
WireConnection;109;0;110;0
WireConnection;106;0;109;0
WireConnection;106;1;97;0
WireConnection;108;0;106;0
WireConnection;39;0;1;0
WireConnection;39;1;105;0
WireConnection;94;0;39;0
WireConnection;94;1;100;0
WireConnection;0;2;94;0
WireConnection;0;9;105;0
WireConnection;0;11;69;0
ASEEND*/
//CHKSM=BE21F596B7E2C73CD354792DDFC91EB21E72B669