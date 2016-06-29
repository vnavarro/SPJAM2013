using UnityEngine;
using System.Collections;

public class SplashTween : MonoBehaviour {
	
	public GameObject bbmLogo, gameLogo;
	public float transitionTime = 3, showTime = 3;
	// Use this for initialization
	void Start () {
		iTween.ColorTo(bbmLogo,iTween.Hash("a",0,"time",0));
		iTween.ColorTo(gameLogo,iTween.Hash("a",0,"time",0));
		
		iTween.ColorTo(bbmLogo,iTween.Hash("time",transitionTime,
										   "delay",0,
										   "a",1));
		
		iTween.ColorTo(bbmLogo,iTween.Hash("time",transitionTime,
										   "delay",transitionTime + showTime,
										   "a",0));
		
		iTween.ColorTo(gameLogo,iTween.Hash("time",transitionTime,
										   "delay",2*transitionTime + showTime,
										   "a",1));
		
		iTween.ColorTo(gameLogo,iTween.Hash("time",transitionTime,
										   "delay",3*transitionTime + 2*showTime,
										   "a",0,
										   "oncomplete","GoToMainMenu","oncompletetarget",gameObject));
		
	}
	void GoToMainMenu () {
		Application.LoadLevel("menu");
	}
	// Update is called once per frame
	void Update () {
	
	}
}
