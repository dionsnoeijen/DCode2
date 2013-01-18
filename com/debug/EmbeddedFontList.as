package com.debug
{
	import flash.text.Font;

	public class EmbeddedFontList
	{
		public static function fontList():void
		{
			var embeddedFonts:Array = Font.enumerateFonts(false);
			embeddedFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			if(embeddedFonts.length > 0)
			{
				for(var font:String in embeddedFonts)
				{
					trace("font: " + embeddedFonts[font].fontName);
				}
			}
			else
			{
				trace('No Fonts Embedded');
			}
		}
	}
}