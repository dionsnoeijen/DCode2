package com.positioners.sliders
{
	import com.events.AssetEvent;
	import com.graphics.asset.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.initial.GlobalStage;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Fader extends Sprite
	{
		private var images:Vector.<Asset>;
		private var _currentImage:int;
		private var _timer:int;
		private var _transitionTime:int;
		
		public var debugging:Boolean = false;
		
		public function Fader(images:Vector.<Asset>, timer:int = 3, transitionTime:int = 1)
		{
			this._currentImage = 0;
			this._timer = timer * 1000;
			this._transitionTime = transitionTime;
			
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
		
		private var _kenBurns:Boolean = false;
		public function startKenBurns():void
		{
			if(this.debugging)
				trace('START KEN BURNS');
			
			this._kenBurns = true;
			this.kenBurns();
		}
		
		public function killCurrentKenBurnsTween():void
		{
			if(this.debugging)
				trace('KILL KEN BURNS TWEEN');
			
			this.kbTween.kill();
		}
		
		public function stopKenBurns():void
		{
			if(this.debugging)
				trace('STOP KEN BURNS');
			
			this._kenBurns = false;
			for each(var image:Asset in this.images)
			{
				image.img.x = 0;
				image.img.y = 0;
				this._kenBurns = false;
			}
		}
		
		private var t:Timer;
		public function autoPlay():void
		{
			if(this.debugging)
				trace('AUTO PLAY');
			
			if(!this.t)
			{
				this.t = new Timer(this._timer);
				this.t.addEventListener(TimerEvent.TIMER, this.autoNext);
			}
			this.t.start();
		}
		
		public function stopAutoPlay():void
		{
			if(this.debugging)
				trace('STOP AUTOPLAY');
			
			this.t.stop();
			this.t.reset();
			this.select(0);
		}
		
		private function autoNext(e:TimerEvent):void
		{
			this.next();	
		}
		
		public function getItem(index:int):Asset
		{
			return this.images[index];
		}
		
		private function makeAllImagesInactive():void
		{
			for each(var image:Asset in this.images)
			{
				if(image.visible)
					TweenMax.to(image, this._transitionTime, {alpha:0, onComplete:fadeDoneDisableMe, onCompleteParams:[image]});	
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
			
			if(this._kenBurns)
			{
				this.kenBurns();
			}
			
			TweenMax.to(this.images[this._currentImage], this._transitionTime, {alpha:1});
		}
		
		private var kbTween:TweenMax;
		private function kenBurns():void
		{
			var currentAsset:Asset = this.images[this._currentImage];
			var currentImg:Sprite = this.images[this._currentImage].img;
			var toX:int = 0;
			var toY:int = -((currentImg.height - currentAsset.visibleHeight) / 2); 
			var scale:Number = currentAsset.visibleWidth / currentImg.width;
			
			if(this.images[this._currentImage].img.y == toY)
			{
				toX = 0;
				toY = 0;
				scale = 1;
			}
			this.kbTween = new TweenMax(currentImg, this._timer / 1000, {x:toX, y:toY, ease:Linear.easeNone, scaleX:scale, scaleY:scale, onComplete:this.dispatchTweenComplete});	
		}
		
		private function dispatchTweenComplete():void
		{
			if(this.debugging)
				trace('KEN BURNS TWEEN COMPLETE');
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
			TweenMax.to(this.images[this._currentImage], this._transitionTime, {alpha:1});
		}
		
		private function fadeDoneDisableMe(image:Asset):void
		{
			image.visible = false;
		}
	}
}