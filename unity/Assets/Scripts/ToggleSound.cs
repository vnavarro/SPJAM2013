﻿using UnityEngine;
using System.Collections;

[RequireComponent(typeof(GestureControl))]
public class ToggleSound : MonoBehaviour {
	
	public Texture2D soundOn, soundOff;
	// Use this for initialization
	void Start () {
		GestureControl control = GetComponent<GestureControl>();
		control.onTouchBegin += Toggle;
	}
	
	void OnMouseDown(){
		Toggle(new Touch());
	}
	
	void Toggle(Touch t){
		AudioListener.pause = !AudioListener.pause;
		if(AudioListener.pause){
			renderer.material.mainTexture = soundOff;
		} else {
			renderer.material.mainTexture = soundOn;
		}
		GameSettings.Instance.soundOn = !AudioListener.pause;
	}
}	