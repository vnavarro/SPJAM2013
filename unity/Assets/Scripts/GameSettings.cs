/*****************************************************
*                                                    *
* Singleton class, used to manage game aspects       *
*                                                    *
* There should be only one GameObject in scene, that *
* will be automatically generated whenever needed.   *
*                                                    *
* Every game status and static configuration should  *
* be here.                                           *
*                                                    *
*****************************************************/

using UnityEngine;

// TODO: Convert to a static class?

public class GameSettings : MonoBehaviour {
	
	/*width and height reference numbers.
	  To make auto scale works using 
	  hi-res images
	*/
	public int widthRef = 960;
	public int heightRef = 640;
	
	
	private static GameSettings _instance = null;
	public static GameSettings Instance
	{
		get{
			if (_instance == null){
				_instance = FindObjectOfType(typeof(GameSettings)) as GameSettings;
				if (_instance == null) {
					GameObject settings = new GameObject("Game Settings");
					settings.AddComponent<GameSettings>();
					DontDestroyOnLoad(settings);
					_instance = FindObjectOfType(typeof(GameSettings)) as GameSettings;
				}
			}
			return _instance;
		}
	}
}
