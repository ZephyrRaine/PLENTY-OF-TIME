// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "planet"
{
	Properties
	{
		_WORLD_Seed("WORLD_Seed", Float) = 0
		_WORLD_O("WORLD_O", Float) = 0
		_WORLD_S("WORLD_S", Float) = 0
		_WORLD_W("WORLD_W", Float) = 0
		_WORLD_LerpOffset("WORLD_LerpOffset", Range( -1 , 1)) = 0
		_WORLD_SMult("WORLD_SMult", Float) = 0
		_WORLD_WMult("WORLD_WMult", Float) = 0
		[KeywordEnum(Key0,Key1,Key2,Key3,Key4,Key5)] _WORLD_FractLevel("WORLD_FractLevel", Float) = 0
		_SEA_TimeScaleX("SEA_TimeScaleX", Float) = 0
		_SEA_TimeScaleY("SEA_TimeScaleY", Float) = 0
		_SEA_TimeScaleZ("SEA_TimeScaleZ", Float) = 0
		_SEA_O("SEA_O", Float) = 0
		_SEA_S("SEA_S", Float) = 0
		_SEA_W("SEA_W", Float) = 0
		_SEA_SMult("SEA_SMult", Float) = 0
		_SEA_LerpOffset("SEA_LerpOffset", Range( -1 , 1)) = 0
		_SEA_Wmult("SEA_Wmult", Float) = 0
		[KeywordEnum(Key0,Key1,Key2,Key3,Key4,Key5)] _SEA_FractLevel("SEA_FractLevel", Float) = 0
		_EarthColor("EarthColor", Color) = (0,0,0,0)
		_SEA_Color1("SEA_Color1", Color) = (0,0,0,0)
		_SEA_Color2("SEA_Color2", Color) = (0,0,0,0)
		_EarthHeight("EarthHeight", Float) = 0
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
			#pragma shader_feature _WORLD_FRACTLEVEL_KEY0 _WORLD_FRACTLEVEL_KEY1 _WORLD_FRACTLEVEL_KEY2 _WORLD_FRACTLEVEL_KEY3 _WORLD_FRACTLEVEL_KEY4 _WORLD_FRACTLEVEL_KEY5
			#pragma shader_feature _SEA_FRACTLEVEL_KEY0 _SEA_FRACTLEVEL_KEY1 _SEA_FRACTLEVEL_KEY2 _SEA_FRACTLEVEL_KEY3 _SEA_FRACTLEVEL_KEY4 _SEA_FRACTLEVEL_KEY5


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

			uniform float _WORLD_Seed;
			uniform float _WORLD_S;
			uniform float _WORLD_W;
			uniform float _WORLD_O;
			uniform float _WORLD_SMult;
			uniform float _WORLD_WMult;
			uniform float _WORLD_LerpOffset;
			uniform float _EarthHeight;
			uniform float4 _EarthColor;
			uniform float4 _SEA_Color1;
			uniform float4 _SEA_Color2;
			uniform float _SEA_TimeScaleX;
			uniform float _SEA_TimeScaleY;
			uniform float _SEA_TimeScaleZ;
			uniform float _SEA_S;
			uniform float _SEA_W;
			uniform float _SEA_O;
			uniform float _SEA_SMult;
			uniform float _SEA_Wmult;
			uniform float _SEA_LerpOffset;
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
				float4 appendResult103 = (float4(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _WORLD_Seed ) , 0.0));
				float3 temp_output_9_0_g73 = ( appendResult103 + float4( 0,0,0,0 ) ).xyz;
				float temp_output_4_0_g73 = _WORLD_S;
				float simplePerlin3D8_g73 = snoise( ( temp_output_9_0_g73 * temp_output_4_0_g73 ) );
				float temp_output_5_0_g73 = _WORLD_W;
				float temp_output_35_17_g67 = ( ( simplePerlin3D8_g73 * temp_output_5_0_g73 ) + _WORLD_O );
				float3 temp_output_9_0_g71 = temp_output_9_0_g73;
				float temp_output_6_0_g73 = _WORLD_SMult;
				float temp_output_4_0_g71 = ( temp_output_4_0_g73 * temp_output_6_0_g73 );
				float simplePerlin3D8_g71 = snoise( ( temp_output_9_0_g71 * temp_output_4_0_g71 ) );
				float temp_output_7_0_g73 = _WORLD_WMult;
				float temp_output_5_0_g71 = ( temp_output_5_0_g73 * temp_output_7_0_g73 );
				float temp_output_34_17_g67 = ( ( simplePerlin3D8_g71 * temp_output_5_0_g71 ) + temp_output_35_17_g67 );
				float3 temp_output_9_0_g72 = temp_output_9_0_g71;
				float temp_output_6_0_g71 = temp_output_6_0_g73;
				float temp_output_4_0_g72 = ( temp_output_4_0_g71 * temp_output_6_0_g71 );
				float simplePerlin3D8_g72 = snoise( ( temp_output_9_0_g72 * temp_output_4_0_g72 ) );
				float temp_output_7_0_g71 = temp_output_7_0_g73;
				float temp_output_5_0_g72 = ( temp_output_5_0_g71 * temp_output_7_0_g71 );
				float temp_output_33_17_g67 = ( ( simplePerlin3D8_g72 * temp_output_5_0_g72 ) + temp_output_34_17_g67 );
				float3 temp_output_9_0_g69 = temp_output_9_0_g72;
				float temp_output_6_0_g72 = temp_output_6_0_g71;
				float temp_output_4_0_g69 = ( temp_output_4_0_g72 * temp_output_6_0_g72 );
				float simplePerlin3D8_g69 = snoise( ( temp_output_9_0_g69 * temp_output_4_0_g69 ) );
				float temp_output_7_0_g72 = temp_output_7_0_g71;
				float temp_output_5_0_g69 = ( temp_output_5_0_g72 * temp_output_7_0_g72 );
				float temp_output_32_17_g67 = ( ( simplePerlin3D8_g69 * temp_output_5_0_g69 ) + temp_output_33_17_g67 );
				float3 temp_output_9_0_g68 = temp_output_9_0_g69;
				float temp_output_6_0_g69 = temp_output_6_0_g72;
				float temp_output_4_0_g68 = ( temp_output_4_0_g69 * temp_output_6_0_g69 );
				float simplePerlin3D8_g68 = snoise( ( temp_output_9_0_g68 * temp_output_4_0_g68 ) );
				float temp_output_7_0_g69 = temp_output_7_0_g72;
				float temp_output_5_0_g68 = ( temp_output_5_0_g69 * temp_output_7_0_g69 );
				float temp_output_31_17_g67 = ( ( simplePerlin3D8_g68 * temp_output_5_0_g68 ) + temp_output_32_17_g67 );
				float3 temp_output_9_0_g70 = temp_output_9_0_g68;
				float temp_output_6_0_g68 = temp_output_6_0_g69;
				float temp_output_4_0_g70 = ( temp_output_4_0_g68 * temp_output_6_0_g68 );
				float simplePerlin3D8_g70 = snoise( ( temp_output_9_0_g70 * temp_output_4_0_g70 ) );
				float temp_output_7_0_g68 = temp_output_7_0_g69;
				float temp_output_5_0_g70 = ( temp_output_5_0_g68 * temp_output_7_0_g68 );
				#if defined(_WORLD_FRACTLEVEL_KEY0)
				float staticSwitch15 = temp_output_35_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY1)
				float staticSwitch15 = temp_output_34_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY2)
				float staticSwitch15 = temp_output_33_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY3)
				float staticSwitch15 = temp_output_32_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY4)
				float staticSwitch15 = temp_output_31_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY5)
				float staticSwitch15 = ( ( simplePerlin3D8_g70 * temp_output_5_0_g70 ) + temp_output_31_17_g67 );
				#else
				float staticSwitch15 = temp_output_35_17_g67;
				#endif
				float Noise1_Layer19 = saturate( ( staticSwitch15 + _WORLD_LerpOffset ) );
				
				o.ase_texcoord.xyz = ase_worldPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				float3 vertexValue = ( Noise1_Layer19 * ( v.ase_normal * _EarthHeight ) );
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
				float mulTime64 = _Time.y * _SEA_TimeScaleX;
				float mulTime65 = _Time.y * _SEA_TimeScaleY;
				float mulTime115 = _Time.y * _SEA_TimeScaleZ;
				float3 appendResult71 = (float3(mulTime64 , mulTime65 , mulTime115));
				float3 temp_output_9_0_g66 = ( ase_worldPos + appendResult71 );
				float temp_output_4_0_g66 = _SEA_S;
				float simplePerlin3D8_g66 = snoise( ( temp_output_9_0_g66 * temp_output_4_0_g66 ) );
				float temp_output_5_0_g66 = _SEA_W;
				float temp_output_35_17_g60 = ( ( simplePerlin3D8_g66 * temp_output_5_0_g66 ) + _SEA_O );
				float3 temp_output_9_0_g64 = temp_output_9_0_g66;
				float temp_output_6_0_g66 = _SEA_SMult;
				float temp_output_4_0_g64 = ( temp_output_4_0_g66 * temp_output_6_0_g66 );
				float simplePerlin3D8_g64 = snoise( ( temp_output_9_0_g64 * temp_output_4_0_g64 ) );
				float temp_output_7_0_g66 = _SEA_Wmult;
				float temp_output_5_0_g64 = ( temp_output_5_0_g66 * temp_output_7_0_g66 );
				float temp_output_34_17_g60 = ( ( simplePerlin3D8_g64 * temp_output_5_0_g64 ) + temp_output_35_17_g60 );
				float3 temp_output_9_0_g65 = temp_output_9_0_g64;
				float temp_output_6_0_g64 = temp_output_6_0_g66;
				float temp_output_4_0_g65 = ( temp_output_4_0_g64 * temp_output_6_0_g64 );
				float simplePerlin3D8_g65 = snoise( ( temp_output_9_0_g65 * temp_output_4_0_g65 ) );
				float temp_output_7_0_g64 = temp_output_7_0_g66;
				float temp_output_5_0_g65 = ( temp_output_5_0_g64 * temp_output_7_0_g64 );
				float temp_output_33_17_g60 = ( ( simplePerlin3D8_g65 * temp_output_5_0_g65 ) + temp_output_34_17_g60 );
				float3 temp_output_9_0_g62 = temp_output_9_0_g65;
				float temp_output_6_0_g65 = temp_output_6_0_g64;
				float temp_output_4_0_g62 = ( temp_output_4_0_g65 * temp_output_6_0_g65 );
				float simplePerlin3D8_g62 = snoise( ( temp_output_9_0_g62 * temp_output_4_0_g62 ) );
				float temp_output_7_0_g65 = temp_output_7_0_g64;
				float temp_output_5_0_g62 = ( temp_output_5_0_g65 * temp_output_7_0_g65 );
				float temp_output_32_17_g60 = ( ( simplePerlin3D8_g62 * temp_output_5_0_g62 ) + temp_output_33_17_g60 );
				float3 temp_output_9_0_g61 = temp_output_9_0_g62;
				float temp_output_6_0_g62 = temp_output_6_0_g65;
				float temp_output_4_0_g61 = ( temp_output_4_0_g62 * temp_output_6_0_g62 );
				float simplePerlin3D8_g61 = snoise( ( temp_output_9_0_g61 * temp_output_4_0_g61 ) );
				float temp_output_7_0_g62 = temp_output_7_0_g65;
				float temp_output_5_0_g61 = ( temp_output_5_0_g62 * temp_output_7_0_g62 );
				float temp_output_31_17_g60 = ( ( simplePerlin3D8_g61 * temp_output_5_0_g61 ) + temp_output_32_17_g60 );
				float3 temp_output_9_0_g63 = temp_output_9_0_g61;
				float temp_output_6_0_g61 = temp_output_6_0_g62;
				float temp_output_4_0_g63 = ( temp_output_4_0_g61 * temp_output_6_0_g61 );
				float simplePerlin3D8_g63 = snoise( ( temp_output_9_0_g63 * temp_output_4_0_g63 ) );
				float temp_output_7_0_g61 = temp_output_7_0_g62;
				float temp_output_5_0_g63 = ( temp_output_5_0_g61 * temp_output_7_0_g61 );
				#if defined(_SEA_FRACTLEVEL_KEY0)
				float staticSwitch63 = temp_output_35_17_g60;
				#elif defined(_SEA_FRACTLEVEL_KEY1)
				float staticSwitch63 = temp_output_34_17_g60;
				#elif defined(_SEA_FRACTLEVEL_KEY2)
				float staticSwitch63 = temp_output_33_17_g60;
				#elif defined(_SEA_FRACTLEVEL_KEY3)
				float staticSwitch63 = temp_output_32_17_g60;
				#elif defined(_SEA_FRACTLEVEL_KEY4)
				float staticSwitch63 = temp_output_31_17_g60;
				#elif defined(_SEA_FRACTLEVEL_KEY5)
				float staticSwitch63 = ( ( simplePerlin3D8_g63 * temp_output_5_0_g63 ) + temp_output_31_17_g60 );
				#else
				float staticSwitch63 = temp_output_35_17_g60;
				#endif
				float noise2_layer94 = saturate( ( staticSwitch63 + _SEA_LerpOffset ) );
				float4 lerpResult100 = lerp( _SEA_Color1 , _SEA_Color2 , noise2_layer94);
				float4 appendResult103 = (float4(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _WORLD_Seed ) , 0.0));
				float3 temp_output_9_0_g73 = ( appendResult103 + float4( 0,0,0,0 ) ).xyz;
				float temp_output_4_0_g73 = _WORLD_S;
				float simplePerlin3D8_g73 = snoise( ( temp_output_9_0_g73 * temp_output_4_0_g73 ) );
				float temp_output_5_0_g73 = _WORLD_W;
				float temp_output_35_17_g67 = ( ( simplePerlin3D8_g73 * temp_output_5_0_g73 ) + _WORLD_O );
				float3 temp_output_9_0_g71 = temp_output_9_0_g73;
				float temp_output_6_0_g73 = _WORLD_SMult;
				float temp_output_4_0_g71 = ( temp_output_4_0_g73 * temp_output_6_0_g73 );
				float simplePerlin3D8_g71 = snoise( ( temp_output_9_0_g71 * temp_output_4_0_g71 ) );
				float temp_output_7_0_g73 = _WORLD_WMult;
				float temp_output_5_0_g71 = ( temp_output_5_0_g73 * temp_output_7_0_g73 );
				float temp_output_34_17_g67 = ( ( simplePerlin3D8_g71 * temp_output_5_0_g71 ) + temp_output_35_17_g67 );
				float3 temp_output_9_0_g72 = temp_output_9_0_g71;
				float temp_output_6_0_g71 = temp_output_6_0_g73;
				float temp_output_4_0_g72 = ( temp_output_4_0_g71 * temp_output_6_0_g71 );
				float simplePerlin3D8_g72 = snoise( ( temp_output_9_0_g72 * temp_output_4_0_g72 ) );
				float temp_output_7_0_g71 = temp_output_7_0_g73;
				float temp_output_5_0_g72 = ( temp_output_5_0_g71 * temp_output_7_0_g71 );
				float temp_output_33_17_g67 = ( ( simplePerlin3D8_g72 * temp_output_5_0_g72 ) + temp_output_34_17_g67 );
				float3 temp_output_9_0_g69 = temp_output_9_0_g72;
				float temp_output_6_0_g72 = temp_output_6_0_g71;
				float temp_output_4_0_g69 = ( temp_output_4_0_g72 * temp_output_6_0_g72 );
				float simplePerlin3D8_g69 = snoise( ( temp_output_9_0_g69 * temp_output_4_0_g69 ) );
				float temp_output_7_0_g72 = temp_output_7_0_g71;
				float temp_output_5_0_g69 = ( temp_output_5_0_g72 * temp_output_7_0_g72 );
				float temp_output_32_17_g67 = ( ( simplePerlin3D8_g69 * temp_output_5_0_g69 ) + temp_output_33_17_g67 );
				float3 temp_output_9_0_g68 = temp_output_9_0_g69;
				float temp_output_6_0_g69 = temp_output_6_0_g72;
				float temp_output_4_0_g68 = ( temp_output_4_0_g69 * temp_output_6_0_g69 );
				float simplePerlin3D8_g68 = snoise( ( temp_output_9_0_g68 * temp_output_4_0_g68 ) );
				float temp_output_7_0_g69 = temp_output_7_0_g72;
				float temp_output_5_0_g68 = ( temp_output_5_0_g69 * temp_output_7_0_g69 );
				float temp_output_31_17_g67 = ( ( simplePerlin3D8_g68 * temp_output_5_0_g68 ) + temp_output_32_17_g67 );
				float3 temp_output_9_0_g70 = temp_output_9_0_g68;
				float temp_output_6_0_g68 = temp_output_6_0_g69;
				float temp_output_4_0_g70 = ( temp_output_4_0_g68 * temp_output_6_0_g68 );
				float simplePerlin3D8_g70 = snoise( ( temp_output_9_0_g70 * temp_output_4_0_g70 ) );
				float temp_output_7_0_g68 = temp_output_7_0_g69;
				float temp_output_5_0_g70 = ( temp_output_5_0_g68 * temp_output_7_0_g68 );
				#if defined(_WORLD_FRACTLEVEL_KEY0)
				float staticSwitch15 = temp_output_35_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY1)
				float staticSwitch15 = temp_output_34_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY2)
				float staticSwitch15 = temp_output_33_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY3)
				float staticSwitch15 = temp_output_32_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY4)
				float staticSwitch15 = temp_output_31_17_g67;
				#elif defined(_WORLD_FRACTLEVEL_KEY5)
				float staticSwitch15 = ( ( simplePerlin3D8_g70 * temp_output_5_0_g70 ) + temp_output_31_17_g67 );
				#else
				float staticSwitch15 = temp_output_35_17_g67;
				#endif
				float Noise1_Layer19 = saturate( ( staticSwitch15 + _WORLD_LerpOffset ) );
				float4 lerpResult24 = lerp( _EarthColor , lerpResult100 , Noise1_Layer19);
				
				
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
330;226;1271;727;-598.8699;1778.454;1.9;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;22;-356.5155,-777.0146;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;101;-267.649,-574.2778;Float;False;Property;_WORLD_Seed;WORLD_Seed;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;478.7071,-1417.903;Float;False;Property;_SEA_TimeScaleY;SEA_TimeScaleY;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;476.5921,-1494.784;Float;False;Property;_SEA_TimeScaleX;SEA_TimeScaleX;8;0;Create;True;0;0;False;0;0;0.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;461.3282,-1282.132;Float;False;Property;_SEA_TimeScaleZ;SEA_TimeScaleZ;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;65;733.7361,-1401.853;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;115;713.2115,-1314.316;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-93.64905,-629.2778;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;64;737.7361,-1491.353;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;916.436,-1475.253;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;103;34.35095,-697.2778;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;66;572.7059,-1884.087;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;390.1611,-381.0384;Float;False;Property;_WORLD_O;WORLD_O;1;0;Create;True;0;0;False;0;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;1319.383,-1488.11;Float;False;Property;_SEA_O;SEA_O;11;0;Create;True;0;0;False;0;0;-2.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;353.9907,-144.3376;Float;False;Property;_WORLD_SMult;WORLD_SMult;5;0;Create;True;0;0;False;0;0;1.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;223.3617,-643.0231;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;4;355.9907,-66.33762;Float;False;Property;_WORLD_WMult;WORLD_WMult;6;0;Create;True;0;0;False;0;0;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;391.9907,-309.3376;Float;False;Property;_WORLD_S;WORLD_S;2;0;Create;True;0;0;False;0;0;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;1320.212,-1335.41;Float;False;Property;_SEA_W;SEA_W;13;0;Create;True;0;0;False;0;0;6.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;1321.212,-1416.41;Float;False;Property;_SEA_S;SEA_S;12;0;Create;True;0;0;False;0;0;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;1285.212,-1173.41;Float;False;Property;_SEA_Wmult;SEA_Wmult;23;0;Create;True;0;0;False;0;0;-0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;1283.212,-1251.41;Float;False;Property;_SEA_SMult;SEA_SMult;15;0;Create;True;0;0;False;0;0;1.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;1152.583,-1750.095;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;390.9907,-228.3376;Float;False;Property;_WORLD_W;WORLD_W;3;0;Create;True;0;0;False;0;0;7.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;75;1521.476,-1604.103;Float;False;FractalNoise;-1;;60;abbe4fe1aa3b7b546b5399cef5641f91;0;6;11;FLOAT3;0,0,0;False;23;FLOAT;0;False;13;FLOAT;0;False;19;FLOAT;0;False;15;FLOAT;0;False;20;FLOAT;0;False;6;FLOAT;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51;FLOAT;52
Node;AmplifyShaderEditor.FunctionNode;2;592.2542,-497.0314;Float;False;FractalNoise;-1;;67;abbe4fe1aa3b7b546b5399cef5641f91;0;6;11;FLOAT3;0,0,0;False;23;FLOAT;0;False;13;FLOAT;0;False;19;FLOAT;0;False;15;FLOAT;0;False;20;FLOAT;0;False;6;FLOAT;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51;FLOAT;52
Node;AmplifyShaderEditor.StaticSwitch;15;1078.145,-512.0448;Float;False;Property;_WORLD_FractLevel;WORLD_FractLevel;7;0;Create;True;0;0;False;0;0;0;1;True;;KeywordEnum;6;Key0;Key1;Key2;Key3;Key4;Key5;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;1713.715,-1288.224;Float;False;Property;_SEA_LerpOffset;SEA_LerpOffset;21;0;Create;True;0;0;False;0;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;63;2007.366,-1619.117;Float;False;Property;_SEA_FractLevel;SEA_FractLevel;25;0;Create;True;0;0;False;0;0;0;4;True;;KeywordEnum;6;Key0;Key1;Key2;Key3;Key4;Key5;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;875.0619,-121.1621;Float;False;Property;_WORLD_LerpOffset;WORLD_LerpOffset;4;0;Create;True;0;0;False;0;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;2196.58,-1300.557;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;1267.358,-193.4851;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;62;2325.39,-1301.913;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;18;1396.168,-194.841;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;98;2707.844,-1237.82;Float;False;Property;_SEA_Color2;SEA_Color2;29;0;Create;True;0;0;False;0;0,0,0,0;0,0.07190378,0.2735849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;26;2678.933,-1458.491;Float;False;Property;_SEA_Color1;SEA_Color1;28;0;Create;True;0;0;False;0;0,0,0,0;0,0.1611173,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;2203.332,-324.9527;Float;False;Property;_EarthHeight;EarthHeight;30;0;Create;True;0;0;False;0;0;-0.0005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;2517.98,-1242.748;Float;False;noise2_layer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;1549.537,-319.0038;Float;False;Noise1_Layer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;45;2397.365,-478.0393;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;2978.158,-369.3739;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;2813.421,-468.3877;Float;False;19;Noise1_Layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;2965.566,-1168.397;Float;False;19;Noise1_Layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;100;2947.983,-1375.5;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;25;2723.864,-1006.086;Float;False;Property;_EarthColor;EarthColor;27;0;Create;True;0;0;False;0;0,0,0,0;0.3176471,1,0.2926998,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;92;1624.224,-2314.719;Float;False;Property;_Float16;Float 16;18;0;Create;True;0;0;False;0;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;3332.351,-1203.182;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;93;1824.488,-2502.412;Float;False;FractalNoise;-1;;74;abbe4fe1aa3b7b546b5399cef5641f91;0;6;11;FLOAT3;0,0,0;False;23;FLOAT;0;False;13;FLOAT;0;False;19;FLOAT;0;False;15;FLOAT;0;False;20;FLOAT;0;False;6;FLOAT;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51;FLOAT;52
Node;AmplifyShaderEditor.SimpleAddOpNode;79;2499.592,-2198.866;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;83;1002.958,-2327.808;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;1622.394,-2386.42;Float;False;Property;_Float15;Float 15;17;0;Create;True;0;0;False;0;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;779.6039,-2393.093;Float;False;Property;_Float10;Float 10;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;1588.224,-2071.719;Float;False;Property;_Float11;Float 11;24;0;Create;True;0;0;False;0;0;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;84;875.7178,-2782.396;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;82;1008.494,-2414.237;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;1455.595,-2648.404;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;80;2628.402,-2200.222;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;81;2310.379,-2517.426;Float;False;Property;_Keyword1;Keyword 1;26;0;Create;True;0;0;False;0;0;0;4;True;;KeywordEnum;6;Key0;Key1;Key2;Key3;Key4;Key5;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;2193.295,-2120.543;Float;False;Property;_Float14;Float 14;20;0;Create;True;0;0;False;0;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;781.7189,-2316.212;Float;False;Property;_Float9;Float 9;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;1586.224,-2149.719;Float;False;Property;_Float13;Float 13;22;0;Create;True;0;0;False;0;0;1.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;97;2450.095,-872.8092;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;1623.224,-2233.719;Float;False;Property;_Float12;Float 12;19;0;Create;True;0;0;False;0;0;7.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;89;1219.448,-2373.562;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;3199.739,-454.2205;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;55;3437.947,-575.3035;Float;False;True;2;Float;ASEMaterialInspector;0;1;planet;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;65;0;58;0
WireConnection;115;0;114;0
WireConnection;102;0;22;3
WireConnection;102;1;101;0
WireConnection;64;0;59;0
WireConnection;71;0;64;0
WireConnection;71;1;65;0
WireConnection;71;2;115;0
WireConnection;103;0;22;1
WireConnection;103;1;22;2
WireConnection;103;2;102;0
WireConnection;56;0;103;0
WireConnection;72;0;66;0
WireConnection;72;1;71;0
WireConnection;75;11;72;0
WireConnection;75;23;73;0
WireConnection;75;13;74;0
WireConnection;75;19;67;0
WireConnection;75;15;68;0
WireConnection;75;20;60;0
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
WireConnection;63;1;75;0
WireConnection;63;0;75;48
WireConnection;63;2;75;49
WireConnection;63;3;75;50
WireConnection;63;4;75;51
WireConnection;63;5;75;52
WireConnection;61;0;63;0
WireConnection;61;1;69;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;62;0;61;0
WireConnection;18;0;17;0
WireConnection;94;0;62;0
WireConnection;19;0;18;0
WireConnection;46;0;45;0
WireConnection;46;1;28;0
WireConnection;100;0;26;0
WireConnection;100;1;98;0
WireConnection;100;2;94;0
WireConnection;24;0;25;0
WireConnection;24;1;100;0
WireConnection;24;2;95;0
WireConnection;93;11;90;0
WireConnection;93;23;91;0
WireConnection;93;13;92;0
WireConnection;93;19;85;0
WireConnection;93;15;86;0
WireConnection;93;20;78;0
WireConnection;79;0;81;0
WireConnection;79;1;87;0
WireConnection;83;0;76;0
WireConnection;82;0;77;0
WireConnection;90;0;84;0
WireConnection;90;1;89;0
WireConnection;80;0;79;0
WireConnection;81;1;93;0
WireConnection;81;0;93;48
WireConnection;81;2;93;49
WireConnection;81;3;93;50
WireConnection;81;4;93;51
WireConnection;81;5;93;52
WireConnection;89;0;82;0
WireConnection;89;1;83;0
WireConnection;27;0;96;0
WireConnection;27;1;46;0
WireConnection;55;0;24;0
WireConnection;55;1;27;0
ASEEND*/
//CHKSM=03CB03C14857864A034F7BA05D72F09A39CAF2C6