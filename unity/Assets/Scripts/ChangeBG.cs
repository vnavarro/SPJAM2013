using UnityEngine;

public class ChangeBG : MonoBehaviour {
	public float changeSpeed = 1;
	
	private Material mat;
	private float currentVar = 0;
	private bool changing = false;
	void Start () {
		mat = renderer.material;
		mat.SetFloat("_Blend",0);
	}
	
	public void ToGood(){
		ToGood(false);
	}
	
	public void ToBad(){
		ToBad(false);
	}
	
	public void ToGood(bool instantChange) {
		if(instantChange){
			currentVar = 0;
			mat.SetFloat("_Blend",0);
			return;
		}
		if (currentVar <= 0) return;
		if (changeSpeed > 0) changeSpeed *= -1;
		changing = true;
	}
	public void ToBad(bool instantChange) {
		if(instantChange){
			currentVar = 1;
			mat.SetFloat("_Blend",1);
			return;
		}
		if (currentVar >= 1) return;
		if (changeSpeed < 0) changeSpeed *= -1;
		changing = true;
	}
	// Update is called once per frame
	void Update () {
		if(changing){
			currentVar += Time.deltaTime*changeSpeed;
			mat.SetFloat("_Blend",currentVar);
			if (currentVar >= 1 || currentVar <= 0) {
				currentVar = Mathf.Clamp01(currentVar);
				changing = false;
			}
		}
	}
	void OnGUI (){
		if (GUILayout.Button("to good")){
			ToGood();
		}
		if (GUILayout.Button("to bad")){
			ToBad();
		}
	}
}
