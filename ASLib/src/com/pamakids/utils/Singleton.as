package com.pamakids.utils
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
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
		 *
		 * @param c
		 * @return
		 */
		public static function getInstance(c:Class):*
		{
			var theClass:*=c;
			var ret:*=_instances[c];
			if (ret == null)
			{
				_constructingClass=theClass;
				new theClass;
				ret=_instances[theClass];
			}
			return ret;
		}
	}
}


