using UnityEngine;
using System.Collections;

[RequireComponent(typeof(GestureControl))]
public class ToggleSound : MonoBehaviour {
	
	public Texture2D soundOn, soundOff;
	// Use this for initialization
	void Start () {
		GestureControl control = GetComponent<GestureControl>();
		control.onTouchBegin += Toggle;
	}
#if UNITY_EDITOR
	void OnMouseDown(){
		Toggle(new Touch());
	}
#endif
	void Toggle(Touch t){
		AudioListener.pause = !AudioListener.pause;
		if(AudioListener.pause){
			GetComponent<Renderer>().material.mainTexture = soundOff;
		} else {
			GetComponent<Renderer>().material.mainTexture = soundOn;
		}
		GameSettings.Instance.soundOn = !AudioListener.pause;
	}
}	