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
		name = name.Replace("(Clone)","");
		control = gameObject.GetComponent<GestureControl>();
		if(spawner == null) {
			collider.enabled = false;
			enabled = false;
			control.enabled = false;
		}
		control.onTouchBegin += OnTouchBegin;
		control.onTouchMoved += OnTouchMove;
		control.onTouchEnded += OnTouchEnd;
		myCollider = collider as BoxCollider;
		Debug.Log(myCollider.size);
		myCollider.size *= 2;
		Debug.Log(myCollider.size);
	}
#if UNITY_EDITOR
	private Vector3 lastMousePos;
	private bool firstClick = true;
	void OnMouseUp() {
		myCollider.size /= 2;
		if(!isMoving){
			RotatePiece();
			boardLimits.GetComponent<Board>().RemovePieceAt(transform.position);
			SnapInBoard();
		} else {
			if (!(isInsideBoard() && SnapInBoard())){
				spawner.RestorePiece();
				Destroy(gameObject);
			}
		}
		isMoving = false;
		//selected = null;
	}
	
	void OnMouseDrag() {
		if(lastMousePos != Input.mousePosition) {
			isMoving = true;
			Vector3 movement = Camera.main.ScreenToWorldPoint(Input.mousePosition);
			movement.z = transform.position.z;
			transform.position=movement;
			lastMousePos = Input.mousePosition;
		}
	}
	
	void OnMouseDown() {
		if (firstClick){
			firstClick = false;
		} else {
			myCollider.size *= 2;
			if(isInsideBoard()){
				boardLimits.GetComponent<Board>().RemovePieceAt(transform.position);
			}
		}
		lastMousePos = Input.mousePosition;
		//selected = this;
	}
#endif
	void OnTouchBegin (Touch t) {
		myCollider.size *= 2;
		if(isInsideBoard()){
			boardLimits.GetComponent<Board>().RemovePieceAt(transform.position);
		}
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
		if(!isMoving){
			RotatePiece();
			SnapInBoard();
		} else {
			if (!(isInsideBoard() && SnapInBoard())){
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
		Vector3 pieceCenter = transform.position;
		bool isInsideX = pieceCenter.x >= boardBounds.min.x && pieceCenter.x <= boardBounds.max.x;		
		bool isInsideY = pieceCenter.y >= boardBounds.min.y && pieceCenter.y <= boardBounds.max.y;
		return isInsideX && isInsideY;
	}
	
	bool SnapInBoard() {
		Board board = boardLimits.GetComponent<Board>();
		Bounds boardBounds = board.collider.bounds;
		Vector3 myPos = transform.position;
		myPos.x = Mathf.Floor((myPos.x - boardBounds.min.x)/board.tileWidth)*board.tileWidth + boardBounds.min.x + board.tileWidth/2;
		myPos.y = Mathf.Floor((myPos.y - boardBounds.min.y)/board.tileHeight)*board.tileHeight + boardBounds.min.y + board.tileHeight/2;
		Debug.Log(myPos);
		if(!board.HavePieceAt(myPos)){
			transform.position = myPos;
			board.PutPieceAt(myPos,name,transform.rotation.eulerAngles.z);
			return true;
		} else {
			return false;
		}
	}
}
