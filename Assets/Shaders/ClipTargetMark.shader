Shader "Custom/ClipTargetMark" {
	Properties {
		//
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Geometry-5" }

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

		// マークをつけるのみなので、頂点はただプロジェクション変換だけを行う
		v2f vert(appdata i)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
			// o.normal = UnityObjectToWorldNormal(i.normal);
			return o;
		}

		ENDCG


		// まず、前のパスでマークを付けたところ（Ref=100）でかつZFailしている部分にマークを付ける
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
	}
	FallBack "Diffuse"
}
