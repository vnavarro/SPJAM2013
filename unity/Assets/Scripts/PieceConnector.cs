using UnityEngine;


public class PieceConnector {	
	public Orientation currentOrientation = Orientation.UP;
	public bool isOn = false;
	
	public PieceConnector(Orientation newOrientation,bool turnOn){
		this.isOn = turnOn;
		this.currentOrientation = newOrientation;
	}
}
