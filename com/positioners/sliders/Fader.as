package com.positioners.sliders
{
	import com.events.AssetEvent;
	import com.graphics.asset.*;
	import com.greensock.TweenMax;
	import com.initial.GlobalStage;
	
	import flash.display.Sprite;

	public class Fader extends Sprite
	{
		private var images:Vector.<Asset>;
		private var _currentImage:int;
		
		public function Fader(images:Vector.<Asset>)
		{
			this._currentImage = 0;
			
			this.images = new Vector.<Asset>();
			this.images = images;
			
			for each(var image:Asset in this.images)
			{
				image.visible = false;
				image.alpha = 0;
				this.addChild(image);
			}
			
			this.images[this._currentImage].visible = true;
			this.images[this._currentImage].alpha = 1;
		}
		
		private function makeAllImagesInactive():void
		{
			for each(var image:Asset in this.images)
			{
				if(image.visible)
					TweenMax.to(image, 1, {alpha:0, onComplete:fadeDoneDisableMe, onCompleteParams:[image]});	
			}
		}
		
		public function select(selector:int):void
		{
			var count:int = 0;
			if(selector != this._currentImage)
			{
				if(selector >= this._currentImage)
				{
					count = selector - this._currentImage;
					for (var i:int = 0 ; i < count ; i++)
					{
						this.next();
					}
				}
				else
				{
					count = this._currentImage - selector;
					for (var j:int = 0 ; j < count ; j++)
					{
						this.prev();
					}
				}
			}
		}
		
		public function next():void
		{
			this._currentImage++;
			if(this._currentImage >= this.images.length)
			{
				this._currentImage = 0;
			}
			this.makeAllImagesInactive();
			this.images[this._currentImage].visible = true;
			TweenMax.to(this.images[this._currentImage], 1, {alpha:1});
		}
		
		public function prev():void
		{
			this._currentImage--;
			if(this._currentImage < 0)
			{
				this._currentImage = (this.images.length - 1);
			}
			this.makeAllImagesInactive();
			this.images[this._currentImage].visible = true;
			TweenMax.to(this.images[this._currentImage], 1, {alpha:1});
		}
		
		private function fadeDoneDisableMe(image:Asset):void
		{
			image.visible = false;
		}
	}
}