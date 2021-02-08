/**
* ...
* @author Michael Huebler
*/

class AxisDisk 
{
	public static var MOVE_UP = 1;
	public static var MOVE_LEFT = 2;
	public static var MOVE_DOWN = 3;
	public static var MOVE_RIGHT = 4;
	public static var MOVE_UNAFFECTED = 0;
		
	public static var DISK_TOP = 1;
	public static var DISK_LEFT = 2;
	public static var DISK_BOTTOM = 3;
	public static var DISK_RIGHT = 4;

	public var centerX:Number;
	public var centerY:Number;
	public var distanceX:Number = 120;
	public var distanceY:Number = 120;
	public var scale:Number;
	public var radius:Number;
	
	private var internalDiskNumber:Number;
	private var x:Number;
	private var y:Number;
	private var labelX:Number;
	private var labelY:Number;
	
	private var myClip:MovieClip;
	private var myDisk:MovieClip;
	private var myGate:MovieClip;
	private var myMarkers:Array;
	private var myFormat:TextFormat;
	private var myLabel:TextField;
	
	private var index:AxisIndex;
	private var gateIndex:AxisIndex;
	private var markerIndices:Array;
	private var numMarkers:Number;
	
	private var startAngle:Number;
	private var offsetAngle:Number;
	private var	singleStepAngle:Number
	
	// private var lastAngle1:Number = null;
	// private var lastAngle2:Number = null;
	// private var lastAngle3:Number = null;
	// private var lastIndex:AxisIndex;
	
	private var i:Number;
		
	public function AxisDisk(clip:MovieClip, diskStartAngle:Number, diskUniqueNumber:Number) 
	{
		scale = AxisVisualizer.diskScale * AxisVisualizer.scale;
		radius = 137 * scale / 100;
		centerX = AxisVisualizer.centerX * AxisVisualizer.scale;
		centerY = AxisVisualizer.centerY * AxisVisualizer.scale;
		distanceX = distanceX * AxisVisualizer.scale;
		distanceY = distanceY * AxisVisualizer.scale;
		
		
		index = new AxisIndex();
		// lastIndex = new AxisIndex();
		gateIndex = new AxisIndex();
		startAngle = diskStartAngle;
		internalDiskNumber = diskUniqueNumber;
		Reset();
		
		myMarkers = new Array();
		markerIndices = new Array();
		numMarkers = 0;
		
		clip.createEmptyMovieClip("diskClip"+internalDiskNumber, clip.getNextHighestDepth());
		myClip = clip["diskClip"+internalDiskNumber];

		myClip.attachMovie("library.New Disk 2.png", "disk", myClip.getNextHighestDepth());
		myDisk = myClip.disk; 
		myClip.createEmptyMovieClip("gate", myClip.getNextHighestDepth());
		myGate = myClip.gate;

		switch (internalDiskNumber) 
		{
			case DISK_TOP: 
				x = centerX;
				y = centerY - distanceY;
				labelX = x;
				labelY = y-(10 * AxisVisualizer.scale);
				break;
			case DISK_LEFT: 
				x = centerX - distanceX;
				y = centerY;
				labelX = x;
				labelY = y-(10 * AxisVisualizer.scale);
				break;
			case DISK_BOTTOM: 
				x = centerX;
				y = centerY + distanceY;
				labelX = x;
				labelY = y+(135 * AxisVisualizer.scale);
				break;
			case DISK_RIGHT: 
				x = centerX + distanceX;
				y = centerY;
				labelX = x+(100 * AxisVisualizer.scale);
				labelY = y-(10 * AxisVisualizer.scale);
				break;
		}
		myDisk._xscale = myDisk._yscale = scale;
		
		// Draw gate
		
		// center point and radius of circle that represent the gate:
		//var gr:Number = 5 *AxisVisualizer.scale; // filled circle
		var gr:Number = 10 *AxisVisualizer.scale; // empty circle
		//var gx:Number = 0.97*radius;
		//var gy:Number = -0.17*radius;
		var gx:Number = 0;
		var gy:Number = -1*radius;
		// constant used in calculation
		var A:Number = Math.tan(22.5 * Math.PI/180);
		// variables for each of 8 segments
		var endx:Number;
		var endy:Number;
		var cx:Number;
		var cy:Number;
	
		myGate.moveTo(gx + gr, gy);
		//myGate.beginFill(0x0000cc, 50); // filled circle
		myGate.lineStyle(2, 0x0000cc, 50); // empty circle
		for (var drawingangle:Number = 45; drawingangle <= 360; drawingangle += 45) 
		{
			// endpoint
			endx = gr*Math.cos(drawingangle*Math.PI/180);
			endy = gr*Math.sin(drawingangle*Math.PI/180);
			// control:
			// (drawingangle-90 is used to give the correct sign)
			cx =endx + gr* A *Math.cos((drawingangle-90)*Math.PI/180);
			cy =endy + gr* A *Math.sin((drawingangle-90)*Math.PI/180);
			myGate.curveTo(cx+gx, cy+gy, endx+gx, endy+gy);
		}
		//myGate.endFill(); // filled circle
		myGate._x = x + radius;
		myGate._y = y + radius;
		
		
		// Draw index
		
		myFormat = new TextFormat();
		myFormat.align = "center";
		myFormat.font = "library.Forgotte.ttf";
		myFormat.size = 16 * AxisVisualizer.scale;
		myFormat.color = 0x000000;
			
		myClip.createTextField("indexText", myClip.getNextHighestDepth(), labelX, labelY, 40 * AxisVisualizer.scale, 24 * AxisVisualizer.scale);
		myLabel = myClip.indexText;
		
		myLabel.embedFonts = true;
		myLabel.selectable = false;
		myLabel.antiAliasType = "advanced";
		
		Draw();
	}
	
