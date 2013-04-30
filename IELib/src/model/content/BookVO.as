package model.content
{

	[Bindable]
	public class BookVO extends DataBaseVO
	{
		public var pages:Array;
		public var backgroundMusic:String;

		/**
		 * 本地路径或网络路径
		 */
		public var dir:String;

	}
}
