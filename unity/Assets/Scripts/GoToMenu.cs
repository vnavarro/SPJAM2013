using UnityEngine;
using System.Collections;

[RequireComponent(typeof(GestureControl))]
public class GoToMenu : MonoBehaviour {
	public GameObject menu;
	public GameObject[] levelsButtons;
	// Use this for initialization
	void Awake (){
		iTween.Init(gameObject);
		iTween.CameraFadeAdd();
	}
	void Start () {
		GestureControl control = GetComponent<GestureControl>();
		control.onTouchBegin += Go;
	}
	
	void OnEnable() {
		iTween.CameraFadeFrom(iTween.Hash("amount",.5f));
		iTween.CameraFadeTo(0,1.5f);
	}
#if UNITY_EDITOR
	void OnMouseDown() {
		Go(new Touch());
	}
#endif
	void Go (Touch t){
		//iTween.CameraFadeTo(1,3);
		iTween.CameraFadeTo(iTween.Hash("amount",.5f,"time",1.5f,"oncomplete","SwapGameObjects","oncompletetarget",gameObject));
	}
	
	void SwapGameObjects() {
		menu.SetActive(true);
		if(GameSettings.Instance.IsCurrentLevelSaved()){
			int currentLevel = GameSettings.Instance.GetCurrentLevel();
			for(int level = 0; level < currentLevel; level++){
				levelsButtons[level].SetActive(true);
			}
		}
		transform.root.gameObject.SetActive(false);
	}
}
