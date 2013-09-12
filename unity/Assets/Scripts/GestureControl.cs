using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Collider))]
public class GestureControl : MonoBehaviour {
	public delegate void TouchBeginHandler(Touch touch);
	public delegate void TouchMovedHandler(Touch touch);
	public delegate void TouchEndedHandler(Touch touch);
	
	public event TouchBeginHandler onTouchBegin;
	public event TouchMovedHandler onTouchMoved;
	public event TouchEndedHandler onTouchEnded;
	
	void Start () {
		
	}
	
	void Update () {
		this.checkTouch();
	}
	
	void checkTouch(){
		if(!this.hasCollider()){
			return;
		}
			
		foreach (Touch touch in Input.touches) {			
			if(!this.isBeingTouched(touch)){
				continue;
			}
			
			if(touch.phase == TouchPhase.Began){
				//print("began on game object");
				if(onTouchBegin != null){
					onTouchBegin(touch);				
				}
			}
			else if(touch.phase == TouchPhase.Moved){
				//print("moved on game object");	
				if(onTouchMoved != null){
					onTouchMoved(touch);
				}
			}
			else if(touch.phase == TouchPhase.Ended){				
				//print("Ended on game object");			
				if(onTouchEnded != null){
					onTouchEnded(touch);
				}
			}
		}
	}
	
	bool hasCollider(){
		if(this.collider == null || !this.collider.enabled){
			Debug.LogWarning("To check for touch use/enable a collider in the game object");
			return false;
		}
		return true;
	}
	
	bool isBeingTouched(Touch touch){				
		Vector3 endVector = Camera.main.ScreenPointToRay (touch.position).origin;
		endVector.z = 100;
		var ray = new Ray(Camera.main.ScreenPointToRay(touch.position).origin,endVector);
		RaycastHit hit;
		Debug.DrawLine(Camera.main.ScreenPointToRay (touch.position).origin,endVector,Color.magenta);
		if (Physics.Raycast(ray,out hit)) {
			if (hit.collider == collider)
			return true;
		}
		return false;
	}
}
