Shader "Custom/TargetPreMask" {
	Properties
	{
		//
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+10" }

		LOD 200

		// まず、ターゲット部分にマスクを掛ける
		Pass
		{
			Name "TargetMask"

			Stencil
			{
				Ref 10
				Comp Always
				Pass Replace
			}

			Cull Front
			ColorMask 0

			CGPROGRAM

			#include "Assets/Mask/Utility/Mask.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0


			float4 frag(v2f i) : SV_Target
			{
				return half4(1, 0, 0, 1);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
