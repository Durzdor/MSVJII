// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ExternalSphereSwirl"
{
	Properties
	{
		_TopMaskFalloff("TopMaskFalloff", Float) = 2.12
		_TopMaskIntensity("TopMaskIntensity", Float) = 0
		_NoiseDir("NoiseDir", Vector) = (0,0,0,0)
		_NoiseSpeed("NoiseSpeed", Float) = 0
		_LineWidth("LineWidth", Range( 0 , 1)) = 0
		[HDR]_LinesColor("LinesColor", Color) = (0,0,0,0)
		_LinesAmount("LinesAmount", Float) = 1
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
		#define ASE_USING_SAMPLING_MACROS 1
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _NoiseSpeed;
		uniform float2 _NoiseDir;
		uniform float _LinesAmount;
		uniform float _LineWidth;
		uniform float4 _LinesColor;
		uniform float _TopMaskFalloff;
		uniform float _TopMaskIntensity;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime23 = _Time.y * _NoiseSpeed;
			float2 appendResult32 = (float2(0.1 , _LinesAmount));
			float2 uv_TexCoord17 = i.uv_texcoord * appendResult32;
			float2 panner18 = ( mulTime23 * _NoiseDir + uv_TexCoord17);
			float simplePerlin2D16 = snoise( panner18*26.85 );
			simplePerlin2D16 = simplePerlin2D16*0.5 + 0.5;
			float temp_output_24_0 = step( simplePerlin2D16 , _LineWidth );
			float4 Emission28 = ( temp_output_24_0 * _LinesColor );
			o.Emission = Emission28.rgb;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float clampResult38 = clamp( ( pow( ( 1.0 - saturate( ase_vertex3Pos.y ) ) , _TopMaskFalloff ) * _TopMaskIntensity ) , 0.0 , 1.0 );
			float OpacityMask12 = clampResult38;
			o.Alpha = ( OpacityMask12 * temp_output_24_0 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
219;574;1920;1019;-749.2867;362.3982;1.766749;True;False
Node;AmplifyShaderEditor.RangedFloatNode;34;-786.5957,324.5454;Inherit;False;Property;_LinesAmount;LinesAmount;6;0;Create;True;0;0;0;False;0;False;1;0.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-739.1422,255.5258;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-2212.562,428.249;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;32;-547.6758,254.3365;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-323.5676,504.3817;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;3;0;Create;True;0;0;0;False;0;False;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2;-1994.963,477.8489;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-305.3981,225.0587;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;21;-298.8676,356.1817;Inherit;False;Property;_NoiseDir;NoiseDir;2;0;Create;True;0;0;0;False;0;False;0,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;23;-140.2676,506.9815;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1631.763,596.2491;Inherit;False;Property;_TopMaskFalloff;TopMaskFalloff;0;0;Create;True;0;0;0;False;0;False;2.12;17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;5;-1818.963,477.8489;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1308.748,701.9031;Inherit;False;Property;_TopMaskIntensity;TopMaskIntensity;1;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;6;-1409.363,468.2489;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;18;91.50067,233.4316;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;337.7066,382.8679;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;26.85;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1065.363,466.649;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;1271.988,795.7653;Inherit;False;Property;_LineWidth;LineWidth;4;0;Create;True;0;0;0;False;0;False;0;0.1875344;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;657.7657,198.984;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;1916.93,623.8226;Inherit;False;Property;_LinesColor;LinesColor;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0.2440212,5.124444,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;24;1570.584,498.1209;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;38;-904.5447,569.8345;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;2169.272,502.5208;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-717.1936,469.5409;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;2408.073,556.4543;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;1742.221,121.0252;Inherit;False;12;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;2183.944,65.62369;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;283.9286,-137.4528;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0.5849056,0.5849056,0.5849056,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;29;2018.883,-173.8868;Inherit;False;28;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2538.596,-202.528;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;ExternalSphereSwirl;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;33;0
WireConnection;32;1;34;0
WireConnection;2;0;1;2
WireConnection;17;0;32;0
WireConnection;23;0;22;0
WireConnection;5;0;2;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;18;0;17;0
WireConnection;18;2;21;0
WireConnection;18;1;23;0
WireConnection;8;0;6;0
WireConnection;8;1;9;0
WireConnection;16;0;18;0
WireConnection;16;1;20;0
WireConnection;24;0;16;0
WireConnection;24;1;25;0
WireConnection;38;0;8;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;12;0;38;0
WireConnection;28;0;26;0
WireConnection;41;0;13;0
WireConnection;41;1;24;0
WireConnection;0;2;29;0
WireConnection;0;9;41;0
ASEEND*/
//CHKSM=B200903D36569FB7AFB400B38954D4A8EDC949F3