/**
 * LiquidFloat
 *
 * Author: Dion Snoeijen
 * Date 21-04-2010
 * 
 * Liquid movement
 * 
 * TODO:
 * Fix the fucking upper left corner bug
 * update: 17-08-2011: this may not be a bug but expected behaviour.
 */
package com.animation
{
	import com.graphics.asset.Asset;
	import com.tools.RandomNumber;
	
	import flash.events.Event;
	
	public class LiquidFloat
	{
		public var dampen		:Number = 0.95;
		public var debugging	:Boolean = false;
		
		private var items		:Vector.<Asset>;
		
		public function LiquidFloat(items:Vector.<Asset>):void
		{	
			this.items = items;
			
			for each(var item:Asset in items)
			{
				// -------------------------
				//	See if the item allready floats.
				// -------------------------
				if(!item.vars.lf)
				{
					item.addEventListener(Event.ENTER_FRAME, animate);
					// -------------------------
					//	Initialize asset Object to give numeric value
					// -------------------------
					item.vars.vx = 0;
					item.vars.vy = 0;
					item.vars.lf = true;
				}
			}
		}
		
		private function animate(e:Event):void
		{	
			var item:Asset = Asset(e.target);
			
			item.vars.vx += (Math.random() * 0.2) - 0.099;
			item.vars.vy += (Math.random() * 0.2) - 0.099;
			
			if(this.debugging && item.vars.debugging)
				trace('LiquidFloat: item.vars.vx:', item.vars.vx, 'item.vars.vy:', item.vars.vy);
		   	
		    item.x += item.vars.vx;
		    item.y += item.vars.vy;

		    item.vars.vx *= dampen;
		    item.vars.vy *= dampen;
		}
		
		public function stopMovement(item:Asset):void
		{
			item.removeEventListener(Event.ENTER_FRAME, animate);			
		}
		
		public function continueMovement(item:Asset):void
		{
			item.addEventListener(Event.ENTER_FRAME, animate);
		}
		
		public function stopAllMovement():void
		{
			for each(var item:Asset in items)
			{
				item.removeEventListener(Event.ENTER_FRAME, animate);
			}
		}
		
		public function continueAllMovement():void
		{
			for each(var item:Asset in items)
			{
				item.addEventListener(Event.ENTER_FRAME, animate);				
			}
		}
	}
}
