package com.collectivecolors.extensions.flex3.drupal.model.data
{
	//----------------------------------------------------------------------------
	// Imports
	
	import com.collectivecolors.errors.InvalidInputError;
	
	//----------------------------------------------------------------------------
		
	public class UserVO
	{
		//--------------------------------------------------------------------------
		// Constants
		
		public static const STATUS_ACTIVE : int  = 1;
		public static const STATUS_BLOCKED : int = 0;
		
		//--------------------------------------------------------------------------
		// Properties
		
		public var sessionId : String;
		
		private var _uid : int;
		public var name : String;
		
		public var initMail : String;
		public var currentMail : String;
		
		public var createdTime : Date;
		public var lastLoginTime : Date;
		public var lastAccessTime : Date;
				
		private var _status : int;
		
		public var contact : Boolean;
		
		public var timezone : String;
		public var language : String;
		
		public var imagePath : String;
		
		public var hostname : String;
		
		private var _roles : Object;
		
		//--------------------------------------------------------------------------
		// Constructor
		
		public function UserVO()
		{
			uid  = 0;
			name = '';
			
			status = STATUS_BLOCKED;
			
			contact = false;
			
			_roles = { };
		}
		
		//--------------------------------------------------------------------------
		// Accessor / Modifiers
		
		public function get uid( ) : int
		{
			return _uid;
		}
		
		public function set uid( value : int ) : void
		{
			if ( value < 0 )
			{
				throw new InvalidInputError( "Invalid user id specified" );
			}
			
			_uid = value;
		}
		
		//--------------------------------------------------------------------------
		
		public function get status( ) : int
		{
			return _status;
		}
		
		public function set status( value : int ) : void
		{
			switch ( value )
			{
				case STATUS_ACTIVE :
				case STATUS_BLOCKED :
					break;
					
				default :
					throw new InvalidInputError( "Invalid user status specified" );
			}
			
			_status = value;
		}
		
		//--------------------------------------------------------------------------
		
		public function get roles( ) : Array
		{
			var rolesArray : Array = [ ];
			
			for each ( var role : RoleVO in _roles )
			{
				rolesArray.push( role );
			}
			
			return rolesArray;
		}
		
		public function addRole( rid : int, name : String ) : void
		{
			_roles[ rid ] = new RoleVO( rid, name );	
		}		
	}
}