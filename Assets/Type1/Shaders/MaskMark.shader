Shader "Custom/MaskMark" {
	Properties {
		_Scale("Normal scale", Range(0,1)) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+5" }

		LOD 200

		// まずは「クリップ領域」を示す部分にマークを付ける
		Pass
		{
			Stencil
			{
				Ref 1
				Comp Always
				Pass Replace
				ZFail Replace
			}

			Cull Front
			ColorMask 0

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			fixed _Scale;

			v2f vert(appdata i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex + float4((i.normal * _Scale), 0.0));
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return float4(1.0, 0.0, 0.0, 1.0);
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
