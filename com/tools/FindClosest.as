package com.tools
{
	public class FindClosest
	{
		public static function number(numbers:Array, value:Number):Number 
		{
			var closestValue:Number;
			var smallestDiff:Number;
			var absoluteDiff:Number;
			var lng:int = numbers.length;
			closestValue = smallestDiff = Number.MAX_VALUE;
			
			for (var i:int = 0; i < lng; i++) 
			{
				absoluteDiff = numbers[i] - value;
				absoluteDiff = (absoluteDiff < 0)? -absoluteDiff: absoluteDiff;
				
				if (absoluteDiff < smallestDiff) 
				{
					smallestDiff = absoluteDiff
					closestValue = numbers[i];
				}
			}
			
			return closestValue;
		}
	}
}