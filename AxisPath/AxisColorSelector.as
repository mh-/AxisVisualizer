/**
* ...
* @author Michael Huebler
*/

class AxisColorSelector 
{
	public var currentColor;
	public var currentDisk;
	
	private var myColorSelector:MovieClip;

	public var centerX:Number;
	public var centerY:Number;
	public var positionX:Number = 61;
	public var positionY:Number = 61;
	public var distanceX1:Number = 76;
	public var distanceY1:Number = 192;
	public var distanceX2:Number = 198;
	public var distanceY2:Number = 72;
	private var x:Number;
	private var y:Number;

	private var WIDTH = 17;
	private var HEIGHT = 17;
	
	private var COLOR_SELECTION = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF];
	private var NUM_COLORS = 6;
	private var currentColorIndex = 0;

	public function AxisColorSelector(clip:MovieClip, disk:Number) 
	{
		clip.createEmptyMovieClip("colorSelector", clip.getNextHighestDepth());
		myColorSelector = clip.colorSelector;
		
		currentColor = COLOR_SELECTION[currentColorIndex];
		currentDisk = disk;
		Draw();
	}
	
	private function Draw(Void):Void
	{ 
		centerX = AxisVisualizer.centerX + positionX;
		centerY = AxisVisualizer.centerY + positionY;
		
		switch (currentDisk) 
		{
			case AxisDisk.DISK_TOP: 
				x = centerX - distanceX1;
				y = centerY - distanceY1;
				break;
			case AxisDisk.DISK_LEFT: 
				x = centerX - distanceX2;
				y = centerY - distanceY2;
				break;
			case AxisDisk.DISK_BOTTOM: 
				x = centerX - distanceX1;
				y = centerY + distanceY1;
				break;
			case AxisDisk.DISK_RIGHT: 
				x = centerX + distanceX2;
				y = centerY - distanceY2;
				break;
		}

		myColorSelector._x = x * AxisVisualizer.scale;
		myColorSelector._y = y * AxisVisualizer.scale;
		
		myColorSelector.clear();
		myColorSelector.lineStyle (0, 0x000000, 100);
		myColorSelector.beginFill(currentColor, 100);
		myColorSelector.lineTo(WIDTH*AxisVisualizer.scale, 0);
		myColorSelector.lineTo(WIDTH*AxisVisualizer.scale, HEIGHT*AxisVisualizer.scale);
		myColorSelector.lineTo(0, HEIGHT*AxisVisualizer.scale);
		myColorSelector.lineTo(0, 0);
		myColorSelector.endFill();
	}
	
	public function ChangeColor(Void):Void
	{
		currentColorIndex += 1;
		if (currentColorIndex > NUM_COLORS - 1)
			{currentColorIndex = 0};
		currentColor = COLOR_SELECTION[currentColorIndex];
		Draw();
	}

	public function MoveTo(disk:Number):Void
	{
		currentDisk = disk;
		Draw();
	}
	
}