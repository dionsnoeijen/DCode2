package com.controls
{
	import flash.display.Sprite;

	public class RadioButton extends Sprite
	{
		public var status:Boolean;
		public var vars:Object = {};
		private var on:Sprite;
		
		public var debugging:Boolean = false;
		
		public function RadioButton(color:uint = 0xCCCCCC, backgroundColor:uint = 0xFFFFFF, radius:Number = 7, padding:Number = 1):void
		{
			this.status = false;
			
			this.drawBackground(color, backgroundColor, radius);
			
			var onRadius:Number = radius - (2 * padding);
			
			this.on = new Sprite();
			this.on.graphics.beginFill(color, 1);
			this.on.graphics.drawCircle(0, 0, 5);
			this.on.graphics.endFill();
			
			this.on.x = this.on.y = (padding / onRadius) / 2;
			
			this.on.mouseEnabled = false;
			this.on.alpha = 0;
			
			this.buttonMode = true;
			
			this.addChild(this.on);
		}
		
		public function drawBackground(color:uint = 0xCCCCCC, backgroundColor:uint = 0xFFFFFF, radius:Number = 7):void
		{
			this.graphics.lineStyle(1, color, 1, true);
			this.graphics.beginFill(backgroundColor, 1);
			this.graphics.drawCircle(0, 0, radius);
			this.graphics.endFill();
		}
		
		public function turnOff():void
		{
			this.status = false;
			this.on.alpha = 0;
			
			if(debugging)
				trace('RadioButton.turnOff();');
		}
		
		public function turnOn():void
		{
			this.status = true;
			this.on.alpha = 1;
			
			if(debugging)
				trace('RadioButton.turnOn();');
		}
		
		public function get text():Boolean
		{
			return this.status;			
		}
	}
}