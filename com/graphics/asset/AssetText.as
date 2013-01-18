package com.graphics.asset
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public final class AssetText
	{
		public var textProps:Object;
		public var CSSPath	:String; 
		public var html		:String;
		public var embedFont:Boolean; 
		public var padding	:Number;
		public var autoSize	:String; 
		public var font		:String;
		public var type		:String;
		
		public function AssetText()
		{
			this.reset();
		}
		
		public function reset():void
		{
			this.textProps = new Object();
			this.CSSPath = null; 
			this.html = '';
			this.embedFont = false; 
			this.padding = 5;
			this.autoSize = TextFieldAutoSize.NONE; 
			this.font = 'Arial';
			this.type = TextFieldType.DYNAMIC;
		}
	}
}