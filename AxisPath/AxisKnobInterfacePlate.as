/**
* ...
* @author Michael Huebler
*/

class AxisKnobInterfacePlate 
{
	public static var MAX_ABSOLUTE_MOVEMENT:Number = 53;
	public static var MAX_INDEX:Number = 50;
	
	private var myKnobInterfacePlate:MovieClip

	private var CenterX:Number;
	private var CenterY:Number;
	
	private var x:Number
	private var y:Number
	
	public function AxisKnobInterfacePlate(Clip:MovieClip, newCenterX:Number, newCenterY:Number) 
	{
		MAX_ABSOLUTE_MOVEMENT = MAX_ABSOLUTE_MOVEMENT * AxisVisualizer.scale;
		CenterX = newCenterX * AxisVisualizer.scale;
		CenterY = newCenterY * AxisVisualizer.scale;
		Clip.attachMovie("library.Knob Interface Plate 2.png", "KnobInterfacePlate", Clip.getNextHighestDepth());
		myKnobInterfacePlate = Clip.KnobInterfacePlate;
		myKnobInterfacePlate._xscale = myKnobInterfacePlate._yscale = AxisVisualizer.diskScale * AxisVisualizer.scale;
		Reset();
	}
	
	public function MoveToAbsoluteIndex(newX:Number, newY:Number):Void
	{
		MoveToAbsolutePosition(newX * MAX_ABSOLUTE_MOVEMENT/MAX_INDEX, newY*MAX_ABSOLUTE_MOVEMENT/MAX_INDEX);
	}
	
	private function MoveToAbsolutePosition(newX:Number, newY:Number):Void
	{
		x = newX;
		y = newY;
		Draw();
	}

	public function Reset(Void):Void
	{
		MoveToAbsolutePosition(0, 0);
	}

	public function Draw(Void):Void
	{
		myKnobInterfacePlate._x = CenterX + x;
		myKnobInterfacePlate._y = CenterY + y;
	}
	
}