package com.collectivecolors.extensions.flex3.drupal.model
{
	//----------------------------------------------------------------------------
	// Imports
	
	import com.collectivecolors.extensions.flex3.drupal.DrupalFacade;
	import com.collectivecolors.extensions.flex3.drupal.model.data.UserServiceVO;
	import com.collectivecolors.extensions.flex3.drupal.model.data.UserVO;
	import com.collectivecolors.extensions.flex3.drupal.model.services.SystemService;
	import com.collectivecolors.extensions.flex3.drupal.model.services.UserService;
	import com.collectivecolors.rpc.AMFAgent;
	import com.collectivecolors.rpc.IServiceAgent;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	//----------------------------------------------------------------------------
	
	public class UserProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		// Constants
		
		public static const NAME_SUFFIX : String = '_userProxy';
		
		//--------------------------------------------------------------------------
		// Constructor
		
		public function UserProxy( extensionName : String )
		{
			super( extensionName + NAME_SUFFIX );
			
			setData( new UserServiceVO( extensionName ) );
			
			// TODO : Plug the service agent via the configuration file.
			data.agent = newServiceAgent( SystemService.SOURCE );
			
			data.systemService = newSystemService( data.agent );			
			data.systemService.connectHandlers( connectResultHandler, 
			                                    userFaultHandler );		  						
			
			data.userService = newUserService( data.agent );
			data.userService.loginHandlers( loginResultHandler, userFaultHandler );
			data.userService.logoutHandlers( logoutResultHandler, userFaultHandler );
			data.userService.loadHandlers( loadResultHandler, userFaultHandler );
			data.userService.saveHandlers( saveResultHandler, userFaultHandler );
		  data.userService.removeHandlers( removeResultHandler, userFaultHandler );
		}
		
		//--------------------------------------------------------------------------
		// Initialization
		
		/**
		 * Create a new instance of the remote service agent.
		 * 
		 * This is useful for overriding in other extensions or the application.
		 */
		public function newServiceAgent( source : String ) : IServiceAgent
		{
		  return new AMFAgent( source );
		}
		
		/**
		 * Create a new instance of the drupal system service.
		 * 
		 * This is useful for overriding in other extensions or the application.
		 */
		public function newSystemService( agent : IServiceAgent ) : SystemService
		{
		  return new SystemService( agent );
		}
		
		/**
		 * Create a new instance of the drupal user service.
		 * 
		 * This is useful for overriding in other extensions or the application.
		 */
		public function newUserService( agent : IServiceAgent ) : UserService
		{
		  return new UserService( agent );
		}
		
		//--------------------------------------------------------------------------
		// Accessor / Modifiers
		
		/**
		 * Get user service data.
		 */
		protected function get data( ) : UserServiceVO
		{
		  return getData( ) as UserServiceVO;
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Get the status of the last user load
		 */
		public function get status( ) : String
		{
		  return data.status;
		}
		
		/**
		 * Get the status message set when loading users
		 */
		public function get message( ) : String
		{
			return data.message;
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Get the remote service agent for this proxy.
		 */
		public function get agent( ) : IServiceAgent
		{
		  return data.agent;
		}
		
		/**
		 * Set remote service agent for this proxy.
		 */
		public function set agent( value : IServiceAgent ) : void
		{
		  if ( value != null )
		  {
		    data.agent = value;
		  }
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Set service agent urls.
		 */
		public function set urls( values : Array ) : void
		{
		  data.agent.clearChannels( );
		  
			for each ( var url : String in values )
			{
			  data.agent.addChannel( url );
			}
		}
		
		//--------------------------------------------------------------------------
				
		/**
		 * Get the user information for the current user of the application.
		 */
		public function get user( ) : UserVO
		{
			return data.user;
		}
		
		/**
		 * Get a specified users information.
		 * 
		 * This function does not load ( because I can not block during download )
		 * so this function returns null if user has not been loaded yet.
		 */
		public function getUser( uid : uint ) : UserVO
		{
		  return data.getUser( uid );
		}
				
		//--------------------------------------------------------------------------
		// Services
		
		/**
		 * Request the current user from the remote site.
		 * 
		 * This method is automatically called by the UserStartupCommand.
		 */
		public function initialize( ) : void
		{
			setNotice( 'Connecting to site' );
			
			sendExtensionNotification( DrupalFacade.USER_CONNECTING );			
			data.systemService.connect( );
		}
		
		/**
		 * Log the current user into the remote site.
		 */
		public function login( userName : String, password : String ) : void
		{
		  setNotice( 'User logging in' );
		  			
			sendExtensionNotification( DrupalFacade.USER_LOGGING_IN );			
			data.userService.login( userName, password );
		}
		
		/**
		 * Log the current user off of the remote site.
		 */
		public function logout( ) : void
		{
		  setNotice( 'User logging out' );
		  			
			sendExtensionNotification( DrupalFacade.USER_LOGGING_OUT );			
			data.userService.logout( );
		}
		
		/**
		 * Load a user from the remote site.
		 */
		public function load( uid : uint ) : void
		{
		  setNotice( 'User loading' );
		  
		  sendExtensionNotification( DrupalFacade.USER_LOADING );
		  data.userService.load( uid );
		}
		
		/**
		 * Save a user at the remote site.
		 */
		public function save( user : UserVO ) : void
		{
		  setNotice( 'Saving user' );
		  
		  sendExtensionNotification( DrupalFacade.USER_SAVING );
		  data.userService.save( user );
		}
				
		/**
		 * Remove a user from the remote site.
		 */
		public function remove( uid : uint ) : void
		{
		  setNotice( 'Removing user' );
		  
		  sendExtensionNotification( DrupalFacade.USER_REMOVING );
		  data.userService.remove( uid );
		}
		
		//--------------------------------------------------------------------------
		// Event handlers
		
		/**
		 * Current user failed to load.
		 */
		protected function userFaultHandler( errorMessage : String ) : void
		{
			setError( errorMessage );
						
			sendExtensionNotification( DrupalFacade.USER_FAILED );
		} 
		
		/**
		 * Current user loaded sucessfully.
		 */
		protected function connectResultHandler( user : UserVO ) : void
		{
			setSuccess( 'Connected to site' );
			
			data.user = user;			
			sendExtensionNotification( DrupalFacade.USER_CONNECTED );
		}
		
		/**
		 * Current user loaded sucessfully.
		 */
		protected function loginResultHandler( user : UserVO ) : void
		{
			setSuccess( 'User logged in successfully' );
			
			data.user = user;			
			sendExtensionNotification( DrupalFacade.USER_LOGGED_IN );
		}
		
		/**
		 * Current user logged out successfully.
		 */
		protected function logoutResultHandler( success : Boolean ) : void
		{
		  setSuccess( ( success ? 'User logged out successfully' 
		                        : 'No user was logged in' ) );			
			data.user = null;
			sendExtensionNotification( DrupalFacade.USER_LOGGED_OUT );
		}
		
		/**
		 * Current user loaded sucessfully.
		 */
		protected function loadResultHandler( user : UserVO ) : void
		{
			setSuccess( 'User loaded successfully' );
			
			data.addUser( user );			
			sendExtensionNotification( DrupalFacade.USER_LOADED );
		}
		
		/**
		 * Current user saved sucessfully.
		 */
		protected function saveResultHandler( uid : uint ) : void
		{
			setSuccess( 'User saved successfully' );			
			sendExtensionNotification( DrupalFacade.USER_SAVED );
		}
		
		/**
		 * User removed successfully.
		 */
		protected function removeResultHandler( success : Boolean ) : void
		{
		  setSuccess( ( success ? 'User removed successfully' 
		                        : 'User does not exist' ) );
		                        
		  sendExtensionNotification( DrupalFacade.USER_REMOVED );
		}
				
		//--------------------------------------------------------------------------
		// Internal utilities
		
		protected function setNotice( message : String ) : void
		{
		  data.status  = DrupalFacade.STATUS_NOTICE;
		  data.message = message;
		}
		
		protected function setError( message : String ) : void
		{
		  data.status  = DrupalFacade.STATUS_ERROR;
		  data.message = message;
		}
		
		protected function setSuccess( message : String ) : void
		{
		  data.status  = DrupalFacade.STATUS_SUCCESS;
		  data.message = message;
		}
		
		protected function sendExtensionNotification( noteName : String ) : void
		{
		  sendNotification( noteName, DrupalFacade.extension( data.extension ) );
		}		
	}
}