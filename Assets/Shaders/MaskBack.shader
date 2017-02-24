Shader "Custom/MaskBack" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+100" }

		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha

		// `102`とマークがついた部分（＝背面）をレンダリング
		Pass
		{
			Stencil
			{
				Ref 102
				Comp Equal
				Pass Keep
				Fail Keep
				ZFail Keep
			}

			Cull Front
			
			CGPROGRAM

			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			sampler2D _MainTex;
			fixed4 _Color;

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			v2f vert(appdata i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 c = _Color;
				c.a = 0.5;
				return c;
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
