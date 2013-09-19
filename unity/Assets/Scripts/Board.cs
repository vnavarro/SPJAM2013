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
	public TextAsset levelsData;
	public GameObject powerCurvePrefab;
	public GameObject powerStraightPrefab;
	public GameObject downCurvePrefab;
	public GameObject downStraightPrefab;
	public GameObject goodPortalPrefab;
	public GameObject badPortalPrefab;
	public GameObject stonePrefab;
	
	
	private const int maxTiles=5;
	[SerializeField]
	private List<List<Tile>> tiles;
	private JSONObject levels;
	
	// Use this for initialization
	void Start () {
		
		levels = new JSONObject(levelsData.text);
		//accessData(j);
		this.tiles = new List<List<Tile>>();
		this.tileWidth = collider.bounds.size.x/maxTiles;
		this.tileHeight = collider.bounds.size.y/maxTiles;
		Debug.Log("Tile width,height"+this.tileWidth+","+this.tileHeight);
		createTiles();
		PopulateBoard();
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	
	void createTiles(){
		Bounds boardBounds = collider.bounds;
		JSONObject currentLevelData = levels["levels"]["level"+GameSettings.Instance.levelNumber]["board"];
		for (int i = 0; i < maxTiles; i++) {
			List<Tile> rowTiles = new List<Tile>();
			for (int j = 0; j < maxTiles; j++) {
				Tile tile = new Tile();
				tile.position.x = boardBounds.min.x+(this.tileWidth*j);
				tile.position.y = boardBounds.max.y-(this.tileHeight*i);
				
				tile.hasObject = currentLevelData[i][j]["tileType"].str != "";
				if (tile.hasObject) {
					tile.hasBlock = currentLevelData[i][j]["tileType"].str == "block";
					if (tile.hasBlock) {
						tile.name = currentLevelData[i][j]["name"].str;
						tile.rotation = (int)currentLevelData[i][j]["rotation"].n;
					} else {
						if(currentLevelData[i][j]["tileType"].str == "portal"){
							tile.name = currentLevelData[i][j]["name"].str + currentLevelData[i][j]["tileType"].str;
						} else {
							tile.name = currentLevelData[i][j]["tileType"].str;
						}
						tile.rotation = 0;
					}
				} else {
					tile.name = "";
					tile.rotation = 0;
					tile.hasBlock = false;
				}
				Debug.Log("===Tile line "+i+",column "+j+" in pos:"+tile.position.x+","+tile.position.y);
				Debug.Log("name: " + tile.name);
				Debug.Log("has object: " + tile.hasObject);
				Debug.Log("rotation: " + tile.rotation);
				Debug.Log("has block: " + tile.hasBlock);
				
				rowTiles.Add(tile);
			}
			tiles.Add(rowTiles);
		}
	}
	
	void PopulateBoard(){
		for (int i = 0; i < maxTiles; i++) {
			for (int j = 0; j < maxTiles; j++) {
				if (!tiles[i][j].hasObject) continue;
				switch(tiles[i][j].name){
				case "stone":
					Instantiate(stonePrefab,new Vector3(tiles[i][j].position.x + tileWidth/2,tiles[i][j].position.y - tileHeight/2,-5f),Quaternion.identity);
					break;
				case "powercurve":
					Instantiate(powerCurvePrefab,new Vector3(tiles[i][j].position.x + tileWidth/2,tiles[i][j].position.y - tileHeight/2,-5f),Quaternion.AngleAxis(tiles[i][j].rotation,Vector3.forward));
					break;
				case "powerstraight":
					Instantiate(powerStraightPrefab,new Vector3(tiles[i][j].position.x + tileWidth/2,tiles[i][j].position.y - tileHeight/2,-5f),Quaternion.AngleAxis(tiles[i][j].rotation,Vector3.forward));
					break;
				case "downcurve":
					Instantiate(downCurvePrefab,new Vector3(tiles[i][j].position.x + tileWidth/2,tiles[i][j].position.y - tileHeight/2,-5f),Quaternion.AngleAxis(tiles[i][j].rotation,Vector3.forward));
					break;
				case "downstraight":
					Instantiate(downStraightPrefab,new Vector3(tiles[i][j].position.x + tileWidth/2,tiles[i][j].position.y - tileHeight/2,-5f),Quaternion.AngleAxis(tiles[i][j].rotation,Vector3.forward));
					break;
				case "goodportal":
					Instantiate(goodPortalPrefab,new Vector3(tiles[i][j].position.x + tileWidth/2,tiles[i][j].position.y - tileHeight/2,-5f),Quaternion.identity);
					break;
				case "badportal":
					Instantiate(badPortalPrefab,new Vector3(tiles[i][j].position.x + tileWidth/2,tiles[i][j].position.y - tileHeight/2,-5f),Quaternion.identity);
					break;
				}
			}
		}
	}
	
	public bool HavePieceAt(Vector3 position) {
		Tile t = GetTileAt(position);
		if(t != null){
			return t.hasObject && !t.name.Contains("portal");
		} else {
			return false;
		}
	}
	
	
	public void PutPieceAt(Vector3 position, string name, float rotation){
		Tile t = GetTileAt(position);
		t.hasObject = true;
		t.hasBlock = true;
		t.name = name;
		t.rotation = (int)rotation;
	}
	
	public void RemovePieceAt(Vector3 position){
		Tile t = GetTileAt(position);
		t.hasObject = false;
		t.hasBlock = false;
		t.name = "";
		t.rotation = 0;
	}
	
	Tile GetTileAt(Vector3 position) {
		Bounds boardBounds = collider.bounds;
		for (int i = 0; i < maxTiles; i++) {
			for (int j = 0; j < maxTiles; j++) {
				if ((int)((position.x - boardBounds.min.x)/tileWidth) == j){
					if ((int)((boardBounds.max.y - position.y)/tileWidth) == i){
						return tiles[i][j];
					}
				}
			}
		}
		return null;
	}
	
	// test function (can be removed later)
	void accessData(JSONObject obj){
		switch(obj.type){
			case JSONObject.Type.OBJECT:
				for(int i = 0; i < obj.list.Count; i++){
					string key = (string)obj.keys[i];
					JSONObject j = (JSONObject)obj.list[i];
					Debug.Log(key);
					accessData(j);
				}
				break;
			case JSONObject.Type.ARRAY:
				foreach(JSONObject j in obj.list){
					accessData(j);
				}
				break;
			case JSONObject.Type.STRING:
				Debug.Log(obj.str);
				break;
			case JSONObject.Type.NUMBER:
				Debug.Log(obj.n);
				break;
			case JSONObject.Type.BOOL:
				Debug.Log(obj.b);
				break;
			case JSONObject.Type.NULL:
				Debug.Log("NULL");
				break;
			
		}
	}
	
}
