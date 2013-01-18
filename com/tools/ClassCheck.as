package com.tools
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class ClassCheck
	{
		public static function getClass(obj:Object):Class 
		{
			return Class(getDefinitionByName(getQualifiedClassName(obj))); 
		}
	}
}