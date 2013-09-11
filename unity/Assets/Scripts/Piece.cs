using UnityEngine;

[RequireComponent(typeof(GestureControl))]
public class Piece : MonoBehaviour {
	public PieceSpawner spawner;
	public static Piece selected = null;
	
	private GestureControl control;
	private bool isMoving = false;
	
	// Use this for initialization
	void Start () {
		control = GetComponent<GestureControl>();
		control.onTouchMoved += OnTouchMove;
		control.onTouchEnded += OnTouchEnd;
	}
#if UNITY_EDITOR
	private Vector3 lastMousePos;
	void OnMouseUp() {
		if(!isMoving){
			RotatePiece();
		} else {
			if (!CheckPosition()){
				spawner.RestorePiece();
				Destroy(gameObject);
			}
		}
		isMoving = false;
		selected = null;
	}
	
	void OnMouseDrag() {
		if(lastMousePos != Input.mousePosition) {
			isMoving = true;
			Vector3 movement = Camera.main.ScreenToWorldPoint(Input.mousePosition);
			movement.z = selected.transform.position.z;
			selected.transform.position=movement;
			lastMousePos = Input.mousePosition;
		}
	}
	
	void OnMouseDown() {
		lastMousePos = Input.mousePosition;
		selected = this;
	}
#endif
	void OnTouchBegin (Touch t) {
		selected = this;
	}
	
	void OnTouchMove (Touch t) {
		isMoving = true;
		Vector3 movement = Camera.main.ScreenToWorldPoint(t.position);
		movement.z = selected.transform.position.z;
		selected.transform.position=movement;
	}
	
	void OnTouchEnd (Touch t) {
		if(!isMoving){
			RotatePiece();
		} else {
			if (!CheckPosition()){
				spawner.RestorePiece();
				Destroy(gameObject);
			}
		}
		isMoving = false;
		selected = null;
	}
	
	void RotatePiece() {
		transform.Rotate(Vector3.back,90);
		Debug.Log(transform.rotation.eulerAngles.z);
	}
	
	bool CheckPosition () {
		return false;
	}
}
