package com.pamakids.utils
{
	import flash.utils.getDefinitionByName;

	public class DynamicInstance
	{
		public function DynamicInstance()
		{
		}

		public static function getInstance(className:String):Object
		{
			var c:Class=getDefinitionByName(className) as Class;
			return new c();
		}
	}
}
