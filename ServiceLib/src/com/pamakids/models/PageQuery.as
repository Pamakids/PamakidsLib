package com.pamakids.models
{

	/**
	 * 分页检索
	 * @author mani
	 */
	public class PageQuery
	{
		public function PageQuery(perPage:int, page:int, query:Object=null)
		{
			this.perPage=perPage;
			this.page=page;
			this.query=query;
		}

		public var perPage:int;
		public var page:int;
		public var query:Object;
	}
}
