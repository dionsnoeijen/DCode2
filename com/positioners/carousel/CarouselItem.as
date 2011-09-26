package com.positioners.carousel 
{
	import com.graphics.asset.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 3D items for MouseCarousel class
	 * @author Devon O.
	 * @changed Dion Snoeijen
	 * @reason Implement into DCode framework
	 */
	public class CarouselItem extends Sprite 
	{
		private var _radius		:Number;
		private var _radians	:Number;
		private var _angle		:Number;
		private var _focalLength:int;
		private var _orgZPos	:Number;
		private var _orgYPos	:Number;
		private var _data		:BitmapData;
		
		private var _zpos:Number;
		
		public function CarouselItem(image:Asset):void 
		{
			image.x -= image.visibleWidth * .5;
			image.y -= image.visibleHeight * .5;
			updateDisplay();
			addChild(image);
		}
		
		internal function updateDisplay():void 
		{
			var angle:Number = this._angle + this._radians;
			var xpos:Number = Math.cos(angle) * this._radius;
			this._zpos = _orgZPos + Math.sin(angle) * this._radius;
			var scaleRatio:Number = this._focalLength / (this._focalLength + this._zpos);
			x = xpos * scaleRatio;
			y = this._orgYPos * scaleRatio;
			scaleX = scaleY = scaleRatio;
		}
		
		internal function get angle():Number {return this._angle;}
		
		internal function set angle(value:Number):void {this._angle = value;}
		
		internal function get radius():Number {return this._radius;}
		
		internal function set radius(value:Number):void {this._radius = value;}
		
		internal function get focalLength():int {return this._focalLength;}
		
		internal function set focalLength(value:int):void {this._focalLength = value;}
		
		internal function get radians():Number {return this._radians;}
		
		internal function set radians(value:Number):void {this._radians = value;}

		public function get zpos():Number {return this._zpos;}
		
		public function set zpos(value:Number):void {this._orgZPos = value;}
		
		internal function set ypos(value:Number):void {this._orgYPos = value;}
		
		internal function get data():BitmapData {return _data;}
	}
}