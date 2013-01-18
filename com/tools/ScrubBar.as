// ActionScript file
package com.tools
{
	import com.graphics.asset.*;
	import com.core.DynamicCenter;
	
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	public class ScrubBar extends DynamicCenter
	{
		private var container	:Sprite;
		private var scrubBg		:Asset;
		private var scrubBar	:Sprite;
		private var hitMe		:Sprite;
		
		private var targetFlv	:Asset;
		
		private var onePercent  :Number;
		
		private var leftOffset	:Number;
		private var w			:Number;
		private var h			:Number;
		private var er			:Number;
		private var bc			:uint;
		private var sc			:uint;
		
		public var location		:Number;
		
		public function ScrubBar(barWidth:Number = 400, barHeight:Number = 18, edgeRoundness:Number = 5, bgColor:uint = 0xFFFFFF, sbColor:uint = 0x000000):void
		{
			this.w = barWidth;
			this.h = barHeight;
			this.er = edgeRoundness;
			this.bc = bgColor;
			this.sc = sbColor;
			
			container = new Sprite();
			
			leftOffset = 100;
			onePercent = 100 / w;
			
			this.ai.width = this.w;
			this.ai.height = this.h;
			this.ai.color = 0xCCCCCC;
			this.ai.alpha = 1;
			
			scrubBg = new Asset(this.ai);
			scrubBg.x = leftOffset;
			
			scrubBar = new Sprite();
			scrubBar.graphics.beginFill(sc);
			scrubBar.graphics.drawRect(0, 0, 10, h);
			scrubBar.graphics.endFill();
			
			scrubBar.x = leftOffset;
			
			hitMe = new Sprite();
			hitMe.graphics.beginFill(0x00FF00, 0);
			hitMe.graphics.drawRect(0, 0, w, h);
			hitMe.graphics.endFill();
			hitMe.buttonMode = true;
			hitMe.addEventListener(MouseEvent.MOUSE_DOWN, hitAreaMouseDown);
			
			hitMe.x = leftOffset;
			
			container.addChild(scrubBg);
			container.addChild(scrubBar);
			container.addChild(hitMe);
			
			addChild(container);
		}
		
		public function setFlv(flv:Asset):void
		{
			targetFlv = flv;
			targetFlv.addEventListener(ProgressEvent.PROGRESS, flvProgress);
		}
		
		private function hitAreaMouseDown(e:MouseEvent):void
		{
			scrubBar.graphics.clear();
			scrubBar.graphics.beginFill(sc);
			scrubBar.graphics.drawRoundRect(0, 0, mouseX - leftOffset, h, er, er);
			scrubBar.graphics.endFill();
			
			location = (mouseX - leftOffset) * onePercent;
			
			//trace('location: ' + location);
			targetFlv.videoSearch(location);
		}
		
		private function flvProgress(e:ProgressEvent):void
		{
			var newWidth:Number = targetFlv.movSendTimePercentage / onePercent;	
			
			if(!isNaN(newWidth))
			{
				scrubBar.graphics.clear();
				scrubBar.graphics.beginFill(sc);
				scrubBar.graphics.drawRect(0, 0, newWidth, h);
				scrubBar.graphics.endFill();	
			}
		}
	}
}