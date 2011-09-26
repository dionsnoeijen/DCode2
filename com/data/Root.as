package com.data
{
	import flash.display.Stage;
	
	/**
	 * Simplify getting flashvars.
	 * While we are at it, also make sure it's not caring about upper/lower case.
	 * 
	 * @author
	 * Dion Snoeijen
	 */
	public final class Root
	{
		public static function parameter(stage:Stage, parameterName:String):String
		{
			for (var key:String in stage.root.loaderInfo.parameters)
			{
				if(key.toLowerCase() == parameterName.toLocaleLowerCase())
				{
					return stage.root.loaderInfo.parameters[key];
				}
			}
			
			return '';
		}	
	}
}