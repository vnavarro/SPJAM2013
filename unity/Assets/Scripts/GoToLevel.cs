using UnityEngine;
using System.Collections;

[RequireComponent(typeof(GestureControl))]
public class GoToLevel : MonoBehaviour {
	public int levelNumber;
	
	void Awake (){
		iTween.Init(gameObject);
		iTween.CameraFadeAdd();
	}
	// Use this for initialization
	void Start () {
		GestureControl control = GetComponent<GestureControl>();
		control.onTouchBegin += FadeOut;
	}
#if UNITY_EDITOR
	void OnMouseDown (){
		FadeOut(new Touch());
	}
#endif
	void FadeOut(Touch t){
		iTween.CameraFadeTo(iTween.Hash("amount",.5f,"time",1.5f,"oncomplete","LoadLevel","oncompletetarget",gameObject));
	}
	
	void LoadLevel() {
		GameSettings.Instance.levelNumber = levelNumber;
		Application.LoadLevel("level");
	}
}
