Shader "Custom/MaskBack" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Scale("Normal scale", Range(0,1)) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Geometry+100" }

		LOD 200

		// `102`とマークがついた部分（＝背面）をレンダリング
		Pass
		{
			Stencil
			{
				Ref 102
				Comp Equal
				Pass Keep
				ZFail Keep
			}

//			ColorMask 0
			ZTest Always
			Cull Front
			
			CGPROGRAM

			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
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
				o.normal = normalize(mul(unity_ObjectToWorld, float4(i.normal, 0.0)));
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return float4(0.0, 1.0, 0.0, 1.0);
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
