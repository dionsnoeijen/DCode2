package com.controls
{
	import com.core.DynamicCenter;
	import com.graphics.asset.*;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	
	public class CircularProgressBar extends DynamicCenter implements IProgressBar
	{
		private var circleSegment		:Asset;
		private var radPerPercent		:Number;
		private var startingPos			:Number;
		
		private var _progressPercentage	:Number;
		
		public function CircularProgressBar(radius:Number = 100, bgColor:uint = 0xCCCCCC, fgColor:uint = 0x626262, thickness:Number = 10):void
		{
			// -------------------------
			//	Start the circle segment at the top -90
			//	The height doesnt matter, width is used for radius
			// -------------------------
			this.ai.shape = AssetSetting.DONUT;
			this.ai.width = radius;
			this.ai.color = bgColor;
			this.ai.customShapeSettings = [thickness];
			this.ai.alpha = 1;
			var background:Asset = new Asset(this.ai);
			background.setFilter(AssetSetting.FILTER_GLOW, .5);
			
			this.ai.reset();
			this.ai.shape = AssetSetting.CIRCLE_SEGMENT;
			this.ai.width = radius;
			this.ai.height = 100;
			this.ai.color = fgColor;
			this.ai.alpha = 1;
			this.ai.customShapeSettings = [-90, -90];
			this.circleSegment = new Asset(this.ai);
			
			this.ai.reset();
			this.ai.shape = AssetSetting.DONUT;
			this.ai.width = radius;
			this.ai.customShapeSettings = [thickness];
			this.ai.alpha = 1;
			var mask:Asset = new Asset(this.ai);
			
			this.addChild(background);
			this.addChild(mask);
			this.circleSegment.mask = mask;
			
			this.addChild(this.circleSegment);
			
			// -------------------------
			//	Calculate needed values
			// -------------------------
			this.radPerPercent = 360 / 100;
			this.circleSegment.newCustom1 = -90 + this.radPerPercent;
		}
		
		public function reset():void
		{
			this.circleSegment.newCustom1 = -90 + this.radPerPercent;
		}
		
		public function set progressPercentage(percentage:Number):void
		{
			this._progressPercentage = percentage;
			TweenMax.to(this.circleSegment, .5, {newCustom1:-90 + (this.radPerPercent * this._progressPercentage)});
		}
		
		public function get progressPercentage():Number
		{
			return this._progressPercentage;
		}
	}
}