using UnityEngine;
using System.Collections;

public class ScrollCredits : MonoBehaviour {
	public float startPos, endPos;
	public float time, stopTime;
	// Use this for initialization
	void Start () {
		iTween.MoveTo(gameObject,iTween.Hash("delay",stopTime,
											 "y",endPos,
											 "time",time,
											 "easetype",iTween.EaseType.linear,
											 "looptype",iTween.LoopType.pingPong));
	}
	
}
