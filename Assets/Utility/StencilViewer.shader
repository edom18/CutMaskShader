// Basic shader that simpy renders the specified colour for the area of the stencil .

Shader "Stencils/Viewers/Stencil_ViewRef_01"
{
	Properties
	{
		_Color1 ("Main Color", Color) = (0.5,0.5,0.5,1)
		_Color2 ("Main Color", Color) = (0.5,0.5,0.5,1)
		_Color3 ("Main Color", Color) = (0.5,0.5,0.5,1)
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" "Queue"="Transparent+500"}		

		ZWrite Off
		ZTest Always

		CGINCLUDE

		fixed4 _Color1;
		fixed4 _Color2;
		fixed4 _Color3;
		
		struct appdata 
		{
			float4 vertex : POSITION;
		};
		
		struct v2f 
		{
			float4 pos : SV_POSITION;
		};

		v2f vert(appdata v) 
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			return o;
		}
		ENDCG

		Pass
		{
			Stencil 
			{
				Ref 10
				Comp Equal
				Pass Keep
			}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			half4 frag(v2f i) : COLOR 
			{
				return _Color1;
			}

			ENDCG
		}

		Pass
		{
			Stencil 
			{
				Ref 11
				Comp Equal
				Pass Keep
			}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			half4 frag(v2f i) : COLOR 
			{
				return _Color2;
			}

			ENDCG
		}

		Pass
		{
			Stencil 
			{
				Ref 3
				Comp Equal
				Pass Keep
			}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			half4 frag(v2f i) : COLOR 
			{
				return _Color3;
			}

			ENDCG
		}
	}
}