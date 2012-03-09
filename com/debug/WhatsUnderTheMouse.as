package com.debug
{
	import com.debug.Print;
	import com.graphics.asset.*;
	import com.tools.ClassCheck;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 *	Use this class to see if there is mess under the click
	 */
	public class WhatsUnderTheMouse extends DisplayObjectContainer
	{
		public static function showMe(displayObject:DisplayObjectContainer, mPosX:Number, mPosY:Number):void
		{
			var mousePos:Point = new Point(mPosX, mPosY);
			var objects:Array = new Array();
			
			objects = displayObject.getObjectsUnderPoint(mousePos);
			
			var objectNames:Array = new Array();
			
			for (var i:int = 0 ; i < objects.length ; i++)
			{
				if(objects[i].name)
				{
					objectNames.push(objects[i].name);
					
					if(ClassCheck.getClass(objects[i]) == Asset)
					{
						var assetObject:Asset = Asset(objects[i]);
						assetObject.updateBorder();
						assetObject.visible = true;
						assetObject.alpha = 1;
						trace('*------- Asset Object Name:', assetObject.name, '-------*');
						trace('parent:', assetObject.parent, 'parentName:', assetObject.parent.name);
						trace('width:', assetObject.width, 'visibleWidth:', assetObject.visibleWidth);
						trace('height:', assetObject.height, 'visibleHeight:', assetObject.visibleHeight, "\n");
						trace('alpha:', assetObject.alpha);
						trace('x:', assetObject.x, 'y:', assetObject.y);
					}
				}
			}
			
			trace('\n*------- OBJECT NAMES -------*');
			Print.r(objectNames);
			trace('*------- OBJECTS ------*');
			Print.r(objects);
			trace('*------- END OBJECTS -------*');
		}
	}
}