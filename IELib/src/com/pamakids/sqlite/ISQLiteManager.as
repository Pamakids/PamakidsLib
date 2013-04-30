package com.pamakids.sqlite
{
	import com.pamakids.sqlite.vo.SQLiteTableVO;
	
	/**
	 * Describes the contract for Objects that serve as a central point to access SQLite database.
	 *   
	 * @author Elad Elrom
	 * 
	 */	
	public interface ISQLiteManager
	{
		function start(dbFullFileName:String, sqliteTables:Vector.<SQLiteTableVO>=null, password:String=null, selectedTableName:String=""):void
		function closeConnection():void
	}
}