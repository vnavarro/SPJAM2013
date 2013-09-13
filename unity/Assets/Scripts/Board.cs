using UnityEngine;

public class Board : MonoBehaviour {	
	
	[System.Serializable]
	public struct Tile{
		public Vector2 position;
		public bool hasBlock;
		public string name;
		public int rotation;
		public bool hasObject;
	}
	
	public float tileWidth;
	public float tileHeight;
	private const int maxTiles=5;
	private Tile[,] tiles = new Tile[maxTiles,maxTiles];
	
	// Use this for initialization
	void Start () {
		tileWidth = collider.bounds.size.x/Board.maxTiles;
		tileHeight = collider.bounds.size.y/Board.maxTiles;
		createTiles();
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void createTiles(){
		Bounds boardBounds = collider.bounds;
		for (int i = 0; i < maxTiles; i++) {
			for (int j = 0; j < maxTiles; j++) {
				tiles[i,j].position.x = boardBounds.min.x+(tileWidth*j);
				tiles[i,j].position.y = boardBounds.min.y+(tileHeight*i);
			}
		}
	}
}
