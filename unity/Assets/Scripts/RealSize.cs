/************************************************
* Utility class, used to adjust sprite quad.    *
*                                               *
* Just add it on sprites you will use,          *
* right-click and select "Adjust Sprite".       *
* It will set a quad that fits the texture.     *
* (use it only after set the object's material) *
************************************************/

using UnityEngine;

public class RealSize : MonoBehaviour {
	
	[ContextMenu("Adjust Sprite")]
	void Adjust (){
		Awake();
	}
	
	void Awake () {
		float screenWidth = GameSettings.Instance.widthRef;
		float screenHeight = GameSettings.Instance.heightRef;
		float textureWidth = GetComponent<Renderer>().sharedMaterial.mainTexture.width;
		float textureHeight = GetComponent<Renderer>().sharedMaterial.mainTexture.height;
	
		// create mesh to hold sprite
		Mesh m = new Mesh();
		GetComponent<MeshFilter>().mesh = m;
		Vector3[] vert = new Vector3[4];
		Vector3[] norm = new Vector3[4];
		Vector2[] uv   = new Vector2[4];
		int[] tri = new int[6]{0,2,1,
							   2,3,1};
		
		float totalHeight = Camera.main.orthographicSize*2;
		float totalWidth = totalHeight * screenWidth/screenHeight;
		
		vert[0] = new Vector2(-(Scale(0, screenWidth, textureWidth, 0, totalWidth))/2,-(Scale(0, screenHeight, textureHeight, 0, totalHeight))/2);
		vert[1] = new Vector2((Scale(0, screenWidth, textureWidth, 0, totalWidth))/2,-(Scale(0, screenHeight, textureHeight, 0, totalHeight))/2);
		vert[2] = new Vector2(-(Scale(0, screenWidth, textureWidth, 0, totalWidth))/2,(Scale(0, screenHeight, textureHeight, 0, totalHeight))/2);
		vert[3] = new Vector2((Scale(0, screenWidth, textureWidth, 0, totalWidth))/2,(Scale(0, screenHeight, textureHeight, 0, totalHeight))/2);
		
		
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
		
	}
	
	float Scale(float srcFloor, float srcCeil, float srcVal, float dstFloor, float dstCeil) {
		return (dstCeil-dstFloor)*(srcVal-srcFloor)/(srcCeil-srcFloor) + dstFloor;
	}
}
