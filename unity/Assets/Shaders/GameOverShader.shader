Shader "Custom/GameOver" {
	Properties {
		_Color ("Color Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		LOD 200
		CGPROGRAM
		#pragma surface surf Lambert alpha
		struct Input {
			float2 uv_MainTex;
		};
		sampler2D _MainTex;
		fixed4 _Color;
		
		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb * _Color;  
			o.Alpha = _Color.a;
		
		}
		ENDCG
	} 
	FallBack "Transparent/Diffuse"
}
