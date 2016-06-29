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
		GameSettings.Instance.levelNumber = levelNumber;
		iTween.AudioTo(GameObject.Find("Music"),0,1,1.5f);
		iTween.CameraFadeTo(iTween.Hash("amount",.5f,"time",1.5f,"oncomplete","LoadLevel","oncompletetarget",gameObject));
	}
	
	void LoadLevel() {
		Application.LoadLevel("level");
	}
}
