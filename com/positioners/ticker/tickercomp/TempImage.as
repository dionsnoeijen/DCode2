package com.positioners.ticker.tickercomp
{
	import flash.display.Shape;

	public class TempImage extends Shape
	{
		public function TempImage(color:uint = 0xFF0000)
		{
			this.graphics.clear();
			this.graphics.beginFill(color, 1);
			this.graphics.drawRect(0, 0, 6, 1000);
			this.graphics.endFill();
		}
	}
}