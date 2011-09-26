package com.parsers
{
	public class Validation
	{
		public static function eMail(pString:String):Boolean
		{
			var regExpPattern : RegExp = /^[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;
			if(pString.match(regExpPattern) == null)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
	}
}