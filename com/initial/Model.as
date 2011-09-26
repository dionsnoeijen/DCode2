package com.initial
{
	import com.debug.Print;
	import com.events.ModelEvent;
	import com.initial.GlobalStage;
	import com.tools.StringUtils;
	import com.data.Root;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Model extends EventDispatcher
	{
		// ---------------------------
		//	Public
		// ---------------------------
		public var debugging:Boolean;
		
		// ---------------------------
		//	Get / Set
		// ---------------------------
		private var _xml	:XML;
		
		// ---------------------------
		//	Cache
		// ---------------------------
		private var _cacheID	:String;
		private var _cache		:Array;
		
		public function Model()
		{
			// ---------------------------
			//	Construct
			// ---------------------------
			this._cache = new Array();
		}
		
		public function get cache():Array
		{
			return this._cache;
		}
		
		public function set cache(c:Array):void
		{
			this._cache = c;
		}
		
		public function get cacheID():String
		{
			return this._cacheID;
		}
		
		public function set cacheID(cID:String):void
		{
			this._cacheID = cID;
		}
		
		public function getData(source:String):void
		{
			var loaderPath:String;
			
			// ---------------------------
			//	Is it a path, or a flashvar
			// ---------------------------
			if(StringUtils.contains(source, 'http://'))
			{
				loaderPath = source;
			}
			else
			{
				loaderPath = Root.parameter(GlobalStage.stageInstance, source);
			}
			
			if(this.debugging)
				trace('Path to load:', loaderPath);
			
			var l:URLLoader = new URLLoader(new URLRequest(loaderPath));
			l.addEventListener(Event.COMPLETE, lComplete);
		}
		
		private function lComplete(e:Event):void
		{
			if(this.debugging)
				trace('Model.lComplete');
			
			this._xml = new XML(e.currentTarget.data);
			
			if(this.debugging)
				trace(this._xml);
			
			this.dispatchEvent(new Event(ModelEvent.DATA_LOADED, true));
		}
		
		public function get xml():XML
		{
			return this._xml;
		}
	}
}