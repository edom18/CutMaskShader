Shader "Custom/ClipTargetMark" {
	Properties {
		//
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+10" }

		LOD 200

		CGINCLUDE

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

		ENDCG


		// まず、前のパスでマークを付けたところ（Ref=1）でかつZFailしている部分にマークを付ける
		Pass
		{
			Stencil
			{
				Ref 1
				Comp Equal
				Pass Keep
				Fail Keep
				ZFail IncrSat
			}

			Cull Front
			ZWrite Off
			ColorMask 0
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			float4 frag(v2f i) : SV_Target
			{
				return float4(0.0, 0.0, 1.0, 1.0);
			}

			ENDCG
		}

		// 次に、マスク内の「ZFailしてない」部分にマークを付ける
		Pass
		{
			Stencil
			{
				Ref 2
				Comp Equal
				Pass IncrSat
				Fail Keep
				ZFail Keep
			}

			Cull Back
			ZWrite Off
			ColorMask 0

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			float4 frag(v2f i) : SV_Target
			{
				return half4(1.0, 1.0, 0.0, 1.0);
			}

			ENDCG
		}

		// 普通にレンダリング
//		Pass
//		{
//			Stencil
//			{
//				Ref 1
//				Comp NotEqual
//				Pass Keep
//				Fail Keep
//				ZFail Keep
//			}
//
//			Cull Back
//			Zwrite On
//
//			CGPROGRAM
//
//			#pragma vertex vert
//			#pragma fragment frag
//
//			float4 frag(v2f i) : SV_Target
//			{
//				return half4(0, 0, 0.5, 1);
//			}
//
//			ENDCG
//		}
	}
	FallBack "Diffuse"
}
