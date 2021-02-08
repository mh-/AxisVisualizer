class AxisVisualizer
{

	private static var Disk:Array;
	private static var States;
	
	private static var myStage:MovieClip;
	private static var myBackground:AxisBackground;
	private static var myKnobInterfacePlate:AxisKnobInterfacePlate;
	private static var myFormat:TextFormat;
	private static var myColorSelector:AxisColorSelector;

	private static var x:Number = 0;
	private static var y:Number = 0;
	
	private static var step:Number = 0;
	
	private static var i:Number = 0;
	private static var j:Number = 0;
	
	private static var CurrentMovement:Number = AxisDisk.MOVE_UNAFFECTED;
	private static var MAX_STEP:Number = 100;
	private static var STEP_INC:Number = 5; // this affects the animation speed
	private static var automatic:Boolean = false;
	
	private static var startManualMove = 8;
	private static var endManualMove = 92;
	
	public static var selectedDisk:Number = AxisDisk.DISK_TOP;
	
	//public static var centerX:Number = -27;
	//public static var centerY:Number = 142;
	public static var centerX:Number = 27;
	public static var centerY:Number = 222;
	public static var diskScale:Number = 50;
	
	public static var scale = 0.69;

	public static function main()
	{
		States = new AxisStates();
		
		// Set the stage
		// Stage.scaleMode = "noscale";
		Stage.scaleMode = "showAll";
		Stage.align = "CC";

		myStage = _root.createEmptyMovieClip("AxisStage", _root.getNextHighestDepth());
		
		myBackground = new AxisBackground (myStage);
		
		var GateTestingPiece = 
			//new AxisGateTestingPiece (myStage, AxisDisk.centerX - 65, AxisDisk.centerY - 65);
			new AxisGateTestingPiece (myStage, (AxisVisualizer.centerX - 136), (AxisVisualizer.centerY - 136));

		Disk = new Array ();
		Disk[AxisDisk.DISK_TOP] = new AxisDisk (myStage, 0, AxisDisk.DISK_TOP);
		Disk[AxisDisk.DISK_LEFT] = new AxisDisk (myStage, 90, AxisDisk.DISK_LEFT);
		Disk[AxisDisk.DISK_BOTTOM] = new AxisDisk (myStage, 180, AxisDisk.DISK_BOTTOM);
		Disk[AxisDisk.DISK_RIGHT] = new AxisDisk (myStage, 270, AxisDisk.DISK_RIGHT);

		myKnobInterfacePlate = 
			//new AxisKnobInterfacePlate (myStage, centerX - 65, centerY - 65);
			//new AxisKnobInterfacePlate (myStage, centerX - 115, centerY - 115);
			//new AxisKnobInterfacePlate (myStage, centerX - 78.5, centerY - 78.5);
			new AxisKnobInterfacePlate (myStage, centerX - 75.5, centerY - 75.5);
			
		//myColorSelector = new AxisColorSelector (myStage, centerX + 380, centerY + 98);
		myColorSelector = new AxisColorSelector (myStage, selectedDisk);
		
		myFormat = new TextFormat();
		myFormat.align = "center";
		myFormat.font = "library.Forgotte.ttf";
		myFormat.size = 22 * AxisVisualizer.scale;
		myFormat.color = 0x000000;
		
	
		myStage.createTextField("sequenceText", myStage.getNextHighestDepth(), (centerX - 133) * AxisVisualizer.scale, (centerY + 278) * AxisVisualizer.scale, 400 * AxisVisualizer.scale, 24 * AxisVisualizer.scale);
		myStage.sequenceText.text = "Sequence";
		
		myStage.sequenceText.embedFonts = true;
		myStage.sequenceText.selectable = false;
		myStage.sequenceText.antiAliasType = "advanced";
		myFormat.size = 28 * AxisVisualizer.scale;
		myStage.sequenceText.setTextFormat(myFormat);
		
		myStage.createTextField("sequenceText2", myStage.getNextHighestDepth(), (centerX - 133) * AxisVisualizer.scale, (centerY + 302) * AxisVisualizer.scale, 400 * AxisVisualizer.scale, 24 * AxisVisualizer.scale);
		myStage.sequenceText2.text = "";
		
		myStage.sequenceText2.embedFonts = true;
		myStage.sequenceText2.selectable = false;
		myStage.sequenceText2.antiAliasType = "advanced";
		myFormat.size = 20 * AxisVisualizer.scale;
		myStage.sequenceText2.setTextFormat(myFormat);

		var keylistener = new Object();
		keylistener.onKeyDown = function() {
			var i:Number;
			
			var sequenceText:String;

			//trace("Ascii: "+ Key.getAscii() + " Code: " + Key.getCode()); 
			
			switch (Key.getAscii()){
				case 103: // g
					AxisVisualizer.ToggleGatesVisibility();
					break;
				case 56: // 8
				case 117: // u
					AxisVisualizer.selectedDisk = AxisDisk.DISK_TOP;
					AxisVisualizer.myColorSelector.MoveTo(AxisVisualizer.selectedDisk);
					break;
				case 52: // 4
				case 104: // h
					AxisVisualizer.selectedDisk = AxisDisk.DISK_LEFT;
					AxisVisualizer.myColorSelector.MoveTo(AxisVisualizer.selectedDisk);
					break;
				case 50: // 2
				case 110: // n
					AxisVisualizer.selectedDisk = AxisDisk.DISK_BOTTOM;
					AxisVisualizer.myColorSelector.MoveTo(AxisVisualizer.selectedDisk);
					break;
				case 54: // 6
				case 106: // j
					AxisVisualizer.selectedDisk = AxisDisk.DISK_RIGHT;
					AxisVisualizer.myColorSelector.MoveTo(AxisVisualizer.selectedDisk);
					break;
				case 109: // m
					AxisVisualizer.SetMarker();
					break;
				case 99: // c
					AxisVisualizer.myColorSelector.ChangeColor();
					break;
				case 100: // d
					AxisVisualizer.DeleteLastMarker();
					break;
			}

			if (AxisVisualizer.CurrentMovement == AxisDisk.MOVE_UNAFFECTED)
			{
				switch (Key.getCode())
				{
					case Key.UP: 
						AxisVisualizer.StartMovement (AxisDisk.MOVE_UP);
						break;
					case Key.LEFT:
						AxisVisualizer.StartMovement (AxisDisk.MOVE_LEFT);
						break;
					case Key.DOWN:
						AxisVisualizer.StartMovement (AxisDisk.MOVE_DOWN);
						break;
					case Key.RIGHT:
						AxisVisualizer.StartMovement (AxisDisk.MOVE_RIGHT);
						break;
					case Key.DELETEKEY:
						AxisVisualizer.ClearAllMarkers();
						break;
				}
				switch (Key.getAscii()){
					case 102: // f
						if AxisVisualizer.STEP_INC == 5 {
							AxisVisualizer.STEP_INC = 10;
						} else {
							AxisVisualizer.STEP_INC = 5;
						}
						break;
					case 115: // s
						AxisVisualizer.SetGates();
						break;
					case 43: // +
						AxisVisualizer.TurnCCW(AxisVisualizer.selectedDisk);
						break;
					case 45: // -
						AxisVisualizer.TurnCW(AxisVisualizer.selectedDisk);
						break;
				}
			} else {
				if (!AxisVisualizer.automatic && ((AxisVisualizer.step > AxisVisualizer.startManualMove) || (AxisVisualizer.step < AxisVisualizer.endManualMove)))
				{
					if (Key.getCode() == Key.SPACE) // SPACE
					{ 
						AxisVisualizer.automatic = true;
					} else
					{
						if (AxisVisualizer.CurrentMovement == AxisDisk.MOVE_UP)
						{
							if (Key.getCode() == Key.UP) AxisVisualizer.NextStep();
							if (Key.getCode() == Key.DOWN) AxisVisualizer.PreviousStep();
						}
						if (AxisVisualizer.CurrentMovement == AxisDisk.MOVE_LEFT)
						{
							if (Key.getCode() == Key.LEFT) AxisVisualizer.NextStep();
							if (Key.getCode() == Key.RIGHT) AxisVisualizer.PreviousStep();
						}
						if (AxisVisualizer.CurrentMovement == AxisDisk.MOVE_DOWN)
						{
							if (Key.getCode() == Key.DOWN) AxisVisualizer.NextStep();
							if (Key.getCode() == Key.UP) AxisVisualizer.PreviousStep();
						}
						if (AxisVisualizer.CurrentMovement == AxisDisk.MOVE_RIGHT)
						{
							if (Key.getCode() == Key.RIGHT) AxisVisualizer.NextStep();
							if (Key.getCode() == Key.LEFT) AxisVisualizer.PreviousStep();
						}
					}
				}
			}
			
			if (Key.getAscii() == 114) // r
			{
				AxisVisualizer.Reset();
			}

					
			//trace ("Statenumber: " + AxisStates.State2StateNumber(Disk[1].GetIndex(), Disk[2].GetIndex(), Disk[3].GetIndex(), Disk[4].GetIndex()));
			//trace(AxisStates.GetCombination(AxisStates.State2StateNumber(Disk[1].GetIndex(), Disk[2].GetIndex(), Disk[3].GetIndex(), Disk[4].GetIndex())));
			sequenceText = AxisStates.GetCombination(AxisStates.State2StateNumber(AxisVisualizer.Disk[1].GetIndex(), AxisVisualizer.Disk[2].GetIndex(), AxisVisualizer.Disk[3].GetIndex(), AxisVisualizer.Disk[4].GetIndex()));
			AxisVisualizer.myStage.sequenceText.text = AxisStates.GetNicerCombinationFormat2(sequenceText);
			AxisVisualizer.myFormat.size = 28 * AxisVisualizer.scale;
			AxisVisualizer.myStage.sequenceText.setTextFormat(AxisVisualizer.myFormat);
			AxisVisualizer.myStage.sequenceText2.text = AxisStates.GetNicerCombinationFormat(sequenceText);
			AxisVisualizer.myFormat.size = 20 * AxisVisualizer.scale;
			AxisVisualizer.myStage.sequenceText2.setTextFormat(AxisVisualizer.myFormat);

			};
		Key.addListener(keylistener);
			
		myStage.onEnterFrame = function () {
			if (AxisVisualizer.CurrentMovement != AxisDisk.MOVE_UNAFFECTED) && 
				(AxisVisualizer.automatic || (AxisVisualizer.step <= AxisVisualizer.startManualMove) || (AxisVisualizer.step >= AxisVisualizer.endManualMove))
			{
				AxisVisualizer.NextStep();
			}
		}
		
	}
	
	private static function Reset(Void):Void
	{
		var i:Number;
		var sequenceText:String;

		for (i = 1; i <= 4; i++)
		{
			Disk[i].Reset();
			Disk[i].Draw();
		}
		step = 0;
		x = 0;
		y = 0;
		myKnobInterfacePlate.MoveToAbsoluteIndex(x, y);
		
		CurrentMovement = AxisDisk.MOVE_UNAFFECTED;
		
		sequenceText = AxisStates.GetCombination(AxisStates.State2StateNumber(Disk[1].GetIndex(), Disk[2].GetIndex(), Disk[3].GetIndex(), Disk[4].GetIndex()));
		myStage.sequenceText.text = AxisStates.GetNicerCombinationFormat2(sequenceText);
		myFormat.size = 28 * AxisVisualizer.scale;
		myStage.sequenceText.setTextFormat(myFormat);
		myStage.sequenceText2.text = AxisStates.GetNicerCombinationFormat(sequenceText);
		myFormat.size = 20 * AxisVisualizer.scale;
		myStage.sequenceText2.setTextFormat(AxisVisualizer.myFormat);
	}
	
	private static function StartMovement(direction:Number):Void
	{
		CurrentMovement = direction;
		automatic = true;
		if Key.isDown(Key.SHIFT) {
			automatic = false;
		}
	}

	private static function TurnCCW(disk:Number):Void
	{
		Disk[disk].TurnCCW();
	}

	private static function TurnCW(disk:Number):Void
	{
		Disk[disk].TurnCW();
	}
	
	private static function SetGates(Void):Void
	{
		var i:Number;
		for (i = 1; i <= 4; i++)
		{
			Disk[i].SetGateToCurrentPosition();
			Disk[i].Draw();
		}
	}
	
	private static function ToggleGatesVisibility(Void):Void
	{
		var i:Number;
		for (i = 1; i <= 4; i++)
		{
			Disk[i].ToggleGateVisibility();
			Disk[i].Draw();
		}
	}
	
	/*
	private static function SetMarkers(firstHalf:Boolean):Void
	{
		var i:Number;
		for (i = 1; i <= 4; i++)
		{	
			Disk[i].SetMarkerToCurrentPosition(firstHalf, myColorSelector.currentColor);
			Disk[i].Draw();
		}
	}
	*/
	private static function SetMarker(Void):Void
	{
		Disk[selectedDisk].SetMarkerToCurrentPosition(myColorSelector.currentColor);
		Disk[selectedDisk].Draw();
	}
	
	private static function ClearAllMarkers(Void):Void
	{
		var i:Number;
		for (i = 1; i <= 4; i++)
		{
			Disk[i].ClearAllMarkers();
		}
	}
	
	private static function DeleteLastMarker(Void):Void
	{
		Disk[selectedDisk].DeleteLastMarker();
	}
	private static function NextStep(Void):Void
	{
		var sequenceText:String;
		
		if step < MAX_STEP 
		{
			step += STEP_INC;

			for (i = 1; i <= 4; i++)
			{
				Disk[i].RotateToIncrementalAngle(Disk[i].ControlCurveAngle(CurrentMovement,step));
			}
			switch (CurrentMovement)
			{
				case AxisDisk.MOVE_UP:
					y = -step;
					if y < -MAX_STEP/2 {y = -MAX_STEP - y;}
					break;
				case AxisDisk.MOVE_DOWN:
					y = step;
					if y > MAX_STEP/2 {y = MAX_STEP - y;}
					break;
				case AxisDisk.MOVE_LEFT:
					x = -step;
					if x < -MAX_STEP/2 {x = -MAX_STEP - x;}
					break;
				case AxisDisk.MOVE_RIGHT:
					x = step;
					if x > MAX_STEP/2 {x = MAX_STEP - x;}
					break;
			}

			myKnobInterfacePlate.MoveToAbsoluteIndex(x, y);

		} else {
			
			step = 0;
			x = y = 0;
			myKnobInterfacePlate.MoveToAbsoluteIndex(x, y);
		
			for (i = 1; i <= 4; i++)
			{
				Disk[i].Move(CurrentMovement);
			}
		
			CurrentMovement = AxisDisk.MOVE_UNAFFECTED;
		
			sequenceText = AxisStates.GetCombination(AxisStates.State2StateNumber(Disk[1].GetIndex(), Disk[2].GetIndex(), Disk[3].GetIndex(), Disk[4].GetIndex()));
			myStage.sequenceText.text = AxisStates.GetNicerCombinationFormat2(sequenceText);
			myFormat.size = 28 * AxisVisualizer.scale;
			myStage.sequenceText.setTextFormat(myFormat);
			myStage.sequenceText2.text = AxisStates.GetNicerCombinationFormat(sequenceText);
			myFormat.size = 20 * AxisVisualizer.scale;
			myStage.sequenceText2.setTextFormat(AxisVisualizer.myFormat);
		}
	}
	
	private static function PreviousStep(Void):Void
	{
		if step > 0
		{
		step -= STEP_INC;

		for (i = 1; i <= 4; i++)
			{
				Disk[i].RotateToIncrementalAngle(Disk[i].ControlCurveAngle(CurrentMovement,step));
			}
			switch (CurrentMovement)
			{
				case AxisDisk.MOVE_UP:
					y = -step;
					if y < -MAX_STEP/2 {y = -MAX_STEP - y;}
					break;
				case AxisDisk.MOVE_DOWN:
					y = step;
					if y > MAX_STEP/2 {y = MAX_STEP - y;}
					break;
				case AxisDisk.MOVE_LEFT:
					x = -step;
					if x < -MAX_STEP/2 {x = -MAX_STEP - x;}
					break;
				case AxisDisk.MOVE_RIGHT:
					x = step;
					if x > MAX_STEP/2 {x = MAX_STEP - x;}
					break;
			}

			myKnobInterfacePlate.MoveToAbsoluteIndex(x, y);
		}
	}
}
