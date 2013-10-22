﻿using UnityEngine;
using System.Collections;

public class LevelTransition : MonoBehaviour {
	public GameObject nextLevelBG, nextLevelImage, gameOverBG, gameOverImage;
	private string nextScreen;
	// Use this for initialization
	void Start () {
		iTween.Init(gameObject);
		iTween.CameraFadeAdd();
		iTween.ColorTo(nextLevelBG,iTween.Hash("a",0,"time",0));
		iTween.ColorTo(nextLevelImage,iTween.Hash("a",0,"time",0));
		iTween.ColorTo(gameOverBG,iTween.Hash("a",0,"time",0));
		iTween.ColorTo(gameOverImage,iTween.Hash("a",0,"time",0));
		iTween.CameraFadeFrom(iTween.Hash("amount",.5f,"time",1.5f));
		Invoke("StartTimer",1.5f);
	}
	
	void StartTimer() {
		TimerBar timer = GameObject.FindObjectOfType(typeof(TimerBar)) as TimerBar;
		timer.paused = false;
	}
	
	public void NextLevelTransition() {
		if(GameSettings.Instance.levelNumber == 6){
			nextScreen = "video";
		} else {
			GameSettings.Instance.levelNumber++;
			nextScreen = "level";
		}
		nextLevelBG.collider.enabled = true;
		iTween.ColorTo(nextLevelBG,iTween.Hash("a",.8f,
											   "time",3f));
		iTween.ColorTo(nextLevelImage,iTween.Hash("a",1,
											   	  "time",3f));
		Invoke("FadeOut",4f);
	}
	
	public void GameOverTransition() {
		nextScreen = "menu";
		gameOverBG.collider.enabled = true;
		iTween.ColorTo(gameOverBG,iTween.Hash("a",1,
											   "time",3f));
		iTween.ColorTo(gameOverImage,iTween.Hash("a",1,
											   	  "time",3f));
		Invoke("FadeOut",4f);
	}
	
	void FadeOut() {
		iTween.CameraFadeTo(iTween.Hash("amount",.5f,"time",1.5f));
		Invoke("LoadScene",2.2f);
	}
	
	void LoadScene() {
		Application.LoadLevel(nextScreen);
	}
}
