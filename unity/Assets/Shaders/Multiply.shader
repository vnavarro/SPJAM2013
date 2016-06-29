Shader "Custom/Multiply" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		LOD 200
		Pass {
			//BlendOp Sub
			Blend DstColor Zero
			//Blend SrcAlpha OneMinusSrcAlpha
			//Blend One One
			SetTexture[_MainTex] {
				combine texture
			}
			
		}
	} 
	FallBack "Transparent/Diffuse"
}
