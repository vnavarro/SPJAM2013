using UnityEngine;

public class ChangeBG : MonoBehaviour {
	public AudioSource goodMusic, badMusic, changeSound;
	public Material portalMat;
	public float changeSpeed = 1;
	
	private Material mat;
	private float currentVar = 0;
	private bool changing = false;
	void Start () {
		mat = renderer.material;
		mat.SetFloat("_Blend",0);
		portalMat.SetFloat("_Blend",0);
	}
	
	public void ToGood(){
		ToGood(false);
	}
	
	public void ToBad(){
		ToBad(false);
	}
	
	public void ToGood(bool instantChange) {
		badMusic.Stop();
		if (!goodMusic.isPlaying) goodMusic.Play();
		if(instantChange){
			currentVar = 0;
			mat.SetFloat("_Blend",0);
			portalMat.SetFloat("_Blend",0);
			return;
		}
		if (currentVar <= 0) return;
		if (changeSpeed > 0) changeSpeed *= -1;
		if (!changing) {
			changeSound.Play();
		}
		changing = true;
	}
	public void ToBad(bool instantChange) {
		goodMusic.Stop();
		if (!badMusic.isPlaying) badMusic.Play();
		if(instantChange){
			currentVar = 1;
			mat.SetFloat("_Blend",1);
			portalMat.SetFloat("_Blend",1);
			return;
		}
		if (currentVar >= 1) return;
		if (changeSpeed < 0) changeSpeed *= -1;
		if (!changing) {
			changeSound.Play();
		}
		changing = true;
	}
	// Update is called once per frame
	void Update () {
		if(changing){
			currentVar += Time.deltaTime*changeSpeed;
			mat.SetFloat("_Blend",currentVar);
			portalMat.SetFloat("_Blend",currentVar);
			if (currentVar >= 1 || currentVar <= 0) {
				currentVar = Mathf.Clamp01(currentVar);
				changing = false;
			}
		}
	}
}
