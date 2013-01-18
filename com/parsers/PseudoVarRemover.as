package com.parsers
{
	import com.tools.StringUtils;
	
	public class PseudoVarRemover
	{
		public static function removeAllPseudoVars(pString:String):String
		{
			var findPseudoVars:String = StringUtils.between(pString, '{apsbb:', '{/apsbb:');
			var findEndTag:String = StringUtils.between(pString, '{/apsbb:', '}');
			pString = StringUtils.remove(pString, '{apsbb:' + findPseudoVars + '{/apsbb:' + findEndTag + '}');

			return pString;
		}
	}
}