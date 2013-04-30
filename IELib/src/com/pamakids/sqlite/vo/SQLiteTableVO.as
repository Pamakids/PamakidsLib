package com.pamakids.sqlite.vo
{
	public class SQLiteTableVO
	{
		public var tableName:String;
		public var createTableStatement:String;
		
		public function SQLiteTableVO(tableName:String, createTableStatement:String)
		{
			this.tableName = tableName;
			this.createTableStatement = createTableStatement;
		}
	}
}