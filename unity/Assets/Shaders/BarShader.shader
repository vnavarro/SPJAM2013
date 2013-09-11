Shader "Custom/BarShader" {
	Properties {
		_MainTex ("Base (RGBA)", 2D) = "white" {}
		_Cut ("Cut Range", Range(0,1)) = 0
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		LOD 200
		
		Blend SrcAlpha OneMinusSrcAlpha 
		Material {
			
		}
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};
		float _Cut;
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			if (IN.uv_MainTex.x > _Cut) {
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			} else {
				o.Alpha = 0;
			}
		}
		ENDCG
	} 
	FallBack "Unlit/Transparent"
}
