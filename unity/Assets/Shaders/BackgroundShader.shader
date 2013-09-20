﻿Shader "Custom/BackgroundShader" {
	Properties {
	    _Blend ("Blend", Range (0, 1) ) = 0.0
	    _MainTex ("Base Texture", 2D) = "" {}
	    _OverlayTexture ("Texture 2", 2D) = "" {}
	 
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha 
       	Pass {
	        SetTexture[_MainTex]
	        SetTexture[_OverlayTexture] {
	        	ConstantColor (0,0,0, [_Blend]) 
	        	combine texture Lerp(constant) previous
	        }
       	}
	}
}