/**********************************************************************************
* Sprite animation using SpriteSheet                                              *
* Based on (http://wiki.unity3d.com/index.php/Animating_Tiled_texture_-_Extended) *
*                                                                                 *
* To work better with it, set everything, right-click and select "Create Mesh".   *
* It will create a quad mesh that fits one animation frame.                       *
**********************************************************************************/

using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
public class AnimatedSpriteSheet : MonoBehaviour
{
 
	//vars for the whole sheet
	public int colCount = 4;
	public int rowCount = 4;
 
	//vars for animation
	public int rowNumber  =  0; //Zero Indexed
	public int colNumber = 0; //Zero Indexed
	public int totalCells = 4;
	public int fps = 10;
	
  	// current frame offset
    private Vector2 offset;
	
	// cell size (UV values)
	private Vector2 size;
	
	[ContextMenu("Create mesh")]
	void CreateQuad(){
		Start();Update();
	}
	
	void Start () {
		float screenWidth = GameSettings.Instance.widthRef;
		float screenHeight = GameSettings.Instance.heightRef;
		
		float textureWidth = renderer.sharedMaterial.mainTexture.width;
		float textureHeight = renderer.sharedMaterial.mainTexture.height;
	
	
		// create mesh to hold sprite
		size =  new Vector2(1.0f / colCount,1.0f / rowCount);
		Mesh m = new Mesh();
		GetComponent<MeshFilter>().mesh = m;
		Vector3[] vert = new Vector3[4];
		Vector3[] norm = new Vector3[4];
		Vector2[] uv   = new Vector2[4];
		int[] tri = new int[6]{0,2,1,
							   2,3,1};
		//Vector3[] vert = m.vertices;
		
		float totalHeight = Camera.main.orthographicSize*2;
		float totalWidth = totalHeight * screenWidth/screenHeight;
		
		vert[0] = new Vector2(-(Scale(0, screenWidth, textureWidth/colCount, 0, totalWidth))/2,-(Scale(0, screenHeight, textureHeight/rowCount, 0, totalHeight))/2);
		vert[1] = new Vector2((Scale(0, screenWidth, textureWidth/colCount, 0, totalWidth))/2,-(Scale(0, screenHeight, textureHeight/rowCount, 0, totalHeight))/2);
		vert[2] = new Vector2(-(Scale(0, screenWidth, textureWidth/colCount, 0, totalWidth))/2,(Scale(0, screenHeight, textureHeight/rowCount, 0, totalHeight))/2);
		vert[3] = new Vector2((Scale(0, screenWidth, textureWidth/colCount, 0, totalWidth))/2,(Scale(0, screenHeight, textureHeight/rowCount, 0, totalHeight))/2);
		
		
		norm[0] = 
		norm[1] =
		norm[2] =
		norm[3] = -Vector3.forward;
		
		uv[0] = new Vector2(0,0);
		uv[1] = new Vector2(1,0);
		uv[2] = new Vector2(0,1);
		uv[3] = new Vector2(1,1);
		
		m.vertices = vert;
		m.normals = norm;
		m.uv = uv;
		m.triangles = tri;
		m.name = "spriteQuad";
		renderer.sharedMaterial.SetTextureScale  ("_MainTex", size);
	}
	//Update
	void Update() {
	    // Calculate index
	    int index  = (int)(Time.time * fps);
	    // Repeat when exhausting all cells
	    index = index % totalCells;
	 	
	    // split into horizontal and vertical index
	    var uIndex = index % colCount;
	    var vIndex = index / colCount;
	 
	    // build offset
	    // v coordinate is the bottom of the image in opengl so we need to invert.
	    offset.x = (uIndex+colNumber) * size.x;
	    offset.y = (1.0f - size.y) - (vIndex + rowNumber) * size.y;
	    
		renderer.sharedMaterial.SetTextureOffset ("_MainTex", offset);
	    renderer.sharedMaterial.SetTextureScale  ("_MainTex", size);
	}
	
	float Scale(float srcFloor, float srcCeil, float srcVal, float dstFloor, float dstCeil) {
		return (dstCeil-dstFloor)*(srcVal-srcFloor)/(srcCeil-srcFloor) + dstFloor;
	}
	
}