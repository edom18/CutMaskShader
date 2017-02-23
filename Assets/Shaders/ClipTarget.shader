Shader "Custom/ClipTarget" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader
	{
		Pass
		{
			Tags { "RenderType"="Opaque" "Queue"="Geometry-5" }

			LOD 200

			Stencil
			{
				Ref 100
				Comp Equal
				Pass Keep
				Fail Keep
				ZFail IncrSat
			}

			Cull Front
			//ZTest Always
//			ColorMask 0
			
			CGPROGRAM

			// Physically based Standard lighting model, and enable shadows on all light types
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : TEXCOORD1;
			};

			half _Glossiness;
			half _Metallic;
			fixed4 _Color;

			v2f vert(appdata i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
				o.normal = mul(unity_ObjectToWorld, float4(i.normal, 0.0));
				// o.normal = UnityObjectToWorldNormal(i.normal);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return float4(0.0, 0.0, 1.0, 1.0);
			}


			ENDCG
		}
	}
	FallBack "Diffuse"
}
