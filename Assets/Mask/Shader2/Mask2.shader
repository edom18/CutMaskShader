Shader "Custom/Mask2" {
	Properties {
		//
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
				Pass Keep
				ZFail IncrSat
			}

			Cull Front
			ZWrite Off
			ZTest Greater
			ColorMask 0

			CGPROGRAM

			#include "Assets/Mask/Utility/Mask.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			float4 frag(v2f i) : SV_Target
			{
				return half4(0, 1, 0, 1);
			}

			ENDCG
		}

//		Pass
//		{
//			Stencil
//			{
//				Ref 11
//				Comp Equal
//				Pass IncrSat
//			}
//
//			Cull Front
//			ZWrite Off
//			ZTest GEqual
//			ColorMask 0
//
//			CGPROGRAM
//
//			#include "Assets/Mask/Utility/Mask.cginc"
//			#pragma vertex vert
//			#pragma fragment frag
//			#pragma target 3.0
//
//			float4 frag(v2f i) : SV_Target
//			{
//				return half4(0, 1, 0, 1);
//			}
//
//			ENDCG
//		}
	}
	FallBack "Diffuse"
}
