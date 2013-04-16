package
{

	/**
	 * 游戏属性VO
	 * @author mani
	 *
	 */
	public class PropertyVO
	{
		public function PropertyVO(key:String='', defaultValue:String='', tip:String='')
		{
			this.key=key;
			this.defaultValue=defaultValue;
			this.tip=tip;
		}

		public var key:String;
		/**
		 * 配置游戏属性时显示的提示
		 */
		public var tip:String;
		/**
		 * 游戏属性默认值
		 */
		public var defaultValue:String;
	}
}
