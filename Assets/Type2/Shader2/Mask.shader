Shader "Custom/Mask" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+11" }

		LOD 200

		Pass
		{
			Stencil
			{
				Ref 10
				Comp Equal
				Pass IncrSat
				Fail Keep
				ZFail IncrSat
			}

			Cull Front
			ZWrite On
			ZTest LEqual
//			ColorMask 0

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			sampler2D _MainTex;

			struct appdata {
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			fixed4 _Color;

			v2f vert(appdata i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return half4(0, 1, 0, 1);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
