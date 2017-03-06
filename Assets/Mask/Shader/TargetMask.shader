Shader "Custom/TargetMask" {
	Properties
	{
		//
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+11" }

		LOD 200

		// --------------------------------------------------
		Pass
		{
			Stencil
			{
				Ref 10
				Comp Equal
				ZFail IncrSat
			}

			Cull Back
			Zwrite Off
			ZTest GEqual
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


		// --------------------------------------------------
		Pass
		{
			Name "TargetMask"

			Stencil
			{
				Ref 11
				Comp Equal
				ZFail IncrSat
			}

			Cull Front
			Zwrite Off
			ZTest LEqual
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


		// --------------------------------------------------
		Pass
		{
			Name "TargetMask"

			Stencil
			{
				Ref 10
				Comp Equal
				ZFail DecrSat
			}

			Cull Back
			Zwrite Off
			ZTest LEqual
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
