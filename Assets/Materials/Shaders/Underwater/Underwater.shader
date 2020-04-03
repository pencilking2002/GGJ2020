// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Underwater_Lens"
{
	Properties
	{
		_WaveSpeed("Wave Speed", Float) = 1
		_WaveTile("Wave Tile", Float) = 0.3
		_WaveStretch("Wave Stretch", Vector) = (5,1,0,0)
		_WaveHeight("Wave Height", Float) = 1
		_WaterColor("Water Color", Color) = (0,0,0,0)
		_TopColor("Top Color", Color) = (0,0,0,0)
		_NormalMap("Normal Map", 2D) = "white" {}
		_NormalStrength("Normal Strength", Range( 0 , 1)) = 0
		_NormalTile("Normal Tile", Float) = 1
		_NormalSpeed("Normal Speed", Float) = 1
		_Texture0("Texture 0", 2D) = "white" {}
		_SeaFoamTile("Sea Foam Tile", Float) = 1
		_Refraction("Refraction", Float) = 0.1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		AlphaToMask On
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
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
			float4 temp_cast_4 = (5.0).xxxx;
			return temp_cast_4;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_73_0 = ( _Time.y * _WaveSpeed );
			float2 _WaveDirection = float2(1,0);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 WorldSpaceTile137 = ase_worldPos;
			float3 WaveTile65 = ( ( WorldSpaceTile137 * float3( _WaveStretch ,  0.0 ) ) * _WaveTile );
			float2 panner83 = ( temp_output_73_0 * _WaveDirection + WaveTile65.xy);
			float simplePerlin2D87 = snoise( panner83 );
			float2 panner80 = ( temp_output_73_0 * _WaveDirection + ( WaveTile65 * float3( 0.1,0.1,0 ) ).xy);
			float simplePerlin2D88 = snoise( panner80 );
			float temp_output_93_0 = ( simplePerlin2D87 + simplePerlin2D88 );
			float4 WaveHeight119 = ( ( float4(0,1,0,0) * _WaveHeight ) * temp_output_93_0 );
			v.vertex.xyz += WaveHeight119.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 WorldSpaceTile137 = ase_worldPos;
			float3 temp_output_148_0 = ( WorldSpaceTile137 / 10.0 );
			float2 panner155 = ( 1.0 * _Time.y * ( float2( 1,0 ) * _NormalSpeed ) + ( temp_output_148_0 * _NormalTile ).xy);
			float2 panner154 = ( 1.0 * _Time.y * ( float2( -1,0 ) * ( _NormalSpeed * 3.0 ) ) + ( temp_output_148_0 * ( _NormalTile * 1.0 ) ).xy);
			float3 Nomals160 = BlendNormals( UnpackScaleNormal( tex2D( _NormalMap, panner155 ), _NormalStrength ) , UnpackScaleNormal( tex2D( _NormalMap, panner154 ), _NormalStrength ) );
			o.Normal = Nomals160;
			float2 panner74 = ( 1.0 * _Time.y * float2( 0.1,0.2 ) + ( WorldSpaceTile137 * 0.03 ).xy);
			float simplePerlin2D82 = snoise( panner74 );
			float4 clampResult95 = clamp( ( tex2D( _Texture0, ( ( WorldSpaceTile137 / 10.0 ) * _SeaFoamTile ).xy ) * simplePerlin2D82 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 SeaFoam99 = clampResult95;
			float temp_output_73_0 = ( _Time.y * _WaveSpeed );
			float2 _WaveDirection = float2(1,0);
			float3 WaveTile65 = ( ( WorldSpaceTile137 * float3( _WaveStretch ,  0.0 ) ) * _WaveTile );
			float2 panner83 = ( temp_output_73_0 * _WaveDirection + WaveTile65.xy);
			float simplePerlin2D87 = snoise( panner83 );
			float2 panner80 = ( temp_output_73_0 * _WaveDirection + ( WaveTile65 * float3( 0.1,0.1,0 ) ).xy);
			float simplePerlin2D88 = snoise( panner80 );
			float temp_output_93_0 = ( simplePerlin2D87 + simplePerlin2D88 );
			float WavePattern97 = temp_output_93_0;
			float clampResult164 = clamp( WavePattern97 , 0.0 , 1.0 );
			float4 lerpResult167 = lerp( _WaterColor , ( _TopColor + SeaFoam99 ) , clampResult164);
			float4 WaterColor168 = lerpResult167;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor134 = tex2D( _GrabTexture, ( (ase_grabScreenPosNorm).xyzw + float4( ( _Refraction * Nomals160 ) , 0.0 ) ).xy );
			float4 clampResult135 = clamp( screenColor134 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Refraction136 = clampResult135;
			float4 lerpResult172 = lerp( WaterColor168 , Refraction136 , 1.0);
			o.Albedo = lerpResult172.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
1466;-305.5;1712;1226;894.1071;-164.517;1;False;False
Node;AmplifyShaderEditor.WorldPosInputsNode;139;-4922.878,-1134.4;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-4338.473,-1100.074;Float;True;WorldSpaceTile;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;55;-3216.748,-1057.131;Float;True;Property;_WaveStretch;Wave Stretch;2;0;Create;True;0;0;False;0;5,1;5,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;56;-3216.25,-1317.034;Float;True;137;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;141;1917.039,-326.8115;Float;True;Property;_NormalSpeed;Normal Speed;11;0;Create;True;0;0;False;0;1;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-2825.117,-1132.136;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-2672.418,-953.6036;Float;False;Property;_WaveTile;Wave Tile;1;0;Create;True;0;0;False;0;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;1242.86,-467.3894;Float;True;137;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;143;1256.833,-721.599;Float;True;Property;_NormalTile;Normal Tile;10;0;Create;True;0;0;False;0;1;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;1225.909,-199.3122;Float;False;Constant;_Float2;Float 2;13;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;1657.983,208.4558;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;146;1847.504,-757.2714;Float;True;Constant;_PanDirection;Pan Direction;10;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2445.065,-1192.836;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;145;1733.57,526.2335;Float;True;Constant;_PanD2;Pan D2;10;0;Create;True;0;0;False;0;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;2152.541,-104.5467;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;148;1583.229,-400.7332;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-6504.497,-1955.624;Float;True;137;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-6508.272,-1033.048;Float;False;Constant;_FoamMask;Foam Mask;16;0;Create;True;0;0;False;0;0.03;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-6476.047,-1654.973;Float;False;Constant;_Float4;Float 4;14;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-2112.949,-1217.094;Float;True;WaveTile;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;2053.151,525.0255;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;1956.756,206.9201;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-6487.886,-1241.713;Float;False;137;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;2149.099,-529.4684;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;1836.542,-468.7986;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;155;2372.206,-479.7101;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-4598.138,1018.698;Float;True;Property;_WaveSpeed;Wave Speed;0;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-6114.46,-1566.886;Float;True;Property;_SeaFoamTile;Sea Foam Tile;14;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;66;-6146.652,-1877.62;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;156;1248.549,-17.47925;Float;True;Property;_NormalMap;Normal Map;8;0;Create;True;0;0;False;0;None;52e0ac29f63794f44843b0a5a26ec54e;True;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;154;2400.069,206.3759;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-6105.903,-1188.668;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-4183.414,1152.876;Float;False;65;WaveTile;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;67;-4610.236,745.0405;Float;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;2420.085,-125.6437;Float;False;Property;_NormalStrength;Normal Strength;9;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-4610.101,105.2619;Float;False;65;WaveTile;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;75;-5690.528,-2654.642;Float;True;Property;_Texture0;Texture 0;12;0;Create;True;0;0;False;0;None;5bb479181ffac0e4091bc2608dea0f60;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;158;2742.399,42.24213;Float;True;Property;_TextureSample1;Texture Sample 1;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;74;-5822.734,-1187.709;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;157;2737.32,-439.8419;Float;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-4215.972,827.3745;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;76;-4599.947,431.6915;Float;True;Constant;_WaveDirection;Wave Direction;0;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-3949.692,1150.625;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.1,0.1,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-5685.888,-2008.628;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;159;3448.085,-172.6437;Float;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;82;-5565.568,-1188.806;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;83;-3766.533,228.8354;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;81;-5244.266,-2219.691;Float;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;80;-3747.516,683.7085;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;3893.726,-178.1887;Float;False;Nomals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;87;-3560.179,186.3858;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;88;-3473.68,681.9335;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-4919.874,-1804.799;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;128;-1952.619,-4120.313;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;95;-4667.544,-1521.176;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-2958.417,471.4666;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;-1907.472,-3602.429;Float;False;160;Nomals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-1896.667,-3805.619;Float;False;Property;_Refraction;Refraction;15;0;Create;True;0;0;False;0;0.1;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-1507.472,-3752.429;Float;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;131;-1547.243,-4127.006;Float;True;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-2304.952,470.0035;Float;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-4298.978,-1524.302;Float;False;SeaFoam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;-52.55804,-2080.457;Float;False;97;WavePattern;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;133;-1208.472,-3842.429;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;162;-54.73566,-2654.932;Float;False;Property;_TopColor;Top Color;5;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;161;-67.20407,-2422.907;Float;False;99;SeaFoam;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;164;274.4739,-2078.82;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;134;-926.4723,-3822.429;Float;False;Global;_GrabScreen0;Grab Screen 0;16;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;166;232.8748,-2467.754;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;108;-1783.37,-1286.109;Float;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;False;0;0,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;165;-40.31506,-2882.169;Float;False;Property;_WaterColor;Water Color;4;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;106;-1785.838,-1039.823;Float;True;Property;_WaveHeight;Wave Height;3;0;Create;True;0;0;False;0;1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;135;-602.4722,-3819.429;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;167;392.2643,-2775.932;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1429.482,-1170.287;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-1082.975,-1115.331;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-342.4723,-3808.429;Float;False;Refraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;168;789.522,-2745.925;Float;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-1106.471,-68.59796;Float;False;136;Refraction;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-883.025,-1117.215;Float;False;WaveHeight;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-1060.131,-234.8954;Float;False;168;WaterColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;174;-822.9717,59.23285;Float;False;Constant;_Float9;Float 9;17;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-4705.341,-2675.979;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;122;46.19696,859.0696;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-1078.471,84.40204;Float;False;114;Depth;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;109;563.4659,-3726.99;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;102;214.429,-3718.933;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;113;-2285.299,-2804.554;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-6494.578,-2242.169;Float;False;Property;_EdgeFoamTile;Edge Foam Tile;13;0;Create;True;0;0;False;0;1;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-494.6683,489.9935;Float;True;119;WaveHeight;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-6520.016,-2660.771;Float;True;137;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-5630.334,-2349.745;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DepthFade;96;-3317.865,-2823.89;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-988.5461,691.2665;Float;False;Constant;_Float5;Float 5;19;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-2555.991,-2794.666;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;1170.841,-3633.226;Float;False;Depth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-993.7462,800.4656;Float;False;Constant;_Float6;Float 6;19;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-124.3239,-3636.331;Float;False;Property;_Depth;Depth;16;0;Create;True;0;0;False;0;-4;-24.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-235.1074,287.017;Float;False;Constant;_Float11;Float 11;17;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-603.2308,-363.2901;Float;True;136;Refraction;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-3687.873,-2889.222;Float;False;Property;_EdgeDistance;Edge Distance;7;0;Create;True;0;0;False;0;1;3.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-526.0623,352.7355;Float;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-1015.846,934.3666;Float;False;Constant;_Float7;Float 7;19;0;Create;True;0;0;False;0;80;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-6491.565,-2360.121;Float;False;Constant;_Float3;Float 3;14;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;110;838.8409,-3709.226;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;91;-6162.17,-2582.769;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;138;-4627.197,-1097.927;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-590.4681,62.61169;Float;True;160;Nomals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-2698.83,-2529.587;Float;True;Property;_EdgePower;Edge Power;6;0;Create;True;0;0;False;0;1;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;172;-683.4712,-80.59796;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-2097.91,-2799.666;Float;False;Edge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;104;-2948.873,-2831.222;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;103;-5271.331,-2636.407;Float;True;Property;_SeaFoam;Sea Foam;13;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceBasedTessNode;123;-621.9462,769.2655;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-998.5873,294.3215;Float;True;118;Edge;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-183.0552,598.1636;Float;False;Constant;_Float8;Float 8;17;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Underwater_Lens;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;100;-138.7549,-2932.169;Float;False;1171.278;640.1411;Water Color;0;Water Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;89;-2002.619,-4177.006;Float;False;1903.147;689.5779;Comment;0;Refraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;71;-6570.016,-2725.979;Float;False;2018.675;629.2335;Comment;0;Sea Foam Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;60;-4660.237,55.2619;Float;False;2598.284;1228.363;Wave Pattern;0;Wave Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;1187.846,-807.2714;Float;False;2948.879;1637.505;Normal Map;0;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;-3266.748,-1367.034;Float;False;2626.723;613.9029;Wave UVs and Height;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;84;-3737.873,-2939.222;Float;False;1857;705;Comment;0;Edge Foam;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-4972.878,-1184.4;Float;False;888.406;265.4732;World Space Tile;0;;1,1,1,1;0;0
WireConnection;137;0;139;0
WireConnection;57;0;56;0
WireConnection;57;1;55;0
WireConnection;144;0;143;0
WireConnection;59;0;57;0
WireConnection;59;1;58;0
WireConnection;147;0;141;0
WireConnection;148;0;142;0
WireConnection;148;1;140;0
WireConnection;65;0;59;0
WireConnection;149;0;145;0
WireConnection;149;1;147;0
WireConnection;151;0;148;0
WireConnection;151;1;144;0
WireConnection;152;0;146;0
WireConnection;152;1;141;0
WireConnection;150;0;148;0
WireConnection;150;1;143;0
WireConnection;155;0;150;0
WireConnection;155;2;152;0
WireConnection;66;0;61;0
WireConnection;66;1;62;0
WireConnection;154;0;151;0
WireConnection;154;2;149;0
WireConnection;68;0;63;0
WireConnection;68;1;64;0
WireConnection;158;0;156;0
WireConnection;158;1;154;0
WireConnection;158;5;153;0
WireConnection;74;0;68;0
WireConnection;157;0;156;0
WireConnection;157;1;155;0
WireConnection;157;5;153;0
WireConnection;73;0;67;0
WireConnection;73;1;72;0
WireConnection;77;0;70;0
WireConnection;78;0;66;0
WireConnection;78;1;69;0
WireConnection;159;0;157;0
WireConnection;159;1;158;0
WireConnection;82;0;74;0
WireConnection;83;0;79;0
WireConnection;83;2;76;0
WireConnection;83;1;73;0
WireConnection;81;0;75;0
WireConnection;81;1;78;0
WireConnection;80;0;77;0
WireConnection;80;2;76;0
WireConnection;80;1;73;0
WireConnection;160;0;159;0
WireConnection;87;0;83;0
WireConnection;88;0;80;0
WireConnection;85;0;81;0
WireConnection;85;1;82;0
WireConnection;95;0;85;0
WireConnection;93;0;87;0
WireConnection;93;1;88;0
WireConnection;132;0;130;0
WireConnection;132;1;129;0
WireConnection;131;0;128;0
WireConnection;97;0;93;0
WireConnection;99;0;95;0
WireConnection;133;0;131;0
WireConnection;133;1;132;0
WireConnection;164;0;163;0
WireConnection;134;0;133;0
WireConnection;166;0;162;0
WireConnection;166;1;161;0
WireConnection;135;0;134;0
WireConnection;167;0;165;0
WireConnection;167;1;166;0
WireConnection;167;2;164;0
WireConnection;112;0;108;0
WireConnection;112;1;106;0
WireConnection;115;0;112;0
WireConnection;115;1;93;0
WireConnection;136;0;135;0
WireConnection;168;0;167;0
WireConnection;119;0;115;0
WireConnection;105;0;104;0
WireConnection;105;1;103;0
WireConnection;109;0;102;0
WireConnection;102;0;101;0
WireConnection;113;0;111;0
WireConnection;98;0;91;0
WireConnection;98;1;92;0
WireConnection;96;0;94;0
WireConnection;111;0;105;0
WireConnection;111;1;107;0
WireConnection;114;0;110;0
WireConnection;110;0;109;0
WireConnection;91;0;86;0
WireConnection;91;1;90;0
WireConnection;138;0;139;1
WireConnection;138;1;139;3
WireConnection;172;0;170;0
WireConnection;172;1;171;0
WireConnection;172;2;174;0
WireConnection;118;0;113;0
WireConnection;104;0;96;0
WireConnection;103;0;75;0
WireConnection;103;1;98;0
WireConnection;123;0;116;0
WireConnection;123;1;120;0
WireConnection;123;2;117;0
WireConnection;0;0;172;0
WireConnection;0;1;125;0
WireConnection;0;11;121;0
WireConnection;0;14;173;0
ASEEND*/
//CHKSM=9F37A4FC2B0E819B0A86EC420C42B3C3648DA1E2