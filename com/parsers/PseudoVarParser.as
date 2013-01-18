/**
 * PseudoVarParser
 *
 * Author: Dion Snoeijen
 *
 * Parse psuedo variables into Array's
 * 
 * example:
 * {apsbb:form action="http://www.example.com/index.php/formactions.php"}
 * {inputfield name="Name" width="300" height="300"}
 * {checkbox name="Mailing"}
 * {radiobutton name="Aanhef" options="Mr, Mrs"}
 * {/apsbb:form}
 *
 */
package com.parsers
{
	import com.tools.StringUtils;
	
	/**
	 * <code>PseudoVarParser</code>
	 * Pseudo Variable Parser
	 */
	public class PseudoVarParser
	{
		/**
		 *	function formParser. 
		 * 	Get apsbb tag with form data and return as Array
		 */
		public static function formParser(pString:String):Array
		{
			var returnArray:Array = new Array();
			
			var mainTagAttributes:String = StringUtils.between(pString, 'action="', '"');
			
			// -------------------------
			//	REG EXP van maken!!
			// -------------------------
			var parsingStages:Array = new Array();
			parsingStages.push(StringUtils.between(pString, '{apsbb:form', '{/apsbb:form}'));
			parsingStages.push(StringUtils.remove(parsingStages[0], '\n', true));
			parsingStages.push(StringUtils.remove(parsingStages[1], '<p>', true));
			parsingStages.push(StringUtils.remove(parsingStages[2], '</p>', true));
			parsingStages.push(StringUtils.remove(parsingStages[3], '<br />', true));
			
			// -------------------------
			//	parsingStages.push(StringUtils.remove(parsingStages[4], 'action="' + mainTagAttributes + '"', true));
			// -------------------------
			var allSingleVariables:String = parsingStages[parsingStages.length - 1];
			var singleVariables:Array = allSingleVariables.split('}');
			
			var i:int = 0;
			for each(var singleVariable:String in singleVariables)
			{
				if(singleVariable != '')
				{
					returnArray.push(new Array());	
				}
				
				var attributes:Array = singleVariable.split(' ');
								
				for each(var attribute:String in attributes)
				{
					if(attribute != '')
					{
						if(attribute.substr(0, 1) == '{')
						{
							returnArray[i].push(StringUtils.remove(attribute, '{', true));
						}
						else
						{
							returnArray[i].push(StringUtils.between(attribute, '"', '"'));
						}
					}
				}
				i++;
			}
			
			return returnArray;
		}
		
		public static function myspaceParser(pString:String):String
		{
			return StringUtils.between(pString, '{apsbb:myspace}', '{/apsbb:myspace}');
		}
		
		public static function linkedInParser(pString:String):String
		{
			return StringUtils.between(pString, '{apsbb:linkedin}', '{/apsbb:linkedin}');
		}
		
		public static function twitterParser(pString:String):String
		{
			return StringUtils.between(pString, '{apsbb:twitter}', '{/apsbb:twitter}');
		}
		
		public static function slideShareParser(pString:String):String
		{
			return StringUtils.between(pString, '{apsbb:slideshare}', '{/apsbb:slideshare}');
		}
		
		public static function faceBookParser(pString:String):String
		{
			return StringUtils.between(pString, '{apsbb:facebook}', '{/apsbb:facebook}');			
		}
	}
}