	public function Reset(Void):Void
	{
		index.N = 0;
		index.M = 0;
		// lastAngle1 = null;
		Index2Angle ();
	}
	
	public function Draw(Void):Void
	{
		// trace ("Draw");
		myDisk._rotation = -startAngle-offsetAngle-singleStepAngle;
		myDisk._x = x - Math.SQRT2 * radius * Math.cos((-startAngle-offsetAngle-singleStepAngle + 45)*Math.PI/180) + radius;
		myDisk._y = y - Math.SQRT2 * radius * Math.sin(( -startAngle - offsetAngle - singleStepAngle + 45) * Math.PI / 180) + radius; 
		
		myGate._rotation = -startAngle-offsetAngle-singleStepAngle + (72 * gateIndex.N + 24 * gateIndex.M);
				
		for (i = 0; i < numMarkers; i++)
		{
			if (myMarkers[i] != undefined)
			{
				myMarkers[i]._rotation = -startAngle-offsetAngle-singleStepAngle + (72 * markerIndices[i].N + 24 * markerIndices[i].M);
			}
		}
		
		if (index.M == 1) 
		{
			myLabel.text = "["+index.N+", +"+index.M+"]";
		} else {
			myLabel.text = "["+index.N+", "+index.M+"]";
		}
		myLabel.setTextFormat(myFormat);
	}
	
	public function RotateToAbsoluteAngle (newAngle:Number):Void
	{
		offsetAngle = newAngle % 360;
		singleStepAngle = 0;
	}

	public function RotateToIncrementalAngle (incrementalAngle:Number):Void
	{
		singleStepAngle = incrementalAngle;
		
		myDisk._rotation = -startAngle-offsetAngle-singleStepAngle;
		myDisk._x = x - Math.SQRT2 * radius * Math.cos((-startAngle-offsetAngle-singleStepAngle + 45)*Math.PI/180) + radius;
		myDisk._y = y - Math.SQRT2 * radius * Math.sin((-startAngle-offsetAngle-singleStepAngle + 45)*Math.PI/180) + radius; 

		myGate._rotation = -startAngle - offsetAngle - singleStepAngle + (72 * gateIndex.N + 24 * gateIndex.M);

		for (i = 0; i < numMarkers; i++)
		{
			if (myMarkers[i] != undefined)
			{
				myMarkers[i]._rotation = -startAngle - offsetAngle - singleStepAngle + (72 * markerIndices[i].N + 24 * markerIndices[i].M);
			}
		}
	}
	
	private function Index2Angle (Void):Void
	{
		offsetAngle = (72 * index.N + 24 * index.M) % 360;
		singleStepAngle = 0;
	}
	
	public function TurnCCW (Void):Void
	{
		index.M++;
		if (index.M > 1) {
			index.M = -1;
			index.N++;
		}
		index.N = index.N % 5;
		Index2Angle();
		Draw();
	}
	
