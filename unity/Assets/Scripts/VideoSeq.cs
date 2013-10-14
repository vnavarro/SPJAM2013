﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class VideoSeq : MonoBehaviour {
	public float fps = 20;
	private Queue<Texture2D> textures = new Queue<Texture2D>();
	private float lastUpdate = 0;
	// Use this for initialization
	void Start () {
		lastUpdate = Time.time;
		StartCoroutine("AddTextures");
	}
	
	IEnumerator AddTextures() {
		for(int i = 0; i <= 451; i++){
			while(textures.Count > 5) yield return null;
			
			textures.Enqueue(Resources.Load("Video/final_scene_tela_3"+i.ToString("D3")) as Texture2D);
			yield return null;
		}
	}
	
	// Update is called once per frame
	int i = 0;
	void Update () {
		if(lastUpdate + 1f/fps < Time.time){
			if(textures.Count > 0){
				Resources.UnloadAsset(renderer.material.mainTexture);
				renderer.material.mainTexture = textures.Dequeue();
				
			}
			lastUpdate = Time.time;
		}
	}
}