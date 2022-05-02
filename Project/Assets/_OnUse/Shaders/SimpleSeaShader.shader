// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SimpleSeaShader"
{
	Properties
	{
		_WaveLenght("WaveLenght", Vector) = (0,0,0,0)
		_WaveTiling("WaveTiling", Float) = 0
		_WaveDir("WaveDir", Vector) = (0,0,0,0)
		_WaveSpeed("WaveSpeed", Float) = 0
		_WaveHeight("WaveHeight", Float) = 0
		_Smoothness("Smoothness", Float) = 0
		_WaterColor("WaterColor", Color) = (0.01432895,0.3787474,0.4339623,0)
		_TopColor("TopColor", Color) = (0.01134745,0.4204375,0.4811321,0)
		_DepthFadeDistance("DepthFadeDistance", Float) = 0
		_DepthFadeIntensity("DepthFadeIntensity", Float) = 0
		_NormalTile("NormalTile", Float) = 0
		_NormalMap("NormalMap", 2D) = "white" {}
		_PanSpeed1("PanSpeed1", Float) = 0
		_PanSpeed2("PanSpeed2", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 4.6
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float _WaveHeight;
		uniform float _WaveSpeed;
		uniform float2 _WaveDir;
		uniform float2 _WaveLenght;
		uniform float _WaveTiling;
		uniform sampler2D _NormalMap;
		uniform float _PanSpeed1;
		uniform float _NormalTile;
		uniform float _PanSpeed2;
		uniform float4 _WaterColor;
		uniform float4 _TopColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFadeDistance;
		uniform float _DepthFadeIntensity;
		uniform float _Smoothness;


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
			float temp_output_66_0 = ( _Time.y * _WaveSpeed );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult70 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile71 = appendResult70;
			float4 WaveTileUV82 = ( ( WorldSpaceTile71 * float4( _WaveLenght, 0.0 , 0.0 ) ) * _WaveTiling );
			float2 panner63 = ( temp_output_66_0 * _WaveDir + WaveTileUV82.xy);
			float simplePerlin2D61 = snoise( panner63*5.0 );
			float2 panner84 = ( temp_output_66_0 * _WaveDir + ( WaveTileUV82 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D85 = snoise( panner84 );
			float temp_output_87_0 = ( simplePerlin2D61 + simplePerlin2D85 );
			float WavePattern88 = temp_output_87_0;
			float3 WaveHeight89 = ( float3(0,1,0) * _WaveHeight * WavePattern88 );
			v.vertex.xyz += WaveHeight89;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 appendResult70 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile71 = appendResult70;
			float4 temp_output_140_0 = ( WorldSpaceTile71 * _NormalTile );
			float2 panner150 = ( 1.0 * _Time.y * ( float2( 1,0 ) * _PanSpeed1 ) + temp_output_140_0.xy);
			float2 panner149 = ( 1.0 * _Time.y * ( float2( -1,0 ) * _PanSpeed2 ) + ( temp_output_140_0 * ( _NormalTile * 5.0 ) ).xy);
			float3 Normals159 = BlendNormals( tex2D( _NormalMap, panner150 ).rgb , tex2D( _NormalMap, panner149 ).rgb );
			o.Normal = Normals159;
			float temp_output_66_0 = ( _Time.y * _WaveSpeed );
			float4 WaveTileUV82 = ( ( WorldSpaceTile71 * float4( _WaveLenght, 0.0 , 0.0 ) ) * _WaveTiling );
			float2 panner63 = ( temp_output_66_0 * _WaveDir + WaveTileUV82.xy);
			float simplePerlin2D61 = snoise( panner63*5.0 );
			float2 panner84 = ( temp_output_66_0 * _WaveDir + ( WaveTileUV82 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D85 = snoise( panner84 );
			float temp_output_87_0 = ( simplePerlin2D61 + simplePerlin2D85 );
			float WavePattern88 = temp_output_87_0;
			float4 lerpResult97 = lerp( _WaterColor , _TopColor , saturate( WavePattern88 ));
			o.Albedo = lerpResult97.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth130 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth130 = abs( ( screenDepth130 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) );
			float DepthFade137 = ( ( 1.0 - saturate( distanceDepth130 ) ) * _DepthFadeIntensity );
			float3 temp_cast_8 = (DepthFade137).xxx;
			o.Emission = temp_cast_8;
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
7;1;1906;1019;-4371.91;1888.447;1.526088;True;False
Node;AmplifyShaderEditor.CommentaryNode;72;901.3069,-887.9442;Inherit;False;855.8676;321.0464;World Space UV;3;69;70;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;69;951.3069,-837.9442;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;70;1249.491,-819.8977;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;1503.174,-808.6226;Inherit;False;WorldSpaceTile;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;75;2093.686,-735.2703;Inherit;False;Property;_WaveLenght;WaveLenght;0;0;Create;True;0;0;0;False;0;False;0,0;5.56,36.89;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;73;2046.88,-830.1728;Inherit;False;71;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;77;2331.092,-657.8181;Inherit;False;Property;_WaveTiling;WaveTiling;1;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;2356.35,-802.6201;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;2543.245,-800.9359;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;2724.729,-806.022;Inherit;False;WaveTileUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;1792.295,8.893746;Inherit;False;82;WaveTileUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;67;1644.663,452.4441;Inherit;False;Property;_WaveSpeed;WaveSpeed;3;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;65;1627.842,322.5648;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;2374.227,453.9274;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1838.885,374.8742;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;64;1637.267,180.379;Inherit;False;Property;_WaveDir;WaveDir;2;0;Create;True;0;0;0;False;0;False;0,0;-0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;142;3401.723,-1392.243;Inherit;False;Property;_NormalTile;NormalTile;10;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;63;2282.186,5.503312;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;3368.424,-1521.456;Inherit;False;71;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;161;1183.366,858.3358;Inherit;False;1446.565;278.7552;Depth;7;131;130;136;135;133;132;137;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;84;2497.168,598.8948;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;68;2421.239,171.8637;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;4066.522,-1253.281;Inherit;False;Property;_PanSpeed1;PanSpeed1;12;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;1233.366,988.3794;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;8;0;Create;True;0;0;0;False;0;False;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;85;2901.602,592.3759;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;3728.357,-1497.929;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;61;2758.534,67.87372;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;151;4028.202,-1405.01;Inherit;False;Constant;_PanDirection;PanDirection;13;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;152;4297.719,-1024.698;Inherit;False;Constant;_PanDirection2;PanDirection2;13;0;Create;True;0;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;3744.413,-1087.473;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;4324.989,-801.5088;Inherit;False;Property;_PanSpeed2;PanSpeed2;13;0;Create;True;0;0;0;False;0;False;0;0.042;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;4272.861,-1403.148;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;4498.749,-1001.331;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;4004.498,-1066.385;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DepthFade;130;1499.652,913.7454;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;3311.571,533.5717;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;136;1767.785,921.425;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;3693.793,441.1516;Inherit;True;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;149;4639.475,-1117.934;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;150;4522.317,-1483.456;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;144;4853.574,-1354.857;Inherit;True;Property;_NormalMap;NormalMap;11;0;Create;True;0;0;0;False;0;False;None;aa72b7b4063494e48bfe07e6d3f3fbd9;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;133;1961.478,1022.091;Inherit;False;Property;_DepthFadeIntensity;DepthFadeIntensity;9;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;135;1944.919,908.3358;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;78;2800.935,-515.0092;Inherit;False;Constant;_WaveUpDir;WaveUpDir;5;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;146;5303.112,-1273.974;Inherit;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;145;5316.868,-1471.174;Inherit;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;2732.102,-354.3184;Inherit;False;Property;_WaveHeight;WaveHeight;4;0;Create;True;0;0;0;False;0;False;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;2819.136,-176.28;Inherit;False;88;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;4628.419,136.7468;Inherit;False;88;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;3084.737,-477.631;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;2167.479,917.0908;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;157;5711.417,-1401.583;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;2386.931,926.7469;Inherit;False;DepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;96;4583.802,-351.4431;Inherit;False;Property;_WaterColor;WaterColor;6;0;Create;True;0;0;0;False;0;False;0.01432895,0.3787474,0.4339623,0;0,0.8199613,0.9433962,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;6028.313,-1367.301;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;134;4861.618,79.70928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;95;4301.539,-172.1101;Inherit;False;Property;_TopColor;TopColor;7;0;Create;True;0;0;0;False;0;False;0.01134745,0.4204375,0.4811321,0;0.01134745,0.4204375,0.4811321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;3357.328,-443.9699;Inherit;False;WaveHeight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;172;1820.646,1448.163;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;180;1889.295,1848.078;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;112;6170.857,486.398;Inherit;False;89;WaveHeight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;162;1319.72,1435.299;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;189;2162.451,1444.842;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;1589.245,1574.264;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;0.92;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;97;5004.623,-202.9117;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;109;3730.835,670.7788;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;178;2309.618,1792.764;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;5386.451,103.4884;Inherit;False;137;DepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;5435.512,3.32734;Inherit;False;159;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;92;5736.888,155.8469;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;185;3362.146,1453.276;Inherit;False;Foam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;2180.896,1913.689;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;12.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;3927.332,691.4623;Inherit;False;SteppedWavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;4981.181,355.0243;Inherit;True;88;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;203;5289.643,370.2706;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;204;5795.655,340.6219;Inherit;True;Property;_TextureSample2;Texture Sample 2;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;2662.303,1472.23;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;6708.608,-40.42206;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;SimpleSeaShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;2;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;70;0;69;1
WireConnection;70;1;69;3
WireConnection;71;0;70;0
WireConnection;74;0;73;0
WireConnection;74;1;75;0
WireConnection;76;0;74;0
WireConnection;76;1;77;0
WireConnection;82;0;76;0
WireConnection;86;0;83;0
WireConnection;66;0;65;0
WireConnection;66;1;67;0
WireConnection;63;0;83;0
WireConnection;63;2;64;0
WireConnection;63;1;66;0
WireConnection;84;0;86;0
WireConnection;84;2;64;0
WireConnection;84;1;66;0
WireConnection;85;0;84;0
WireConnection;140;0;139;0
WireConnection;140;1;142;0
WireConnection;61;0;63;0
WireConnection;61;1;68;0
WireConnection;148;0;142;0
WireConnection;153;0;151;0
WireConnection;153;1;154;0
WireConnection;156;0;152;0
WireConnection;156;1;155;0
WireConnection;147;0;140;0
WireConnection;147;1;148;0
WireConnection;130;0;131;0
WireConnection;87;0;61;0
WireConnection;87;1;85;0
WireConnection;136;0;130;0
WireConnection;88;0;87;0
WireConnection;149;0;147;0
WireConnection;149;2;156;0
WireConnection;150;0;140;0
WireConnection;150;2;153;0
WireConnection;135;0;136;0
WireConnection;146;0;144;0
WireConnection;146;1;149;0
WireConnection;145;0;144;0
WireConnection;145;1;150;0
WireConnection;79;0;78;0
WireConnection;79;1;80;0
WireConnection;79;2;90;0
WireConnection;132;0;135;0
WireConnection;132;1;133;0
WireConnection;157;0;145;0
WireConnection;157;1;146;0
WireConnection;137;0;132;0
WireConnection;159;0;157;0
WireConnection;134;0;98;0
WireConnection;89;0;79;0
WireConnection;172;0;162;2
WireConnection;172;1;173;0
WireConnection;189;0;172;0
WireConnection;97;0;96;0
WireConnection;97;1;95;0
WireConnection;97;2;134;0
WireConnection;109;0;87;0
WireConnection;178;0;180;0
WireConnection;178;1;181;0
WireConnection;185;0;182;0
WireConnection;110;0;109;0
WireConnection;203;0;106;0
WireConnection;182;0;189;0
WireConnection;182;1;178;0
WireConnection;0;0;97;0
WireConnection;0;1;160;0
WireConnection;0;2;187;0
WireConnection;0;4;92;0
WireConnection;0;11;112;0
ASEEND*/
//CHKSM=A498F4D99174EE373A492958ED5D95A6829B1411