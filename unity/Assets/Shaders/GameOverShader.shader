Shader "Custom/GameOver" {
	Properties {
		_Color ("Color Tint", Color) = (1,1,1,1)
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
				ConstantColor [_Color] 
	        	combine texture * constant + previous
			}
			
		}
	} 
	FallBack "Transparent/Diffuse"
}
