Shader "Custom/Test" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "ForceNoShadowCasting"="True" "Queue"="Transparent" }

		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha

		GrabPass { "_MaskGrabTexture" }

		Pass {
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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uvgrab : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
				float3 normal : TEXCOORD3;
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
				o.normal = normalize(mul(unity_ObjectToWorld, float4(i.normal, 0.0)).xyz);

				//o.uvgrab = ComputeScreenPos(o.pos);
				o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
				o.uvgrab.zw = o.pos.zw;

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float rim = 1.0 - dot(-i.viewDir, i.normal);
				half4 col = _Color * tex2Dproj(_MaskGrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				//half4 col = _Color * tex2D(_MaskGrabTexture, float2(i.uvgrab.xy / i.uvgrab.w));
				col.a *= rim;
				return col;
				//return half4(1.0, 0.0, 0.0, 1.0);
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
