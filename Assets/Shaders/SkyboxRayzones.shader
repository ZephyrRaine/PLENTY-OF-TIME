// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SG/Skybox/Rayzones"
{
	Properties
	{
		_MainSkyboxColor("MainSkyboxColor", Color) = (0,0,0,0)
		_Noise1Color("Noise1Color", Color) = (0,0,0,0)
		_Noise1_TimeScaleY("Noise1_TimeScaleY", Float) = 0
		_Noise1_TimeScaleX("Noise1_TimeScaleX", Float) = 0
		_Noise1_TilingTexCoords("Noise1_TilingTexCoords", Vector) = (0,0,0,0)
		_Noise1_LerpOffset("Noise1_LerpOffset", Range( -1 , 1)) = 0
		_Noise1_O("Noise1_O", Float) = 0
		_Noise1_S("Noise1_S", Float) = 0
		_Noise1_W("Noise1_W", Float) = 0
		_Noise1_SMult("Noise1_SMult", Float) = 0
		_Noise1_WMult("Noise1_WMult", Float) = 0
		[KeywordEnum(Key0,Key1,Key2,Key3,Key4,Key5)] _Noise1_FractLevel("Noise1_FractLevel", Float) = 0
		_Noise2Color("Noise2Color", Color) = (0,0,0,0)
		_Noise2_TimeScaleY("Noise2_TimeScaleY", Float) = 0
		_Noise2_TimeScaleX("Noise2_TimeScaleX", Float) = 0
		_Noise2_TilingTexCoords("Noise2_TilingTexCoords", Vector) = (0,0,0,0)
		_Noise2_LerpOffset("Noise2_LerpOffset", Range( -1 , 1)) = 0
		_Noise2_O("Noise2_O", Float) = 0
		_Noise2_S("Noise2_S", Float) = 0
		_Noise2_W("Noise2_W", Float) = 0
		_Noise2_SMult("Noise2_SMult", Float) = 0
		_Noise2_WMult("Noise2_WMult", Float) = 0
		[KeywordEnum(Key0,Key1,Key2,Key3,Key4,Key5)] _Noise2_FractLevel("Noise2_FractLevel", Float) = 0
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 0
		[NoScaleOffset]_StarsCubemap("Stars Cubemap", CUBE) = "black" {}
		_StarLayer1Intensity("Star Layer 1 Intensity", Range( 0 , 1)) = 1
		_StarLayer2Intensity("Star Layer 2 Intensity", Range( 0 , 1)) = 1
		_StarLayer3Intensity("Star Layer 3 Intensity", Range( 0 , 1)) = 0.8474913
		_StarSize("Star Size", Vector) = (0.1,0.1,0.1,0)
		_StarsColor("StarsColor", Color) = (0,0,0,0)
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
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
			#pragma shader_feature _NOISE2_FRACTLEVEL_KEY0 _NOISE2_FRACTLEVEL_KEY1 _NOISE2_FRACTLEVEL_KEY2 _NOISE2_FRACTLEVEL_KEY3 _NOISE2_FRACTLEVEL_KEY4 _NOISE2_FRACTLEVEL_KEY5


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform float _ToggleSwitch0;
			uniform float4 _MainSkyboxColor;
			uniform float4 _Noise1Color;
			uniform float2 _Noise1_TilingTexCoords;
			uniform float _Noise1_TimeScaleY;
			uniform float _Noise1_TimeScaleX;
			uniform float _Noise1_S;
			uniform float _Noise1_W;
			uniform float _Noise1_O;
			uniform float _Noise1_SMult;
			uniform float _Noise1_WMult;
			uniform float _Noise1_LerpOffset;
			uniform float4 _Noise2Color;
			uniform float2 _Noise2_TilingTexCoords;
			uniform float _Noise2_TimeScaleY;
			uniform float _Noise2_TimeScaleX;
			uniform float _Noise2_S;
			uniform float _Noise2_W;
			uniform float _Noise2_O;
			uniform float _Noise2_SMult;
			uniform float _Noise2_WMult;
			uniform float _Noise2_LerpOffset;
			uniform float4 _StarsColor;
			uniform samplerCUBE _StarsCubemap;
			uniform float _StarLayer1Intensity;
			uniform float3 _StarSize;
			uniform float _StarLayer2Intensity;
			uniform float _StarLayer3Intensity;
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

				o.ase_texcoord.xyz = v.ase_texcoord.xyz;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				float3 vertexValue =  float3(0,0,0) ;
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
				float4 color137 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
				float4 color139 = IsGammaSpace() ? float4(0,1,0,0) : float4(0,1,0,0);
				float mulTime149 = _Time.y * _Noise1_TimeScaleY;
				float mulTime151 = _Time.y * _Noise1_TimeScaleX;
				float2 appendResult150 = (float2(mulTime149 , mulTime151));
				float3 uv0152 = i.ase_texcoord.xyz;
				uv0152.xy = i.ase_texcoord.xyz.xy * _Noise1_TilingTexCoords + appendResult150;
				float3 temp_output_9_0_g128 = uv0152;
				float temp_output_4_0_g128 = _Noise1_S;
				float simplePerlin3D8_g128 = snoise( ( temp_output_9_0_g128 * temp_output_4_0_g128 ) );
				float temp_output_5_0_g128 = _Noise1_W;
				float temp_output_35_17_g122 = ( ( simplePerlin3D8_g128 * temp_output_5_0_g128 ) + _Noise1_O );
				float3 temp_output_9_0_g126 = temp_output_9_0_g128;
				float temp_output_6_0_g128 = _Noise1_SMult;
				float temp_output_4_0_g126 = ( temp_output_4_0_g128 * temp_output_6_0_g128 );
				float simplePerlin3D8_g126 = snoise( ( temp_output_9_0_g126 * temp_output_4_0_g126 ) );
				float temp_output_7_0_g128 = _Noise1_WMult;
				float temp_output_5_0_g126 = ( temp_output_5_0_g128 * temp_output_7_0_g128 );
				float temp_output_34_17_g122 = ( ( simplePerlin3D8_g126 * temp_output_5_0_g126 ) + temp_output_35_17_g122 );
				float3 temp_output_9_0_g127 = temp_output_9_0_g126;
				float temp_output_6_0_g126 = temp_output_6_0_g128;
				float temp_output_4_0_g127 = ( temp_output_4_0_g126 * temp_output_6_0_g126 );
				float simplePerlin3D8_g127 = snoise( ( temp_output_9_0_g127 * temp_output_4_0_g127 ) );
				float temp_output_7_0_g126 = temp_output_7_0_g128;
				float temp_output_5_0_g127 = ( temp_output_5_0_g126 * temp_output_7_0_g126 );
				float temp_output_33_17_g122 = ( ( simplePerlin3D8_g127 * temp_output_5_0_g127 ) + temp_output_34_17_g122 );
				float3 temp_output_9_0_g124 = temp_output_9_0_g127;
				float temp_output_6_0_g127 = temp_output_6_0_g126;
				float temp_output_4_0_g124 = ( temp_output_4_0_g127 * temp_output_6_0_g127 );
				float simplePerlin3D8_g124 = snoise( ( temp_output_9_0_g124 * temp_output_4_0_g124 ) );
				float temp_output_7_0_g127 = temp_output_7_0_g126;
				float temp_output_5_0_g124 = ( temp_output_5_0_g127 * temp_output_7_0_g127 );
				float temp_output_32_17_g122 = ( ( simplePerlin3D8_g124 * temp_output_5_0_g124 ) + temp_output_33_17_g122 );
				float3 temp_output_9_0_g123 = temp_output_9_0_g124;
				float temp_output_6_0_g124 = temp_output_6_0_g127;
				float temp_output_4_0_g123 = ( temp_output_4_0_g124 * temp_output_6_0_g124 );
				float simplePerlin3D8_g123 = snoise( ( temp_output_9_0_g123 * temp_output_4_0_g123 ) );
				float temp_output_7_0_g124 = temp_output_7_0_g127;
				float temp_output_5_0_g123 = ( temp_output_5_0_g124 * temp_output_7_0_g124 );
				float temp_output_31_17_g122 = ( ( simplePerlin3D8_g123 * temp_output_5_0_g123 ) + temp_output_32_17_g122 );
				float3 temp_output_9_0_g125 = temp_output_9_0_g123;
				float temp_output_6_0_g123 = temp_output_6_0_g124;
				float temp_output_4_0_g125 = ( temp_output_4_0_g123 * temp_output_6_0_g123 );
				float simplePerlin3D8_g125 = snoise( ( temp_output_9_0_g125 * temp_output_4_0_g125 ) );
				float temp_output_7_0_g123 = temp_output_7_0_g124;
				float temp_output_5_0_g125 = ( temp_output_5_0_g123 * temp_output_7_0_g123 );
				#if defined(_NOISE1_FRACTLEVEL_KEY0)
				float staticSwitch161 = temp_output_35_17_g122;
				#elif defined(_NOISE1_FRACTLEVEL_KEY1)
				float staticSwitch161 = temp_output_34_17_g122;
				#elif defined(_NOISE1_FRACTLEVEL_KEY2)
				float staticSwitch161 = temp_output_33_17_g122;
				#elif defined(_NOISE1_FRACTLEVEL_KEY3)
				float staticSwitch161 = temp_output_32_17_g122;
				#elif defined(_NOISE1_FRACTLEVEL_KEY4)
				float staticSwitch161 = temp_output_31_17_g122;
				#elif defined(_NOISE1_FRACTLEVEL_KEY5)
				float staticSwitch161 = ( ( simplePerlin3D8_g125 * temp_output_5_0_g125 ) + temp_output_31_17_g122 );
				#else
				float staticSwitch161 = temp_output_35_17_g122;
				#endif
				float Noise1_Layer112 = saturate( ( staticSwitch161 + _Noise1_LerpOffset ) );
				float4 lerpResult120 = lerp( lerp(_MainSkyboxColor,color137,_ToggleSwitch0) , lerp(_Noise1Color,color139,_ToggleSwitch0) , Noise1_Layer112);
				float4 color197 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
				float mulTime179 = _Time.y * _Noise2_TimeScaleY;
				float mulTime178 = _Time.y * _Noise2_TimeScaleX;
				float2 appendResult180 = (float2(mulTime179 , mulTime178));
				float3 uv0182 = i.ase_texcoord.xyz;
				uv0182.xy = i.ase_texcoord.xyz.xy * _Noise2_TilingTexCoords + appendResult180;
				float3 temp_output_9_0_g121 = uv0182;
				float temp_output_4_0_g121 = _Noise2_S;
				float simplePerlin3D8_g121 = snoise( ( temp_output_9_0_g121 * temp_output_4_0_g121 ) );
				float temp_output_5_0_g121 = _Noise2_W;
				float temp_output_35_17_g115 = ( ( simplePerlin3D8_g121 * temp_output_5_0_g121 ) + _Noise2_O );
				float3 temp_output_9_0_g119 = temp_output_9_0_g121;
				float temp_output_6_0_g121 = _Noise2_SMult;
				float temp_output_4_0_g119 = ( temp_output_4_0_g121 * temp_output_6_0_g121 );
				float simplePerlin3D8_g119 = snoise( ( temp_output_9_0_g119 * temp_output_4_0_g119 ) );
				float temp_output_7_0_g121 = _Noise2_WMult;
				float temp_output_5_0_g119 = ( temp_output_5_0_g121 * temp_output_7_0_g121 );
				float temp_output_34_17_g115 = ( ( simplePerlin3D8_g119 * temp_output_5_0_g119 ) + temp_output_35_17_g115 );
				float3 temp_output_9_0_g120 = temp_output_9_0_g119;
				float temp_output_6_0_g119 = temp_output_6_0_g121;
				float temp_output_4_0_g120 = ( temp_output_4_0_g119 * temp_output_6_0_g119 );
				float simplePerlin3D8_g120 = snoise( ( temp_output_9_0_g120 * temp_output_4_0_g120 ) );
				float temp_output_7_0_g119 = temp_output_7_0_g121;
				float temp_output_5_0_g120 = ( temp_output_5_0_g119 * temp_output_7_0_g119 );
				float temp_output_33_17_g115 = ( ( simplePerlin3D8_g120 * temp_output_5_0_g120 ) + temp_output_34_17_g115 );
				float3 temp_output_9_0_g117 = temp_output_9_0_g120;
				float temp_output_6_0_g120 = temp_output_6_0_g119;
				float temp_output_4_0_g117 = ( temp_output_4_0_g120 * temp_output_6_0_g120 );
				float simplePerlin3D8_g117 = snoise( ( temp_output_9_0_g117 * temp_output_4_0_g117 ) );
				float temp_output_7_0_g120 = temp_output_7_0_g119;
				float temp_output_5_0_g117 = ( temp_output_5_0_g120 * temp_output_7_0_g120 );
				float temp_output_32_17_g115 = ( ( simplePerlin3D8_g117 * temp_output_5_0_g117 ) + temp_output_33_17_g115 );
				float3 temp_output_9_0_g116 = temp_output_9_0_g117;
				float temp_output_6_0_g117 = temp_output_6_0_g120;
				float temp_output_4_0_g116 = ( temp_output_4_0_g117 * temp_output_6_0_g117 );
				float simplePerlin3D8_g116 = snoise( ( temp_output_9_0_g116 * temp_output_4_0_g116 ) );
				float temp_output_7_0_g117 = temp_output_7_0_g120;
				float temp_output_5_0_g116 = ( temp_output_5_0_g117 * temp_output_7_0_g117 );
				float temp_output_31_17_g115 = ( ( simplePerlin3D8_g116 * temp_output_5_0_g116 ) + temp_output_32_17_g115 );
				float3 temp_output_9_0_g118 = temp_output_9_0_g116;
				float temp_output_6_0_g116 = temp_output_6_0_g117;
				float temp_output_4_0_g118 = ( temp_output_4_0_g116 * temp_output_6_0_g116 );
				float simplePerlin3D8_g118 = snoise( ( temp_output_9_0_g118 * temp_output_4_0_g118 ) );
				float temp_output_7_0_g116 = temp_output_7_0_g117;
				float temp_output_5_0_g118 = ( temp_output_5_0_g116 * temp_output_7_0_g116 );
				#if defined(_NOISE2_FRACTLEVEL_KEY0)
				float staticSwitch190 = temp_output_35_17_g115;
				#elif defined(_NOISE2_FRACTLEVEL_KEY1)
				float staticSwitch190 = temp_output_34_17_g115;
				#elif defined(_NOISE2_FRACTLEVEL_KEY2)
				float staticSwitch190 = temp_output_33_17_g115;
				#elif defined(_NOISE2_FRACTLEVEL_KEY3)
				float staticSwitch190 = temp_output_32_17_g115;
				#elif defined(_NOISE2_FRACTLEVEL_KEY4)
				float staticSwitch190 = temp_output_31_17_g115;
				#elif defined(_NOISE2_FRACTLEVEL_KEY5)
				float staticSwitch190 = ( ( simplePerlin3D8_g118 * temp_output_5_0_g118 ) + temp_output_31_17_g115 );
				#else
				float staticSwitch190 = temp_output_35_17_g115;
				#endif
				float Noise2_Layer175 = saturate( ( staticSwitch190 + _Noise2_LerpOffset ) );
				float4 lerpResult191 = lerp( lerpResult120 , lerp(_Noise2Color,color197,_ToggleSwitch0) , Noise2_Layer175);
				float3 uv_StarsCubemap593 = i.ase_texcoord.xyz;
				float4 texCUBENode59 = texCUBE( _StarsCubemap, uv_StarsCubemap593 );
				float StarsLayer119 = saturate( ( pow( ( texCUBENode59.r * _StarLayer1Intensity ) , _StarSize.x ) + pow( ( texCUBENode59.g * _StarLayer2Intensity ) , _StarSize.y ) + pow( ( texCUBENode59.b * _StarLayer3Intensity ) , _StarSize.z ) ) );
				float lerpResult259 = lerp( 0.25 , 2.0 , max( Noise2_Layer175 , Noise1_Layer112 ));
				float4 lerpResult124 = lerp( lerpResult191 , _StarsColor , ( StarsLayer119 * lerpResult259 ));
				
				
				finalColor = lerpResult124;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
125;242;1271;540;-259.3736;1318.155;2.804672;True;True
Node;AmplifyShaderEditor.RangedFloatNode;108;-1702.287,-254.7387;Float;False;Property;_Noise1_TimeScaleY;Noise1_TimeScaleY;2;0;Create;True;0;0;False;0;0;0.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-1700.172,-177.8578;Float;False;Property;_Noise1_TimeScaleX;Noise1_TimeScaleX;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-1880.937,539.841;Float;False;Property;_Noise2_TimeScaleX;Noise2_TimeScaleX;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-1881.518,464.494;Float;False;Property;_Noise2_TimeScaleY;Noise2_TimeScaleY;13;0;Create;True;0;0;False;0;0;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;179;-1621.908,466.3908;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;178;-1625.908,555.8909;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;151;-1445.143,-161.8079;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;149;-1441.143,-251.308;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;150;-1262.443,-235.2081;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;110;-1699.202,-411.1685;Float;False;Property;_Noise1_TilingTexCoords;Noise1_TilingTexCoords;4;0;Create;True;0;0;False;0;0,0;-1.64,4.63;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;180;-1443.208,482.4906;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;181;-1879.967,306.5303;Float;False;Property;_Noise2_TilingTexCoords;Noise2_TilingTexCoords;15;0;Create;True;0;0;False;0;0,0;-1.84,-1.89;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;157;-987.6373,151.8728;Float;False;Property;_Noise1_WMult;Noise1_WMult;10;0;Create;True;0;0;False;0;0;0.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-952.6373,-10.12722;Float;False;Property;_Noise1_W;Noise1_W;8;0;Create;True;0;0;False;0;0;0.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;152;-989.388,-354.9169;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;156;-989.6373,73.87279;Float;False;Property;_Noise1_SMult;Noise1_SMult;9;0;Create;True;0;0;False;0;0;1.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-951.6373,-91.12714;Float;False;Property;_Noise1_S;Noise1_S;7;0;Create;True;0;0;False;0;0;1.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-953.467,-162.828;Float;False;Property;_Noise1_O;Noise1_O;6;0;Create;True;0;0;False;0;0;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-1132.403,626.5716;Float;False;Property;_Noise2_S;Noise2_S;18;0;Create;True;0;0;False;0;0;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-1133.403,707.5715;Float;False;Property;_Noise2_W;Noise2_W;19;0;Create;True;0;0;False;0;0;30.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;182;-1170.153,362.7819;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;187;-1168.403,869.5716;Float;False;Property;_Noise2_WMult;Noise2_WMult;21;0;Create;True;0;0;False;0;0;2.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-1134.232,554.8708;Float;False;Property;_Noise2_O;Noise2_O;17;0;Create;True;0;0;False;0;0;141.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;183;-1170.403,791.5716;Float;False;Property;_Noise2_SMult;Noise2_SMult;20;0;Create;True;0;0;False;0;0;5.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;247;-796.7232,500.3013;Float;True;FractalNoise;-1;;115;5716b6e40d96ba5438d926730be25351;0;6;11;FLOAT3;0,0,0;False;23;FLOAT;0;False;13;FLOAT;0;False;19;FLOAT;0;False;15;FLOAT;0;False;20;FLOAT;0;False;6;FLOAT;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51;FLOAT;52
Node;AmplifyShaderEditor.FunctionNode;248;-615.9578,-217.3974;Float;True;FractalNoise;-1;;122;5716b6e40d96ba5438d926730be25351;0;6;11;FLOAT3;0,0,0;False;23;FLOAT;0;False;13;FLOAT;0;False;19;FLOAT;0;False;15;FLOAT;0;False;20;FLOAT;0;False;6;FLOAT;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51;FLOAT;52
Node;AmplifyShaderEditor.RangedFloatNode;165;-284.6175,57.1381;Float;False;Property;_Noise1_LerpOffset;Noise1_LerpOffset;5;0;Create;True;0;0;False;0;0;-0.07;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;545.4854,457.0402;Float;False;Property;_StarLayer1Intensity;Star Layer 1 Intensity;35;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;811.1106,272.006;Float;True;Property;_StarsCubemap;Stars Cubemap;34;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;693.1507,688.196;Float;False;Property;_StarLayer3Intensity;Star Layer 3 Intensity;37;0;Create;True;0;0;False;0;0.8474913;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-465.3828,774.8369;Float;False;Property;_Noise2_LerpOffset;Noise2_LerpOffset;16;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;190;-554.0204,495.251;Float;False;Property;_Noise2_FractLevel;Noise2_FractLevel;22;0;Create;True;0;0;False;0;0;0;2;True;;KeywordEnum;6;Key0;Key1;Key2;Key3;Key4;Key5;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;161;-373.2551,-222.4477;Float;False;Property;_Noise1_FractLevel;Noise1_FractLevel;11;0;Create;True;0;0;False;0;0;0;3;True;;KeywordEnum;6;Key0;Key1;Key2;Key3;Key4;Key5;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;655.8337,556.4419;Float;False;Property;_StarLayer2Intensity;Star Layer 2 Intensity;36;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;1068.298,687.3274;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;173;-159.0861,696.5139;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;62;1045.552,920.478;Float;False;Property;_StarSize;Star Size;38;0;Create;True;0;0;False;0;0.1,0.1,0.1;3.18,0.91,1.26;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1076.136,442.074;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;1073.162,569.1021;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;166;21.67908,-21.18494;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;64;1342.557,572.5714;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;65;1387.718,715.0051;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;66;1384.432,410.2848;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;174;-30.27622,695.1579;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;167;150.489,-22.54089;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;321.4574,-26.70373;Float;False;Noise1_Layer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;140.6923,690.9951;Float;False;Noise2_Layer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;1657.564,536.51;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;139;-834.1237,-1384.64;Float;False;Constant;_Color1;Color 1;21;0;Create;True;0;0;False;0;0,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;35;-1057.83,-1295.19;Float;False;Property;_Noise1Color;Noise1Color;1;0;Create;True;0;0;False;0;0,0,0,0;0.2012014,1,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-949.103,-1541.378;Float;False;Property;_MainSkyboxColor;MainSkyboxColor;0;0;Create;True;0;0;False;0;0,0,0,0;1,0.8341393,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;137;-732.7963,-1741.755;Float;False;Constant;_Color0;Color 0;20;0;Create;True;0;0;False;0;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;201;576.5968,-689.7098;Float;False;112;Noise1_Layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;68;1853.582,357.682;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;256;584.0033,-787.5847;Float;False;175;Noise2_Layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;197;-243.6371,-932.4874;Float;False;Constant;_Color3;Color 3;21;0;Create;True;0;0;False;0;0,0,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;138;-539.7775,-1292.407;Float;False;Property;_ToggleSwitch0;Toggle Switch0;23;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;196;-467.3434,-843.0374;Float;False;Property;_Noise2Color;Noise2Color;12;0;Create;True;0;0;False;0;0,0,0,0;0.111205,0.1613563,0.4622642,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;121;-531.5142,-1159.938;Float;False;112;Noise1_Layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;136;-479.5556,-1434.469;Float;False;Property;_ToggleSwitch0;Toggle Switch0;28;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;260;996.5834,-707.4271;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;2062.575,391.6108;Float;False;StarsLayer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;199;50.70905,-840.2544;Float;False;Property;_ToggleSwitch0;Toggle Switch0;30;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;1176.687,-922.4626;Float;False;119;StarsLayer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;120;-137.891,-1283.127;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;58.97235,-707.7854;Float;False;175;Noise2_Layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;259;1084.562,-830.7877;Float;False;3;0;FLOAT;0.25;False;1;FLOAT;2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;126;672.8487,-992.0012;Float;False;Property;_StarsColor;StarsColor;39;0;Create;True;0;0;False;0;0,0,0,0;1,0,0.09067249,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;191;385.0803,-1069.007;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;1436.552,-878.0938;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;208;2479.974,-325.7715;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;2888.307,-317.8742;Float;False;Property;_StarTimeScale;StarTimeScale;40;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;220;3636.499,-17.32546;Float;False;Property;_Star_LerpOffset;Star_LerpOffset;27;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;124;1730.791,-1118.169;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;209;2475.974,-236.2715;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;2969.48,-165.5907;Float;False;Property;_Star_S;Star_S;29;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;2931.48,-0.590776;Float;False;Property;_Star_SMult;Star_SMult;31;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;223;4242.574,-101.1673;Float;False;StarNoiseLayer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;249;3305.159,-291.861;Float;True;FractalNoise;-1;;129;5716b6e40d96ba5438d926730be25351;0;6;11;FLOAT3;0,0,0;False;23;FLOAT;0;False;13;FLOAT;0;False;19;FLOAT;0;False;15;FLOAT;0;False;20;FLOAT;0;False;6;FLOAT;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51;FLOAT;52
Node;AmplifyShaderEditor.OneMinusNode;261;788.73,-570.3585;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;211;2658.674,-309.6717;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;217;2933.48,77.40925;Float;False;Property;_Star_WMult;Star_WMult;32;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;216;2942.729,-541.3805;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;204;-54.80965,-1106.903;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;219;3547.862,-296.9113;Float;False;Property;_Star_FractLevel;Star_FractLevel;33;0;Create;True;0;0;False;0;0;0;0;True;;KeywordEnum;6;Key0;Key1;Key2;Key3;Key4;Key5;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;250;3254.307,-557.8742;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;206;2220.945,-252.3214;Float;False;Property;_Star_TimeScaleX;Star_TimeScaleX;25;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;222;4071.605,-97.00445;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;2218.83,-329.2022;Float;False;Property;_Star_TimeScaleY;Star_TimeScaleY;24;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;221;3942.796,-95.64849;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;210;2221.915,-485.632;Float;False;Property;_Star_TilingTexCoords;Star_TilingTexCoords;26;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;251;3009.307,-405.8742;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;2967.65,-237.2916;Float;False;Property;_Star_O;Star_O;28;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;2968.48,-84.59079;Float;False;Property;_Star_W;Star_W;30;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2426.128,-1080.618;Float;False;True;2;Float;ASEMaterialInspector;0;1;SG/Skybox/Rayzones;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;0;False;-1;True;0;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;179;0;177;0
WireConnection;178;0;176;0
WireConnection;151;0;109;0
WireConnection;149;0;108;0
WireConnection;150;0;149;0
WireConnection;150;1;151;0
WireConnection;180;0;179;0
WireConnection;180;1;178;0
WireConnection;152;0;110;0
WireConnection;152;1;150;0
WireConnection;182;0;181;0
WireConnection;182;1;180;0
WireConnection;247;11;182;0
WireConnection;247;23;186;0
WireConnection;247;13;185;0
WireConnection;247;19;184;0
WireConnection;247;15;183;0
WireConnection;247;20;187;0
WireConnection;248;11;152;0
WireConnection;248;23;153;0
WireConnection;248;13;154;0
WireConnection;248;19;155;0
WireConnection;248;15;156;0
WireConnection;248;20;157;0
WireConnection;190;1;247;0
WireConnection;190;0;247;48
WireConnection;190;2;247;49
WireConnection;190;3;247;50
WireConnection;190;4;247;51
WireConnection;190;5;247;52
WireConnection;161;1;248;0
WireConnection;161;0;248;48
WireConnection;161;2;248;49
WireConnection;161;3;248;50
WireConnection;161;4;248;51
WireConnection;161;5;248;52
WireConnection;63;0;59;3
WireConnection;63;1;56;0
WireConnection;173;0;190;0
WireConnection;173;1;189;0
WireConnection;61;0;59;1
WireConnection;61;1;57;0
WireConnection;60;0;59;2
WireConnection;60;1;58;0
WireConnection;166;0;161;0
WireConnection;166;1;165;0
WireConnection;64;0;60;0
WireConnection;64;1;62;2
WireConnection;65;0;63;0
WireConnection;65;1;62;3
WireConnection;66;0;61;0
WireConnection;66;1;62;1
WireConnection;174;0;173;0
WireConnection;167;0;166;0
WireConnection;112;0;167;0
WireConnection;175;0;174;0
WireConnection;67;0;66;0
WireConnection;67;1;64;0
WireConnection;67;2;65;0
WireConnection;68;0;67;0
WireConnection;138;0;35;0
WireConnection;138;1;139;0
WireConnection;136;0;1;0
WireConnection;136;1;137;0
WireConnection;260;0;256;0
WireConnection;260;1;201;0
WireConnection;119;0;68;0
WireConnection;199;0;196;0
WireConnection;199;1;197;0
WireConnection;120;0;136;0
WireConnection;120;1;138;0
WireConnection;120;2;121;0
WireConnection;259;2;260;0
WireConnection;191;0;120;0
WireConnection;191;1;199;0
WireConnection;191;2;198;0
WireConnection;258;0;125;0
WireConnection;258;1;259;0
WireConnection;208;0;207;0
WireConnection;124;0;191;0
WireConnection;124;1;126;0
WireConnection;124;2;258;0
WireConnection;209;0;206;0
WireConnection;223;0;222;0
WireConnection;249;11;250;0
WireConnection;249;23;213;0
WireConnection;249;13;214;0
WireConnection;249;19;215;0
WireConnection;249;15;212;0
WireConnection;249;20;217;0
WireConnection;261;0;201;0
WireConnection;211;0;208;0
WireConnection;211;1;209;0
WireConnection;216;0;210;0
WireConnection;216;1;211;0
WireConnection;204;0;138;0
WireConnection;204;1;199;0
WireConnection;219;1;249;0
WireConnection;219;0;249;48
WireConnection;219;2;249;49
WireConnection;219;3;249;50
WireConnection;219;4;249;51
WireConnection;219;5;249;52
WireConnection;250;0;216;1
WireConnection;250;1;216;2
WireConnection;250;2;251;0
WireConnection;222;0;221;0
WireConnection;221;0;219;0
WireConnection;221;1;220;0
WireConnection;251;0;252;0
WireConnection;0;0;124;0
ASEEND*/
//CHKSM=E9AAAA2101EC11ABDCD41310C30FF34B17752A3D