package com.graphics
{
	import flash.display.Sprite;
	
	public class Grid extends Sprite
	{
		public static const WIDTH_LEADING:String = 'width_leading';
		public static const HEIGHT_LEADING:String = 'height_leading';
		public static const STRETCH:String = 'stretch';
		
		public function draw(width:Number, height:Number, rectangles:int, leading:String):void
		{
			var verticalLineSpacing:int = width / rectangles;
			var horizontalLineSpacing:int = height / rectangles;
			
			var vs:int;
			var hs:int;
			
			switch(leading)
			{
				case WIDTH_LEADING:
				vs = verticalLineSpacing;
				hs = verticalLineSpacing;
				break;
				case HEIGHT_LEADING:
				vs = horizontalLineSpacing;
				hs = horizontalLineSpacing;
				break;
				case STRETCH:
				vs = verticalLineSpacing;
				hs = horizontalLineSpacing;
				break;
				default:
				throw new Error('Class: Grid  |  Method: draw  |  ERROR: no leading defined');
			}
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xCCCCCC, 1, true);
			
			for (var i:int = 0 ; i < (rectangles + 1) ; i++)
			{
				//Vertical lines
				this.graphics.moveTo(i * vs, 0);
				this.graphics.lineTo(i * vs, height);
				
				//Horizontal lines
				this.graphics.moveTo(0, i * hs);
				this.graphics.lineTo(width, i * hs);
			}
			
			this.alpha = .3;
		}
	}
}
