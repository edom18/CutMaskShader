Shader "Custom/MaskRender" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MaskColor ("Mask color", Color) = (0.0, 0.9, 1.0, 1.0)
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

		struct FragOut
		{
			float4 color : SV_Target;
			float depth : SV_Depth;
		};

		fixed4 _Color;
		fixed4 _MaskColor;

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


		// ------------------------------------------------------
		// Target back face.
		Pass
		{
			Stencil
			{
				Ref 12
				Comp Equal
			}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			float4 frag(v2f i) : SV_Target
			{
				return _MaskColor;
			}

			ENDCG
		}


		// ------------------------------------------------------
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Back
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			float4 frag(v2f i) : SV_Target
			{
				return half4(0, 0.5, 1.0, 0.0);
			}

			ENDCG
		}


		// ------------------------------------------------------
		Pass
		{
			Stencil
			{
				Ref 9
				Comp Equal
				Pass Keep
			}

			Blend SrcAlpha OneMinusSrcAlpha
			Cull Back
			ZTest Always
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			FragOut frag(v2f i)
			{
				FragOut o = (FragOut)0;
				o.color = half4(0.0, 0.5, 1.0, 0.0);
				o.depth = 0;
				return o;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
