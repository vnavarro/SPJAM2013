using UnityEngine;
using UnityEngine.UI;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class PlayMovie : MonoBehaviour {
	
		#if !UNITY_IOS && !UNITY_ANDROID
	public MovieTexture movieTexture;
	public AudioSource audioSource;
		#endif
	// Use this for initialization
	void Start () {
				#if !UNITY_IOS && !UNITY_ANDROID
		GetComponent<RawImage>().texture = movieTexture;
		audioSource = GetComponent<AudioSource>();
		audioSource.clip = movieTexture.audioClip;
		movieTexture.Play();
		audioSource.Play();
				#endif
	}
	
	// Update is called once per frame
	void Update () {
				#if !UNITY_IOS && !UNITY_ANDROID
		if(!movieTexture.isPlaying){
			Application.LoadLevel("menu");
		}
				#endif
	}
}
