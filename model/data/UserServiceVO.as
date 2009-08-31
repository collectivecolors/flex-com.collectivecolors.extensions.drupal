package com.collectivecolors.extensions.flex3.drupal.model.data
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.extensions.as3.data.StatusVO;
  import com.collectivecolors.extensions.flex3.drupal.model.services.SystemService;
  import com.collectivecolors.extensions.flex3.drupal.model.services.UserService;
  import com.collectivecolors.rpc.IServiceAgent;

  //----------------------------------------------------------------------------

  public class UserServiceVO extends StatusVO
  {
    //--------------------------------------------------------------------------
    // Properties
    
    public var agent : IServiceAgent;
    
    public var systemService : SystemService;
    public var userService : UserService;
    
    private var _user : UserVO;
    private var cache : Object = { };    
    
    //--------------------------------------------------------------------------
    // Constructor
    
    public function UserServiceVO( extensionName : String = null )
    {
      super( extensionName );
    }
    
    //--------------------------------------------------------------------------
    // Accessor / modifiers
    
    public function get user( ) : UserVO
    {
      return _user;
    }
    
    public function set user( value : UserVO ) : void
    {
      _user = value;
      addUser( _user );
    }
    
    //--------------------------------------------------------------------------
    
    public function getUser( uid : uint ) : UserVO
    {
      if ( ! cache.hasOwnProperty( uid ) )
      {
        return null;
      }
      
      return cache[ uid ];
    }
    
    public function addUser( user : UserVO ) : void
    {
      cache[ user.uid ] = user;
    }
    
    public function removeUser( uid : uint ) : void
    {
      delete cache[ uid ];
    }    
  }
}