// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Background_Shader"
{
	Properties
	{
		_BaseColor("Base Color", 2D) = "white" {}
		_ColorShift("Color Shift", Vector) = (-5000,1000,0,1)
		_Color0("Color 0", Color) = (0.03702387,0.4579069,0.6037736,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

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
				float4 ase_texcoord1 : TEXCOORD1;
			};

			uniform sampler2D _BaseColor;
			uniform float4 _BaseColor_ST;
			uniform float4 _Color0;
			uniform float4 _ColorShift;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord1.xyz = ase_worldPos;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.ase_texcoord1.w = 0;
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
				fixed4 finalColor;
				float2 uv_BaseColor = i.ase_texcoord.xy * _BaseColor_ST.xy + _BaseColor_ST.zw;
				float4 tex2DNode1 = tex2D( _BaseColor, uv_BaseColor );
				float3 ase_worldPos = i.ase_texcoord1.xyz;
				float WorldSpace4 = ase_worldPos.y;
				float4 lerpResult16 = lerp( ( tex2DNode1 * _Color0 ) , tex2DNode1 , (_ColorShift.z + (WorldSpace4 - _ColorShift.x) * (_ColorShift.w - _ColorShift.z) / (_ColorShift.y - _ColorShift.x)));
				
				
				finalColor = lerpResult16;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16301
2047;128;1712;1226;2464.824;569.1185;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;9;-940.8671,-855.4551;Float;False;681;229;Comment;2;6;4;World Space;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;6;-890.8672,-805.4551;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-502.8672,-755.4552;Float;False;WorldSpace;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-1665.565,67.35708;Float;False;4;WorldSpace;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1808.673,-518.2311;Float;True;Property;_BaseColor;Base Color;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-1984.09,-238.7662;Float;False;Property;_Color0;Color 0;2;0;Create;True;0;0;False;0;0.03702387,0.4579069,0.6037736,0;0.03702387,0.4579069,0.6037736,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;19;-1585.042,460.7026;Float;False;Property;_ColorShift;Color Shift;1;0;Create;True;0;0;False;0;-5000,1000,0,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1275.29,-30.63885;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;18;-1203.643,324.7444;Float;False;5;0;FLOAT;0;False;1;FLOAT;-5000;False;2;FLOAT;1000;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-943.3235,-34.7438;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1890.124,165.1533;Float;True;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;17;-1396.758,206.4954;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;10;-6,26;Float;False;True;2;Float;ASEMaterialInspector;0;1;Background_Shader;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;4;0;6;2
WireConnection;13;0;1;0
WireConnection;13;1;14;0
WireConnection;18;0;11;0
WireConnection;18;1;19;1
WireConnection;18;2;19;2
WireConnection;18;3;19;3
WireConnection;18;4;19;4
WireConnection;16;0;13;0
WireConnection;16;1;1;0
WireConnection;16;2;18;0
WireConnection;17;0;11;0
WireConnection;10;0;16;0
ASEEND*/
//CHKSM=77E185BB2E71FD30431A4E7EC42C12998E4442CF