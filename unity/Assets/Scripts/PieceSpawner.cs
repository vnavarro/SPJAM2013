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
		counter.text = string.Format("x{0:D2}",amount);
		Piece.boardLimits = GameObject.Find("BoardLimits");
	}
	
	void OnTouchBegin(Touch t){
		if (amount > 0){
			amount--;
			Piece p = Instantiate(piece,transform.position,transform.rotation) as Piece;
			p.spawner = this;
			Piece.selected = p;
			p.transform.Translate(Vector3.back*0.1f,Space.World);
			counter.text = string.Format("x{0:D2}",amount);
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
			counter.text = string.Format("x{0:D2}",amount);
		}
	}
#endif
	public void RestorePiece(){
		amount++;
		counter.text = string.Format("x{0:D2}",amount);
	}
	// Update is called once per frame
	void Update () {
	
	}
}
