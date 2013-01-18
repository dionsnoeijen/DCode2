package com.helpers
{
	import com.tools.StringUtils;	
	
	public class FormValidation
	{
		/**
		 *	<code>isEmail(email:String):Boolean</code>
		 *  Simple check if we are dealing with an email adress
		 */		
		public static function isEmail(email:String):Boolean
		{
			var emailRegExp:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailRegExp.test(email);
		}
		
		/**
		 *	<code>hasValue(value:String):Boolean</code>
		 *  Simple check to see if there is any relevant information
		 */
		public static function hasValue(value:String):Boolean
		{
			var test:Boolean;
			
			if(value.length > 0)
			{		
				test = true;
			}
			else
			{
				test = false;
			}
			
			return test;
		}
	}
}