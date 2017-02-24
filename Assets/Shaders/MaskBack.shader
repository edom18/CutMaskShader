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

		// `102`とマークがついた部分（＝背面）をレンダリング
		Pass
		{
			Stencil
			{
				Ref 3
				Comp NotEqual
				Pass Keep
				Fail Keep
				ZFail Keep
			}

			Cull Front
			
			CGPROGRAM

			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			sampler2D _MainTex;
			fixed4 _Color;

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

			float4 frag(v2f i) : SV_Target
			{
				float4 c = _Color;
				return c;
			}

			ENDCG
		}

		Pass {

			Stencil
			{
				Ref 3
				Comp Equal
				Pass Keep
				Fail Keep
				ZFail Keep
			}

			CGPROGRAM

			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			sampler2D _MainTex;
			uniform sampler2D _MaskGrabTexture;
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

				//o.uvgrab = ComputeScreenPos(o.pos);
				o.viewDir = normalize(mul(unity_ObjectToWorld, i.vertex).xyz - _WorldSpaceCameraPos);
				o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				//half4 col = tex2Dproj(_MaskGrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				half4 col = tex2D(_MaskGrabTexture, float2(i.uvgrab.xy / i.uvgrab.w));
				return col * _Color;
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
