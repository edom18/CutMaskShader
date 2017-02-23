Shader "Custom/Mask" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Scale("Normal scale", Range(0,1)) = 0.0
	}
	SubShader
	{
		// まずは「クリップ領域」を示す部分にマークを付ける
		Pass
		{
			Tags { "RenderType"="Opaque" "Queue"="Geometry-10" }

			LOD 200

			Stencil
			{
				Ref 100
				Comp Always
				Pass Replace
				ZFail Replace
			}

//			ZWrite Off
			Cull Front
			ColorMask 0

			CGPROGRAM

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
			fixed _Scale;

			v2f vert(appdata i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex + float4((i.normal * _Scale), 0.0));

				// ワールド空間での法線を計算
				o.normal = normalize(mul(unity_ObjectToWorld, float4(i.normal, 0.0)));
				// こっちでもいける
				// o.normal = UnityObjectToWorldNormal(i.normal);

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return float4(1.0, 0.0, 0.0, 1.0);
			}

			ENDCG
		}

		Pass
		{
			Tags { "RenderType"="Opaque" "Queue"="Geometry+100" }

			Stencil
			{
				Ref 101
				Comp Equal
				Pass Keep
				ZFail Keep
			}

			LOD 200

//			ColorMask 0
			ZTest Always
			Cull Front
			
			CGPROGRAM

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

				// ワールド空間での法線を計算
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
