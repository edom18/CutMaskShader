Shader "Custom/MaskRender" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+12" }

		LOD 200


		// --------------------------
		CGINCLUDE

		sampler2D _MainTex;
		sampler2D _MaskGrabTexture;

		struct appdata
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			float3 normal : TEXCOORD1;
			float4 uvgrab : TEXCOORD2;
		};

		fixed4 _Color;

		v2f vert(appdata i)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, i.vertex);

			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif

			// Compute screen pos to UV.
			o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
			o.uvgrab.zw = o.pos.zw;

			return o;
		}

		ENDCG
		// --------------------------


		// Grab background rendering.
		GrabPass { "_MaskGrabTexture" }


		Pass
		{
			Name "TargetSurface"

			Stencil
			{
				Ref 11
				Comp Equal
				Pass Keep
//				Fail IncrSat
//				ZFail IncrSat
			}

			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			float4 frag(v2f i) : SV_Target
			{
				return half4(0.0, 0.5, 1.0, 1.0);
			}

			ENDCG
		}

		Pass
		{
			Name "TargetBackFace"

			Stencil
			{
				Ref 12
				Comp Equal
				Pass Keep
				Fail Keep
				ZFail Keep
			}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			float4 frag(v2f i) : SV_Target
			{
//				half4 texel = tex2D(_MaskGrabTexture, float2(i.uvgrab.xy / i.uvgrab.w));
				half4 col = half4(0.0, 0.9, 1, 1);
				return col;
			}

			ENDCG
		}

		Pass
		{
			Stencil
			{
				Ref 10
				Comp Equal
			}

			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			float4 frag(v2f i) : SV_Target
			{
//				half4 texel = tex2D(_MaskGrabTexture, float2(i.uvgrab.xy / i.uvgrab.w));
				half4 col = half4(0, 1, 1, 0.5);
				return col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
