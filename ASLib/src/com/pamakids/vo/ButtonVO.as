package com.pamakids.vo
{

	public class ButtonVO
	{
		public function ButtonVO(name:String, selected:String='', required:Boolean=false, centerFill:Boolean=false, sl:Boolean=true)
		{
			this.name=name;
			this.selected=selected;
			this.required=required;
			this.centerFill=centerFill;
			this.selectable=sl;
		}

		/**
		 * 是否将素材居中显示
		 */
		public var centerFill:Boolean;

		public var name:String;
		/**
		 * 选中后的皮肤状态
		 */
		public var selected:String;
		/**
		 * 是否选中后就不能点击取消选中
		 */
		public var required:Boolean;
		/**
		 * 是否可选中
		 */
		public var selectable:Boolean=true;
	}
}
