package com.controls
{
	import com.events.AssetEvent;
	import com.graphics.asset.*;
	import com.greensock.TweenMax;
	import com.tools.FindClosest;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class HorizontalSlider extends Sprite
	{
		private var ai				:AssetInitializer;
		private var bg				:Asset;
		private var fg				:Asset;
		private var padding			:Number;
		
		private var bgComplete		:Boolean;
		private var fgComplete		:Boolean;
		public var debugging		:Boolean = false;
		
		public static const CHANGE:String = 'change';
		public static const IMAGES_LOADED:String = 'images_loaded';
		
		public function HorizontalSlider(bgPath:String = null,
										 fgPath:String = null,
										 bgBitmap:Bitmap = null,
										 fgBitmap:Bitmap = null,
										 bgAlpha:Number = 0,
										 fgAlpha:Number = 0,
										 bgWidth:Number = 10, 
										 bgHeight:Number = 10, 
										 fgWidth:Number = 10,
										 fgHeight:Number = 10,
										 bgColor:uint = 0xFFFFFF, 
										 fgColor:uint = 0xFFFFFF,
										 padding:Number = 2):void
		{
			this.padding = padding;
			
			// -------------------------
			//	First, create the background
			// -------------------------
			this.ai = new AssetInitializer();
			this.ai.width = bgWidth;
			this.ai.height = bgHeight;
			this.ai.color = bgColor;
			this.ai.alpha = bgAlpha;
			this.bg = new Asset(this.ai);
			
			// -------------------------
			//	Then, the foreground
			// -------------------------
			this.ai.reset();
			this.ai.width = fgWidth;
			this.ai.height = fgHeight;
			this.ai.color = fgColor;
			this.ai.alpha = fgAlpha;
			this.fg = new Asset(this.ai);
			this.fg.makeButton();
			
			if(bgPath)
			{
				this.bg.setImage(bgPath, AssetSetting.ASSET_TO_IMAGE);
				this.bg.addEventListener(AssetEvent.IMAGE_COMPLETE, bgImageComplete);
			}
			else if(bgBitmap)
			{
				this.bgComplete = true;
				this.bg.setBitmap(bgBitmap);
				if(this.bgComplete && this.fgComplete)
					this.startBuild();
			}	
			else
			{
				this.bgComplete = true;
				if(this.bgComplete && this.fgComplete)
					this.startBuild();
			}
			
			if(fgPath)
			{
				this.fg.setImage(fgPath, AssetSetting.ASSET_TO_IMAGE);
				this.fg.addEventListener(AssetEvent.IMAGE_COMPLETE, fgImageComplete);
			}
			else if(fgBitmap)
			{
				this.fgComplete = true;
				this.fg.setBitmap(fgBitmap);
				if(this.fgComplete && this.bgComplete)
					this.startBuild();
			}
			else
			{
				this.fgComplete = true;
				if(this.fgComplete && this.bgComplete)
					this.startBuild();
			}
		}
		
		private function bgImageComplete(e:Event):void
		{
			if(this.debugging)
				trace('bg loaded');
			
			this.bgComplete = true;
			if(this.bgComplete && this.fgComplete)
				this.startBuild();
		}
		
		private function fgImageComplete(e:Event):void
		{
			if(this.debugging)
				trace('fg loaded');
			
			this.fgComplete = true;
			if(this.fgComplete && this.bgComplete)
				this.startBuild();
		}
		
		private var maxX:Number;
		private function startBuild():void
		{	
			if(this.debugging)
				trace('starting build');
			
			this.addChild(this.bg);			
			this.maxX = (this.bg.visibleWidth - this.fg.visibleWidth) - (padding * 2);
			this.fg.addEventListener(MouseEvent.MOUSE_DOWN, fgDown);
			this.fg.x = this.fg.y = this.padding;
			this.addChild(this.fg);
			
			this.dispatchEvent(new Event(HorizontalSlider.IMAGES_LOADED));
			
			if(this.debugging)
				trace('bg width:', this.bg.visibleWidth, 'maxX:', this.maxX);
		}
		
		private var startX:Number;
		private function fgDown(e:MouseEvent):void
		{
			this.startX = this.fg.mouseX;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
		}
		
		private function stageMove(e:MouseEvent):void
		{
			this.fg.x = (this.mouseX - this.startX);		
			
			if(this.fg.x < this.padding)
			{
				this.fg.x = this.padding;
			}
			else if(this.fg.x > this.maxX)
			{
				this.fg.x = this.maxX;
			}
			
			this.dispatchEvent(new Event(CHANGE));
		}
		
		private function stageUp(e:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stageUp);
		}
		
		public function set position(percentage:Number):void
		{
			var posX:Number = Number((this.maxX / 100) * percentage);
			this.fg.x = posX;
			if(this.fg.x < this.padding)
			{
				this.fg.x = this.padding;
			}
			else if(this.fg.x > this.maxX)
			{
				this.fg.x = this.maxX;
			}
		}
		
		private var _position:Number;
		public function get position():Number
		{
			_position = (100 / (this.maxX - this.padding)) * (this.fg.x - this.padding);
			
			return _position;
		}
	}
}