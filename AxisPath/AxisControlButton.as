/**
* ...
* @author Michael Huebler
*/

class AxisControlButton 
{
	private static var fillType:String = "linear";
	private static var colors:Array = [0xFAD4DB, 0xEC748B, 0xC13A59, 0xA81230];
	private static var alphas:Array = [100, 100, 100, 100];
	private static var ratios:Array = [0, 126, 127, 255];
	private static var matrix:Object = {matrixType:"box", x:0, y:0, w:80, h:30, r:90/180*Math.PI};
	
	private var myButton:MovieClip;
	
	public function AxisControlButton(ButtonUniqueNumber:Number, Clip:MovieClip, x:Number, y:Number, Text:String, Action:Function) 
	{
		var myFormat:TextFormat = new TextFormat();
		myFormat.align = "center";
		myFormat.font = "library.kroe0656.ttf";
		myFormat.size = 13;
		myFormat.color = 0xFFFFFF;
		
		Clip.createEmptyMovieClip("myButton" + ButtonUniqueNumber, Clip.getNextHighestDepth());
		
		switch (ButtonUniqueNumber)
		{
			case 1: myButton = Clip.myButton1; break;
			case 2: myButton = Clip.myButton2; break;
			case 3: myButton = Clip.myButton3; break;
			case 4: myButton = Clip.myButton4; break;
			case 5: myButton = Clip.myButton5; break;
			case 6: myButton = Clip.myButton6; break;
			case 7: myButton = Clip.myButton7; break;
			case 8: myButton = Clip.myButton8; break;
			case 9: myButton = Clip.myButton9; break;
			case 10: myButton = Clip.myButton10; break;
		}
				
		myButton.createEmptyMovieClip("buttonBkg", myButton.getNextHighestDepth());
		myButton._x = x;
		myButton._y = y;
		myButton.buttonBkg.lineStyle(0, 0x820F26, 60, true, "none", "square", "round");
		myButton.buttonBkg.beginGradientFill(fillType, colors, alphas, ratios, matrix);myButton.buttonBkg.lineTo(120, 0);
		myButton.buttonBkg.lineTo(120, 30);
		myButton.buttonBkg.lineTo(0, 30);
		myButton.buttonBkg.lineTo(0, 0);
		myButton.buttonBkg.endFill();
		
		myButton.createTextField("labelText", myButton.getNextHighestDepth(), 0, 5, myButton._width, 24);
		myButton.labelText.text = Text;
		
		myButton.labelText.embedFonts = true;
		myButton.labelText.selectable = false;
		myButton.labelText.antiAliasType = "advanced";
		myButton.labelText.setTextFormat(myFormat);
		
		myButton.onRelease = Action;
		/*
		myButton.onRelease = function() {
			getURL("http://www.google.com");
		}
		*/
	}
	
}

		/*	
		var ButtonUp = new AxisControlButton(1, myStage, 0, 330, "Up", function () {
				 if (CurrentMovement == AxisDisk.MOVE_UNAFFECTED)
				 {
					 CurrentMovement = AxisDisk.MOVE_UP;
				 }
			});
		var ButtonDown = new AxisControlButton(2, myStage, 0, 370, "Down", function () {
				 if (CurrentMovement == AxisDisk.MOVE_UNAFFECTED)
				 {
					 CurrentMovement = AxisDisk.MOVE_DOWN;
				 }
			});
		var ButtonLeft = new AxisControlButton(3, myStage, 150, 330, "Left", function () {
				 if (CurrentMovement == AxisDisk.MOVE_UNAFFECTED)
				 {
					 CurrentMovement = AxisDisk.MOVE_LEFT;
				 }
			});
		var ButtonRight = new AxisControlButton(4, myStage, 150, 370, "Right", function () {
				 if (CurrentMovement == AxisDisk.MOVE_UNAFFECTED)
				 {
					 CurrentMovement = AxisDisk.MOVE_RIGHT;
				 }
			});
		*/