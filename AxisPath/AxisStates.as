/**
* ...
* @author Michael Huebler
*/

class AxisStates 
{
	private static var CombinationTable:Array;
	
	public function AxisStates() 
	{
		var i:Number;
		var j:Number;
		var pos:Number = 0;
		var len:Number;
		var temp:Number;

		CombinationTable = new Array();
		for (i = 0; i <= 2984; i++)
		{
			pos += distanceCodingTable[StateTable1.stateTable1[i] % 16];
			temp = Math.floor(StateTable1.stateTable1[i] / 16);
			len = temp % 16;
			temp = Math.floor(temp / 16);
			CombinationTable [pos] = "";
			for (j = 0; j <= len - 1; j++)
			{
				CombinationTable [pos] += movementCodingTable[temp % 4];
				temp = Math.floor(temp / 4);
			}
		} 
		for (i = 0; i <= 4514; i++)
		{
			pos += distanceCodingTable[StateTable2.stateTable2[i] % 16];
			temp = Math.floor(StateTable2.stateTable2[i] / 16);
			len = temp % 16;
			temp = Math.floor(temp / 16);
			CombinationTable [pos] = "";
			for (j = 0; j <= len - 1; j++)
			{
				CombinationTable [pos] += movementCodingTable[temp % 4];
				temp = Math.floor(temp / 4);
			}
		}
		CombinationTable [3616] = "<Reset>"
		
	}
	
	private var movementCodingTable = ["U", "L", "D", "R"];
	
	private var distanceCodingTable = [1, 3, 4, 17, 31, 33, 46, 49, 62, 227, 257];
	
	
	public static function State2StateNumber(TopIndex:AxisIndex, LeftIndex:AxisIndex, BottomIndex:AxisIndex, RightIndex:AxisIndex):Number
	{
		return  (TopIndex.N * 3 + TopIndex.M + 1) * (15 * 15 * 15) + 
				(LeftIndex.N * 3 + LeftIndex.M + 1) * (15 * 15) + 
				(RightIndex.N * 3 + RightIndex.M + 1) * (15) + 
				(BottomIndex.N * 3 + BottomIndex.M + 1)
	}
	   
	public static function StateNumber2State(StateNumber:Number, TopIndex:AxisIndex, LeftIndex:AxisIndex, BottomIndex:AxisIndex, RightIndex:AxisIndex):Void
	{
		var Bottom:Number = StateNumber % 15
		var Right:Number = Math.floor(StateNumber / 15) % 15
		var Left:Number = Math.floor(StateNumber / (15 * 15)) % 15
		var Top:Number = Math.floor(StateNumber / (15 *15 * 15)) % 15
    
		BottomIndex.M = (Bottom % 3) - 1
		RightIndex.M = (Right % 3) - 1
		LeftIndex.M = (Left % 3) - 1
		TopIndex.M = (Top % 3) - 1
    
		BottomIndex.N = Math.floor(Bottom / 3)
		RightIndex.N = Math.floor(Right / 3)
		LeftIndex.N = Math.floor(Left / 3)
		TopIndex.N = Math.floor(Top / 3)
	}
	

	public static function GetCombination(StateNumber:Number):String
	{
		if (CombinationTable[StateNumber] == undefined) {
			return "<invalid state>";
		} else {
			return CombinationTable[StateNumber];
		}
	}

	public static function GetNicerCombinationFormat(Combination:String):String
	{
		var NicerCombinationFormat:String;
		var LastMovement:String;
		var i:Number;
		var count:Number;
		
		//Combination = "UDLRUDLRUDLRUDLRUDLRUDLRR"

		NicerCombinationFormat = ""
		if ((Combination == "<invalid state>") || (Combination == "Sequence") || (Combination == "<Reset>")){
			return "";
		} else {
			LastMovement = Combination.charAt (0);
			count = 0;
			for (i = 0; i < Combination.length; i++) {
				//trace ("NCF: "+NicerCombinationFormat)
				if ((Combination.charAt (i) == LastMovement) || (i == 0)) {
					count++;
				} else {
					NicerCombinationFormat = NicerCombinationFormat + LastMovement;
					if (count > 1) {
						NicerCombinationFormat = NicerCombinationFormat + "*" + count;
					}
					NicerCombinationFormat = NicerCombinationFormat + "  ";
					LastMovement = Combination.charAt (i);
					count = 1;
				}
			}
			NicerCombinationFormat = "(" + NicerCombinationFormat + LastMovement;			
			if (count > 1) {
				NicerCombinationFormat = NicerCombinationFormat + "*" + count;
			}
			NicerCombinationFormat = NicerCombinationFormat + ")";
			return NicerCombinationFormat;
		}
	}

	public static function GetNicerCombinationFormat2(Combination:String):String
	{
		var NicerCombinationFormat:String;
		var LastMovement:String;
		var i:Number;
		
		//Combination = "UDLRUDLRUDLRUDLRUDLRUDLRR"

		NicerCombinationFormat = ""
		if ((Combination == "<invalid state>") || (Combination == "Sequence") || (Combination == "<Reset>")){
			return Combination;
		} else {
			LastMovement = Combination.charAt (0);
			for (i = 0; i < Combination.length; i++) {
				//trace ("NCF: "+NicerCombinationFormat)
				if ((Combination.charAt (i) == LastMovement) || (i == 0)) {
					NicerCombinationFormat = NicerCombinationFormat + Combination.charAt (i);
				} else {
					NicerCombinationFormat = NicerCombinationFormat + " " +Combination.charAt (i);
					LastMovement = Combination.charAt (i);
				}
			}
			//NicerCombinationFormat = NicerCombinationFormat + LastMovement;
			return NicerCombinationFormat;
		}
	}
}