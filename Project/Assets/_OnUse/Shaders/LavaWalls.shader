// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LavaWalls"
{
	Properties
	{
		_RockTex("RockTex", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_LavaMoveDir("LavaMoveDir", Vector) = (0,0,0,0)
		_Float1("Float 1", Float) = 0
		_NoiseScale("NoiseScale", Float) = 0
		_LavaAmount("LavaAmount", Range( 0 , 1)) = 0
		_LavaEmissionMarker("LavaEmissionMarker", Range( 0 , 1)) = 0
		[HDR]_LavaEmissionColor("LavaEmissionColor", Color) = (0,0,0,0)
		_OriginalTexIntensity("OriginalTexIntensity", Range( 0 , 1)) = 0
		[NoScaleOffset][Normal]_NormalMap("NormalMap", 2D) = "bump" {}
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _RockTex;
		uniform float2 _Tiling;
		uniform float _OriginalTexIntensity;
		uniform sampler2D _TextureSample1;
		uniform float _Float1;
		uniform float2 _LavaMoveDir;
		uniform float _LavaEmissionMarker;
		uniform float4 _LavaEmissionColor;
		uniform float _NoiseScale;
		uniform float _LavaAmount;
		uniform sampler2D _NormalMap;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord5 = i.uv_texcoord * _Tiling;
			float mulTime12 = _Time.y * _Float1;
			float2 panner10 = ( mulTime12 * _LavaMoveDir + i.uv_texcoord);
			float4 tex2DNode2 = tex2D( _TextureSample1, panner10 );
			float4 LavaTexture20 = tex2DNode2;
			float grayscale33 = Luminance(tex2DNode2.rgb);
			float4 LavaEmission41 = ( ( tex2DNode2 * ( 1.0 - step( grayscale33 , _LavaEmissionMarker ) ) ) * _LavaEmissionColor );
			float simplePerlin3D24 = snoise( float3( i.uv_texcoord ,  0.0 )*_NoiseScale );
			simplePerlin3D24 = simplePerlin3D24*0.5 + 0.5;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult4 = lerp( ( tex2D( _RockTex, uv_TexCoord5 ) * _OriginalTexIntensity ) , ( ( LavaTexture20 * 0.63 ) + LavaEmission41 ) , saturate( ( saturate( step( simplePerlin3D24 , _LavaAmount ) ) * pow( ( 1.0 - ase_vertex3Pos.y ) , 14.2 ) ) ));
			float2 uv_NormalMap66 = i.uv_texcoord;
			o.Emission = ( lerpResult4 * UnpackNormal( tex2D( _NormalMap, uv_NormalMap66 ) ).b ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;497;1110;504;592.7644;525.8632;2.665231;True;False
Node;AmplifyShaderEditor.RangedFloatNode;18;-2390.534,788.2725;Inherit;False;Property;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-2285.295,681.2379;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;11;-2557.112,688.8276;Inherit;True;Property;_LavaMoveDir;LavaMoveDir;3;0;Create;True;0;0;0;False;0;False;0,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-2361.279,383.591;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;10;-2036.081,392.6001;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1790.94,366.7143;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;645559849f5afdd42bbe90de5f985ddf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-1528.143,1144.03;Inherit;False;Property;_LavaEmissionMarker;LavaEmissionMarker;7;0;Create;True;0;0;0;False;0;False;0;0.6985362;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;33;-1567.366,859.5953;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;34;-1337.143,889.0296;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-987.9128,461.2467;Inherit;False;Property;_NoiseScale;NoiseScale;5;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;35;-1101.858,994.9788;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1056.011,305.1497;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;56;82.27907,327.2188;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-512.4131,650.7027;Inherit;False;Property;_LavaAmount;LavaAmount;6;0;Create;True;0;0;0;False;0;False;0;0.6405017;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;24;-755.2552,316.4673;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-638.4412,823.688;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;39;-590.5942,986.0927;Inherit;False;Property;_LavaEmissionColor;LavaEmissionColor;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;2.251309,0,0.1324299,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-728.9504,564.1746;Inherit;False;LavaTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;64;279.7451,332.6065;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;287.1673,618.3224;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;14.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;27;-220.7777,402.4403;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;6;-1763.464,-297.6945;Inherit;False;Property;_Tiling;Tiling;2;0;Create;True;0;0;0;False;0;False;0,0;0.02,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-448.1956,838.3549;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-797.642,-3.425402;Inherit;False;20;LavaTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-772.6277,71.64348;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;0.63;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1440.263,-332.8943;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-239.9373,841.9149;Inherit;False;LavaEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;60;526.3162,300.2366;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;4.638229,214.4531;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-772.9363,153.0012;Inherit;False;41;LavaEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-567.484,27.77635;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-756.1611,-191.5837;Inherit;False;Property;_OriginalTexIntensity;OriginalTexIntensity;9;0;Create;True;0;0;0;False;0;False;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;601.6958,112.75;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1035.78,-400.2954;Inherit;True;Property;_RockTex;RockTex;0;0;Create;True;0;0;0;False;0;False;-1;None;0b83d3bb02b01c844b97ea4fca9672f1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-408.1628,20.19532;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;62;807.5356,98.99385;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-593.9103,-301.6824;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;66;1215.574,76.01972;Inherit;True;Property;_NormalMap;NormalMap;10;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;733a149a785b5544185cc5b1ac7bc894;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;4;1069.063,-101.2598;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;1524.012,-113.8848;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1798.358,-144.3994;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LavaWalls;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;18;0
WireConnection;10;0;19;0
WireConnection;10;2;11;0
WireConnection;10;1;12;0
WireConnection;2;1;10;0
WireConnection;33;0;2;0
WireConnection;34;0;33;0
WireConnection;34;1;36;0
WireConnection;35;0;34;0
WireConnection;24;0;29;0
WireConnection;24;1;25;0
WireConnection;37;0;2;0
WireConnection;37;1;35;0
WireConnection;20;0;2;0
WireConnection;64;0;56;2
WireConnection;27;0;24;0
WireConnection;27;1;28;0
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;5;0;6;0
WireConnection;41;0;38;0
WireConnection;60;0;64;0
WireConnection;60;1;61;0
WireConnection;31;0;27;0
WireConnection;54;0;21;0
WireConnection;54;1;55;0
WireConnection;57;0;31;0
WireConnection;57;1;60;0
WireConnection;1;1;5;0
WireConnection;42;0;54;0
WireConnection;42;1;43;0
WireConnection;62;0;57;0
WireConnection;52;0;1;0
WireConnection;52;1;53;0
WireConnection;4;0;52;0
WireConnection;4;1;42;0
WireConnection;4;2;62;0
WireConnection;65;0;4;0
WireConnection;65;1;66;3
WireConnection;0;2;65;0
ASEEND*/
//CHKSM=4CD84801402CB722DB82CAECA4B4D8C9924F1190