package com.pamakids.models
{
	import com.pamakids.utils.NodeUtil;
	import com.pamakids.utils.ObjectUtil;

	public class BaseVO
	{
		public function BaseVO()
		{
		}

		private var _updator:Object;
		private var _creator:Object;
		protected var _user:Object;
		protected var userField:String='worker_id';
		protected var required:Array=[];

		public function get user():Object
		{
			return _user ? _user.member_id : null;
		}

		public function set user(value:Object):void
		{
			_user=value;
		}

		public function get updator():Object
		{
			return _updator ? _updator[userField] : null;
		}

		public function set updator(value:Object):void
		{
			_updator=value;
		}

		public function get creator():Object
		{
			return _creator ? _creator[userField] : null;
		}

		public function set creator(value:Object):void
		{
			_creator=value;
		}

		private var _created_at:String;
		private var _updated_at:String;

		public var _id:String;

		public function get updated_at():String
		{
			return NodeUtil.getTime(_updated_at);
		}

		public function set updated_at(value:String):void
		{
			_updated_at=value;
		}

		public function get created_at():String
		{
			return NodeUtil.getTime(_created_at);
		}

		public function set created_at(value:String):void
		{
			_created_at=value;
		}

		public function toString():String
		{
			var arr:Array=ObjectUtil.getClassInfo(this).properties as Array;
			var s:String;
			for each (var q:QName in arr)
			{
				s+=q.localName + ' = ' + this[q.localName] + '\n';
			}
			return s;
		}

		public function getBaseInfos():String
		{
			var s:String='创建时间：' + created_at + '\t' + '创建人：' + creator;
			if (updator)
				s='更新时间：' + updated_at + '\t' + '更新者：' + updator + '\n' + s;
			return s;
		}

		public var invalidMessage:String;

		public function isValidate():Boolean
		{
			for each (var p:String in required)
			{
				var value:Object=this[p];
				if (value != false && value != 0 && !value)
					return false;
			}
			return true;
		}

		public static function jsonArray(arr:Array):Array
		{
			var a:Array=[];
			for each (var o:Object in arr)
			{
				a.push(JSON.stringify(o));
			}
			return a;
		}

		/**
		 * 忽略更新的项
		 */
		public function getIgnoreFields():Array
		{
			return null;
		}

		/**
		 * 获取值对象差值，用以更新数据对象时只更新有差异的属性
		 * @param source 源数据
		 * @param newSource 新数据
		 * @return 最终提交更新的数据
		 */
		public static function diff(source:BaseVO, newSource:BaseVO):Object
		{
			var diff:Object;
			var arr:Array=ObjectUtil.getClassInfo(source).properties as Array;
			var ignore:Array=source.getIgnoreFields();
			for each (var q:QName in arr)
			{
				if (ignore && ignore.indexOf(q.localName) != -1)
					break;
				if (newSource.hasOwnProperty(q.localName))
				{
					if (newSource[q.localName] != source[q.localName] && newSource[q.localName] != null)
					{
						if (!diff)
						{
							diff={};
							diff._id=source._id;
						}
						var oa:Array=newSource[q.localName] as Array;
						if (oa)
						{
							var sa:Array=source[q.localName] as Array;
							if (!compareArray(oa, sa))
								diff[q.localName]=oa;
						}
						else
						{
							diff[q.localName]=newSource[q.localName];
						}
					}
				}
			}
			return diff;
		}

		private static function compareArray(a1:Array, a2:Array):Boolean
		{
			var equal:Boolean=true;
			if (a1 && a1.length != a2.length || !a1)
			{
				equal=false;
			}
			else if (a1.length == a2.length)
			{
				for (var i:int; i < a1.length; i++)
				{
					if (a1[i] != a2[i])
					{
						equal=false;
						break;
					}
				}
			}
			return equal;
		}
	}
}