	public function TurnCW (Void):Void
	{
		index.M--;
		if (index.M < -1) {
			index.M = 1;
			index.N--;
		}
		index.N = (index.N + 5)% 5;
		Index2Angle();
		Draw();
	}

	private var ControlCurves:Array = 
		[ // 100 steps (50 moving into the disk and 50 moving out of the disk)
		  // comments refer to upper disk: M, Direction
		  
		// #0: 0, Up
		[  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
		   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  -5,  -7,  
		  -9, -11, -14, -17, -20, -24, -28, -33, -36, -40, -49, -49, -49, -49, -48, -48, -48, -48, -48, -48,
		 -48, -48, -48, -48, -48, -48, -48, -48, -50, -52, -54, -56, -58, -60, -61, -63, -64, -65, -67, -68,
		 -69, -70, -71, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72], 
		 
		// #1: -1, Up
		[-24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, 
		 -24, -24, -24, -23, -22, -21, -20, -19, -19, -18, -17, -17, -17, -17, -17, -17, -17, -17, -17, -17, 
		 -17, -17, -17, -20, -24, -28, -33, -36, -40, -49, -49, -49, -49, -49, -48, -48, -48, -48, -48, -48, 
		 -48, -48, -48, -48, -48, -48, -48, -48, -50, -52, -54, -56, -58, -60, -61, -63, -64, -65, -67, -68, 
		 -69, -70, -71, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72, -72],
		  
		// #2: +1, Up
		[ 24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  26,  27,  29,  30,  31,  33,  35,  36,  38,  40,  
		  41,  42,  43,  45,  46,  47,  48,  49,  50,  50,  51,  52,  52,  52,  52,  52,  52,  52,  52,  52,
		  52,  52,  52,  52,  48,  44,  39,  36,  32,  23,  23,  23,  23,  23,  24,  24,  24,  24,  24,  24, 
		  24,  24,  24,  24,  24,  24,  24,  24,  22,  20,  18,  16,  14,  12,  11,   9,   8,   7,   5,   4,
		   3,   2,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0], 
		
		// #3: 0, Left:
		[  0,   0,   0,   0,   0,   0,   0,   0,   1,   3,   5,   6,   8,   9,  10,  13,  14,  15,  16,  18,
		  19,  20,  21,  22,  23,  24,  24,  24,  25,  25,  25,  25,  25,  25,  25,  25,  25,  25,  25,  25,
		  25,  20,  16,  10,   5,  -1,  -6, -10, -15, -17, -16, -15, -14, -13, -12, -11, -10,  -9,  -9,  -9,
		  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9, -11, -13, -14, -16, -18, -19, -20, -22,
		 -23, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24], 
		 
		// #4: -1, Left
		[ -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24,
		  -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -28, -31, -35, -38, -41, -43,
		  -47, -52, -56, -62, -67, -73, -78, -82, -87, -89, -88, -87, -86, -85, -84, -83, -82, -81, -81, -81,
		  -81, -81, -81, -81, -81, -81, -81, -81, -81, -81, -81, -81, -83, -85, -86, -88, -90, -91, -92, -94,
		  -95, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96, -96], 
		  
		// #5: +1, Left
		[  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,
		   24,  24,  24,  24,  24,  25,  26,  27,  27,  27,  27,  27,  27,  27,  27,  27,  27,  27,  27,  27,
		   27,  25,  16,  10,   5,  -1,  -6, -10, -15, -17, -16, -15, -14, -13, -12, -11, -10,  -9,  -9,  -9,
		   -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9,  -9, -11, -13, -14, -16, -18, -19, -20, -22, 
		  -23, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24], 
		
		// #6: 0, Right:
		[   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
		    0,   2,   3,   4,   6,   7,   8,   9,  10,  11,  11,  12,  13,  13,  13,  13,  13,  13,  13,  13, 
		   13,  13,  10,   6,   3,   1,  -3,  -5,  -8, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10,
		  -10, -10, -10, -10, -10, -11, -15, -16, -18, -20, -22, -24, -27, -30, -31, -33, -35, -38, -39, -40,
		  -41, -42, -43, -44, -46, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48], 
		 
		// #7: -1, Right
		[ -24, -24, -24, -24, -24, -23, -21, -19, -18, -16, -14, -12, -10,  -9,  -7,  -5,  -4,  -2,   0,   2,
		    3,   4,   6,   7,   8,   9,  10,  11,  11,  12,  13,  13,  13,  13,  13,  13,  13,  13,  13,  13, 
		   13,  13,  10,   6,   3,   1,  -3,  -5,  -8, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10,
		  -10, -10, -10, -10, -10, -10, -11, -15, -16, -18, -20, -22, -24, -27, -30, -31, -33, -35, -38, -39, 
		  -40, -41, -42, -43, -44, -46, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48], 
		  
		// #8: +1, Right
		[  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24, 
		   24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  24,  22,  20,  18, 
		   16,  13,  10,   6,   3,   1,  -3,  -5,  -8, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, 
		  -10, -10, -10, -10, -10, -10, -11, -15, -16, -18, -20, -22, -24, -27, -30, -31, -33, -35, -38, -39, 
		  -40, -41, -42, -43, -44, -46, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48, -48]
		
		];
	
