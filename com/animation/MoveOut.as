/**
 * MoveOut
 *
 * Author: Dion Snoeijen
 * Date 29-04-2010
 * 
 * Move stuff out of the way in all kinds of fashionable ways. 
 */
package com.animation
{
	import com.graphics.asset.Asset;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.tools.RandomNumber;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MoveOut
	{
		public static const ANIMATION_DONE:String = 'animation_done';
		
		public static function moveOutZoom(items:Array):void
		{
			var delay:Number;
			
			for each(var item:Array in items)
			{
				delay = Math.random();
				TweenMax.to(item[0], .3, {delay:delay, scaleX2:2, scaleY2:2, alpha:0});
			}
		}
		
		public static function moveInZoom(items:Array):void
		{
			var delay:Number;
			
			for each(var item:Asset in items)
			{
				TweenMax.to(item, 0, {scaleX2:.4, scaleY2:.4, ease:Back.easeInOut});
			
				delay = Math.random();
				TweenMax.to(item, .3, {delay:delay, scaleX2:1, scaleY2:1, alpha:1, ease:Back.easeInOut});
			}
		}
		
		public static function moveAwayFromOrigin(items:Array, originX:Number, originY:Number, extraFrom:Number, extraTo:Number, transTime:Number = .3):void
		{
			for each(var item:Array in items)
			{
				var relMPX:Number = Math.abs(item[0].x - originX);
				var relMPY:Number = Math.abs(item[0].y - originY);
				var theta:Number = Math.atan(relMPY / relMPX);
			
				var extraDist:Number = RandomNumber.randomNumber(extraFrom, extraTo);
								
				var newRelX:Number = relMPX + extraDist;
				var newRelY:Number = relMPY + extraDist;
				
				var radius:Number = Math.sqrt((newRelX * newRelX) + (newRelY * newRelY));
				var newX:Number = Math.cos(theta) * radius;
				var newY:Number = Math.sin(theta) * radius;
				
				if(item[0].x >= originX && item[0].y <= originY)
				{	
					// -------------------------
				  	//	Quadrant I
					// -------------------------
					TweenMax.to(item[0], transTime, {x:newX + originX, y:-newY + originY, ease:Back.easeInOut, motionBlur:true});
				}
				else if(item[0].x < originX && item[0].y <= originY)
				{
					// -------------------------
				  	//	Quadrant II
					// -------------------------
				 	TweenMax.to(item[0], transTime, {x:-newX + originX, y:-newY + originY, ease:Back.easeInOut, motionBlur:true});
				}
				else if(item[0].x < originX && item[0].y > originY)
				{
					// -------------------------
				  	//	Quadrant III
					// -------------------------
				 	TweenMax.to(item[0], transTime, {x:-newX + originX, y:newY + originY, ease:Back.easeInOut, motionBlur:true});
				}
				else 
				{
					// -------------------------
				  	//	Quadrant IV
					// -------------------------
				 	TweenMax.to(item[0], transTime, {x:newX + originX, y:newY + originY, ease:Back.easeInOut, motionBlur:true});
				}
			}
		}
		
		public static function distanceTest(items:Array, xMargin:Number = 100):void
		{
			for each(var item:Array in items)
			{
				trace('Item position:', item[0].x, item[0].y);	
			}
		}
	}
}