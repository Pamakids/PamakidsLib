package com.pamakids.utils
{

	import flash.utils.describeType;

	public class CloneUtil
	{
		public static function copyValue(source:Object, target:Object, force:Boolean=false):void
		{
			var arr:Array=ObjectUtil.getClassInfo(source).properties as Array;
			for each (var q:QName in arr)
			{
				if (target.hasOwnProperty(q.localName) || force)
				{
					if (source[q.localName] || source[q.localName] == '')
					{
						var od:Object=source[q.localName];
						if (typeof od == 'object' && !(od is Array))
						{
							for (var p:* in od)
							{
								target[p]=od[p];
							}
						}
						else
						{
							target[q.localName]=od;
						}
					}
				}
			}
		}

		public static function cloneObject(source:Object, target:Object, force:Boolean=false):void
		{
			for (var p:* in source)
			{
				if (force || target.hasOwnProperty(p))
				{
					target[p]=source[p];
				}
			}
		}

		public static function cloneArray(source:Array):Array
		{
			var arr:Array=[];
			for each (var p:* in source)
			{
				arr.push(p);
			}
			return arr;
		}

		public static function convertObject(source:Object, tobeClass:*, autoArrayToAC:Boolean=false):*
		{
			try
			{
				if (!source)
					return null;
				var o:Object=new tobeClass();

				var objectXML:Object=describeType(o); //生成描述vo的xml
				var xmlList:Object=objectXML.accessor;
				var name:String;
				for each (var accessor:XML in xmlList)
				{
					if (accessor.@access != 'readonly')
					{
						name=accessor.@name;
						if (source.hasOwnProperty(name))
						{
							o[name]=source[name];
						}
					}
				}

				xmlList=objectXML.variable;
				for each (var accessor2:XML in xmlList)
				{
					if (accessor2.@access != 'readonly')
					{
						name=accessor2.@name;
						if (source.hasOwnProperty(name))
						{
							o[name]=source[name];
						}
					}
				}
			}
			catch (error:Error)
			{
				trace("ConvertObject Error:" + error);
			}

			return o;
		}

		public static function convertArrayObjects(source:Array, tobeClass:*, autoArrayToAC:Boolean=false):Array
		{
			var arr:Array=[]
			for each (var o:Object in source)
			{
				arr.push(convertObject(o, tobeClass, autoArrayToAC) as tobeClass);
			}
			return arr;
		}
	}
}

