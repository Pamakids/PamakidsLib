package com.pamakids.sqlite
{
	import com.pamakids.sqlite.events.DatabaseFailEvent;
	import com.pamakids.sqlite.events.DatabaseSuccessEvent;
	import com.pamakids.sqlite.events.StatementCompleteEvent;
	import com.pamakids.sqlite.vo.SQLQueryVO;
	import com.pamakids.sqlite.vo.SQLiteTableVO;
	import com.pamakids.util.EncryptionKeyGenerator;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	import flash.utils.ByteArray;
	
	import mx.utils.ObjectUtil;
	
	/**
	 *  Dispatched when the database failed
	 *
	 *  @eventType com.elad.framework.sqlite.events.DATABASE_FAIL
	 */
	[Event(name="databaseFail", type="com.pamakids.sqlite.events.DatabaseFailEvent")]
	
	/**
	 *  Dispatched when a command execution failed
	 *
	 *  @eventType com.elad.framework.sqlite.events.COMMAND_EXEC_FAILED
	 */
	[Event(name="commandExecFailed", type="com.pamakids.sqlite.events.DatabaseFailEvent")]
	
	/**
	 *  Dispatched when a command executed successfully
	 *
	 *  @eventType com.elad.framework.sqlite.events.COMMAND_EXEC_SUCCESSFULLY
	 */
	[Event(name="commandExecSuccesfully", type="com.pamakids.sqlite.events.DatabaseSuccessEvent")]
	
	/**
	 *  Dispatched when the database is connected successfully
	 *
	 *  @eventType com.elad.framework.sqlite.events.DATABASE_CONNECTED_SUCCESSFULLY
	 */
	[Event(name="databaseConnectedSuccessfully", type="com.pamakids.sqlite.events.DatabaseSuccessEvent")]
	
	/**
	 *  Dispatched when the database is ready and you can execute commands
	 *
	 *  @eventType com.elad.framework.sqlite.events.DATABASE_READY
	 */
	[Event(name="databaseReady", type="com.pamakids.sqlite.events.DatabaseSuccessEvent")]				
	
	/**
	 *  Dispatched when creating the database started 
	 *
	 *  @eventType com.elad.framework.sqlite.events.CREATING_DATABASE
	 */
	[Event(name="creatingDatabase", type="com.pamakids.sqlite.events.DatabaseSuccessEvent")]
	
	/**
	 * <p>Working with an application that has many SQL commands and multiple tables can become challenging; 
	 * these commands may be initialized from different classes and we may want to keep the database 
	 * connection open and avoid duplicating code.  
	 * <code>SQLiteManager</code> does just that and allows you to set the database settings and than access the 
	 * manager from anywhere in your application.</p>
	 * 
	 * <p><code>SQLiteManager</code> help handling the database connections and calls as well as tables. You pass a start properties to the singleton and you
	 * can execute common commands or custom commands.</p>
	 * 
	 * <p>Storing the information in a SQL database is the key for working offline. 
	 * The process for connecting to a SQLite database is as follows:</p>
	 * <ul>
	 * 	<li>Open a database connection.</li>
	 *  <li>Execute one or more SQL commands.</li>
	 *  <li>Close connection.</li>
	 * </ul>
	 * 
	 * @author Elad Elrom
	 * 
	 * @example The following code implements the SQLite manager and call the start command
	 * <listing version="3.0"> 
	 * 
	 *      var database:SQLiteManager = SQLiteManager.getInstance();
	 * 		database.start("Users.sql3", "Users", "CREATE TABLE Users(userId VARCHAR(150) PRIMARY KEY, UserName VARCHAR(150))");
	 * 
	 * </listing>
	 * 
	 */
	public class SQLiteManager extends EventDispatcher implements ISQLiteManager
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Database file name and extension
		 */		
		public var dbFullFileName:String;
		
		/**
		 * SQL command to create the database
		 */		
		public var sqliteTables:Vector.<SQLiteTableVO> = null;
		
		// datsbase apis instances
		protected var _connection:SQLConnection;
		protected var statement:SQLStatement;
		protected var sqlFile:File= null;
		private var encryptionKey:ByteArray = null;
		
		
		// repeated sql command
		protected var repeateFailCallBack:Function;
		protected var repeateCallBack:Function;
		protected var repeateSqlCommand:String = "";
		
		// Singleton instance.
		protected static var instance:SQLiteManager;
		
		// in case we are in a transaction mode hold the rollback responder
		private var rollbackRespnder:Responder = null;
		
		/**
		 * Enforce singleton design pattern.
		 *  
		 * @param enforcer
		 * 
		 */		
		public function SQLiteManager(enforcer:AccessRestriction)
		{
			if (enforcer == null)
				throw new Error("Error enforcer input param is undefined" );
		}
		
		//--------------------------------------------------------------------------
		//
		//  Setters / Getters
		//
		//--------------------------------------------------------------------------	
		
		/**
		 * Selected table name
		 */		
		private var _selectedTableName:String;
		
		public function get selectedTableName():String
		{
			return _selectedTableName;
		}
		
		public function set selectedTableName(value:String):void
		{
			_selectedTableName = value;
		}
		
		/**
		 * Expose reading the connection class, just in case user needs to pull information.
		 * 
		 * @return 
		 * 
		 */		
		public function get connection():SQLConnection
		{
			if ( (sqlFile != null) && !_connection.connected )  
				_connection.open( sqlFile, SQLMode.CREATE, false, 1024, encryptionKey );
			
			return _connection;
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 * Opens a database connection. The <code>File</code> API is used and it selects the <code>applicationStorageDirectory</code> method, 
		 * which will map to the location were your .air application is stored. The database can be encrypted by setting the password field. 
		 * 
		 * Mac example: HD/Users/[user name]/Library/Preferences/[Application name]/Local Store/[database name]
		 *  
		 * @param dbFullFileName the database file name for instance: Users.sql
		 * @param createTableStatement holds the create tables statments for instance: CREATE TABLE Users(userId VARCHAR(150) PRIMARY KEY, UserName VARCHAR(150))
		 * @param passowrd	used for a database that holds an encryption. The password must be 8-32 char, with one letter lowercase letter, one upper case and one number
		 * @param selectedTableName holds the selected table name, for instance: Users.  If no table is selected the first one will be selected.
		 * 
		 */	
		public function start( dbFullFileName:String, sqliteTables:Vector.<SQLiteTableVO> = null, password:String=null, selectedTableName:String="" ):void
		{
			this.dbFullFileName = dbFullFileName;
			
			_connection = new SQLConnection();
			
			if(sqliteTables)
				sqlFile = File.applicationStorageDirectory.resolvePath(dbFullFileName);
			else 
				sqlFile = File.applicationDirectory.resolvePath(dbFullFileName);
			
			try
			{
				if (password)
					encryptionKey = getEncryptionKey(password, sqlFile);
//				else 
//					encryptionKey = '';
				
				if(sqliteTables)
				{
					this.selectedTableName = (selectedTableName == "") ? sqliteTables[0].tableName : selectedTableName;
					this.sqliteTables = sqliteTables;
				}
				
				_connection.open(sqlFile, SQLMode.CREATE, false, 1024, encryptionKey);
				
				trace('SQLite File:'+sqlFile.nativePath, "Password: "+encryptionKey.toString());
				
				this.dispatchEvent( new DatabaseSuccessEvent(DatabaseSuccessEvent.DATABASE_CONNECTED_SUCCESSFULLY, "Database connected successfully") );
			}
			catch (error:SQLError)
			{
				var errorMessage:String = "Error message:" + error.message;
				
				if (error.details != "")
					errorMessage += ", Details:" + error.details;
				
				fail(null, errorMessage);
			}
		}
		
		/**
		 * This method uses the <code>EncryptionKeyGenerator</code> class to validate the password and generate an 
		 * encryption key.
		 * 
		 * @param password	The password must be 8-32 char with one letter lowercase letter and one number.
		 * @param sqlFile	the File that we will be using
		 * @return encryption key
		 * 
		 */		
		private function getEncryptionKey(password:String, sqlFile:File):ByteArray
		{
			var keyGen:EncryptionKeyGenerator = new EncryptionKeyGenerator();
			var encryptionKey:ByteArray;
			
			if (!keyGen.validateStrongPassword(password))
			{
				var errorMessage:String = "The password must be 8-32 char, " + "with one letter lowercase letter, " + 
					"one upper case and one number";
				
				fail(null, errorMessage);
				
				return null;
			}
			
			encryptionKey = keyGen.getEncryptionKey(sqlFile, password);	
			
			return encryptionKey;
		}
		
		/**
		 * Test the table to ensure it exists. Sends a fail call back function to create the table if 
		 * it doesn't exists.
		 * 
		 */		
		public function testTableExists():void
		{
			var sql:String = "SELECT * FROM "+selectedTableName+" LIMIT 1;";
			executeCustomCommand(sql, "testTableExists", this.onDatabaseReady, this.createTables );
		}
		
		/**
		 * Method to create the database table.  The create table method works using transactions.  Each sql statement is executed and after
		 * all the create database statements are executed the commit property is used to update the local sql file.
		 * 
		 */		
		private function createTables():void
		{
			connection.begin();
			
			sqliteTables.forEach( function(element:SQLiteTableVO,index:int, vector:Vector.<SQLiteTableVO> ):void
			{
				statement = new SQLStatement();
				statement.sqlConnection = connection;
				statement.text = sqliteTables[index].createTableStatement;
				statement.execute();				
			});	
			
			connection.commit();
			
			this.dispatchEvent( new DatabaseSuccessEvent(DatabaseSuccessEvent.CREATING_DATABASE, "Creating new database statment: "+statement.text) );
			
			statement.addEventListener(SQLEvent.RESULT, onDatabaseReady);			
		}
		
		
		/**
		 * Common sql command: select all entries in a table
		 *  
		 * @selectedTableName	selected table if left empty the one already selected will be used
		 * @param userGestureName	holds the user gesture name that generates this command
		 * @param callback
		 * @param failCallback
		 * 
		 */		
		public function executeSelectAllCommand( selectedTableName:String = "", userGestureName:String = "", callback:Function=null, failCallback:Function=null ):void
		{
			this.selectedTableName = ( selectedTableName != "" ) ? selectedTableName : this.selectedTableName;
			
			var sql:String = "SELECT * FROM " + selectedTableName + ";";
			executeCustomCommand(sql, userGestureName, callback, failCallback);
		}
		
		/**
		 * Common sql command: delete all entries in a table
		 * 
		 * @selectedTableName	selected table if left empty the one already selected will be used
		 * @param userGestureName	holds the user gesture name that generates this command
		 * @param callback
		 * @param failCallback
		 * 
		 */		
		public function executeDeleteAllCommand( selectedTableName:String = "", userGestureName:String = "", callback:Function=null, failCallback:Function=null ):void
		{
			this.selectedTableName = ( selectedTableName != "" ) ? selectedTableName : this.selectedTableName;
			
			var sql:String = "DELETE FROM " + selectedTableName + ";";
			executeCustomCommand(sql, userGestureName, callback, failCallback);
		}
		
		/**
		 * Method to execute a SQL command
		 * 
		 * @param sql SQL command string
		 * @param userGestureName	holds the user gesture name that generates this command
		 * @param callback success call back function to impliment if necessery
		 * @param failCallBack fail call back function to impliment if necessery
		 * 
		 */	
		public function executeCustomCommand(sql:String, userGestureName:String = "", callBack:Function=null, failCallBack:Function=null):void
		{
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = sql;
			
//			if (callBack != null)
//			{
//				statement.addEventListener(SQLEvent.RESULT, callBack);
//			}
//			else
//			{
				statement.addEventListener(SQLEvent.RESULT, function(event:SQLEvent):void 
				{
					event.currentTarget.removeEventListener(event.type, arguments.callee);
					var results:Object = statement.getResult();
					if(sql.indexOf('COUNT') != -1)
						results = results.data[0][sql.match(/COUNT(.*)(?= FROM)/)[0]];
					if(callBack !=null)
					{
						callBack(results);
					}else
					{
						var evt:StatementCompleteEvent = new StatementCompleteEvent(StatementCompleteEvent.COMMAND_EXEC_SUCCESSFULLY, results, userGestureName);
						dispatchEvent(evt);						
					}
				});
//			}
			
			statement.addEventListener(SQLErrorEvent.ERROR, function(event:SQLErrorEvent):void { 
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				fail(); 
			});
			
			try
			{
				statement.execute();
			}
			catch (error:SQLError)
			{
				this.handleErrors(error, sql, callBack, failCallBack);			    
			}			
		}
		
		/**
		 * Utility method to clean bad characters that can break SQL commands 
		 * 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function removeBadCharacters(str:String):String
		{
			var retVal:String = str.split("'").join("&#8217;&rsquo;");
			return retVal;
		}
		
		/**
		 * Close connection 
		 * 
		 */		
		public function closeConnection():void
		{
			connection.close();
		}
		
		/**
		 * Method to begin a transaction 
		 * 
		 * @param option	set the transaction option
		 * @param responder	set the responder
		 * @param rollbackRespnder	set the rollback responder
		 * 
		 */		
		public function beginTransaction(option:String=null, responder:Responder=null, rollbackRespnder:Responder=null):void
		{
			this.rollbackRespnder = rollbackRespnder;
			connection.begin(option, responder);
		}
		
		/**
		 * Handles a request to stop the transaction and commit the changes.
		 *  
		 * @param responder
		 * 
		 */		
		public function stopTransactionAndCommit(responder:Responder=null):void
		{
			if (connection.inTransaction)
				connection.commit(responder);
		}
		
		/**
		 * Handles a request to roll back any changes since the tranaction started.
		 * 
		 * @param responder
		 * 
		 */		
		public function rollbackTransaction(responder:Responder=null):void
		{
			if (responder != null)
			{
				this.rollbackRespnder = responder;
			}
			
			if (connection.inTransaction)
				connection.rollback(this.rollbackRespnder);
		}
		
		//--------------------------------------------------------------------------
		//
		//  AIR 2.0 additional methods
		//
		//--------------------------------------------------------------------------		
		
		/**
		 * Method to set save point.
		 * 
		 * @param name
		 * @param responder
		 * 
		 * @see flash.data.SQLConnection.setSavepoint
		 * 
		 */		
		public function setSavepoint(name:String="", responder:Responder=null):void
		{
			if ( (connection as Object).hasOwnProperty("setSavepoint") )
				(connection as Object).setSavepoint(name, responder);
			else
				trace("**** warnings: setSavepoint not avaliable for this version of SDK ****");				
		}
		
		/**
		 * Method to release the save point.
		 * 
		 * @param name
		 * @param responder
		 * 
		 * @see flash.data.SQLConnection.releaseSavepoint
		 * 
		 */		
		public function releaseSavepoint(name:String="", responder:Responder=null):void
		{
			if ( (connection as Object).hasOwnProperty("releaseSavepoint") )
				(connection as Object).releaseSavepoint(name, responder);
			else
				trace("**** warnings: releaseSavepoint not avaliable for this version of SDK ****");
		}
		
		/**
		 * Method to rollback save point
		 * 
		 * @param name
		 * @param responder
		 * 
		 * @see flash.data.SQLConnection.rollbackToSavepoint
		 * 
		 */		
		public function rollbackToSavepoint(name:String="", responder:Responder=null):void
		{
			if ( (connection as Object).hasOwnProperty("rollbackToSavepoint") )
				(connection as Object).rollbackToSavepoint(name, responder);
			else
				trace("**** warnings: rollbackToSavepoint not avaliable for this version of SDK ****");			
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------	
		
		/**
		 * Method to handle SQL command that create the dataabase.  
		 * If the method was created due to a fail SQL command method checks if need to repeate any SQL command.
		 *  
		 * @param event
		 * 
		 */		
		private function onDatabaseReady(event:Event=null):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			
			this.dispatchEvent( new DatabaseSuccessEvent(DatabaseSuccessEvent.DATABASE_READY) );
			
			if (repeateSqlCommand != "")
			{
				this.executeCustomCommand(repeateSqlCommand, "createDatabaseUserGesture", repeateCallBack, repeateFailCallBack);
				
				repeateSqlCommand = "";
				repeateFailCallBack = null;
				repeateCallBack = null;
			}
		}
		
		/**
		 * Error handler
		 *  
		 * @param error
		 * @param sql
		 * @param callBack
		 * @param failCallBack
		 * 
		 */		
		private function handleErrors(error:SQLError, sql:String, callBack:Function, failCallBack:Function):void
		{
			var errorMessage:String = "Error message:" + error.message + "Details:" + error.details;
			
			if (error.details == "no such table: '"+selectedTableName+"'")
			{
				repeateSqlCommand = sql;
				repeateFailCallBack = failCallBack;
				repeateCallBack = callBack; 
				
				createTables();
			}
			else
			{
				if (failCallBack != null)
				{
					failCallBack();
				}
				else
				{
					fail(null, errorMessage);
				}			    	
			}			
		}
		
		/**
		 * Handler fail calls.  In case there is a transaction going roll the changes back.
		 *  
		 * @param event
		 * 
		 */		
		private function fail(event:Event=null, errorMessage:String=""):void
		{
			var isRolledBack:Boolean = false;
			
			if ( connection.inTransaction )
			{
				connection.rollback();
				isRolledBack = true;
			}
			
			this.dispatchEvent( new DatabaseFailEvent(DatabaseFailEvent.DATABASE_FAIL, errorMessage, isRolledBack) );
			closeConnection();
		}
		
		/**
		 * Method function to retrieve instance of the class
		 *  
		 * @return The same instance of the class
		 * 
		 */
		public static function getInstance():SQLiteManager
		{
			if( instance == null )
				instance = new  SQLiteManager(new AccessRestriction());
			
			return instance;
		}
		
//		INSERT INTO words ( id,familiarity,score,category,rank,detail,phonetic,sound,spell,tags,translate ) VALUES ( '1','1','1','0','22996167','art.
//			他最喜欢你。','[ðə, ði:]','the.mp3','the','toefl','art.这,那 ad.[用于比较级;最高级前]' );
		
		public function insertData(data:Object, table:String, callback:Function=null):void
		{
			var sql:String = "INSERT INTO "+table+ " (";
			var cloumns:Array = [];
			var values:Array = [];
			
			var arr:Array=ObjectUtil.getClassInfo(data).properties as Array;
			for each (var q:QName in arr)
			{
				var value:String = data[q.localName];
				if(value && q.localName != 'conditions')
				{
					cloumns.push(q.localName);
					values.push("'"+value+"'");
				}
			}
			
			sql+= cloumns.join(',') + ') VALUES ('+values.join(',') + ' );';
			trace("Insert SQL: "+sql);
			executeCustomCommand(sql, '', callback);
		}
		
//		UPDATE words SET score = 100 WHERE id = 9999
		/**
		 * Update Data 
		 * @param data
		 * @param table
		 * @param callback
		 * @param mainColumn Use for select data to update
		 */		
		public function updateData(data:Object, table:String, callback:Function = null):void
		{
			var conditions:Array = data.conditions as Array;
			if(!conditions)
				throw new Error('No Conditions!');
			var sql:String = "UPDATE "+table+" SET ";
			var arr:Array=ObjectUtil.getClassInfo(data).properties as Array;
			var setFields:Array = [];
			for each (var q:QName in arr)
			{
				var value:String = data[q.localName];
				if(value && q.localName != 'conditions' && !conditions[q.localName])
					setFields.push(q.localName+' = '+value);
			}
			sql += setFields.join(',') + ' WHERE '+jionConditions(conditions);
			trace("Update SQL: "+sql);
			executeCustomCommand(sql, '', callback);
		}
		
		public function deleteData(data:Object, table:String, callback:Function = null):void
		{
			var conditions:Array = data is Array ? data as Array : data.conditions as Array;
			if(!conditions)
				throw new Error('No Conditions!');
			var sql:String = 'DELETE FROM '+table +' WHERE ' + jionConditions(conditions);
			trace("DELETE SQL: "+sql);
			executeCustomCommand(sql, '', callback);
		}
		
		public function getCount(query:SQLQueryVO, callback:Function=null):void
		{
			executeCustomCommand(query.toCountString(), '', callback);
		}
		
		public function getData(query:SQLQueryVO, callback:Function=null):void
		{
			executeCustomCommand(query.toQueryString(), '', callback);
		}
		
		private function jionConditions(arr:Array):String
		{
			var conditions:Array = [];
			
			for(var key:String in arr)
			{
				conditions.push( key + ' = '+arr[key] );				
			}
			
			return conditions.join(' AND ');
		}
	}
}

class AccessRestriction {}