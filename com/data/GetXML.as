package com.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class GetXML extends EventDispatcher
	{
		private var _xml:XML;
		private var _name:String;
		private var _path:String;
		
		public function GetXML(path:String)
		{
			this._path = path;
			var l:URLLoader = new URLLoader(new URLRequest(this._path));
			l.addEventListener(Event.COMPLETE, lComplete);
		}
		
		private function lComplete(e:Event):void
		{
			this._xml = new XML(e.currentTarget.data);
			this._xml.ignoreComments = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get xml():XML
		{
			return this._xml;
		}
		
		public function get name():String
		{
			return this._name;
		}
		
		public function set name(value:String):void
		{
			this._name = value;
		}
		
		public function get path():String
		{
			return this._path;
		}
	}
}