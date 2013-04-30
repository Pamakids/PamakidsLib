package com.pamakids.sqlite.vo
{
	public class SQLQueryVO
	{
		public function SQLQueryVO(table:String, columns:Array=null, conditions:Array=null, orderBy:String='', limit:int=0, isDESC:Boolean=false)
		{
			this.table = table;
			this.columns = columns;
			this.conditions = conditions;
			this.limit = limit;
			this.isDESC = isDESC;
			this.orderBy = orderBy;
		}
		
		public var columns:Array;
		public var conditions:Array;
		public var limit:int;
		public var isDESC:Boolean;
		private var table:String;
		public var orderBy:String;
		
		public function toCountString():String
		{
			var column:String = columns ? columns[0] : '*';
			var sql:String = 'SELECT COUNT('+column+') FROM '+table;
			if(conditions)
				sql += ' WHERE ' + joinConditions(conditions);
			return sql;
		}
		
		public function toQueryString():String
		{
			var sql:String = "SELECT ";
			
			if(columns)
				sql += columns.join(',');
			else
				sql += "*";
			
			sql += " FROM "+table;
			
			if(conditions)
				sql += " WHERE "+joinConditions(conditions);
			
			if(orderBy)
				sql += ' ORDER BY '+orderBy;
			
			sql += isDESC ? ' DESC' : '';
			
			sql += limit ? ' LIMIT ' + limit : '';
			
			trace("QUERY SQL: "+sql);
			
			return sql;
		}
		
		private function joinConditions(arr:Array):String
		{
			var conditions:Array = [];
			var s:String;
			
			if(conditions[0])
			{
				s = conditions[0];	
			}else
			{
				for(var key:String in arr)
				{
					conditions.push( key + ' = '+arr[key] );				
				}
				s = conditions.join(' AND ');
			}
			
			return s;
		}
	}
}