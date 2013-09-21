Shader "Custom/Multiply" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		LOD 200
		Pass {
			Blend DstColor Zero
			SetTexture[_MainTex] {combine texture}
		}
	} 
	FallBack "Diffuse"
}
