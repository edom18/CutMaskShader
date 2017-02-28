Shader "Custom/MaskBack" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "ForceNoShadowCasting"="True" "Queue"="Transparent+100" }

		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha

		GrabPass { "_MaskGrabTexture" }

		// `3`とマークがついた部分（＝背面）をレンダリング
		Pass
		{
			Stencil
			{
				Ref 3
				Comp Equal
				Pass Keep
				Fail Keep
				ZFail Keep
			}

			Cull Front
			ZWrite Off
			
			CGPROGRAM

			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			uniform sampler2D _MaskGrabTexture;
			sampler2D _MainTex;
			fixed4 _Color;

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uvgrab : TEXCOORD1;
			};

			v2f vert(appdata i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);

				#if UNITY_UV_STARTS_AT_TOP
				// UVが上から始まる場合はスケールをマイナスして反転する
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif

				// XY座標を、Wを使って補正する（0.0～1.0かな？）
				//o.uvgrab = ComputeScreenPos(o.pos);
				o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
				o.uvgrab.zw = o.pos.zw;

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				//half4 col = tex2Dproj(_MaskGrabTexture, UNITY_PROJ_COORD(i.uvgrab));
//				half4 col = tex2D(_MaskGrabTexture, float2(i.uvgrab.xy / i.uvgrab.w));
				return half4(0, 1, 0, 1);
			}

			ENDCG
		}

		// クリップした背面をレンダリング
		Pass {
			Stencil
			{
				Ref 3
				Comp NotEqual
				Pass Keep
				Fail Keep
				ZFail Keep
			}

			CGPROGRAM

			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			uniform sampler2D _MaskGrabTexture;
			sampler2D _MainTex;
			fixed4 _Color;

			struct appdata {
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uvgrab : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};

			v2f vert(appdata i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);

				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif

				o.viewDir = normalize(mul(unity_ObjectToWorld, i.vertex).xyz - _WorldSpaceCameraPos);
				o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
				o.uvgrab.zw = o.pos.zw;

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				half4 col = tex2D(_MaskGrabTexture, float2(i.uvgrab.xy / i.uvgrab.w));
				return col * half4(1.0, 0.0, 0.0, 1.0);
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
