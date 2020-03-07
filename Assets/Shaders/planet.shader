// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "planet"
{
	Properties
	{
		_Noise1_TimeScaleY("Noise1_TimeScaleY", Float) = 0
		_Noise1_TimeScaleX("Noise1_TimeScaleX", Float) = 0
		_Noise1_O("Noise1_O", Float) = 0
		_Noise1_S("Noise1_S", Float) = 0
		_Noise1_W("Noise1_W", Float) = 0
		_Noise1_LerpOffset("Noise1_LerpOffset", Range( -1 , 1)) = 0
		_Noise1_SMult("Noise1_SMult", Float) = 0
		_Noise1_WMult("Noise1_WMult", Float) = 0
		[KeywordEnum(Key0,Key1,Key2,Key3,Key4,Key5)] _Noise1_FractLevel("Noise1_FractLevel", Float) = 0
		_Terre("Terre", Color) = (0,0,0,0)
		_Mer("Mer", Color) = (0,0,0,0)
		_Float0("Float 0", Float) = 0
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			
			CGPROGRAM

#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
		//only defining to not throw compilation error over Unity 5.5
		#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma shader_feature _NOISE1_FRACTLEVEL_KEY0 _NOISE1_FRACTLEVEL_KEY1 _NOISE1_FRACTLEVEL_KEY2 _NOISE1_FRACTLEVEL_KEY3 _NOISE1_FRACTLEVEL_KEY4 _NOISE1_FRACTLEVEL_KEY5


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform float _Noise1_TimeScaleY;
			uniform float _Noise1_TimeScaleX;
			uniform float _Noise1_S;
			uniform float _Noise1_W;
			uniform float _Noise1_O;
			uniform float _Noise1_SMult;
			uniform float _Noise1_WMult;
			uniform float _Noise1_LerpOffset;
			uniform float _Float0;
			uniform float4 _Terre;
			uniform float4 _Mer;
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
			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float mulTime12 = _Time.y * _Noise1_TimeScaleY;
				float mulTime11 = _Time.y * _Noise1_TimeScaleX;
				float2 appendResult14 = (float2(mulTime12 , mulTime11));
				float3 temp_output_9_0_g59 = ( ase_worldPos + float3( appendResult14 ,  0.0 ) );
				float temp_output_4_0_g59 = _Noise1_S;
				float simplePerlin3D8_g59 = snoise( ( temp_output_9_0_g59 * temp_output_4_0_g59 ) );
				float temp_output_5_0_g59 = _Noise1_W;
				float temp_output_35_17_g2 = ( ( simplePerlin3D8_g59 * temp_output_5_0_g59 ) + _Noise1_O );
				float3 temp_output_9_0_g57 = temp_output_9_0_g59;
				float temp_output_6_0_g59 = _Noise1_SMult;
				float temp_output_4_0_g57 = ( temp_output_4_0_g59 * temp_output_6_0_g59 );
				float simplePerlin3D8_g57 = snoise( ( temp_output_9_0_g57 * temp_output_4_0_g57 ) );
				float temp_output_7_0_g59 = _Noise1_WMult;
				float temp_output_5_0_g57 = ( temp_output_5_0_g59 * temp_output_7_0_g59 );
				float temp_output_34_17_g2 = ( ( simplePerlin3D8_g57 * temp_output_5_0_g57 ) + temp_output_35_17_g2 );
				float3 temp_output_9_0_g58 = temp_output_9_0_g57;
				float temp_output_6_0_g57 = temp_output_6_0_g59;
				float temp_output_4_0_g58 = ( temp_output_4_0_g57 * temp_output_6_0_g57 );
				float simplePerlin3D8_g58 = snoise( ( temp_output_9_0_g58 * temp_output_4_0_g58 ) );
				float temp_output_7_0_g57 = temp_output_7_0_g59;
				float temp_output_5_0_g58 = ( temp_output_5_0_g57 * temp_output_7_0_g57 );
				float temp_output_33_17_g2 = ( ( simplePerlin3D8_g58 * temp_output_5_0_g58 ) + temp_output_34_17_g2 );
				float3 temp_output_9_0_g55 = temp_output_9_0_g58;
				float temp_output_6_0_g58 = temp_output_6_0_g57;
				float temp_output_4_0_g55 = ( temp_output_4_0_g58 * temp_output_6_0_g58 );
				float simplePerlin3D8_g55 = snoise( ( temp_output_9_0_g55 * temp_output_4_0_g55 ) );
				float temp_output_7_0_g58 = temp_output_7_0_g57;
				float temp_output_5_0_g55 = ( temp_output_5_0_g58 * temp_output_7_0_g58 );
				float temp_output_32_17_g2 = ( ( simplePerlin3D8_g55 * temp_output_5_0_g55 ) + temp_output_33_17_g2 );
				float3 temp_output_9_0_g54 = temp_output_9_0_g55;
				float temp_output_6_0_g55 = temp_output_6_0_g58;
				float temp_output_4_0_g54 = ( temp_output_4_0_g55 * temp_output_6_0_g55 );
				float simplePerlin3D8_g54 = snoise( ( temp_output_9_0_g54 * temp_output_4_0_g54 ) );
				float temp_output_7_0_g55 = temp_output_7_0_g58;
				float temp_output_5_0_g54 = ( temp_output_5_0_g55 * temp_output_7_0_g55 );
				float temp_output_31_17_g2 = ( ( simplePerlin3D8_g54 * temp_output_5_0_g54 ) + temp_output_32_17_g2 );
				float3 temp_output_9_0_g56 = temp_output_9_0_g54;
				float temp_output_6_0_g54 = temp_output_6_0_g55;
				float temp_output_4_0_g56 = ( temp_output_4_0_g54 * temp_output_6_0_g54 );
				float simplePerlin3D8_g56 = snoise( ( temp_output_9_0_g56 * temp_output_4_0_g56 ) );
				float temp_output_7_0_g54 = temp_output_7_0_g55;
				float temp_output_5_0_g56 = ( temp_output_5_0_g54 * temp_output_7_0_g54 );
				#if defined(_NOISE1_FRACTLEVEL_KEY0)
				float staticSwitch15 = temp_output_35_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY1)
				float staticSwitch15 = temp_output_34_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY2)
				float staticSwitch15 = temp_output_33_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY3)
				float staticSwitch15 = temp_output_32_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY4)
				float staticSwitch15 = temp_output_31_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY5)
				float staticSwitch15 = ( ( simplePerlin3D8_g56 * temp_output_5_0_g56 ) + temp_output_31_17_g2 );
				#else
				float staticSwitch15 = temp_output_35_17_g2;
				#endif
				float Noise1_Layer19 = saturate( ( staticSwitch15 + _Noise1_LerpOffset ) );
				
				o.ase_texcoord.xyz = ase_worldPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				float3 vertexValue = ( Noise1_Layer19 * ( v.ase_normal * _Float0 ) );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float mulTime12 = _Time.y * _Noise1_TimeScaleY;
				float mulTime11 = _Time.y * _Noise1_TimeScaleX;
				float2 appendResult14 = (float2(mulTime12 , mulTime11));
				float3 temp_output_9_0_g59 = ( ase_worldPos + float3( appendResult14 ,  0.0 ) );
				float temp_output_4_0_g59 = _Noise1_S;
				float simplePerlin3D8_g59 = snoise( ( temp_output_9_0_g59 * temp_output_4_0_g59 ) );
				float temp_output_5_0_g59 = _Noise1_W;
				float temp_output_35_17_g2 = ( ( simplePerlin3D8_g59 * temp_output_5_0_g59 ) + _Noise1_O );
				float3 temp_output_9_0_g57 = temp_output_9_0_g59;
				float temp_output_6_0_g59 = _Noise1_SMult;
				float temp_output_4_0_g57 = ( temp_output_4_0_g59 * temp_output_6_0_g59 );
				float simplePerlin3D8_g57 = snoise( ( temp_output_9_0_g57 * temp_output_4_0_g57 ) );
				float temp_output_7_0_g59 = _Noise1_WMult;
				float temp_output_5_0_g57 = ( temp_output_5_0_g59 * temp_output_7_0_g59 );
				float temp_output_34_17_g2 = ( ( simplePerlin3D8_g57 * temp_output_5_0_g57 ) + temp_output_35_17_g2 );
				float3 temp_output_9_0_g58 = temp_output_9_0_g57;
				float temp_output_6_0_g57 = temp_output_6_0_g59;
				float temp_output_4_0_g58 = ( temp_output_4_0_g57 * temp_output_6_0_g57 );
				float simplePerlin3D8_g58 = snoise( ( temp_output_9_0_g58 * temp_output_4_0_g58 ) );
				float temp_output_7_0_g57 = temp_output_7_0_g59;
				float temp_output_5_0_g58 = ( temp_output_5_0_g57 * temp_output_7_0_g57 );
				float temp_output_33_17_g2 = ( ( simplePerlin3D8_g58 * temp_output_5_0_g58 ) + temp_output_34_17_g2 );
				float3 temp_output_9_0_g55 = temp_output_9_0_g58;
				float temp_output_6_0_g58 = temp_output_6_0_g57;
				float temp_output_4_0_g55 = ( temp_output_4_0_g58 * temp_output_6_0_g58 );
				float simplePerlin3D8_g55 = snoise( ( temp_output_9_0_g55 * temp_output_4_0_g55 ) );
				float temp_output_7_0_g58 = temp_output_7_0_g57;
				float temp_output_5_0_g55 = ( temp_output_5_0_g58 * temp_output_7_0_g58 );
				float temp_output_32_17_g2 = ( ( simplePerlin3D8_g55 * temp_output_5_0_g55 ) + temp_output_33_17_g2 );
				float3 temp_output_9_0_g54 = temp_output_9_0_g55;
				float temp_output_6_0_g55 = temp_output_6_0_g58;
				float temp_output_4_0_g54 = ( temp_output_4_0_g55 * temp_output_6_0_g55 );
				float simplePerlin3D8_g54 = snoise( ( temp_output_9_0_g54 * temp_output_4_0_g54 ) );
				float temp_output_7_0_g55 = temp_output_7_0_g58;
				float temp_output_5_0_g54 = ( temp_output_5_0_g55 * temp_output_7_0_g55 );
				float temp_output_31_17_g2 = ( ( simplePerlin3D8_g54 * temp_output_5_0_g54 ) + temp_output_32_17_g2 );
				float3 temp_output_9_0_g56 = temp_output_9_0_g54;
				float temp_output_6_0_g54 = temp_output_6_0_g55;
				float temp_output_4_0_g56 = ( temp_output_4_0_g54 * temp_output_6_0_g54 );
				float simplePerlin3D8_g56 = snoise( ( temp_output_9_0_g56 * temp_output_4_0_g56 ) );
				float temp_output_7_0_g54 = temp_output_7_0_g55;
				float temp_output_5_0_g56 = ( temp_output_5_0_g54 * temp_output_7_0_g54 );
				#if defined(_NOISE1_FRACTLEVEL_KEY0)
				float staticSwitch15 = temp_output_35_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY1)
				float staticSwitch15 = temp_output_34_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY2)
				float staticSwitch15 = temp_output_33_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY3)
				float staticSwitch15 = temp_output_32_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY4)
				float staticSwitch15 = temp_output_31_17_g2;
				#elif defined(_NOISE1_FRACTLEVEL_KEY5)
				float staticSwitch15 = ( ( simplePerlin3D8_g56 * temp_output_5_0_g56 ) + temp_output_31_17_g2 );
				#else
				float staticSwitch15 = temp_output_35_17_g2;
				#endif
				float Noise1_Layer19 = saturate( ( staticSwitch15 + _Noise1_LerpOffset ) );
				float4 lerpResult24 = lerp( _Terre , _Mer , Noise1_Layer19);
				
				
				finalColor = lerpResult24;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
