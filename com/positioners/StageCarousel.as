package com.positioners
{	
	import com.graphics.asset.Asset;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.initial.GlobalStage;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class StageCarousel extends Sprite 
	{	
		private var radiusX		:uint;
		private var radiusY		:uint;
		private var centerX		:Number; // x position of center of carousel
		private var centerY		:Number; // y position of center of carousel
		private var speed		:Number; // initial speed of rotation of carousel
		private var itemArray	:Array;  // store the Items to sort them according to their 'depth' - see sortBySize() function.
		
		private var items		:Vector.<Asset>;
		
		public function StageCarousel(items		:Vector.<Asset>,
								 radiusX	:uint = 250, 
								 radiusY	:uint = 25, 
								 centerX	:Number = 100, 
								 centerY	:Number = 100, 
								 speed		:Number = 0):void 
		{
			this.radiusX = radiusX;
			this.radiusY = radiusY;
			
			this.centerX = centerX;
			this.centerY = centerY;
			
			this.items = new Vector.<Asset>();
			this.items = items;
			
			this.speed = speed;
			
			this.itemArray = new Array();
			
			var i:int = 0;
			for each(var item:Asset in this.items) 
			{
				item.vars.angl = i * ((Math.PI * 2) / this.items.length);
				item.alpha = 1;
				
				this.itemArray.push(item);
				
				var addEventListenerToMe:Asset = item;
				if(item.getChildByName('hitArea'))
				{
					addEventListenerToMe = Asset(item.getChildByName('hitArea'));
				}
				
				addEventListenerToMe.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				addEventListenerToMe.addEventListener(MouseEvent.MOUSE_DOWN, hitAreaDown);
				item.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				
				item.name = String(i);

				this.addFrameHandler(item);
				
				this.addChild(item);

				i++;
			}
			
			GlobalStage.stageInstance.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private var addCounter:int = 0;
		private function addFrameHandler(item:Asset):void
		{
			this.addCounter++;
			if(this.addCounter == this.itemArray.length)
			{
				for each(var itemetje:Asset in this.itemArray)
				{
					itemetje.addEventListener(Event.ENTER_FRAME, enterFrameHandler);			
				}
			}
		}
		
		// position Items in elipse
		private function enterFrameHandler(e:Event):void 
		{
			e.currentTarget.x = Math.cos(e.currentTarget.vars.angl) * radiusX + centerX; // x position of Item
			e.currentTarget.y = Math.sin(e.currentTarget.vars.angl) * radiusY + centerY; // y postion of Item
			
			// scale Item according to y position to give perspective
			var s:Number = e.currentTarget.y / (centerY + radiusY);
			
			if(s < 0.8)
			{
				TweenMax.to(e.currentTarget, 2, {blurFilter:{blurX:(s * 10), blurY:(s * 10), alpha:.5}});
			}
			else
			{
				TweenMax.to(e.currentTarget, 2, {blurFilter:{blurX:0, blurY:0, alpha:1}});
			}
			
			e.currentTarget.scaleX = e.currentTarget.scaleY = s;
			e.currentTarget.vars.angl += speed; // speed is updated by mouseMoveHandler
			this.sortBySize();
		}
		
		// set the display list index (depth) of the Items according to their
		// scaleX property so that the bigger the Item, the higher the index (depth)
		private function sortBySize():void 
		{
			// There isn't an Array.ASCENDING property so use DESCENDING and reverse()
			this.itemArray.sortOn("scaleX", Array.DESCENDING | Array.NUMERIC);
			this.itemArray.reverse();
			for(var i:uint = 0; i < itemArray.length; i++) 
			{
				var item:Asset = Asset(itemArray[i]);
				this.setChildIndex(item, i);
			}
		}
		
		private function rollOverHandler(e:MouseEvent):void 
		{
			var item:Asset = Asset(e.currentTarget);
			
			if(item.name == 'hitArea')
			{
				item.parent.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				TweenMax.to(item.parent, .5, {blurFilter:{blurX:0, blurY:0, alpha:1}});
			}
			else
			{
				TweenMax.to(item, .5, {blurFilter:{blurX:0, blurY:0, alpha:1}});
			}
			
			for each(var itemetje:Asset in this.itemArray)
			{
				itemetje.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		private function hitAreaDown(e:MouseEvent):void
		{
			//moet dion nog invullen, cause i have no clue!
		}
		
		private function rollOutHandler(e:MouseEvent):void 
		{
			if(e.currentTarget.name != 'hitArea')
			{
				e.currentTarget.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			}
			for each(var item:Asset in this.itemArray)
			{
				item.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		/*
		Update the speed at which the carousel rotates accoring to the distance of the mouse from the center of the stage. The speed variable only gets updated when the mouse moves over the Item Sprites.
		*/
		private function mouseMoveHandler(event:MouseEvent):void 
		{
			var distance:Number = 70;
			if(this.mouseX < (this.centerX + distance)  && this.mouseX > (this.centerX - distance))
			{
				//continue next check
				//if(mouseX < 580/2) angl += speed;
				//else angl-=speed;
				speed = (mouseX - centerX) / 3000;
			}
			/*
			speed = (mouseX - centerX) / 3000;*/
		}
	}
}