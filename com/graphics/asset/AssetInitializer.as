/**
 *	Asset Dependancy Object
 */
package com.graphics.asset
{
	import com.graphics.asset.AssetSetting;
	
	public final class AssetInitializer
	{
		public var shape				:String;
		public var width				:Number;
		public var height				:Number;
		public var color				:uint;
		public var alpha				:Number;
		public var vectorAlpha			:Number;
		public var mask					:Boolean;
		public var borderThickness		:Number;
		public var borderColor			:uint;
		public var customShapeSettings 	:Array;
		public var image				:String;
		public var sound				:String;
		public var autoHeight			:Boolean;
		
		public function AssetInitializer()
		{
			this.reset();
		}
		
		public function reset():void
		{
			this.shape = AssetSetting.RECT;
			this.width = 10;
			this.height = 10;
			this.color = 0x000000;
			this.alpha = 1;
			this.vectorAlpha = 0;
			this.mask = false;
			this.borderThickness = 0;
			this.borderColor = 0;
			this.customShapeSettings = null;
			this.image = '';
			this.sound = '';
			this.autoHeight = false;
		}
	}
}