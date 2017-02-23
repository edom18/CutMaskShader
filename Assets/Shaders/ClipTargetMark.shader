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


		// 次に、前のパスでマークを付けたところでかつZFailしている部分にマークを付ける
		Pass
		{
			Stencil
			{
				Ref 100
				Comp Equal
				Pass Keep
				Fail Keep
				ZFail IncrSat
			}

			Cull Front
//			ZTest Always
			ZWrite Off
			ColorMask 0
			
			CGPROGRAM

			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			float4 frag(v2f i) : SV_Target
			{
				return float4(0.0, 0.0, 1.0, 1.0);
			}


			ENDCG
		}

		// まず、マスク内の「ZFailしてない」部分にマークを付ける
		Pass
		{
			Stencil
			{
				Ref 101
				Comp Equal
				Pass IncrSat
				Fail Keep
				ZFail Keep
			}

			Cull Back
			ZTest LEqual
			ZWrite Off

			CGPROGRAM

			#include "UnityCG.cginc"
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
