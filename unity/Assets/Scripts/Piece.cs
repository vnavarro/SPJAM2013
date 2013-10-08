using UnityEngine;

[RequireComponent(typeof(GestureControl))]
public class Piece : MonoBehaviour {
	public PieceSpawner spawner;
	public static Piece selected = null;
	public static GameObject boardLimits;
	
	private GestureControl control;
	private bool isMoving = false;
	
	private BoxCollider myCollider;
	private PieceConnector[] connectors;
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
		
		this.CreateConnectors();
	}
	
	void CreateConnectors(){
		connectors = new PieceConnector[2];
		connectors[0] = new PieceConnector(Orientation.LEFT,false);
		connectors[1] = new PieceConnector(Orientation.RIGHT,false);		
		
		this.AdjustConnectors();
	}
	
	void AdjustConnectors(){
		int rotation = (int)this.gameObject.transform.rotation.eulerAngles.z;
		if(this.name.Contains("portal")){
			connectors[0].isOn = true;
			connectors[1].isOn = true;
			connectors[2] = new PieceConnector(Orientation.UP,true);
			connectors[3] = new PieceConnector(Orientation.DOWN,true);
		}
		else if (this.name.Contains("straight")){
			if (rotation == 0 || rotation == 180){
				connectors[0].currentOrientation = Orientation.UP;
				connectors[1].currentOrientation = Orientation.DOWN;
            }
            else if(rotation == 90 || rotation == 270){
				connectors[0].currentOrientation = Orientation.LEFT;
				connectors[1].currentOrientation = Orientation.RIGHT;
            }			
		}
		else{
			if (rotation == 0){
				connectors[0].currentOrientation = Orientation.UP;
				connectors[1].currentOrientation = Orientation.RIGHT;
            }	
            else if(rotation == 90){
				connectors[0].currentOrientation = Orientation.RIGHT;
				connectors[1].currentOrientation = Orientation.DOWN;
            }
            else if(rotation == 180){
				connectors[0].currentOrientation = Orientation.LEFT;
				connectors[1].currentOrientation = Orientation.DOWN;
            }
            else if(rotation == 270){
                connectors[0].currentOrientation = Orientation.UP;
				connectors[1].currentOrientation = Orientation.LEFT;
            }			
		}
	}
#if UNITY_EDITOR
	private Vector3 lastMousePos;
	private bool firstClick = true;
	void OnMouseUp() {
		myCollider.size /= 2;
		if(!isMoving){
			RotatePiece();
			boardLimits.GetComponent<Board>().RemovePieceAt(transform.position);
			boardLimits.GetComponent<Board>().RemovePieceFromUsed(this);
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
				boardLimits.GetComponent<Board>().RemovePieceFromUsed(this);
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
			boardLimits.GetComponent<Board>().RemovePieceFromUsed(this);
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
		this.AdjustConnectors();
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
			board.AddPieceToUsed(this);
			return true;
		} else {
			return false;
		}
	}
}
