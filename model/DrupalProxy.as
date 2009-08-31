package com.collectivecolors.extensions.flex3.drupal.model
{
	//----------------------------------------------------------------------------
	// Imports
	
	import com.collectivecolors.extensions.flex3.drupal.DrupalFacade;
	import com.collectivecolors.extensions.flex3.drupal.model.data.DrupalVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	//----------------------------------------------------------------------------
	
	public class DrupalProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		// Constants
		
		public static const NAME_SUFFIX : String = '_drupalProxy';
		
		//--------------------------------------------------------------------------
		// Constructor
		
		public function DrupalProxy( extensionName : String, 
		                             flashVars : Object = null )
		{
			super( extensionName + NAME_SUFFIX );
			
			setData( new DrupalVO( extensionName ) );
		}
		
		//--------------------------------------------------------------------------
		// Accessors / Modifiers
		
		/**
		 * Get drupal data object
		 */
		protected function get data( ) : DrupalVO
		{
		  return getData( ) as DrupalVO;
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Get the status of the configuration parse
		 */
		public function get status( ) : String
		{
		  return data.status;
		}
		
		/**
		 * Set the proxy status
		 */
		public function set status( value : String ) : void
		{
		  data.status = value;
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Get the status message set when parsing configuration
		 */
		public function get message( ) : String
		{
			return data.message;
		}
		
		/**
		 * Set the status message
		 */
		public function set message( value : String ) : void
		{
		  data.message = value;
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Get the url locations of the stylesheets to import
		 */
		public function get urls( ) : Array
		{
		  return data.location.urls;
		}
		
		/**
		 * Set the url locations of the stylesheets to import
		 */
		public function set urls( values : Array ) : void
		{
		  data.location.urls = values;
		  
		  sendNotification( 
		    DrupalFacade.UPDATED, 
		    DrupalFacade.extension( data.extension ) 
		  );
		}
		
		/**
		 * Add a url to the list of stylesheets to import
		 */
		public function addUrl( url : String ) : void
		{
		  data.location.addUrl( url );
		  
		  sendNotification( 
		    DrupalFacade.UPDATED, 
		    DrupalFacade.extension( data.extension )
		  );
		}
		
		/**
		 * Remove a url from the list of stylesheets to import
		 */
		public function removeUrl( url : String ) : void
		{
		  data.location.removeUrl( url );
		  
		  sendNotification( 
		    DrupalFacade.UPDATED, 
		    DrupalFacade.extension( data.extension )
		  );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Get whether or not this proxy has been initialized.
		 */
		public function get initialized( ) : Boolean
		{
		  return data.initialized;
		}
		
		/**
		 * Set whether or not this proxy has been initialized.
		 */
		public function set initialized( value : Boolean ) : void
		{
		  data.initialized = value;
		}
	}
}