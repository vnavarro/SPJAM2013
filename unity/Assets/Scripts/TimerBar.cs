using UnityEngine;

public class TimerBar : MonoBehaviour {
	// a delegate, called when the timer runs out
	public delegate void ExpiredTimeHandler();
	public static event ExpiredTimeHandler ExpiredTime;
	// the rate the time runs (exactly like in Lua version)
	public float timerSpeed;
	// used to have current and final timer reference
	public Transform currentPos, finalPos;
	// used to animate the timer bar
	public GameObject timerBar;
	
	public bool paused = true;
	// used to make the lua version-like calc
	private float totalTime;
	// timerBar material caching
	private Material barMaterial;
	private AudioSource gameOverSound;
	private ChangeBG bg;
	
	void Start () {
		gameOverSound = GameObject.Find("Game Over Sound").GetComponent<AudioSource>();
		bg = GameObject.FindObjectOfType(typeof(ChangeBG)) as ChangeBG;
		totalTime = finalPos.position.x - currentPos.position.x;
		barMaterial = timerBar.GetComponent<Renderer>().material;
		barMaterial.SetFloat("_Cut", 0);
	}
	
	public void ResetTimer() {
		currentPos.position = new Vector3(finalPos.position.x - totalTime
										 ,currentPos.position.y
										 ,currentPos.position.z);
	}
	
	public void MoveUp () {
		transform.Translate(0,1.4f,0);
	}
	
	// Update is called once per frame
	void Update () {
		if(paused) return;
		Vector3 moveTimer = currentPos.position;
		Vector3 endTimer = finalPos.position;
		// keep lua compatibility
		moveTimer.x += timerSpeed * Time.deltaTime * totalTime/10;
		if (moveTimer.x >= endTimer.x){
			moveTimer.x = endTimer.x;
			bg.StopMusic();
			gameOverSound.Play();
			LevelTransition lt = GameObject.FindObjectOfType(typeof(LevelTransition)) as LevelTransition;
			lt.GameOverTransition();
			
			if(ExpiredTime != null){
				ExpiredTime();
			}
			Destroy(this);
		}
		// update monster pos and timer bar
		currentPos.position = moveTimer;
		barMaterial.SetFloat("_Cut", 0.99f-(endTimer.x - moveTimer.x)/totalTime);
	}
}
