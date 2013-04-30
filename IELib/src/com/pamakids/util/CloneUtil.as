package com.pamakids.util
{
	import flash.utils.describeType;

	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	public class CloneUtil
	{
		public static function cloneArrayCollection(source:ArrayCollection, target:ArrayCollection):void
		{
			for each (var o:* in source)
			{
				target.addItem(o);
			}
		}

		public static function convertArrayToArrayCollection(arr:Array):ArrayCollection
		{
			var ac:ArrayCollection=new ArrayCollection();
			for each (var o:* in arr)
			{
				ac.addItem(o);
			}
			return ac;
		}

		public static function copyValue(source:Object, target:Object, force:Boolean=false):void
		{
			var arr:Array=ObjectUtil.getClassInfo(source).properties as Array;
			for each (var q:QName in arr)
			{
				if (target.hasOwnProperty(q.localName) || force)
				{
					if (source[q.localName] || source[q.localName] == '')
						target[q.localName]=source[q.localName];
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
							if (autoArrayToAC)
							{
								var type:String=accessor.@type;
								var a:Array=source[name] as Array;
								if (type == 'mx.collections::ArrayCollection')
								{
									if (a)
										o[name]=new ArrayCollection(a);
								}
								else
								{
									o[name]=source[name];
								}
							}
							else
							{
								o[name]=source[name];
							}
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

