// ActionScript file
package com.graphics.patterns
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;

	public class Pattern extends Sprite
	{
		public static const RECT:String = 'rect';
		public static const RECT_BLUR:String = 'rect_blur';
		
		public function Pattern(type:String):void
		{
			switch(type)
			{
				case RECT:
					this.rectangles();
					break;
				case RECT_BLUR:
					this.rectangles();
					this.blur();
					break;
				default:
					throw new Error('Class: Pattern  |  Method: Pattern (constructor)  |  ERROR: No pattern');
			}
		}
		
		private function rectangles():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, 2, 2);
			this.graphics.drawRect(3, 0, 2, 2);
			this.graphics.drawRect(0, 3, 2, 2);
			this.graphics.drawRect(3, 3, 2, 2);
			this.graphics.endFill();
		}
		
		private function blur():void
		{
			var blur:BlurFilter =	new BlurFilter(2, 2, BitmapFilterQuality.HIGH);
			
			this.filters = [blur];
		}
	}
}