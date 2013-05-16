package com.pamakids.utils
{

	public class StringUtil
	{
		public function StringUtil()
		{
		}

		/**
		 * 从字符串获取名称，比如/folder/file.extension，得到file
		 * @param string e.g /folder/file.extension
		 * @reutrn e.g file
		 */
		public static function getName(string:String):String
		{
			return string ? string.substring(string.lastIndexOf('/') + 1, string.lastIndexOf('.')) : '';
		}

		public static function getType(string:String):String
		{
			return string ? string.substring(string.lastIndexOf('.')) : '';
		}
	}
}
