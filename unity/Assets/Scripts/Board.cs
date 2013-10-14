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
		public bool start;
		
		public bool ContainsPiece(){
			return this.name.Contains("straight") || this.name.Contains("curve");
		}
		
		public bool ContainsPortal(){
			return this.name.Contains("portal");
		}
		
		public Vector2 NextTile(Orientation orientation){
			switch (orientation) {
				case Orientation.UP:
					return new Vector2(position.x,position.y-1);
				case Orientation.DOWN:
					return new Vector2(position.x,position.y+1);
				case Orientation.RIGHT:
					return new Vector2(position.x+1,position.y);
				case Orientation.LEFT:
					return new Vector2(position.x-1,position.y);
				default:
					return position;
			}
		}
		
		public bool HasConnectorWith(Orientation from,out Orientation connectedTo){
			foreach (PieceConnector connector in this.connectors) {
				if(from == Orientation.UP && connector.currentOrientation == Orientation.DOWN){
					connectedTo = connector.currentOrientation;
					return true;
				}
				else if(from == Orientation.DOWN && connector.currentOrientation == Orientation.UP){
					connectedTo = connector.currentOrientation;
					return true;
				}
				else if(from == Orientation.RIGHT && connector.currentOrientation == Orientation.LEFT){
					connectedTo = connector.currentOrientation;
					return true;
				}
				else if(from == Orientation.LEFT && connector.currentOrientation == Orientation.RIGHT){
					connectedTo = connector.currentOrientation;
					return true;
				}				
			}
			connectedTo = Orientation.DOWN;
			return false;
		}
		
		public List<PieceConnector> connectors;
		
		public void CreateConnectors(){
			if (!this.ContainsPiece()){
				return;
			}
			connectors = new List<PieceConnector>();
			connectors.Add(new PieceConnector(Orientation.LEFT,false));
			connectors.Add(new PieceConnector(Orientation.RIGHT,false));		
			
			this.AdjustConnectors();
		}
	
		public void AdjustConnectors(){
			if (this.name.Contains("straight")){
				if (rotation == 0 || rotation == 180){
					connectors[0].currentOrientation = Orientation.UP;
					connectors[1].currentOrientation = Orientation.DOWN;
	            }
	            else if(rotation == 90 || rotation == 270){
					connectors[0].currentOrientation = Orientation.LEFT;
					connectors[1].currentOrientation = Orientation.RIGHT;
	            }			
			}
			else if(this.name.Contains("curve")){
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
		
		
		public Orientation GetStartToOrientation(){
			int iy = (int)this.position.y;
			int jx = (int)this.position.x;
			if (this.name.Contains("straight")){
				if (rotation == 0 || rotation == 180){
					//Só pode estar no canto superior ou inferiro
					if (iy == 0){
						return Orientation.DOWN;
					}
					else{
						return Orientation.UP;
					}
	            }
	            else if(rotation == 90 || rotation == 270){
					//Só pode estar no canto esquerdo ou direito
					if(jx == 0){
						return Orientation.RIGHT;
					}
					else {
						return Orientation.LEFT;
					}
	            }			
			}
			else if(this.name.Contains("curve")){
				if (rotation == 0){
					//Só pode estar no canto superior ou direito
					if(iy == 0){
						return Orientation.RIGHT;
					}
					else{
						return Orientation.UP;
					}					
	            }	
	            else if(rotation == 90){
					//Só pode estar no canto inferior ou direito
					if(jx == 0){
						return Orientation.DOWN;
					}
					else{
						return Orientation.RIGHT;
					}
	            }
	            else if(rotation == 180){
					//Só pode estar no canto inferior ou esquerdo
					if(iy == 0){
						return Orientation.DOWN;
					}
					else{
						return Orientation.LEFT;
					}
	            }
	            else if(rotation == 270){
					//Só pode estar no canto superiro ou esquerdo
					if(jx == 0){
						return Orientation.LEFT;
					}
					else{
						return Orientation.UP;
					}
	            }			
			}
			Debug.LogWarning("Should not have entered on else in GetStartToOrientation!");
			return Orientation.UP;
		}
		
		public Orientation GetRemainingConnector(Orientation from){
			if(this.connectors[0].currentOrientation == from){
				return this.connectors[1].currentOrientation;
			}else{
				return this.connectors[0].currentOrientation;
			}
		}
	}
	public float tileWidth;
	public float tileHeight;
	public TextAsset levelsData;
	public GameObject powerCurvePrefab;
	public GameObject downCurvePrefab;
	public GameObject powerStraightPrefab;
	public GameObject downStraightPrefab;
	public GameObject portalPrefab;
	public GameObject stonePrefab;
	
	
	private const int maxTiles=5;
	[SerializeField]
	private List<List<Tile>> tiles;
	private JSONObject levels;
	//private string solution = "";
	private PieceSpawner powerCurveSpawner, downCurveSpawner, powerStraightSpawner, downStraightSpawner;
	private ChangeBG bg;
	private Vector2 initialPathTile;
	// Use this for initialization
	void Start () {
		bg = FindObjectOfType(typeof(ChangeBG)) as ChangeBG;
		powerCurveSpawner = GameObject.Find("PowerCurve").GetComponent<PieceSpawner>();
		downCurveSpawner = GameObject.Find("DownCurve").GetComponent<PieceSpawner>();
		powerStraightSpawner = GameObject.Find("PowerStraight").GetComponent<PieceSpawner>();
		downStraightSpawner = GameObject.Find("DownStraight").GetComponent<PieceSpawner>();
		levels = new JSONObject(levelsData.text);
		//accessData(j);
		this.tiles = new List<List<Tile>>();
		this.tileWidth = collider.bounds.size.x/maxTiles;
		this.tileHeight = collider.bounds.size.y/maxTiles;
		Debug.Log("Tile width,height"+this.tileWidth+","+this.tileHeight);
		//change bg if needed
		if (levels["levels"]["level"+GameSettings.Instance.levelNumber]["bgImg"].str == "bad") {
			bg.ToBad(true);
		} else {
			bg.ToGood(true);
		}
		//solution = levels["levels"]["level"+GameSettings.Instance.levelNumber]["solution"].str;
		List<JSONObject> jsonPieces = levels["levels"]["level"+GameSettings.Instance.levelNumber]["pieces"].list;
		foreach(JSONObject pieceInfo in jsonPieces){
			switch(pieceInfo["name"].str){
				case "powercurve":
					powerCurveSpawner.amount = (int)pieceInfo["count"].n;
					powerCurveSpawner.UpdateAmount();
					break;
				case "downcurve":
					downCurveSpawner.amount = (int)pieceInfo["count"].n;
					downCurveSpawner.UpdateAmount();
					break;
				case "powerstraight":
					powerStraightSpawner.amount = (int)pieceInfo["count"].n;
					powerStraightSpawner.UpdateAmount();
					break;
				case "downstraight":
					downStraightSpawner.amount = (int)pieceInfo["count"].n;
					downStraightSpawner.UpdateAmount();
					break;
			}
		}
		createTiles();
		PopulateBoard();
	}
	
	// Update is called once per frame
	void Update () {
		if(this.pathFind()){
			Debug.Log("YAY FUNFA!");
		}
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
				tile.start = currentLevelData[i][j]["start"];
				if(tile.start){
					this.initialPathTile = new Vector2(j,i);
				}
				
				if (tile.hasObject) {
					tile.hasBlock = currentLevelData[i][j]["tileType"].str == "block";
					if (tile.hasBlock) {
						tile.name = currentLevelData[i][j]["name"].str;
						tile.rotation = (int)currentLevelData[i][j]["rotation"].n;
					} else {
						tile.name = currentLevelData[i][j]["tileType"].str;
						tile.rotation = 0;
					}
				} else {
					tile.name = "";
					tile.rotation = 0;
					tile.hasBlock = false;
				}
				tile.CreateConnectors();
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
					case "portal":
						Instantiate(portalPrefab,new Vector3(tiles[i][j].position.x + tileWidth/2,tiles[i][j].position.y - tileHeight/2,-5f),Quaternion.identity);
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
		t.AdjustConnectors();
		if(t.name.Contains("Down")){
			bg.ToBad();
		}
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
	
	bool pathFind(){
		Tile startTile = tiles[(int)this.initialPathTile.y][(int)this.initialPathTile.x];
		Orientation startOrientation = startTile.GetStartToOrientation();
		Vector2 nextTilePosition = startTile.NextTile(startOrientation);
		return pathFind(nextTilePosition,startTile.GetStartToOrientation());
	}
	
	bool pathFind(Vector2 position,Orientation from){
		Tile tile = tiles[(int)position.y][(int)position.x];
		if(!tile.ContainsPiece()){
			return false;
		}
		if(tile.ContainsPortal()){
			return true;
		}
		Orientation connectedTo;		
		if(tile.HasConnectorWith(from,out connectedTo)){
			return false;
		}
		Orientation remainingOrientation = tile.GetRemainingConnector(connectedTo);
		return pathFind(tile.NextTile(remainingOrientation),remainingOrientation);
			
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
