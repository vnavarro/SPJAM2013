using UnityEngine;
using System.Collections;

public class GestureControl : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		foreach (Touch touch in Input.touches) {
			if(touch.phase == TouchPhase.Ended){
				if(this.isThisBeingTouched(touch)){
					print("Ended on game object");			
					print(this.gameObject);
				}
			}
		}
	}
	
	bool isThisBeingTouched(Touch touch){				
		//var ray = Camera.main.ScreenPointToRay (touch.position);	//cam.ScreenPointToRay (touch.position);	
		var ray = new Ray(new Vector3(touch.position.x,touch.position.y,-1),Vector3.forward);
		RaycastHit hit;
		Debug.Log("Direction:"+Camera.main.ScreenPointToRay (touch.position).origin);
		Debug.DrawLine(Vector3.zero,new Vector3(touch.position.x,touch.position.y,0),Color.magenta);
		Debug.DrawLine(ray.origin,ray.direction * 10);
		Debug.DrawRay(ray.origin,ray.direction);
		
		//Old way, works i think
		if (Physics.Raycast(ray,out hit)) {
			print("Ray touched:"+this.gameObject+","+Physics.Raycast (ray));
			Debug.Log(hit.transform.name);//Object you touched			
			//hit.transform.SendMessage(methodName,touch);
			return true;
		}
		/*else if(!isReceiverPhysical){
			this.gameObject.SendMessage(methodName,touch);
		}*/
		return false;
	}
}
