package com.tools
{
	public class RoundDecimal
	{
		public static function roundDec(numIn:Number, decimalPlaces:int):Number 
		{
			var nExp:int = Math.pow(10,decimalPlaces) ; 
			var nRetVal:Number = Math.round(numIn * nExp) / nExp
			return nRetVal;
		}
	}
}