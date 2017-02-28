Shader "Custom/MaskRenderer" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		GrabPass { "_MaskGrabTexture" }
		
		Pass {
			CGPROGRAM

			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			sampler2D _MainTex;
			sampler2D _MaskGrabTexture;
			fixed4 _Color;

			struct appdata {
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
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif

				o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
				o.uvgrab.zw = o.pos.zw;

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				half4 col = tex2Dproj(_MaskGrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				return col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
