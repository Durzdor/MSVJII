// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Underwater"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_FlowmapIntensity("FlowmapIntensity", Range( 0 , 1)) = 0.31

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _TextureSample1;
			uniform float _FlowmapIntensity;


			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 uv_MainTex = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 texCoord9 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner8 = ( _Time.y * float2( 0.2,0.1 ) + texCoord9);
				

				float4 color = tex2D( _MainTex, ( float4( uv_MainTex, 0.0 , 0.0 ) + ( tex2D( _TextureSample1, panner8 ) * _FlowmapIntensity ) ).rg );
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;7;1906;1012;1930.022;764.9426;1.380182;True;False
Node;AmplifyShaderEditor.RangedFloatNode;12;-1997.586,405.4916;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-2083.586,52.49159;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;10;-2106.586,199.4916;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;0.2,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1851.586,314.4916;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;8;-1645.933,63.1119;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;13;-1205.891,55.61693;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;0ce1f828ff2aa6646b24a727e6e3b188;0ce1f828ff2aa6646b24a727e6e3b188;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-1536.019,-442.5003;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-976.3165,319.8806;Inherit;False;Property;_FlowmapIntensity;FlowmapIntensity;1;0;Create;True;0;0;0;False;0;False;0.31;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1209.358,-153.2834;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-887.9853,27.28197;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-794.2446,-116.5975;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-481.4182,-266.8097;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;140.5864,-80.91307;Float;False;True;-1;2;ASEMaterialInspector;0;2;Underwater;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;11;0;12;0
WireConnection;8;0;9;0
WireConnection;8;2;10;0
WireConnection;8;1;11;0
WireConnection;13;1;8;0
WireConnection;6;2;1;0
WireConnection;14;0;13;0
WireConnection;14;1;15;0
WireConnection;7;0;6;0
WireConnection;7;1;14;0
WireConnection;3;0;1;0
WireConnection;3;1;7;0
WireConnection;0;0;3;0
ASEEND*/
//CHKSM=039F2AD3E02A0F16FBE4851A350C5EA857CF46BA