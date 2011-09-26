/**
 * RandomNumber
 *
 * Author: Dion Snoeijen
 * Date 29-04-2010
 * 
 * Return random number between different values.
 *
 */

package com.tools
{
	public class RandomNumber
	{
		public static function randomNumber(low:Number, high:Number):Number
		{
			return Math.round(Math.random() * (high - low)) + low;
		}
	}
}