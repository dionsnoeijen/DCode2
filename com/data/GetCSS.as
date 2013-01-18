/**
 * 	GetCSS
 *  
 *  Author: Dion Snoeijen
 *  
 * 	Description:
 *  Load css files to styling text.
 *  Only load's the same css file once.
 */
package com.data
{
	import com.data.GlobalDataContainer;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	
	public final class GetCSS extends StyleSheet
	{
		public function GetCSS():void
		{	
			//Empty constructor.
			//GetCSS functionality splitted from constructor to be able to add event listener in right order.
		}
		
		public function getCSS(path:String):void
		{
			if(GlobalDataContainer.vars.cssl == undefined) 
			{
				GlobalDataContainer.vars.cssl = new URLLoader();
				GlobalDataContainer.vars.cssl.addEventListener(Event.COMPLETE, returnNewStylesheet);
				GlobalDataContainer.vars.cssl.addEventListener(IOErrorEvent.IO_ERROR, ioError);
				GlobalDataContainer.vars.cssl.load(new URLRequest(path));
			}
			else
			{
				if(!GlobalDataContainer.vars.cssLoaded)
				{
					GlobalDataContainer.vars.cssl.addEventListener(Event.COMPLETE, returnPrevStylesheet);
				}
				else
				{
					this.returnStoredCSS();
				}
			}
		}
		
		private function ioError(e:ErrorEvent):void
		{
			trace('CSS FILE KON NIET WORDEN GELADEN', e);
		}
		
		private function returnNewStylesheet(e:Event):void
		{
			this.parseCSS(e.target.data);
			GlobalDataContainer.vars.css = e.target.data;
			
			GlobalDataContainer.vars.cssLoaded = true;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function returnPrevStylesheet(e:Event):void
		{
			this.parseCSS(GlobalDataContainer.vars.css);
			
			GlobalDataContainer.vars.cssLoaded = true;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function returnStoredCSS():void
		{	
			this.parseCSS(GlobalDataContainer.vars.css);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}