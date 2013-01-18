package com.controls
{
	import com.graphics.asset.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrubBar extends ProgressBar
	{
		private var scrubber			:Asset;
		private var _scrubDownPercentage:Number;
		
		public static const SCRUB_DOWN:String = 'scrub_down';
		
		private var ai:AssetInitializer;
		
		public function ScrubBar(barBackgroundPath:String = null, width:Number = 10, height:Number = 10, color:uint = 0xFFFFFF, alpha:Number = 0, padding:Number = 4):void
		{
			super(barBackgroundPath, width, height, color, alpha, padding);
			
			this.ai = new AssetInitializer();
			this.ai.shape = AssetSetting.CIRC;
			this.ai.width = 10;
			this.ai.height = 10;
			this.ai.color = 0x606060;
			this.ai.alpha = 1;
			
			this.scrubber = new Asset(this.ai);
			this.scrubber.makeButton();
			this.scrubber.x = (this.barProgress.visibleWidth - (this.scrubber.visibleWidth / 2));
			this.addChild(this.scrubber);
			
			this.addEventListener('updating_progress_bar', thisUpdate);	
			this.addEventListener(MouseEvent.MOUSE_DOWN, scrubberDown);
		}
		
		private function thisUpdate(e:Event):void
		{	
			this.scrubber.x = (this.barProgress.visibleWidth - (this.scrubber.visibleWidth / 2));
		}
		
		private function scrubberDown(e:MouseEvent):void
		{
			this._scrubDownPercentage = (this.mouseX / (this.width / 100));
			
			this.dispatchEvent(new Event(SCRUB_DOWN));
		}
		
		public function get newPercentage():Number
		{
			return this._scrubDownPercentage;
		}
	}
}