package com.collectivecolors.extensions.flex3.drupal.controller
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.errors.XMLParseError;
  import com.collectivecolors.extensions.flex3.drupal.DrupalFacade;
  import com.collectivecolors.extensions.flex3.drupal.model.DrupalProxy;
  
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.command.SimpleCommand;

  //----------------------------------------------------------------------------

  public class DrupalConfigParseCommand extends SimpleCommand
  {
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function execute(note : INotification ) : void
    {
      var config : XML = note.getBody( ) as XML;
      
			for each ( var drupal : DrupalFacade in DrupalFacade.extensions )
			{
			  var extensionName : String = drupal.getExtensionName( );
			  var proxy : DrupalProxy    = drupal.drupalProxy;
			  
			  // Set service endpoints ( at least one tag required ).
			  try
			  {
			    proxy.urls = XMLParser.parseMultiTagRequired( 
			      config[ extensionName ], 
			      DrupalFacade.CONFIG_URL,
			      "Service endpoints are not specified",
			      "Service endpoints are incorrectly specified"
			    );
			  }
			  catch ( error : XMLParseError )
			  {
			    proxy.status      = DrupalFacade.STATUS_ERROR;
			    proxy.message     = error.message;
			    proxy.initialized = false;
			    
			    sendNotification( DrupalFacade.SERVICE_FAILED, drupal );
			    return;
			  }
			  
			  proxy.status      = DrupalFacade.STATUS_SUCCESS;
			  proxy.message     = "Drupal service configuration loaded successfully";
			  proxy.initialized = true;
			  
			  sendNotification( DrupalFacade.SERVICE_READY, drupal );			
			}			  
    }
  }
}