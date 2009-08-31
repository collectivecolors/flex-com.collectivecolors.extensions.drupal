package com.collectivecolors.extensions.flex3.drupal.model.services
{
	//----------------------------------------------------------------------------
	// Imports
	
	import com.collectivecolors.extensions.flex3.drupal.model.data.UserVO;
	import com.collectivecolors.rpc.IServiceAgent;
	import com.collectivecolors.rpc.RemoteService;
	
	import mx.rpc.events.ResultEvent;
	
	//----------------------------------------------------------------------------
	
	public class UserService extends RemoteService
	{
		//--------------------------------------------------------------------------
		// Constants
		
		public static const SOURCE : String = 'user';
		
		//---------------------
		
		private static const LOGIN : String  = 'login';
		private static const LOGOUT : String = 'logout';
		
		private static const LOAD : String   = 'get';
		private static const SAVE : String   = 'save';
		private static const REMOVE : String = 'delete';
		
		//--------------------------------------------------------------------------
		// Constructor
		
		public function UserService( agent : IServiceAgent, urls : Array = null )
		{
			super( agent, urls );
			
			// Register user service handlers
			agent.register( LOGIN, loginResultHandler, serviceFaultHandler );
			agent.register( LOGOUT, executeResultHandler, serviceFaultHandler );
			
			agent.register( LOAD, loadResultHandler, serviceFaultHandler );
			agent.register( SAVE, executeResultHandler, serviceFaultHandler );
			agent.register( REMOVE, executeResultHandler, serviceFaultHandler );
		}
		
		//--------------------------------------------------------------------------
		// Service methods
		
		/**
		 * Register login method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function loginResultHandler( user : UserVO ) : void
		 *  function loginFaultHandler( statusMessage : String ) : void
		 */
		public function loginHandlers( resultHandler : Function,
		                               faultHandler : Function = null ) : void
		{
		  registerHandlers( LOGIN, resultHandler, faultHandler );
		}
		
		/**
		 * Execute remote login method and return current user.
		 */
		public function login( userName : String, password : String ) : void
		{
		  agent.execute( LOGIN, userName, password );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Register logout method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function logoutResultHandler( success : Boolean ) : void
		 *  function logoutFaultHandler( statusMessage : String ) : void
		 */
		public function logoutHandlers( resultHandler : Function = null,
		                                faultHandler : Function = null ) : void
		{
		  registerHandlers( LOGOUT, resultHandler, faultHandler );
		}
		
		/**
		 * Execute remote logout method.
		 */
		public function logout( ) : void
		{
		  agent.execute( LOGOUT );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Register load method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function loadResultHandler( user : UserVO ) : void
		 *  function loadFaultHandler( statusMessage : String ) : void
		 */
		public function loadHandlers( resultHandler : Function,
		                              faultHandler : Function = null ) : void
		{
		  registerHandlers( LOAD, resultHandler, faultHandler );
		}
		
		/**
		 * Execute remote load method and return user object.
		 */
		public function load( uid : uint ) : void
		{
		  agent.execute( LOAD, uid );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Register save method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function saveResultHandler( uid : uint ) : void
		 *  function saveFaultHandler( statusMessage : String ) : void
		 */
		public function saveHandlers( resultHandler : Function = null,
		                              faultHandler : Function = null ) : void
		{
		  registerHandlers( SAVE, resultHandler, faultHandler );
		}
		
		/**
		 * Execute remote save method.
		 */
		public function save( user : UserVO ) : void
		{
		  agent.execute( SAVE, parseSaveParameter( user ) );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Register remove method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function removeResultHandler( success : Boolean ) : void
		 *  function removeFaultHandler( statusMessage : String ) : void
		 */
		public function removeHandlers( resultHandler : Function = null,
		                                faultHandler : Function = null ) : void
		{
		  registerHandlers( REMOVE, resultHandler, faultHandler );
		}
		
		/**
		 * Execute remote remove method.
		 */
		public function remove( uid : uint ) : void
		{
		  agent.execute( REMOVE, uid );
		}		
		
		//--------------------------------------------------------------------------
		// Event handlers
		
		/**
		 * Executed when remote login method returns sucessfully.
		 */
		protected function loginResultHandler( event : ResultEvent ) : void
		{
		  executeResultHandler( event, parseLoginResult );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Executed when remote load method returns sucessfully.
		 */
		protected function loadResultHandler( event : ResultEvent ) : void
		{
		  executeResultHandler( event, parseLoadResult );
		}
		
		//--------------------------------------------------------------------------
		// Parameter parsers
		
		/**
		 * Parse a user value object into a native drupal data structure.
		 */
		protected function parseSaveParameter( user : UserVO ) : void
		{
		  return user;
		}
		
		//--------------------------------------------------------------------------
		// Result parsers
		
		/**
		 * Parse the result of the remote login method into a UserVO object
		 * that represents the user who is currently logged in.
		 */
		protected function parseLoginResult( result : Object ) : UserVO
		{
		  var userObj : Object = result.user;
			var user : UserVO    = new UserVO( );
			
			user.sessionId = result.sessid;
			user.uid       = userObj.userid;
			user.hostname  = userObj.hostname;
			
			for ( var rid : String in userObj.roles )
			{
				user.addRole( rid as int, userObj.roles[ rid ] );
			}
			
			if ( user.uid )
			{
				user.name           = userObj.name;
				user.initMail       = userObj.init;
				user.currentMail    = userObj.mail;
				user.createdTime    = new Date( userObj.created );
				user.lastLoginTime  = new Date( userObj.login );
				user.lastAccessTime = new Date( userObj.access );
				user.status         = userObj.status;
				user.contact        = ( userObj.contact ? true : false );
				user.timezone       = userObj.timezone;
				user.language       = userObj.language;
				user.imagePath      = userObj.picture;
			}			
			
			return user;
		}
		
		/**
		 * Return a UserVO object for a specified user.
		 */
		protected function parseLoadResult( result : Object ) : String
		{
		  var user : UserVO = new UserVO( );
			
			user.sessionId = null;
			user.uid       = result.userid;
			user.hostname  = result.hostname;
			
			for ( var rid : String in result.roles )
			{
				user.addRole( rid as int, result.roles[ rid ] );
			}
			
			if ( user.uid )
			{
				user.name           = result.name;
				user.initMail       = result.init;
				user.currentMail    = result.mail;
				user.createdTime    = new Date( result.created );
				user.lastLoginTime  = new Date( result.login );
				user.lastAccessTime = new Date( result.access );
				user.status         = result.status;
				user.contact        = ( result.contact ? true : false );
				user.timezone       = result.timezone;
				user.language       = result.language;
				user.imagePath      = result.picture;
			}			
			
			return user;
		}	
	}
}