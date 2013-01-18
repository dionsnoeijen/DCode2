package com.initial
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	public class GlobalStage
	{
		// -------------------------
		//	Private Properties
		// -------------------------
		private static var instance:GlobalStage = null;
		private static var stage:Stage = null;
		
		// -------------------------
		//	Constructor
		// -------------------------
		public function GlobalStage(stageRef:Stage)
		{
			if(instance != null)
			{
				throw new Error("Error: GlobalStage can only be instantiated once.");
			}
			
			GlobalStage.instance = this;
			GlobalStage.stage = stageRef;
			
			// -------------------------
			//	Do we ever want it any different?
			// -------------------------
			GlobalStage.align = StageAlign.TOP_LEFT;
			GlobalStage.scaleMode = StageScaleMode.NO_SCALE;
			GlobalStage.quality = StageQuality.BEST;
		}
		
		// -------------------------
		//	Getters / Setters
		// -------------------------
		public static function get align():String
		{
			return GlobalStage.stage.align;
		}
		
		public static function set align(setting:String):void
		{
			GlobalStage.stage.align = setting;
		}
		
		public static function get scaleMode():String
		{
			return GlobalStage.stage.scaleMode;
		}
		
		public static function set scaleMode(setting:String):void
		{
			GlobalStage.stage.scaleMode = setting;
		}
		
		public static function get quality():String
		{
			return GlobalStage.stage.quality;	
		}
		
		public static function set quality(setting:String):void
		{
			GlobalStage.stage.quality = setting;
		}
		
		// -------------------------
		//	For more advanced contstuctions, return the entire stage object.
		// -------------------------
		public static function get stageInstance():Stage
		{
			return GlobalStage.stage;
		}
	}
}