	public function ControlCurveAngle (movement:Number, step:Number):Number
	{
		var controlCurveNumber:Number;
		var normalizedMovement:Number;
		var angle:Number;
		
		switch (internalDiskNumber) {
			case DISK_TOP:
				switch (movement) {
					case MOVE_LEFT:  normalizedMovement = MOVE_LEFT; break;
					case MOVE_UP:    normalizedMovement = MOVE_UP; break;
					case MOVE_RIGHT: normalizedMovement = MOVE_RIGHT; break;
					case MOVE_DOWN:  normalizedMovement = MOVE_UNAFFECTED; break;
				}
				break;
			case DISK_LEFT:
				switch (movement) {
					case MOVE_LEFT:  normalizedMovement = MOVE_UP; break;
					case MOVE_UP:    normalizedMovement = MOVE_RIGHT; break;
					case MOVE_RIGHT: normalizedMovement = MOVE_UNAFFECTED; break;
					case MOVE_DOWN:  normalizedMovement = MOVE_LEFT; break;
				}
				break;
			case DISK_RIGHT:
				switch (movement) {
					case MOVE_LEFT:  normalizedMovement = MOVE_UNAFFECTED; break;
					case MOVE_UP:    normalizedMovement = MOVE_LEFT; break;
					case MOVE_RIGHT: normalizedMovement = MOVE_UP; break;
					case MOVE_DOWN:  normalizedMovement = MOVE_RIGHT; break;
				}
				break;
			case DISK_BOTTOM:
				switch (movement) {
					case MOVE_LEFT:  normalizedMovement = MOVE_RIGHT; break;
					case MOVE_UP:    normalizedMovement = MOVE_UNAFFECTED; break;
					case MOVE_RIGHT: normalizedMovement = MOVE_LEFT; break;
					case MOVE_DOWN:  normalizedMovement = MOVE_UP; break;
				}
				break;
		}
				
		switch (index.M) {
			case 0:
				switch (normalizedMovement) {
					case MOVE_UP:
						controlCurveNumber = 0;
						break;
					case MOVE_LEFT:
						controlCurveNumber = 3;
						break;
					case MOVE_RIGHT:
						controlCurveNumber = 6;
						break;
				}
				break;
			case 1:
				switch (normalizedMovement) {
					case MOVE_UP:
						controlCurveNumber = 1;
						break;
					case MOVE_LEFT:
						controlCurveNumber = 4;
						break;
					case MOVE_RIGHT:
						controlCurveNumber = 7;
						break;
				}
				break;
			case -1:
				switch (normalizedMovement) {
					case MOVE_UP:
						controlCurveNumber = 2;
						break;
					case MOVE_LEFT:
						controlCurveNumber = 5;
						break;
					case MOVE_RIGHT:
						controlCurveNumber = 8;
						break;
				}
				break;
		}
		if normalizedMovement == MOVE_UNAFFECTED {
			angle = 0;
		} else {
			angle = - (ControlCurves [controlCurveNumber] [Math.round(step)] - ControlCurves [controlCurveNumber] [0]);
		}
		//trace(angle)
		return angle;
	}
	
	public function Move (movement:Number):Void
	{
		var increment:Number = Math.round(ControlCurveAngle (movement, 99) / 24);
		//trace(movement);
		//trace(increment);
		
		// lastIndex.N = index.N;
		// lastIndex.M = index.M;
		// lastAngle1 = ControlCurveAngle (movement, 26);
		// lastAngle2 = ControlCurveAngle (movement, 40);
		// lastAngle3 = ControlCurveAngle (movement, 79);
		index.M += increment;
		if (index.M > 1) {
			index.M -= 3;
			index.N += 1;
		}
		index.N = index.N % 5;
		
		Index2Angle (index);
		Draw();
	}
	
