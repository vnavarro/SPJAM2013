using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Board : MonoBehaviour {	
	
	[System.Serializable]
	public class Tile{
		public Vector2 position = Vector2.zero;
		public bool hasBlock;
		public string name;
		public int rotation;
		public bool hasObject;
	}
	
	public float tileWidth;
	public float tileHeight;
	private const int maxTiles=5;
	private List<List<Tile>> tiles;
	
	// Use this for initialization
	void Start () {
		this.tiles = new List<List<Tile>>();
		this.tileWidth = (int)Mathf.Floor(this.gameObject.collider.bounds.size.x/Board.maxTiles);
		this.tileHeight = (int)Mathf.Floor(this.gameObject.collider.bounds.size.y/Board.maxTiles);
		Debug.Log("Tile width,height"+this.tileWidth+","+this.tileHeight);
		createTiles();
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void createTiles(){
		Bounds boardBounds = this.gameObject.collider.bounds;
		for (int i = 0; i < Board.maxTiles; i++) {
			List<Tile> rowTiles = new List<Tile>();
			for (int j = 0; j < Board.maxTiles; j++) {
				Tile tile = new Tile();
				tile.position.x = boardBounds.min.x+(this.tileWidth*j);
				tile.position.y = boardBounds.min.y+(this.tileHeight*i);
				Debug.Log("Tile line,column:"+i+","+j+"in pos:"+tile.position.x+","+tile.position.y);
				rowTiles.Add(tile);
			}
			this.tiles.Add(rowTiles);
		}
	}
}
