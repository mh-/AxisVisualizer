/**
* ...
* @author Michael Huebler
*/

class AxisGateTestingPiece 
{
	private var myTestingPiece:MovieClip;
	
	public function AxisGateTestingPiece(Clip:MovieClip, newCenterX:Number, newCenterY:Number)
	{
		//Clip.attachMovie("library.Testing Piece.png", "TestingPiece", Clip.getNextHighestDepth());
		Clip.attachMovie("library.Gate Tester.png", "TestingPiece", Clip.getNextHighestDepth());
		myTestingPiece = Clip.TestingPiece;
		myTestingPiece._xscale = myTestingPiece._yscale = AxisVisualizer.diskScale * AxisVisualizer.scale;
		myTestingPiece._x = newCenterX * AxisVisualizer.scale;
		myTestingPiece._y = newCenterY * AxisVisualizer.scale;
	}
	
	
}