	public function GetIndex():AxisIndex
	{
		return index
	}
	
	public function SetGateToCurrentPosition ():Void
	{
		gateIndex.N = index.N;
		gateIndex.M = index.M;
		myGate._visible = true
	}

	public function ToggleGateVisibility ():Void
	{
		myGate._visible = !myGate._visible
	}
/*	
	public function SetMarkerToCurrentPosition (firstHalf:Boolean, color:Number):Void
	{
		if (lastAngle1 != null)
		{
			var no:Number;
			no = numMarkers;
			numMarkers++;

			var startAngle:Number;
			var endAngle:Number;
			if myMarkers[no] == undefined
			{
				myClip.createEmptyMovieClip("marker"+no, myClip.getNextHighestDepth());
				myMarkers[no] = myClip["marker" + no];
				markerIndices[no] = new AxisIndex();
			}
			myMarkers[no].clear();
			myMarkers[no].lineStyle(5, color, 50);
			if firstHalf 
			{
				startAngle = lastAngle1;
				endAngle = lastAngle2;
			} else {
				startAngle = lastAngle2;
				endAngle = lastAngle3;
			}
			//trace(startAngle + " " + endAngle);
			myMarkers[no].moveTo(radius * Math.sin (startAngle * Math.PI / 180), 
				-radius * Math.cos (startAngle*Math.PI/180));
			myMarkers[no].curveTo(radius * (1.01 + (endAngle - startAngle) * (endAngle - startAngle)/30000) * Math.sin ((startAngle+(endAngle-startAngle)/2) * Math.PI / 180), 
				-radius * (1.01 + (endAngle - startAngle) * (endAngle - startAngle)/30000) * Math.cos ((startAngle+((endAngle-startAngle)/2)) * Math.PI / 180), 
				radius * Math.sin (endAngle * Math.PI / 180), 
				-radius * Math.cos (endAngle*Math.PI/180));
			myMarkers[no]._x = x + radius;
			myMarkers[no]._y = y + radius;
	
			markerIndices[no].N = lastIndex.N;
			markerIndices[no].M = lastIndex.M;
		}
	}
*/
public function SetMarkerToCurrentPosition (color:Number):Void
	{
	
		var no:Number;
		no = numMarkers;
		numMarkers++;

		var startAngle:Number;
		var endAngle:Number;
		if myMarkers[no] == undefined
		{
			myClip.createEmptyMovieClip("marker"+no, myClip.getNextHighestDepth());
			myMarkers[no] = myClip["marker" + no];
			markerIndices[no] = new AxisIndex();
		}
		myMarkers[no].clear();
		myMarkers[no].lineStyle(5, color, 50);
		
		startAngle = -9+singleStepAngle;
		endAngle = 9+singleStepAngle;

		//trace(startAngle + " " + endAngle);
		myMarkers[no].moveTo(radius * Math.sin (startAngle * Math.PI / 180), 
			-radius * Math.cos (startAngle*Math.PI/180));
		myMarkers[no].curveTo(radius * (1.01 + (endAngle - startAngle) * (endAngle - startAngle)/30000) * Math.sin ((startAngle+(endAngle-startAngle)/2) * Math.PI / 180), 
			-radius * (1.01 + (endAngle - startAngle) * (endAngle - startAngle)/30000) * Math.cos ((startAngle+((endAngle-startAngle)/2)) * Math.PI / 180), 
			radius * Math.sin (endAngle * Math.PI / 180), 
			-radius * Math.cos (endAngle*Math.PI/180));
		myMarkers[no]._x = x + radius;
		myMarkers[no]._y = y + radius;

		markerIndices[no].N = index.N;
		markerIndices[no].M = index.M;

	}
	
	public function ClearAllMarkers (Void):Void
	{
		for (i = 0; i < numMarkers; i++)
		{
			myMarkers[i].clear();
		}
		numMarkers = 0;
	}

	public function DeleteLastMarker (Void):Void
	{
		if (numMarkers > 0) {
			numMarkers--;
			myMarkers[numMarkers].clear();
		}
	}

}