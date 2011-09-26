package com.data
{
	import com.graphics.asset.Asset;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class Preloader extends Sprite
	{
		private var total			:int;
		private var counter			:int;
		
		private var targetStage		:Stage;
		private var blankScreen		:Asset;
		private var font 			:String;
		private var embed			:Boolean;
		
		private var preloaderPath	:String;
		
		private var color			:uint;
		
		public function Preloader(cStage:Stage, totalToBeLoaded:int, preloaderIcon:String = '', pColor:uint = 0xFFFFFF, pFont:String = 'Arial', pEmbed:Boolean = false):void
		{
			total = totalToBeLoaded;
			targetStage = cStage;
			color = pColor;
			embed = pEmbed;
			font = pFont;
			createPreloaderGraphics();
		}
		
		private function createPreloaderGraphics():void
		{
			blankScreen = new Asset(Asset.RECT, targetStage.stageWidth, targetStage.stageHeight, color);
			blankScreen.setText(null, '<b>LOADING 0%</b>');
			addChild(blankScreen);
		}
		
		public function count():void
		{
			counter++;
			
			var percentLoaded:Number = counter / total;
			percentLoaded = Math.round(percentLoaded * 100);
			
			blankScreen.setText({text:'<b>LOADING ' + String(percentLoaded) + '%</b>', color:0xFFFFFF, fontSize:12, top:(targetStage.stageHeight / 2) - 10, left:(targetStage.stageWidth / 2) - 80, font:font, embed:embed});
			
			//trace(percentLoaded);
			
			if(counter == total)
			{
				//trace('Preloading done, removing graphics.');
				TweenMax.to(blankScreen, 1, {alpha:0, onComplete:removeFromDisplayList});
				//blankScreen.fadeOut();
			}
		}
		
		private function removeFromDisplayList():void
		{
			removeChild(blankScreen);
		}
	}
}
