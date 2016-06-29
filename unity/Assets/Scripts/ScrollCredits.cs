using UnityEngine;
using System.Collections;

public class ScrollCredits : MonoBehaviour {
	public float startPos, endPos;
	public float time, stopTime;
	// Use this for initialization
	//void Start () {
	void OnEnable() {
		iTween.MoveTo(gameObject,iTween.Hash("delay",stopTime,
											 "y",endPos,
											 "time",time,
											 "easetype",iTween.EaseType.linear,
											 "looptype",iTween.LoopType.pingPong));
	}
	void OnDisable () {
		iTween.Stop(gameObject);
		transform.position = new Vector3(transform.position.x,startPos,transform.position.z);
	}
	
}
