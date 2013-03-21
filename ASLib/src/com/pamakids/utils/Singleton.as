package com.pamakids.utils
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**46p
	 * 单例管理类
	 * @author mani
	 */
	public class Singleton extends EventDispatcher
	{
		private static var _constructingClass:Class;

		private static var _instances:Dictionary=new Dictionary();

		/**
		 *
		 */
		public function Singleton()
		{
			Singleton.registerInstance(this);
		}

		/**
		 *
		 * @param instance
		 */
		public static function registerInstance(instance:*):void
		{
			var con:*=(instance as Object).constructor;
			var qulifiedClassName:*=getQualifiedClassName(con);
			_instances[con]=instance;
		}

		/**
		 *
		 * @param c
		 */
		public static function destory(c:Class):void
		{
			delete _instances[c];
		}

		/**
		 *这里首先字典不怎么会用，这里太灵活了，新建一个类为什么没有（）；
		 * 最好解释一遍。
		 * @param c
		 * @return
		 */
		public static function getInstance(c:Class):*
		{
			var theClass:*=c;// 把传进来的类给当前类
			var ret:*=_instances[c];    // 先存到字典然后再赋值给ret
			if (ret == null)            //如果字典里面没有
			{
				_constructingClass=theClass;  //给静态类赋值了
				new theClass;                     // 新建一个类，为什么没有（）；
				ret=_instances[theClass];        // 什么意思不懂
				
			}
			return ret;                          // 返回ret               
		}
	}
}


