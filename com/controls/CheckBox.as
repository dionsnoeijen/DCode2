package com.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CheckBox extends Sprite
	{
		public var status:Boolean;
		private var on:Sprite;
		
		public function CheckBox(color:uint = 0xCCCCCC, bgColor:uint = 0xFFFFFF):void
		{
			this.status = false;
			
			this.graphics.lineStyle(1, color, 1);
			this.graphics.beginFill(bgColor, 1);
			this.graphics.drawRect(0, 0, 12, 12);
			this.graphics.endFill();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, thisDown);
			
			this.on = new Sprite();
			this.on.graphics.lineStyle(2, color, 1);
			this.on.graphics.moveTo(6, 0);
			this.on.graphics.lineTo(6, 12);
			this.on.graphics.moveTo(0, 6);
			this.on.graphics.lineTo(12, 6);
			this.on.x = 6;
			this.on.y = -3;
			this.on.rotation = 45;
	
			this.on.mouseEnabled = false;
			this.on.visible = false;
			
			this.addChild(this.on);
		}
		
		private function thisDown(e:MouseEvent):void
		{
			if(this.status)
			{
				this.status = false;
				this.on.visible = false;
			}
			else
			{
				this.status = true;
				this.on.visible = true;
			}
		}
		
		public function get text():Boolean
		{
			return this.status;		
		}
	}
}