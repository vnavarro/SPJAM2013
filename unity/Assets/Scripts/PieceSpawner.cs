using UnityEngine;

[RequireComponent(typeof(GestureControl))]
public class PieceSpawner : MonoBehaviour {
	public Piece piece;
	public int amount;
	
	private GestureControl touchControl;
	private TextMesh counter;
	
	void Start () {
		touchControl = gameObject.GetComponent<GestureControl>();
		touchControl.onTouchBegin += OnTouchBegin;
		counter = transform.GetChild(0).GetComponent<TextMesh>();
		UpdateAmount();
		Piece.boardLimits = GameObject.Find("BoardLimits");
	}

	public void SpawnPiece() {
		if (amount > 0){
			amount--;
			Piece p = Instantiate(piece,transform.position,transform.rotation) as Piece;
			p.spawner = this;
			Piece.selected = p;			
			p.transform.Translate(Vector3.back*0.1f,Space.World);
		}
	}
	
	void OnTouchBegin(Touch t){
		UpdateAmount();
		SpawnPiece();		
	}
#if UNITY_EDITOR
	void OnMouseDown() {
		UpdateAmount();
		SpawnPiece();		
	}
#endif
	public void RestorePiece(){
		amount++;
		UpdateAmount();
		SpawnPiece();
	}
	// Update is called once per frame
	public void UpdateAmount () {
		counter.text = string.Format("x{0:D2}",amount);
	}
}
