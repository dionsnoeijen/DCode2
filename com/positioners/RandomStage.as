/**
 * Asset
 *
 * Author: Dion Snoeijen
 * Date: 20-02-2010
 * 
 * Rev: 11-05-2010
 *
 * Distribute object random on specified rectangular area
 *
 * Wo 12 Mei 2010: Added test to make better distribution
 * 
 */
package com.positioners
{
	import com.graphics.asset.Asset;
	import com.tools.RandomNumber;
	import com.tools.Rndm;
	import com.tools.StandardNormal;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class RandomStage
	{
		public static function semiRandomDistribute(minWidth:Number, 
													maxWidth:Number,
													minHeight:Number,
													maxHeight:Number,
													items:Array
													):void
		{
			var sn:StandardNormal = new StandardNormal();
			
			for each(var item:Array in items)
			{
				var randX:Number = (sn.uniform() * (maxWidth - minWidth)) + minWidth;
				var randY:Number = (sn.uniform() * (maxHeight - minHeight)) + minHeight;
				
				item[0].x = randX;
				item[0].y = randY;
			}
		}
		
		public static function distribute(minWidth:Number, 
										  maxWidth:Number, 
										  minHeight:Number, 
										  maxHeight:Number, 
										  items:Vector.<Asset>
										  ):void
		{
			for each(var item:Asset in items)
			{
		        item.x = RandomNumber.randomNumber(minWidth, maxWidth);
		        item.y = RandomNumber.randomNumber(minHeight, maxHeight);
			}
		}
		
		public static function randomControlled(minWidth:Number,
												maxWidth:Number,
												minHeight:Number,
												maxHeight:Number,
												items:Array
												):void
		{
			var positions:Array = new Array();
			
			for each(var item:Array in items)
			{
				var newX:Number = Rndm.integer(minWidth, maxWidth);
				var newY:Number = Rndm.integer(minHeight, maxHeight);
				
				positions.push(new Point(newX, newY));
			}
			
			var i:int;
			for each(var place:Array in items)
			{
				place[0].x = positions[i].x;
				place[0].y = positions[i].y;
				i++;
			}
		}
		
		private static function newXandY(minW:Number, maxW:Number, minH:Number, maxH:Number):Point
		{
			var p:Point = new Point(RandomNumber.randomNumber(minW, maxH), RandomNumber.randomNumber(minW, maxH));
			
			return p;
		}
		
		private static function weightMiddle(input:Number, strength:int = 2):Number 
		{
			if (input < 0.5) return 1 - Math.pow(1 - input, strength) / 2;
			return 0.5 + Math.pow((input - 0.5) * 2, strength) / 2;
		}
	}
}