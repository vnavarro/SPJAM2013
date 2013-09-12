using UnityEngine;

[RequireComponent(typeof(GestureControl))]
public class Piece : MonoBehaviour {
	public PieceSpawner spawner;
	public static Piece selected = null;
	public static GameObject boardLimits;
	
	private GestureControl control;
	private bool isMoving = false;
	
	private BoxCollider myCollider;
	// Use this for initialization
	void Start () {
		control = gameObject.GetComponent<GestureControl>();
		control.onTouchBegin += OnTouchBegin;
		control.onTouchMoved += OnTouchMove;
		control.onTouchEnded += OnTouchEnd;
		myCollider = collider as BoxCollider;
		Debug.Log(myCollider.size);
		myCollider.size *= 2;
		Debug.Log(myCollider.size);
	}
#if false
	private Vector3 lastMousePos;
	void OnMouseUp() {
		if(!isMoving){
			RotatePiece();
		} else {
			if (!isInsideBoard()){
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
		myCollider.size *= 2;
		//selected = this;
	}
	
	void OnTouchMove (Touch t) {
		//if(selected){
			isMoving = true;
			Vector3 movement = Camera.main.ScreenToWorldPoint(t.position);
			movement.z = transform.position.z;
			transform.position=movement;
		//}
	}
	
	void OnTouchEnd (Touch t) {
		myCollider.size /= 2;
		Debug.Log(isMoving);
		if(!isMoving){
			RotatePiece();
		} else {
			if (!isInsideBoard()){
				spawner.RestorePiece();
				Destroy(gameObject);
			}
		}
		isMoving = false;
		//selected = null;
	}
	
	void RotatePiece() {
		transform.Rotate(Vector3.back,90);
		Debug.Log(transform.rotation.eulerAngles.z);
	}
	
	bool isInsideBoard () {
		Bounds boardBounds = Piece.boardLimits.collider.bounds;
		Vector3 pieceCenter = this.gameObject.collider.bounds.center;
		bool isInsideX = pieceCenter.x >= boardBounds.min.x && pieceCenter.x <= boardBounds.max.x;		
		bool isInsideY = pieceCenter.y >= boardBounds.min.y && pieceCenter.y <= boardBounds.max.y;
		return isInsideX && isInsideY;
	}
}
