using UnityEngine;
using System.Collections;

public class ConfigureAspectRatio : MonoBehaviour {

	// Use this for initialization
	void Start () {
		Camera.main.aspect = 480.0f/320.0f;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
