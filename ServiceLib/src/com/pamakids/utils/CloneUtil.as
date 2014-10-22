package com.pamakids.utils
{

	import flash.utils.describeType;

	/**
	 * 克隆工具
	 * @author mani
	 */
	public class CloneUtil
	{
		/**
		 * 复制值
		 * @param source 源
		 * @param target 目标
		 * @param force  是否强制复制所有值
		 *
		 */
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

		/**
		 * 克隆数值
		 */
		public static function cloneArray(source:Array):Array
		{
			var arr:Array=[];
			for each (var p:* in source)
			{
				arr.push(p);
			}
			return arr;
		}

		/**
		 * 转换对象类型
		 * @param source 源对象
		 * @param tobeClass 转换的类
		 * @return 返回新类型的对象
		 */
		public static function convertObject(source:Object, tobeClass:*):*
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

		/**
		 * 转换整个数组的对象
		 * @param source 源数组
		 * @param tobeClass 转换的目标类型
		 * @return 新类型对象的数组
		 */
		public static function convertArrayObjects(source:Array, tobeClass:*):Array
		{
			var arr:Array=[]
			for each (var o:Object in source)
			{
				var oo:Object=convertObject(o, tobeClass) as tobeClass;
				if (oo)
					arr.push(oo);
			}
			return arr;
		}
	}
}

