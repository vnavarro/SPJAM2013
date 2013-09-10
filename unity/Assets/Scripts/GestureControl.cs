using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GestureControl : MonoBehaviour {
	//public Camera cam;
	
	
	public bool isReceiverPhysical = false;	
	public bool touchOn = false;
	public bool pinchOn = false;
	
	bool isPinching = false;
	Touch[] pinchFingers;	
	float distanceInPinch = 0;
	
	// Use this for initialization
	void Start () {
		pinchFingers = new Touch[2];
	}
	
	// Update is called once per frame
	void Update () {
		foreach (Touch touch in Input.touches) {
			if (touch.phase == TouchPhase.Began) {						
				if(Input.touchCount == 1 && touchOn){
					SendGestureMessage("TouchBegan",touch);				
				}
				else if(Input.touchCount == 2){				
					if(isPinching == false && pinchOn){
						isPinching = true; 
						//print("Uma só vez");
						if(touch.fingerId == 0 || touch.fingerId == 1){
							pinchFingers[touch.fingerId] = touch;
						}
						if(pinchFingers.Length >= 2){
							distanceInPinch = Vector2.Distance(pinchFingers[0].position,pinchFingers[1].position);
							//print("Fingers Count:"+pinchFingers.Length);
							SendGestureMessage("PinchBegan",pinchFingers);
						} 
					}					
				}
			}
			if(touch.phase == TouchPhase.Moved){											
				if(Input.touchCount == 1 && touchOn){
					SendGestureMessage("TouchMoved",touch);				
				}	
				else if(Input.touchCount == 2){
					if(isPinching  && pinchOn){
						if(touch.fingerId == 0 || touch.fingerId == 1){
							pinchFingers[touch.fingerId] = touch;
						}
						if(pinchFingers.Length >= 2){							
							float newDistanceInPinch = Vector2.Distance(pinchFingers[0].position,pinchFingers[1].position);
							if(newDistanceInPinch < distanceInPinch ){
								SendGestureMessage("PinchZoomOut",pinchFingers);
								//cam.transform.Translate(new Vector3(0,0,-0.5f));
							}else if(newDistanceInPinch > distanceInPinch){
								SendGestureMessage("PinchZoomIn",pinchFingers);
								//cam.transform.Translate(new Vector3(0,0,0.5f));
							}
							distanceInPinch = newDistanceInPinch;	
						}
					}					
				}
			}
			if(touch.phase == TouchPhase.Ended){
				if(Input.touchCount == 1 && touchOn){
					SendGestureMessage("TouchEnded",touch);
				}
				else if(Input.touchCount == 2){
					if(isPinching  && pinchOn){						
						SendGestureMessage("PinchEnded",pinchFingers);
						isPinching = false;
					}
				}
			}
		}
	}	
	
	void SendGestureMessage(string methodName,Touch touch){				
		var ray = Camera.main.ScreenPointToRay (touch.position);	//cam.ScreenPointToRay (touch.position);	
		//var ray = new Ray(new Vector3(touch.position.x,touch.position.y,Camera.main.transform.position.z),Vector3.forward);
		RaycastHit hit;
		////Debug.Log("Direction:"+Camera.main.ScreenPointToRay (touch.position).origin);
		//Debug.DrawLine(ray.origin,ray.origin*-10);
		//Debug.DrawLine(ray.origin,ray.direction * 10);
		Debug.DrawRay(ray.origin,ray.direction);
		/*if (Physics.Raycast(ray,out hit) && isReceiverPhysical) {
			print("Ray touched:"+this.gameObject+","+Physics.Raycast (ray));
			Debug.Log(hit.transform.name);//Object you touched			
			hit.transform.SendMessage(methodName,touch);
		}else if(!isReceiverPhysical){
			this.gameObject.SendMessage(methodName,touch);
		}*/
		
		//Old way, works i think
		if (Physics.Raycast(ray,out hit) && isReceiverPhysical) {
			//print("Ray touched:"+this.gameObject+","+Physics.Raycast (ray));
			//Debug.Log(hit.transform.name);//Object you touched			
			hit.transform.SendMessage(methodName,touch);
		}else if(!isReceiverPhysical){
			this.gameObject.SendMessage(methodName,touch);
		}
	}
	
	void SendGestureMessage(string methodName,Touch[] touches){
		var rayTouch1 = Camera.main.ScreenPointToRay (touches[0].position);	
		var rayTouch2 = Camera.main.ScreenPointToRay (touches[1].position);
		if ((Physics.Raycast (rayTouch1) || Physics.Raycast (rayTouch2)) && isReceiverPhysical) {
			//print("Ray touched:"+this.gameObject+","+Physics.Raycast (rayTouch1));
			this.gameObject.SendMessage(methodName,touches);
		}else if(!isReceiverPhysical){
			this.gameObject.SendMessage(methodName,touches);
		}
	}
}


