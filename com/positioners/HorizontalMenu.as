package com.positioners
{
	import com.graphics.asset.Asset;
	
	import flash.display.Sprite;
	
	public final class HorizontalMenu extends Sprite
	{
		public function HorizontalMenu(items:Array, mainButtonNodeName:String, subButtonNodeName:String):void
		{
			var horizCounter:int;
			var vertCounter:int;
			var xPos:Number;
			var yPos:Number;
				
			for each(var item:Array in items)
			{
				if(item[0] == mainButtonNodeName)
				{
					var button:Asset = new Asset(Asset.RECT, 100, 40);
					vertCounter = 0; //Reset vertCounter for correct yPos calculation.
					xPos = 102 * horizCounter;
					button.x = xPos;
					button.makeButton();
					this.addChild(button);
					horizCounter++;
				}
				else
				{
					if(vertCounter == 0)
					{
						var subMenuContainer:Sprite = new Sprite();
						var subMenuMask:Sprite = new Sprite();
						subMenuMask.graphics.beginFill(0x000000);
						subMenuContainer.addChild(subMenuMask);
						subMenuContainer.mask = subMenuMask;
						subMenuContainer.x = xPos;
						subMenuContainer.y = 42;
						this.addChild(subMenuContainer);
					}
					var subButton:Asset = new Asset(Asset.RECT, 100, 40);
					yPos = 42 * vertCounter; 
					subButton.y = yPos;
					subButton.makeButton();
					subMenuContainer.addChild(subButton);
					vertCounter++;
				}
			}
		} 
	}
}