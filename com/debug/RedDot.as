package com.debug
{
	import flash.display.Sprite;

	public class RedDot extends Sprite
	{
		public function RedDot(xPos:Number, yPos:Number):void
		{
			this.graphics.beginFill(0xFF0000, 1);
			this.graphics.drawCircle(0, 0, 4);
			this.graphics.endFill();
			
			this.x = xPos;
			this.y = yPos;
		}
	}
}