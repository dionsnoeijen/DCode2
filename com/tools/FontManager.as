package com.tools 
{
 
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.errors.*;
	import flash.system.*;
 
	public class FontManager extends EventDispatcher 
	{
		private static  var INSTANCE:FontManager;
 
		private var _fontsDomain:ApplicationDomain;
		private var _styleSheet:StyleSheet;
 
		public function FontManager(enforcer:SingletonEnforcer) 
		{
			super();
		}
 
		public static function getInstance():FontManager 
		{
			if (INSTANCE == null) {
				INSTANCE = new FontManager(new SingletonEnforcer());
			}
			return INSTANCE;
		}
 
		public function initialize(fontsDomain:ApplicationDomain, styles:StyleSheet):void 
		{
			if (_fontsDomain == null) {
				_fontsDomain = fontsDomain;
				_styleSheet = styles;
			} else {
				throw new IllegalOperationError("FontManager already initialized!");
			}
		}
 
		public function registerFonts(fontList:Array):void 
		{
			for (var i:int = 0; i < fontList.length; i++) 
			{
				Font.registerFont(getFontClass(fontList[i]));
			}
		}
 
		public function getFontClass(id:String):Class 
		{
			return _fontsDomain.getDefinition(id)  as  Class;
		}
 
		public function getFont(id:String):Font 
		{
			var fontClass:Class = getFontClass(id);
			return new fontClass as Font;
		}
 
		public function getStyleSheet():StyleSheet 
		{
			return _styleSheet;
		}
 
	}
 
}
 
class SingletonEnforcer 
{
}
