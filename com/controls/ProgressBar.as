package com.controls
{
	import com.graphics.asset.*;
	import com.events.AssetEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class ProgressBar extends Sprite implements IProgressBar
	{
		private var barBackground:Asset;
		public var barProgress:Asset;
		
		private var _progressPercentage:Number = 0;
		private var padding:Number;
		
		private var ai:AssetInitializer;
		
		public function ProgressBar(barBackgroundPath:String = null, 
									width:Number = 10, 
									height:Number = 10, 
									color:uint = 0xFFFFFF, 
									alpha:Number = 0, 
									padding:Number = 4):void	
		{
			this.ai = new AssetInitializer();
			this.ai.shape = AssetSetting.RNDRECT;
			this.ai.alpha = alpha;
			this.ai.width = width;
			this.ai.height = height;
			this.ai.color = color;
			
			// -------------------------------
			//	Make sure the background is loaded and placed fist
			// -------------------------------
			this.padding = padding;
			
		 	this.barBackground = new Asset(this.ai);
			if(barBackgroundPath)
			{
				this.barBackground.setImage(barBackgroundPath, AssetSetting.ASSET_TO_IMAGE);
				this.barBackground.addEventListener(Event.COMPLETE, barBackgroundComplete);
			}
			else
			{
				this.addChild(this.barBackground);
				this.foreground();
			}
		}
		
		private function barBackgroundComplete(e:Event):void
		{
			this.addChild(this.barBackground);
			this.foreground();
		}
		
		private var fgBarWidth:Number;
		private var fgBarHeight:Number;
		private var pixelPerPercent:Number;
		private function foreground():void
		{
			// -------------------------------
			//	After the background is finished loading, start buidling the foreground
			// -------------------------------
			this.fgBarWidth = this.barBackground.visibleWidth - (this.padding * 2);
			this.fgBarHeight = this.barBackground.visibleHeight - (this.padding * 2);
			
			this.ai.color = 0xFFFFFF;
			this.ai.width = fgBarWidth;
			this.ai.height = fgBarHeight;
			this.ai.alpha = 1;
			
			this.barProgress = new Asset(this.ai);
			this.barProgress.x = this.barProgress.y = this.padding;
			this.barProgress.alpha = .7;
			
			this.pixelPerPercent = this.fgBarWidth / 100;
			
			this.updateProgressBar(this.pixelPerPercent);
			
			this.addChild(this.barProgress);
		}
		
		private function updateProgressBar(val:Number):void
		{
			if(val <= this.pixelPerPercent)
			{
				val = this.pixelPerPercent;
			}
			this.barProgress.updateShapeSize(val, this.fgBarHeight);
			this.dispatchEvent(new Event('updating_progress_bar'));
		}
		
		public function set progressPercentage(percentage:Number):void
		{
			this._progressPercentage = percentage;
			this.updateProgressBar(this.pixelPerPercent * this._progressPercentage);
		}
		
		public function get progressPercentage():Number
		{
			return this._progressPercentage;		
		}
	}
}