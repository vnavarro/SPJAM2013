using UnityEngine;
using System.Collections;

public class PlayMovieOnDevice : MonoBehaviour {

		public string filename;

	// Use this for initialization
	void Start () {	
		#if !UNITY_EDITOR && !UNITY_DEBUG
		StartCoroutine(PlayStreamingVideo(filename));
		#endif
	}

	private IEnumerator PlayStreamingVideo(string url)
	{
		Debug.Log("go!");
		Handheld.PlayFullScreenMovie (filename, Color.black, 
						FullScreenMovieControlMode.Hidden, FullScreenMovieScalingMode.AspectFit);
		yield return new WaitForEndOfFrame();
		yield return new WaitForEndOfFrame();
		Debug.Log("Video playback completed.");
		Application.LoadLevel("menu");
	}
	// Update is called once per frame
	void Update () {
	
	}
}
