package com.pamakids.vo
{

	public class ButtonVO
	{
		public function ButtonVO(name:String, selected:String='', required:Boolean=false, centerFill:Boolean=false)
		{
			this.name=name;
			this.selected=selected;
			this.required=required;
			this.centerFill=centerFill;
			
		}

		public var centerFill:Boolean;
		public var name:String;
		public var selected:String;
		public var required:Boolean;
	}
}
