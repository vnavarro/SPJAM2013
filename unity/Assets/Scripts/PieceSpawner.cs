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
	
	void OnTouchBegin(Touch t){
		if (amount > 0){
			amount--;
			Piece p = Instantiate(piece,transform.position,transform.rotation) as Piece;
			p.spawner = this;
			Piece.selected = p;
			p.transform.Translate(Vector3.back*0.1f,Space.World);
			UpdateAmount();
		}
	}
#if UNITY_EDITOR
	void OnMouseDown() {
		if (amount > 0){
			amount--;
			Piece p = Instantiate(piece,transform.position,transform.rotation) as Piece;
			p.spawner = this;
			Piece.selected = p;
			p.transform.Translate(Vector3.back*0.1f,Space.World);
			UpdateAmount();
		}
	}
#endif
	public void RestorePiece(){
		amount++;
		UpdateAmount();
	}
	// Update is called once per frame
	public void UpdateAmount () {
		counter.text = string.Format("x{0:D2}",amount);
	}
}
