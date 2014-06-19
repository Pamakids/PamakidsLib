package com.pamakids.models
{
	import com.pamakids.utils.ObjectUtil;

	/**
	 * VO基类
	 * @author mani
	 */
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
			return getTimeDetail(_updated_at);
		}

		public function set updated_at(value:String):void
		{
			_updated_at=value;
		}

		public function get created_at():String
		{
			return getTimeDetail(_created_at);
		}

		private function getTimeDetail(time:String):String
		{
			if (!time)
				return '';
			var a1:Array=time.split('T');
			var ymd:String=a1[0];
			var hms:String=a1[1].split('.')[0];
			return time ? ymd + ' ' + hms : null;
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

		public function getDelay():String
		{
			var c:String=created_at;
			var date:Date=new Date();

			var y0:Number=Number(c.substr(0, 4));
			var y1:Number=date.getUTCFullYear();
			if (y1 > y0)
			{
				return (y1 - y0).toString() + '年前';
			}

			var m0s:String=c.substr(5, 2);
			var m0:Number=m0s.charAt(0) == '0' ? Number(m0s.substr(1, 1)) : Number(m0s);
			var m1:Number=date.getUTCMonth() + 1;
			if (m1 > m0)
			{
				return (m1 - m0).toString() + '月前';
			}

			var d0s:String=c.substr(8, 2);
			var d0:Number=d0s.charAt(0) == '0' ? Number(d0s.substr(1, 1)) : Number(d0s);
			var d1:Number=date.getUTCDate();
			if (d1 > d0)
			{
				return (d1 - d0).toString() + '天前';
			}

			var h0s:String=c.substr(11, 2);
			var h0:Number=h0s.charAt(0) == '0' ? Number(h0s.substr(1, 1)) : Number(h0s);
			var h1:Number=date.getUTCHours();
			if (h1 > h0)
			{
				return (h1 - h0).toString() + '小时前';
			}

			var mi0s:String=c.substr(14, 2);
			var mi0:Number=mi0s.charAt(0) == '0' ? Number(mi0s.substr(1, 1)) : Number(mi0s);
			var mi1:Number=date.getUTCMinutes();
			if (mi1 > mi0)
			{
				return (mi1 - mi0).toString() + '分钟前';
			}

			return '刚刚';

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
				{
					invalidMessage='必填项未填，请检查后再输入';
					return false;
				}
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


