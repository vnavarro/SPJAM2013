using UnityEngine;

public enum Orientation 
{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

public class Common{

	public static Orientation GetOpposeOrientation(Orientation direction){
		if (direction == Orientation.DOWN) return Orientation.UP;
        if (direction == Orientation.UP) return Orientation.DOWN;
        if (direction == Orientation.RIGHT) return Orientation.LEFT;
        if (direction == Orientation.LEFT) return Orientation.RIGHT;
		return direction;
	}
	
}