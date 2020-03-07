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
		_EarthHeight("EarthHeight", Float) = 0
		_EarthColor("EarthColor", Color) = (0,0,0,0)
		[HDR]_EARTH_Emissive("EARTH_Emissive", Color) = (0,0,0,0)
		_SEA_Color1("SEA_Color1", Color) = (0,0,0,0)
		_SEA_Color2("SEA_Color2", Color) = (0,0,0,0)
		[HDR]_SEA_Emissive1("SEA_Emissive1", Color) = (0,0,0,0)
		[HDR]_SEA_Emissive2("SEA_Emissive2", Color) = (0,0,0,0)
		_DRY_SEA_Color1("DRY_SEA_Color1", Color) = (0,0,0,0)
		_DRY_SEA_Emissive1("DRY_SEA_Emissive1", Color) = (0,0,0,0)
		_DRY_SEA_Color2("DRY_SEA_Color2", Color) = (0,0,0,0)
		_DRY_SEA_Emissive2("DRY_SEA_Emissive2", Color) = (0,0,0,0)
		_Color0("Color 0", Color) = (0,0,0,0)
		_LEFT_WATER("LEFT_WATER", Range( 0 , 1)) = 0
		_RIGHT_WATER("RIGHT_WATER", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _WORLD_FRACTLEVEL_KEY0 _WORLD_FRACTLEVEL_KEY1 _WORLD_FRACTLEVEL_KEY2 _WORLD_FRACTLEVEL_KEY3 _WORLD_FRACTLEVEL_KEY4 _WORLD_FRACTLEVEL_KEY5
		#pragma shader_feature _SEA_FRACTLEVEL_KEY0 _SEA_FRACTLEVEL_KEY1 _SEA_FRACTLEVEL_KEY2 _SEA_FRACTLEVEL_KEY3 _SEA_FRACTLEVEL_KEY4 _SEA_FRACTLEVEL_KEY5
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
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
		uniform float4 _DRY_SEA_Color1;
		uniform float4 _DRY_SEA_Color2;
		uniform float _LEFT_WATER;
		uniform float _RIGHT_WATER;
		uniform float4 _Color0;
		uniform float4 _EARTH_Emissive;
		uniform float4 _SEA_Emissive1;
		uniform float4 _SEA_Emissive2;
		uniform float4 _DRY_SEA_Emissive1;
		uniform float4 _DRY_SEA_Emissive2;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
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
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( Noise1_Layer19 * ( ase_vertexNormal * _EarthHeight ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
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
			float4 lerpResult138 = lerp( _DRY_SEA_Color1 , _DRY_SEA_Color2 , noise2_layer94);
			float4 lerpResult144 = lerp( lerpResult100 , lerpResult138 , _LEFT_WATER);
			float4 lerpResult145 = lerp( lerpResult100 , lerpResult138 , _RIGHT_WATER);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float isRightSide136 = step( 0.5 , ase_screenPosNorm.x );
			float4 lerpResult146 = lerp( lerpResult144 , lerpResult145 , isRightSide136);
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
			float4 lerpResult24 = lerp( _EarthColor , lerpResult146 , Noise1_Layer19);
			float4 lerpResult135 = lerp( lerpResult24 , ( _Color0 * lerpResult24 ) , isRightSide136);
			o.Albedo = lerpResult135.rgb;
			float4 lerpResult122 = lerp( _SEA_Emissive1 , _SEA_Emissive2 , noise2_layer94);
			float4 lerpResult153 = lerp( _DRY_SEA_Emissive1 , _DRY_SEA_Emissive2 , noise2_layer94);
			float4 lerpResult154 = lerp( lerpResult122 , lerpResult153 , _LEFT_WATER);
			float4 lerpResult156 = lerp( lerpResult122 , lerpResult153 , _RIGHT_WATER);
			float4 lerpResult157 = lerp( lerpResult154 , lerpResult156 , isRightSide136);
			float4 lerpResult121 = lerp( _EARTH_Emissive , lerpResult157 , Noise1_Layer19);
			o.Emission = lerpResult121.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
0;0;1920;1029;-729.418;1726.84;1.503489;True;True
Node;AmplifyShaderEditor.RangedFloatNode;58;230.7422,-1632.806;Float;False;Property;_SEA_TimeScaleY;SEA_TimeScaleY;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;213.3633,-1497.035;Float;False;Property;_SEA_TimeScaleZ;SEA_TimeScaleZ;10;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;228.6272,-1709.687;Float;False;Property;_SEA_TimeScaleX;SEA_TimeScaleX;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;115;465.2467,-1529.219;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;64;489.7713,-1706.256;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;65;485.7713,-1616.756;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;66;572.7059,-1884.087;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;71;668.4711,-1690.156;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;67;782.2034,-1415.059;Float;False;Property;_SEA_W;SEA_W;13;0;Create;True;0;0;False;0;0;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;836.9913,-1825.236;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;68;745.2034,-1331.059;Float;False;Property;_SEA_SMult;SEA_SMult;14;0;Create;True;0;0;False;0;0;1.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;781.3745,-1567.759;Float;False;Property;_SEA_O;SEA_O;11;0;Create;True;0;0;False;0;0;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;783.2034,-1496.059;Float;False;Property;_SEA_S;SEA_S;12;0;Create;True;0;0;False;0;0;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;747.2034,-1253.059;Float;False;Property;_SEA_Wmult;SEA_Wmult;16;0;Create;True;0;0;False;0;0;1.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;22;-356.5155,-777.0146;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;101;-267.649,-574.2778;Float;False;Property;_WORLD_Seed;WORLD_Seed;0;0;Create;True;0;0;False;0;0;10.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;75;1012.021,-1822.012;Float;False;FractalNoise;-1;;60;abbe4fe1aa3b7b546b5399cef5641f91;0;6;11;FLOAT3;0,0,0;False;23;FLOAT;0;False;13;FLOAT;0;False;19;FLOAT;0;False;15;FLOAT;0;False;20;FLOAT;0;False;6;FLOAT;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51;FLOAT;52
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-93.64905,-629.2778;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;63;1286.014,-1837.026;Float;False;Property;_SEA_FractLevel;SEA_FractLevel;17;0;Create;True;0;0;False;0;0;0;4;True;;KeywordEnum;6;Key0;Key1;Key2;Key3;Key4;Key5;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;103;34.35095,-697.2778;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;69;1100.565,-1579.77;Float;False;Property;_SEA_LerpOffset;SEA_LerpOffset;15;0;Create;True;0;0;False;0;0;0.22;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;353.9907,-144.3376;Float;False;Property;_WORLD_SMult;WORLD_SMult;5;0;Create;True;0;0;False;0;0;0.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;390.9907,-228.3376;Float;False;Property;_WORLD_W;WORLD_W;3;0;Create;True;0;0;False;0;0;2.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;223.3617,-643.0231;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;1583.43,-1592.103;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;355.9907,-66.33762;Float;False;Property;_WORLD_WMult;WORLD_WMult;6;0;Create;True;0;0;False;0;0;2.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;391.9907,-309.3376;Float;False;Property;_WORLD_S;WORLD_S;2;0;Create;True;0;0;False;0;0;0.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;390.1611,-381.0384;Float;False;Property;_WORLD_O;WORLD_O;1;0;Create;True;0;0;False;0;0;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2;592.2542,-497.0314;Float;False;FractalNoise;-1;;67;abbe4fe1aa3b7b546b5399cef5641f91;0;6;11;FLOAT3;0,0,0;False;23;FLOAT;0;False;13;FLOAT;0;False;19;FLOAT;0;False;15;FLOAT;0;False;20;FLOAT;0;False;6;FLOAT;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51;FLOAT;52
Node;AmplifyShaderEditor.SaturateNode;62;1712.24,-1593.459;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;129;3048.664,-2167.226;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;1857.35,-1602.876;Float;False;noise2_layer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;875.0619,-121.1621;Float;False;Property;_WORLD_LerpOffset;WORLD_LerpOffset;4;0;Create;True;0;0;False;0;0;0.45;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;15;1078.145,-512.0448;Float;False;Property;_WORLD_FractLevel;WORLD_FractLevel;7;0;Create;True;0;0;False;0;0;0;4;True;;KeywordEnum;6;Key0;Key1;Key2;Key3;Key4;Key5;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;139;2173.274,-1521.406;Float;False;Property;_DRY_SEA_Color1;DRY_SEA_Color1;25;0;Create;True;0;0;False;0;0,0,0,0;1,0,0.194057,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;26;1929.74,-2031.116;Float;False;Property;_SEA_Color1;SEA_Color1;21;0;Create;True;0;0;False;0;0,0,0,0;0,0.6151137,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;130;3366.714,-2172.304;Float;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;1267.358,-193.4851;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;2132.285,-1145.485;Float;False;94;noise2_layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;98;1930.58,-1817.594;Float;False;Property;_SEA_Color2;SEA_Color2;22;0;Create;True;0;0;False;0;0,0,0,0;0.07849769,0.5292693,0.7924528,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;140;2149.414,-1333.884;Float;False;Property;_DRY_SEA_Color2;DRY_SEA_Color2;27;0;Create;True;0;0;False;0;0,0,0,0;0.7921569,0.5312742,0.07843135,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;138;2462.919,-1458.017;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;142;2402.312,-1238.34;Float;False;Property;_LEFT_WATER;LEFT_WATER;30;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;2387.317,-1038.975;Float;False;Property;_RIGHT_WATER;RIGHT_WATER;31;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;3629.983,-2183.387;Float;False;isRightSide;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;18;1396.168,-194.841;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;100;2518.983,-1730.4;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;148;1318.496,-740.9385;Float;False;Property;_DRY_SEA_Emissive2;DRY_SEA_Emissive2;28;0;Create;True;0;0;False;0;0,0,0,0;0.7921569,0.5312742,0.07843135,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;119;1206.818,-800.0343;Float;False;94;noise2_layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;150;1342.356,-928.4604;Float;False;Property;_DRY_SEA_Emissive1;DRY_SEA_Emissive1;26;0;Create;True;0;0;False;0;0,0,0,0;1,0,0.194057,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;144;2818.38,-1536.842;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;1301.367,-552.5394;Float;False;94;noise2_layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;123;1368.165,-1205.014;Float;False;Property;_SEA_Emissive1;SEA_Emissive1;23;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0.3593779,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;124;1366.52,-1032.22;Float;False;Property;_SEA_Emissive2;SEA_Emissive2;24;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0.2687126,0.7735849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;145;2878.728,-1238.629;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;2849.928,-1349.029;Float;False;136;isRightSide;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;1549.537,-317.0038;Float;False;Noise1_Layer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;153;1809.412,-780.8753;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;122;1667.984,-1106.782;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;146;3139.529,-1333.029;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;25;2429.492,-1944.933;Float;False;Property;_EarthColor;EarthColor;19;0;Create;True;0;0;False;0;0,0,0,0;0.1596275,0.3490566,0.1564169,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;95;2917.466,-1593.497;Float;False;19;Noise1_Layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;2240.023,-643.3218;Float;False;136;isRightSide;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;3563.929,-1729.213;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;45;2397.365,-478.0393;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;156;2178.613,-836.6265;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;154;2143.826,-1037.112;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;132;3750.235,-986.6245;Float;False;Property;_Color0;Color 0;29;0;Create;True;0;0;False;0;0,0,0,0;0.06603771,0.06603771,0.06603771,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;2203.332,-322.9527;Float;False;Property;_EarthHeight;EarthHeight;18;0;Create;True;0;0;False;0;0;-0.0005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;4101.544,-960.3323;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;2978.158,-369.3739;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;2813.421,-468.3877;Float;False;19;Noise1_Layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;125;2741.082,-989.3005;Float;False;Property;_EARTH_Emissive;EARTH_Emissive;20;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.2121913,0.76245,0.2611672,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;120;2103.163,-533.9044;Float;False;19;Noise1_Layer;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;157;2517.596,-810.7475;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;4179.618,-844.8767;Float;False;136;isRightSide;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;2845.263,-760.4387;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;3199.739,-454.2205;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;134;3037.917,-530.9211;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;135;4430.146,-1024.445;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;116;4268.726,-531.5383;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;planet;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;115;0;114;0
WireConnection;64;0;59;0
WireConnection;65;0;58;0
WireConnection;71;0;64;0
WireConnection;71;1;65;0
WireConnection;71;2;115;0
WireConnection;72;0;66;0
WireConnection;72;1;71;0
WireConnection;75;11;72;0
WireConnection;75;23;73;0
WireConnection;75;13;74;0
WireConnection;75;19;67;0
WireConnection;75;15;68;0
WireConnection;75;20;60;0
WireConnection;102;0;22;3
WireConnection;102;1;101;0
WireConnection;63;1;75;0
WireConnection;63;0;75;48
WireConnection;63;2;75;49
WireConnection;63;3;75;50
WireConnection;63;4;75;51
WireConnection;63;5;75;52
WireConnection;103;0;22;1
WireConnection;103;1;22;2
WireConnection;103;2;102;0
WireConnection;56;0;103;0
WireConnection;61;0;63;0
WireConnection;61;1;69;0
WireConnection;2;11;56;0
WireConnection;2;23;6;0
WireConnection;2;13;3;0
WireConnection;2;19;7;0
WireConnection;2;15;5;0
WireConnection;2;20;4;0
WireConnection;62;0;61;0
WireConnection;94;0;62;0
WireConnection;15;1;2;0
WireConnection;15;0;2;48
WireConnection;15;2;2;49
WireConnection;15;3;2;50
WireConnection;15;4;2;51
WireConnection;15;5;2;52
WireConnection;130;1;129;1
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;138;0;139;0
WireConnection;138;1;140;0
WireConnection;138;2;141;0
WireConnection;136;0;130;0
WireConnection;18;0;17;0
WireConnection;100;0;26;0
WireConnection;100;1;98;0
WireConnection;100;2;94;0
WireConnection;144;0;100;0
WireConnection;144;1;138;0
WireConnection;144;2;142;0
WireConnection;145;0;100;0
WireConnection;145;1;138;0
WireConnection;145;2;143;0
WireConnection;19;0;18;0
WireConnection;153;0;150;0
WireConnection;153;1;148;0
WireConnection;153;2;149;0
WireConnection;122;0;123;0
WireConnection;122;1;124;0
WireConnection;122;2;119;0
WireConnection;146;0;144;0
WireConnection;146;1;145;0
WireConnection;146;2;147;0
WireConnection;24;0;25;0
WireConnection;24;1;146;0
WireConnection;24;2;95;0
WireConnection;156;0;122;0
WireConnection;156;1;153;0
WireConnection;156;2;143;0
WireConnection;154;0;122;0
WireConnection;154;1;153;0
WireConnection;154;2;142;0
WireConnection;133;0;132;0
WireConnection;133;1;24;0
WireConnection;46;0;45;0
WireConnection;46;1;28;0
WireConnection;157;0;154;0
WireConnection;157;1;156;0
WireConnection;157;2;155;0
WireConnection;121;0;125;0
WireConnection;121;1;157;0
WireConnection;121;2;120;0
WireConnection;27;0;96;0
WireConnection;27;1;46;0
WireConnection;135;0;24;0
WireConnection;135;1;133;0
WireConnection;135;2;137;0
WireConnection;116;0;135;0
WireConnection;116;2;121;0
WireConnection;116;11;27;0
ASEEND*/
//CHKSM=FD6BC638E71238F623FAF6ED19D86D80945D9A3F