// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Underwater"
{
	Properties
	{
		_WaveSpeed("Wave Speed", Float) = 1
		_WaveTile("Wave Tile", Float) = 0.3
		_WaveStretch("Wave Stretch", Vector) = (5,1,0,0)
		_WaveHeight("Wave Height", Float) = 1
		_WaterColor("Water Color", Color) = (0,0,0,0)
		_TopColor("Top Color", Color) = (0,0,0,0)
		_EdgePower("Edge Power", Float) = 1
		_EdgeDistance("Edge Distance", Float) = 1
		_NormalMap("Normal Map", 2D) = "white" {}
		_NormalStrength("Normal Strength", Range( 0 , 1)) = 0
		_NormalTile("Normal Tile", Float) = 1
		_NormalSpeed("Normal Speed", Float) = 1
		_Texture0("Texture 0", 2D) = "white" {}
		_EdgeFoamTile("Edge Foam Tile", Float) = 1
		_SeaFoamTile("Sea Foam Tile", Float) = 1
		_Refraction("Refraction", Float) = 0.1
		_Depth("Depth", Float) = -4
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float _WaveHeight;
		uniform float _WaveSpeed;
		uniform float2 _WaveStretch;
		uniform float _WaveTile;
		uniform sampler2D _NormalMap;
		uniform float _NormalStrength;
		uniform float _NormalSpeed;
		uniform float _NormalTile;
		uniform float4 _WaterColor;
		uniform float4 _TopColor;
		uniform sampler2D _Texture0;
		uniform float _SeaFoamTile;
		uniform sampler2D _GrabTexture;
		uniform float _Refraction;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _EdgeDistance;
		uniform float _EdgeFoamTile;
		uniform float _EdgePower;


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


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, 0.0,80.0,8.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_10_0 = ( _Time.y * _WaveSpeed );
			float2 _WaveDirection = float2(1,0);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult12 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile13 = appendResult12;
			float4 WaveTile23 = ( ( WorldSpaceTile13 * float4( _WaveStretch, 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner5 = ( temp_output_10_0 * _WaveDirection + WaveTile23.xy);
			float simplePerlin2D2 = snoise( panner5 );
			float2 panner25 = ( temp_output_10_0 * _WaveDirection + ( WaveTile23 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D26 = snoise( panner25 );
			float temp_output_28_0 = ( simplePerlin2D2 + simplePerlin2D26 );
			float4 WaveHeight36 = ( ( float4(0,1,0,0) * _WaveHeight ) * temp_output_28_0 );
			v.vertex.xyz += WaveHeight36.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 appendResult12 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile13 = appendResult12;
			float4 temp_output_86_0 = ( WorldSpaceTile13 / 10.0 );
			float2 panner73 = ( 1.0 * _Time.y * ( float2( 1,0 ) * _NormalSpeed ) + ( temp_output_86_0 * _NormalTile ).xy);
			float2 panner74 = ( 1.0 * _Time.y * ( float2( -1,0 ) * ( _NormalSpeed * 3.0 ) ) + ( temp_output_86_0 * ( _NormalTile * 1.0 ) ).xy);
			float3 Nomals83 = BlendNormals( UnpackScaleNormal( tex2D( _NormalMap, panner73 ), _NormalStrength ) , UnpackScaleNormal( tex2D( _NormalMap, panner74 ), _NormalStrength ) );
			o.Normal = Nomals83;
			float2 panner110 = ( 1.0 * _Time.y * float2( 0.1,0.2 ) + ( WorldSpaceTile13 * 0.03 ).xy);
			float simplePerlin2D109 = snoise( panner110 );
			float4 clampResult117 = clamp( ( tex2D( _Texture0, ( ( WorldSpaceTile13 / 10.0 ) * _SeaFoamTile ).xy ) * simplePerlin2D109 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 SeaFoam106 = clampResult117;
			float temp_output_10_0 = ( _Time.y * _WaveSpeed );
			float2 _WaveDirection = float2(1,0);
			float4 WaveTile23 = ( ( WorldSpaceTile13 * float4( _WaveStretch, 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner5 = ( temp_output_10_0 * _WaveDirection + WaveTile23.xy);
			float simplePerlin2D2 = snoise( panner5 );
			float2 panner25 = ( temp_output_10_0 * _WaveDirection + ( WaveTile23 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D26 = snoise( panner25 );
			float temp_output_28_0 = ( simplePerlin2D2 + simplePerlin2D26 );
			float WavePattern33 = temp_output_28_0;
			float clampResult52 = clamp( WavePattern33 , 0.0 , 1.0 );
			float4 lerpResult50 = lerp( _WaterColor , ( _TopColor + SeaFoam106 ) , clampResult52);
			float4 WaterColor53 = lerpResult50;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor124 = tex2D( _GrabTexture, ( (ase_grabScreenPosNorm).xyzw + float4( ( _Refraction * Nomals83 ) , 0.0 ) ).xy );
			float4 clampResult125 = clamp( screenColor124 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Refraction126 = clampResult125;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth129 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth129 = abs( ( screenDepth129 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) );
			float clampResult131 = clamp( ( 1.0 - distanceDepth129 ) , 0.0 , 1.0 );
			float Depth132 = clampResult131;
			float4 lerpResult133 = lerp( WaterColor53 , Refraction126 , Depth132);
			o.Albedo = lerpResult133.rgb;
			float screenDepth56 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth56 = abs( ( screenDepth56 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _EdgeDistance ) );
			float4 clampResult63 = clamp( ( ( ( 1.0 - distanceDepth56 ) + tex2D( _Texture0, ( ( WorldSpaceTile13 / 10.0 ) * _EdgeFoamTile ).xy ) ) * _EdgePower ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Edge61 = clampResult63;
			o.Emission = Edge61.rgb;
			o.Smoothness = 0.9;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
2095;186;1712;1226;5537.406;1078.292;1.808848;True;False
Node;AmplifyShaderEditor.CommentaryNode;31;-4457.87,-445.3625;Float;False;888.406;265.4732;World Space Tile;3;11;12;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;11;-4407.87,-395.3625;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;12;-4112.189,-358.8893;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-3823.465,-361.037;Float;True;WorldSpaceTile;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;38;-2751.74,-627.9966;Float;False;2626.723;613.9029;Wave UVs and Height;11;14;18;16;17;23;15;34;20;21;35;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;84;1702.854,-68.23392;Float;False;2948.879;1637.505;Normal Map;21;78;75;74;80;73;76;77;70;72;71;64;67;79;69;66;81;82;83;86;87;88;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;15;-2701.74,-318.0938;Float;True;Property;_WaveStretch;Wave Stretch;3;0;Create;True;0;0;False;0;5,1;0.15,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;14;-2701.242,-577.9966;Float;True;13;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2310.109,-393.0984;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2157.41,-214.5662;Float;False;Property;_WaveTile;Wave Tile;2;0;Create;True;0;0;False;0;0.3;0.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;1740.917,539.7253;Float;False;Constant;_Float2;Float 2;13;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;2432.047,412.226;Float;True;Property;_NormalSpeed;Normal Speed;12;0;Create;True;0;0;False;0;1;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;1757.868,271.6481;Float;True;13;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;69;1771.841,17.4385;Float;True;Property;_NormalTile;Normal Tile;11;0;Create;True;0;0;False;0;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1930.057,-453.799;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;2172.991,947.4933;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;76;2248.578,1265.271;Float;True;Constant;_PanD2;Pan D2;10;0;Create;True;0;0;False;0;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;75;2362.512,-18.23392;Float;True;Constant;_PanDirection;Pan Direction;10;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;2667.549,634.4908;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;86;2098.237,338.3043;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;39;-4145.229,794.2994;Float;False;2598.284;1228.363;Wave Pattern;13;29;8;9;27;24;10;6;5;25;26;2;28;33;Wave Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;2568.159,1264.063;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-5989.489,-1216.586;Float;True;13;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-5961.039,-915.9351;Float;False;Constant;_Float4;Float 4;14;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;2351.55,270.2389;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-5972.878,-502.6752;Float;False;13;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;2471.764,945.9576;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;2664.107,209.5691;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-5993.264,-294.0106;Float;False;Constant;_FoamMask;Foam Mask;16;0;Create;True;0;0;False;0;0.03;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1597.941,-478.0565;Float;True;WaveTile;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;104;-5631.644,-1138.583;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;8;-4095.228,1484.078;Float;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-5590.895,-449.6306;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;82;2935.093,613.3938;Float;False;Property;_NormalStrength;Normal Strength;10;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;74;2915.077,945.4133;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-5599.452,-827.849;Float;True;Property;_SeaFoamTile;Sea Foam Tile;15;0;Create;True;0;0;False;0;1;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;73;2887.214,259.3274;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-3668.406,1891.914;Float;False;23;WaveTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;98;-6055.008,-1986.941;Float;False;2018.675;629.2335;Comment;8;93;90;96;95;92;94;91;97;Sea Foam Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-4083.13,1757.735;Float;True;Property;_WaveSpeed;Wave Speed;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;64;1763.557,721.5582;Float;True;Property;_NormalMap;Normal Map;9;0;Create;True;0;0;False;0;None;52e0ac29f63794f44843b0a5a26ec54e;True;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-3700.964,1566.412;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;110;-5307.726,-448.6715;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;91;-5175.52,-1915.604;Float;True;Property;_Texture0;Texture 0;13;0;Create;True;0;0;False;0;None;b321a150a7e6b1745b0f571d88c48a95;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;6;-4084.939,1170.729;Float;True;Constant;_WaveDirection;Wave Direction;0;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;70;3252.328,299.1956;Float;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-3434.684,1889.662;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;66;3257.407,781.2796;Float;True;Property;_TextureSample1;Texture Sample 1;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-5170.88,-1269.591;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-4095.093,844.2994;Float;False;23;WaveTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;25;-3232.508,1422.746;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;99;-4729.258,-1480.654;Float;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;109;-5050.56,-449.7685;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;5;-3251.525,967.8729;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;81;3963.093,566.3938;Float;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;89;-3222.865,-2200.184;Float;False;1857;705;Comment;7;57;56;59;58;60;63;61;Edge Foam;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-4404.866,-1065.762;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-6005.008,-1921.734;Float;True;13;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-3045.171,925.4233;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-2958.672,1420.971;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;4408.734,560.8488;Float;False;Nomals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;128;-1487.611,-3437.969;Float;False;1903.147;689.5779;Comment;9;122;120;118;121;119;123;124;125;126;Refraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-5976.557,-1621.083;Float;False;Constant;_Float3;Float 3;14;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;95;-5647.162,-1843.731;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-5979.57,-1503.132;Float;False;Property;_EdgeFoamTile;Edge Foam Tile;14;0;Create;True;0;0;False;0;1;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;118;-1437.611,-3381.276;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;122;-1392.464,-2863.391;Float;False;83;Nomals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-2443.409,1210.504;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3172.865,-2150.184;Float;False;Property;_EdgeDistance;Edge Distance;8;0;Create;True;0;0;False;0;1;3.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;117;-4152.536,-782.1386;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-1381.659,-3066.581;Float;False;Property;_Refraction;Refraction;16;0;Create;True;0;0;False;0;0.1;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;56;-2802.857,-2084.852;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1789.944,1209.041;Float;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;119;-1032.235,-3387.969;Float;True;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-5115.326,-1610.707;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-3783.97,-785.2649;Float;False;SeaFoam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;54;376.2532,-2193.132;Float;False;1171.278;640.1411;Water Color;6;48;47;50;53;107;108;Water Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-992.4642,-3013.391;Float;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;130;390.6841,-2897.293;Float;False;Property;_Depth;Depth;17;0;Create;True;0;0;False;0;-4;-24.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;129;729.437,-2979.895;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-693.4642,-3103.391;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;447.804,-1683.87;Float;False;106;SeaFoam;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;90;-4756.323,-1897.37;Float;True;Property;_SeaFoam;Sea Foam;13;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;48;460.2724,-1915.894;Float;False;Property;_TopColor;Top Color;6;0;Create;True;0;0;False;0;0,0,0,0;0.1415984,0.6694148,0.6981132,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;58;-2433.865,-2092.184;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;462.45,-1341.419;Float;False;33;WavePattern;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-4190.333,-1936.941;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1270.83,-300.7854;Float;True;Property;_WaveHeight;Wave Height;4;0;Create;True;0;0;False;0;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2183.822,-1790.55;Float;True;Property;_EdgePower;Edge Power;7;0;Create;True;0;0;False;0;1;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;52;789.482,-1339.783;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;124;-411.4642,-3083.391;Float;False;Global;_GrabScreen0;Grab Screen 0;16;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;47;474.693,-2143.132;Float;False;Property;_WaterColor;Water Color;5;0;Create;True;0;0;False;0;0,0,0,0;0.1957992,0.6295081,0.754717,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;20;-1268.362,-547.0718;Float;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;False;0;0,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;136;1078.474,-2987.953;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;747.8829,-1728.717;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;131;1353.849,-2970.188;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-2040.983,-2055.628;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;125;-87.46417,-3080.391;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-914.4739,-431.2495;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;50;907.2724,-2036.894;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;1304.53,-2006.888;Float;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;63;-1770.291,-2065.516;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;1685.849,-2894.188;Float;False;Depth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;172.5358,-3069.391;Float;False;Refraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-567.9674,-376.2934;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-643.4631,834.4395;Float;False;132;Depth;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-473.5381,1430.304;Float;False;Constant;_Float5;Float 5;19;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-625.1229,515.1421;Float;False;53;WaterColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-671.4631,681.4395;Float;False;126;Refraction;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-500.8382,1673.404;Float;False;Constant;_Float7;Float 7;19;0;Create;True;0;0;False;0;80;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-1582.902,-2060.628;Float;False;Edge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-368.0169,-378.1773;Float;False;WaveHeight;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-478.7382,1539.503;Float;False;Constant;_Float6;Float 6;19;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;20.33977,1229.031;Float;True;36;WaveHeight;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;19;561.205,1598.107;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;137;-106.9381,1508.303;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-483.5792,1033.359;Float;True;61;Edge;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;133;-248.4631,669.4395;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-75.46008,801.6492;Float;True;83;Nomals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-88.22271,375.7474;Float;True;126;Refraction;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-11.05419,1091.773;Float;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;365.3419,849.8455;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Underwater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;1
WireConnection;12;1;11;3
WireConnection;13;0;12;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;71;0;69;0
WireConnection;79;0;78;0
WireConnection;86;0;67;0
WireConnection;86;1;88;0
WireConnection;80;0;76;0
WireConnection;80;1;79;0
WireConnection;87;0;86;0
WireConnection;87;1;69;0
WireConnection;72;0;86;0
WireConnection;72;1;71;0
WireConnection;77;0;75;0
WireConnection;77;1;78;0
WireConnection;23;0;17;0
WireConnection;104;0;101;0
WireConnection;104;1;102;0
WireConnection;112;0;111;0
WireConnection;112;1;113;0
WireConnection;74;0;72;0
WireConnection;74;2;80;0
WireConnection;73;0;87;0
WireConnection;73;2;77;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;110;0;112;0
WireConnection;70;0;64;0
WireConnection;70;1;73;0
WireConnection;70;5;82;0
WireConnection;27;0;29;0
WireConnection;66;0;64;0
WireConnection;66;1;74;0
WireConnection;66;5;82;0
WireConnection;105;0;104;0
WireConnection;105;1;103;0
WireConnection;25;0;27;0
WireConnection;25;2;6;0
WireConnection;25;1;10;0
WireConnection;99;0;91;0
WireConnection;99;1;105;0
WireConnection;109;0;110;0
WireConnection;5;0;24;0
WireConnection;5;2;6;0
WireConnection;5;1;10;0
WireConnection;81;0;70;0
WireConnection;81;1;66;0
WireConnection;116;0;99;0
WireConnection;116;1;109;0
WireConnection;2;0;5;0
WireConnection;26;0;25;0
WireConnection;83;0;81;0
WireConnection;95;0;92;0
WireConnection;95;1;96;0
WireConnection;28;0;2;0
WireConnection;28;1;26;0
WireConnection;117;0;116;0
WireConnection;56;0;57;0
WireConnection;33;0;28;0
WireConnection;119;0;118;0
WireConnection;93;0;95;0
WireConnection;93;1;94;0
WireConnection;106;0;117;0
WireConnection;121;0;120;0
WireConnection;121;1;122;0
WireConnection;129;0;130;0
WireConnection;123;0;119;0
WireConnection;123;1;121;0
WireConnection;90;0;91;0
WireConnection;90;1;93;0
WireConnection;58;0;56;0
WireConnection;97;0;58;0
WireConnection;97;1;90;0
WireConnection;52;0;51;0
WireConnection;124;0;123;0
WireConnection;136;0;129;0
WireConnection;108;0;48;0
WireConnection;108;1;107;0
WireConnection;131;0;136;0
WireConnection;60;0;97;0
WireConnection;60;1;59;0
WireConnection;125;0;124;0
WireConnection;21;0;20;0
WireConnection;21;1;34;0
WireConnection;50;0;47;0
WireConnection;50;1;108;0
WireConnection;50;2;52;0
WireConnection;53;0;50;0
WireConnection;63;0;60;0
WireConnection;132;0;131;0
WireConnection;126;0;125;0
WireConnection;35;0;21;0
WireConnection;35;1;28;0
WireConnection;61;0;63;0
WireConnection;36;0;35;0
WireConnection;137;0;138;0
WireConnection;137;1;139;0
WireConnection;137;2;140;0
WireConnection;133;0;55;0
WireConnection;133;1;134;0
WireConnection;133;2;135;0
WireConnection;0;0;133;0
WireConnection;0;1;85;0
WireConnection;0;2;62;0
WireConnection;0;4;40;0
WireConnection;0;11;37;0
WireConnection;0;14;137;0
ASEEND*/
//CHKSM=1013F77B955A46253981DB6426B71269CB3B3BAB