344;997;1271;727;-152.6479;721.4396;1.160094;True;True
Node;AmplifyShaderEditor.RangedFloatNode;10;-450.5144,-310.8311;Float;False;Property;_Noise1_TimeScaleX;Noise1_TimeScaleX;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-452.6294,-387.712;Float;False;Property;_Noise1_TimeScaleY;Noise1_TimeScaleY;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-191.4853,-384.2813;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-195.4853,-294.7812;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;22;-356.5155,-777.0146;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;14;-12.78538,-368.1813;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;390.9907,-228.3376;Float;False;Property;_Noise1_W;Noise1_W;5;0;Create;True;0;0;False;0;0;7.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;223.3617,-643.0231;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;4;355.9907,-66.33762;Float;False;Property;_Noise1_WMult;Noise1_WMult;8;0;Create;True;0;0;False;0;0;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;390.1611,-381.0384;Float;False;Property;_Noise1_O;Noise1_O;3;0;Create;True;0;0;False;0;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;391.9907,-309.3376;Float;False;Property;_Noise1_S;Noise1_S;4;0;Create;True;0;0;False;0;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;353.9907,-144.3376;Float;False;Property;_Noise1_SMult;Noise1_SMult;7;0;Create;True;0;0;False;0;0;1.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2;592.2542,-497.0314;Float;False;FractalNoise;-1;;2;abbe4fe1aa3b7b546b5399cef5641f91;0;6;11;FLOAT3;0,0,0;False;23;FLOAT;0;False;13;FLOAT;0;False;19;FLOAT;0;False;15;FLOAT;0;False;20;FLOAT;0;False;6;FLOAT;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51;FLOAT;52
Node;AmplifyShaderEditor.StaticSwitch;15;1078.145,-512.0448;Float;False;Property;_Noise1_FractLevel;Noise1_FractLevel;9;0;Create;True;0;0;False;0;0;0;4;True;;KeywordEnum;6;Key0;Key1;Key2;Key3;Key4;Key5;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;961.0619,-115.1621;Float;False;Property;_Noise1_LerpOffset;Noise1_LerpOffset;6;0;Create;True;0;0;False;0;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;1267.358,-193.4851;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;18;1396.168,-194.841;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;45;1346.359,-113.9581;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;1310.532,67.04731;Float;False;Property;_Float0;Float 0;12;0;Create;True;0;0;False;0;0;-0.0005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;1960.558,-94.17397;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;26;1499.884,326.3059;Float;False;Property;_Mer;Mer;11;0;Create;True;0;0;False;0;0,0,0,0;0,0.1611173,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;25;1186.208,328.8509;Float;False;Property;_Terre;Terre;10;0;Create;True;0;0;False;0;0,0,0,0;0.25,1,0.3735295,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;1567.137,-199.0039;Float;False;Noise1_Layer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;48;2191.603,210.1813;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;2182.138,-179.0205;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;13;-371.8685,-630.7803;Float;False;Property;_Noise1_TilingTexCoords;Noise1_TilingTexCoords;2;0;Create;True;0;0;False;0;0,0;1.11,0.62;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;51;1913.332,318.8656;Float;False;Property;_TesselationMaxdist;TesselationMaxdist;15;0;Create;True;0;0;False;0;0;6.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;1874.332,149.8656;Float;False;Property;_TesselationFactor;TesselationFactor;13;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;1907.332,231.8656;Float;False;Property;_TesselationMinDist;TesselationMinDist;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;1685.909,59.79564;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;55;2746.747,-221.7035;Float;False;True;2;Float;ASEMaterialInspector;0;1;planet;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;12;0;9;0
WireConnection;11;0;10;0
WireConnection;14;0;12;0
WireConnection;14;1;11;0
WireConnection;56;0;22;0
WireConnection;56;1;14;0
WireConnection;2;11;56;0
WireConnection;2;23;6;0
WireConnection;2;13;3;0
WireConnection;2;19;7;0
WireConnection;2;15;5;0
WireConnection;2;20;4;0
WireConnection;15;1;2;0
WireConnection;15;0;2;48
WireConnection;15;2;2;49
WireConnection;15;3;2;50
WireConnection;15;4;2;51
WireConnection;15;5;2;52
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;46;0;45;0
WireConnection;46;1;28;0
WireConnection;19;0;18;0
WireConnection;48;0;49;0
WireConnection;48;1;50;0
WireConnection;48;2;51;0
WireConnection;27;0;19;0
WireConnection;27;1;46;0
WireConnection;24;0;25;0
WireConnection;24;1;26;0
WireConnection;24;2;19;0
WireConnection;55;0;24;0
WireConnection;55;1;27;0
ASEEND*/
//CHKSM=848E0BE61B4CE4DDBF78674A7B7A833186FDC86D