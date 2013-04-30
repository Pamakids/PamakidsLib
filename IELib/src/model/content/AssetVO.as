package model.content
{

	public class AssetVO
	{
		public function AssetVO(name:String='', url:String='', type:String='')
		{
			this.name=name;
			this.url=url;
			this.type=type;
		}

		public var name:String;
		public var url:String;
		public var type:String;
		/**
		 * 临时用
		 */
		public var selected:Boolean;
		public var scale9Grid:Array;
		/**
		 * 素材pandding值
		 */
		public var paddings:Array;
	}
}
