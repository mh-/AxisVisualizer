/**
* ...
* @author Michael Huebler
*/

class AxisBackground 
{	
	private var myClip:MovieClip;
	private var myBackground:MovieClip;
	
	public function AxisBackground(clip:MovieClip) 
	{
		clip.createEmptyMovieClip("backgroundClip", clip.getNextHighestDepth());
		myClip = clip.backgroundClip;

		myClip.attachMovie("library.AxisVisualizerBackground V4.png", "background", myClip.getNextHighestDepth());
		myBackground = myClip.background; 
		myBackground._x = (AxisVisualizer.centerX-200)*AxisVisualizer.scale;
		myBackground._y = (AxisVisualizer.centerY-220)*AxisVisualizer.scale;
		myBackground._xscale = myBackground._yscale = 64*AxisVisualizer.scale;
	}
}