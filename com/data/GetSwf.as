/**
 * 	GetSwf
 *
 * 	Author: Dion Snoeijen
 * 	Date 02-04-2010
 * 
 *	Load swf by url
 */
package com.data
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class GetSwf extends Loader
	{
		public var mc:MovieClip;
		
		private var sd:Boolean = false;
		private var path:String;
		
		public function GetSwf(path:String, seperateDefinitions:LoaderContext = null):void
		{
			this.path = path;
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			if(seperateDefinitions)
			{
				this.sd = true;
				this.load(new URLRequest(path), seperateDefinitions);
			}
			else
			{
				this.load(new URLRequest(path));
			}
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, useData);
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			throw new Error("SWF CAN'T BE LOADED: " + this.path, e);
		}
		
		private function useData(e:Event):void
		{	
			if(!this.sd)
			{
				mc = new MovieClip();
				mc = MovieClip(this.content);
				mc.gotoAndStop(1);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}