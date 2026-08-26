module flua
   !! Fortran Lua wrapper module providing bindings to Lua C-API

   use iso_c_binding

   implicit none

   private

   !======================================================================
   ! Lua C-API
   !======================================================================
   public :: lua_pcall, lua_close
   public :: lua_settop, lua_gettop
   public :: lua_type
   public :: lua_pushnumber, lua_pushinteger, lua_pushboolean, lua_pushstring
   public :: lua_tonumber, lua_tointeger, lua_toboolean, lua_tostring
   public :: lua_createtable, lua_newtable, lua_settable, lua_gettable
   public :: lua_isnil, lua_isnumber, lua_istable, lua_isstring
   public :: lua_getfield, lua_setfield, lua_getglobal, lua_setglobal
   public :: lua_error, lua_objlen

   integer(c_int), parameter, public :: LUA_MULTRET       = -1 !! Return multiple results
   integer(c_int), parameter, public :: LUA_REGISTRYINDEX = -10000 !! Registry index
   integer(c_int), parameter, public :: LUA_ENVIRONINDEX  = -10001 !! Environment index
   integer(c_int), parameter, public :: LUA_GLOBALSINDEX  = -10002 !! Globals index

   integer(c_int), parameter, public :: LUA_TNIL           =   0 !! Lua type: nil
   integer(c_int), parameter, public :: LUA_TBOOLEAN       =   1 !! Lua type: boolean
   integer(c_int), parameter, public :: LUA_TLIGHTUSERDATA =   2 !! Lua type: light userdata
   integer(c_int), parameter, public :: LUA_TNUMBER        =   3 !! Lua type: number
   integer(c_int), parameter, public :: LUA_TSTRING        =   4 !! Lua type: string
   integer(c_int), parameter, public :: LUA_TTABLE         =   5 !! Lua type: table
   integer(c_int), parameter, public :: LUA_TFUNCTION      =   6 !! Lua type: function
   integer(c_int), parameter, public :: LUA_TUSERDATA      =   7 !! Lua type: userdata
   integer(c_int), parameter, public :: LUA_TTHREAD        =   8 !! Lua type: thread

   interface

      function lua_pcall(L, nargs, nresults, errfunc) result(ier) &
         bind(C,name="lua_pcall")
         !! Lua C-API function: protected call a function
         use iso_c_binding
         type(c_ptr), value      :: L        !! Lua state
         integer(c_int), value   :: nargs    !! Number of arguments
         integer(c_int), value   :: nresults !! Number of results
         integer(c_int), value   :: errfunc  !! Error handler index
         integer(c_int)          :: ier      !! Return code (0 = success)
      end function lua_pcall


      subroutine lua_close(L) bind(C,name="lua_close")
         !! Lua C-API function: close a Lua state
         use iso_c_binding
         type(c_ptr), value      :: L       !! Lua state
      end subroutine lua_close


      subroutine lua_settop(L, index) bind(C,name="lua_settop")
         !! Lua C-API function: set the stack top
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int), value  :: index    !! New stack top index
      end subroutine lua_settop


      function lua_gettop(L) result(n) bind(C,name="lua_gettop")
         !! Lua C-API function: get the stack top
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int)         :: n        !! Stack top index
      end function lua_gettop


      function lua_type(L, index) result(n) bind(C,name="lua_type")
         !! Lua C-API function: get the type of a value on the stack
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int), value  :: index    !! Stack index
         integer(c_int)         :: n        !! Type constant
      end function lua_type


      subroutine lua_pushnumber(L, n) bind(C,name="lua_pushnumber")
         !! Lua C-API function: push a number onto the stack
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         real(C_DOUBLE), value  :: n        !! Number to push
      end subroutine lua_pushnumber


      function lua_tonumber(L, index) result(n) bind(C,name="lua_tonumber")
         !! Lua C-API function: convert a value to a number
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int), value  :: index    !! Stack index
         real(C_DOUBLE)         :: n        !! Converted number
      end function lua_tonumber


      subroutine lua_pushinteger(L, n) bind(C,name="lua_pushinteger")
         !! Lua C-API function: push an integer onto the stack
         use iso_c_binding
         type(c_ptr), value       :: L      !! Lua state
         integer(c_int), value    :: n      !! Integer to push
      end subroutine lua_pushinteger


      function lua_tointeger(L, index) result(n) bind(C,name="lua_tointeger")
         !! Lua C-API function: convert a value to an integer
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int), value  :: index    !! Stack index
         integer(c_int)         :: n        !! Converted integer
      end function lua_tointeger


      subroutine lua_createtable(L, narr, nrec) bind(C,name="lua_createtable")
         !! Lua C-API function: create a new table
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int), value  :: narr     !! Expected array elements
         integer(c_int), value  :: nrec     !! Expected non-array elements
      end subroutine lua_createtable


      subroutine lua_settable(L, index) bind(C,name="lua_settable")
         !! Lua C-API function: set a value in a table
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int), value  :: index    !! Table index
      end subroutine lua_settable


      subroutine lua_gettable(L, index) bind(C,name="lua_gettable")
         !! Lua C-API function: get a value from a table
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int), value  :: index    !! Table index
      end subroutine lua_gettable


      function lua_error(L) result(n) bind(C,name="lua_error")
         !! Lua C-API function: raise an error
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int)         :: n        !! Error code
      end function lua_error


      function lua_objlen(L, index) result(n) bind(C,name="lua_objlen")
         !! Lua C-API function: get the length of an object
         use iso_c_binding
         type(c_ptr), value     :: L        !! Lua state
         integer(c_int), value  :: index    !! Stack index
         integer(c_int)         :: n        !! Length of object
      end function lua_objlen

   end interface


   !======================================================================
   ! Lua auxiliary library
   !======================================================================

   public :: luaL_newstate
   public :: luaL_openlibs
   public :: luaL_loadstring, luaL_loadfile
   public :: luaL_dostring, luaL_dofile


   interface

      function luaL_newstate() result(L) bind(C,name="luaL_newstate")
         !! Lua auxiliary function: create a new Lua state
         use iso_c_binding
         type(c_ptr) :: L           !! Lua state pointer
      end function luaL_newstate


      subroutine luaL_openlibs(L) bind(C,name="luaL_openlibs")
         !! Lua auxiliary function: open all standard libraries
         use iso_c_binding
         type(c_ptr), value :: L    !! Lua state
      end subroutine luaL_openlibs

   end interface


   !======================================================================
   ! Fortran 95 extensions
   !======================================================================
   public :: flua_newstate, flua_openlibs, flua_close
   public :: flua_dostring, flua_dofile
   public :: flua_push, flua_pop
   public :: flua_setvar, flua_getvar


   interface flua_push
      !! Push values onto Lua stack (generic interface)
      module procedure flua_push_d     !! Push real value
      module procedure flua_push_d1    !! Push array of reals
      module procedure flua_push_i     !! Push integer
      module procedure flua_push_c     !! Push character string
      module procedure flua_push_l     !! Push logical
   end interface


   interface flua_pop
      !! Pop values from Lua stack (generic interface)
      module procedure flua_pop_d     !! Pop real value
      module procedure flua_pop_d1    !! Pop array of reals
      module procedure flua_pop_i     !! Pop integer
      module procedure flua_pop_i1    !! Pop array of integers
      module procedure flua_pop_c     !! Pop character string
      module procedure flua_pop_l     !! Pop logical
   end interface


   interface flua_setvar
      !! Set global variables in Lua (generic interface)
      module procedure flua_setvar_d
      module procedure flua_setvar_d1
      module procedure flua_setvar_i
      module procedure flua_setvar_c
      module procedure flua_setvar_l
   end interface


   interface flua_getvar
      !! Get global variables from Lua (generic interface)
      module procedure flua_getvar_d
      module procedure flua_getvar_d1
      module procedure flua_getvar_i
      module procedure flua_getvar_i1
      module procedure flua_getvar_c
      module procedure flua_getvar_l
   end interface


contains

   !======================================================================
   ! Lua C-API
   !======================================================================
   subroutine lua_getfield(L, index, name)
      !! Get a field value from a table
      type(c_ptr)                  :: L       !! Lua state
      integer(c_int), intent(in)   :: index   !! Table index on stack
      character(len=*), intent(in) :: name    !! Field name

      interface
         subroutine clua_getfield(L, index, name) bind(C,name="lua_getfield")
            use iso_c_binding
            type(c_ptr), value     :: L
            integer(c_int), value  :: index
            character(kind=c_char) :: name
         end subroutine clua_getfield
      end interface

      call clua_getfield(L, index, trim(name) // c_null_char)
   end subroutine lua_getfield


   subroutine lua_setfield(L, index, name)
      !! Set a field value in a table
      type(c_ptr)                  :: L       !! Lua state
      integer(c_int), intent(in)   :: index   !! Table index on stack
      character(len=*), intent(in) :: name    !! Field name

      interface
         subroutine clua_setfield(L, index, name) bind(C,name="lua_setfield")
            use iso_c_binding
            type(c_ptr), value     :: L
            integer(c_int), value  :: index
            character(kind=c_char) :: name
         end subroutine clua_setfield
      end interface

      call clua_setfield(L, index, trim(name) // c_null_char)
   end subroutine lua_setfield


   subroutine lua_getglobal(L, name)
      !! Get a global variable
      type(c_ptr)                  :: L       !! Lua state
      character(len=*), intent(in) :: name    !! Global variable name

      call lua_getfield(L, LUA_GLOBALSINDEX, name)
   end subroutine lua_getglobal


   subroutine lua_setglobal(L, name)
      !! Set a global variable
      type(c_ptr)                  :: L       !! Lua state
      character(len=*), intent(in) :: name    !! Global variable name

      call lua_setfield(L, LUA_GLOBALSINDEX, name)
   end subroutine lua_setglobal


   function lua_isnil(L, index) result(n)
      !! Check if value at index is nil
      type(c_ptr)                  :: L       !! Lua state
      integer(c_int), intent(in)   :: index   !! Stack index
      logical                      :: n       !! True if nil

      n = (lua_type(L, index) == LUA_TNIL)
   end function lua_isnil


   function lua_isnumber(L, index) result(n)
      !! Check if value at index is a number
      type(c_ptr)                  :: L       !! Lua state
      integer(c_int), intent(in)   :: index   !! Stack index
      logical                      :: n       !! True if number

      n = (lua_type(L, index) == LUA_TNUMBER)
   end function lua_isnumber


   function lua_istable(L, index) result(n)
      !! Check if value at index is a table
      type(c_ptr)                  :: L       !! Lua state
      integer(c_int), intent(in)   :: index   !! Stack index
      logical                      :: n       !! True if table

      n = (lua_type(L, index) == LUA_TTABLE)
   end function lua_istable


   function lua_isstring(L, index) result(n)
      !! Check if value at index is a string
      type(c_ptr)                  :: L       !! Lua state
      integer(c_int), intent(in)   :: index   !! Stack index
      logical                      :: n       !! True if string

      n = (lua_type(L, index) == LUA_TSTRING)
   end function lua_isstring


   function lua_isboolean(L, index) result(n)
      !! Check if value at index is a boolean
      type(c_ptr)                  :: L       !! Lua state
      integer(c_int), intent(in)   :: index   !! Stack index
      logical                      :: n       !! True if boolean

      n = (lua_type(L, index) == LUA_TBOOLEAN)
   end function lua_isboolean


   subroutine lua_newtable(L)
      !! Create a new empty table
      type(c_ptr)               :: L           !! Lua state

      call lua_createtable(L,0,0)
   end subroutine lua_newtable


   function lua_toboolean(L, index) result(n)
      !! Convert a value to boolean
      type(c_ptr)            :: L              !! Lua state
      integer(c_int)         :: index          !! Stack index
      logical                :: n              !! Boolean value

      interface
         function clua_toboolean(L, index) result(n) bind(C,name="lua_toboolean")
            use iso_c_binding
            type(c_ptr), value     :: L
            integer(c_int), value  :: index
            integer(c_int)         :: n
         end function clua_toboolean
      end interface

      n = (clua_toboolean(L, index)/=0)
   end function lua_toboolean


   subroutine lua_pushboolean(L, n)
      !! Push a boolean value onto the stack
      type(c_ptr)               :: L           !! Lua state
      logical                   :: n           !! Boolean value to push

      interface
         subroutine clua_pushboolean(L, n) bind(C,name="lua_pushboolean")
            use iso_c_binding
            type(c_ptr), value     :: L
            integer(c_int), value  :: n
         end subroutine clua_pushboolean
      end interface

      if (n) then
         call clua_pushboolean(L,1)
      else
         call clua_pushboolean(L,0)
      end if
   end subroutine lua_pushboolean


   subroutine lua_pushstring(L, string)
      !! Push a string onto the stack
      type(c_ptr)                :: L         !! Lua state
      character(len=*)           :: string    !! String to push

      interface
         subroutine clua_pushstring(L, s) bind(C,name="lua_pushstring")
            use iso_c_binding
            type(c_ptr), value     :: L
            character(C_CHAR)      :: s
         end subroutine clua_pushstring
      end interface

      call clua_pushstring(L, trim(string) // C_NULL_CHAR)
   end subroutine lua_pushstring


   function lua_tostring(L, index, len) result(s)
      !! Convert a value to a string
      type(c_ptr)                   :: L       !! Lua state
      integer(c_int)                :: index   !! Stack index
      integer(c_int)                :: len     !! Maximum string length
      character(len)                :: s       !! Result string
      character, pointer    :: fptr(:)
      type(c_ptr)           :: cptr
      integer(C_SIZE_T)     :: slen
      integer :: i

      interface
         function clua_tolstring(L, index, len) bind(C,name="lua_tolstring")
            use iso_c_binding
            type(c_ptr), value     :: L
            integer(c_int), value  :: index
            integer(C_SIZE_T)      :: len
            type(c_ptr)            :: clua_tolstring
         end function clua_tolstring
      end interface

      cptr = clua_tolstring(L, index, slen)
      call C_F_POINTER(cptr, fptr, [slen])
      do i = 1, min(slen, len)
         s(i:i) = fptr(i)
      end do
      s(slen+1:len)=""
   end function lua_tostring


   !======================================================================
   ! Lua auxiliary library
   !======================================================================
   function luaL_loadstring(L, string) result(ierr)
      !! Load a Lua chunk from a string
      type(c_ptr)                  :: L       !! Lua state
      character(len=*), intent(in) :: string  !! Lua code to load
      integer(c_int)               :: ierr    !! Return code (0 = success)

      interface
         function cluaL_loadstring(L, string) result(ier) &
            bind(C,name="luaL_loadstring")
            use iso_c_binding
            type(c_ptr), value :: L
            character(kind=c_char) :: string
            integer(c_int)     :: ier
         end function cluaL_loadstring
      end interface

      ierr = cluaL_loadstring(L, trim(string) // C_NULL_CHAR)
   end function luaL_loadstring


   function luaL_loadfile(L, filename) result(ierr)
      !! Load a Lua chunk from a file
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: filename !! File path to load
      integer(c_int)               :: ierr     !! Return code (0 = success)

      interface
         function cluaL_loadfile(L, filename) result(ier) &
            bind(C,name="luaL_loadfile")
            use iso_c_binding
            type(c_ptr), value :: L
            character(kind=c_char) :: filename
            integer(c_int)     :: ier
         end function cluaL_loadfile
      end interface

      ierr = cluaL_loadfile(L, trim(filename) // C_NULL_CHAR)
   end function luaL_loadfile


   function luaL_dostring(L, string) result(ierr)
      !! Execute a Lua chunk from a string
      type(c_ptr)                  :: L       !! Lua state
      character(len=*), intent(in) :: string  !! Lua code to execute
      integer(c_int)               :: ierr    !! Return code (0 = success)

      ierr = luaL_loadstring(L, string)
      if (ierr==0) ierr = lua_pcall(L, 0, LUA_MULTRET, 0)
   end function luaL_dostring


   function luaL_dofile(L, filename) result(ierr)
      !! Execute a Lua chunk from a file
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: filename !! File path to execute
      integer(c_int)               :: ierr     !! Return code (0 = success)

      ierr = luaL_loadfile(L, filename)
      if (ierr==0) ierr = lua_pcall(L, 0, LUA_MULTRET, 0)
   end function luaL_dofile


   !======================================================================
   ! High level F90 API
   !======================================================================
   function flua_newstate(ierr) result(L)
      !! Create a new Lua state
      type(c_ptr)       :: L           !! Lua state pointer
      integer, optional :: ierr        !! Optional error code

      L = luaL_newstate()
      if (present(ierr)) then
         if (c_associated(L)) then
            ierr = 0
         else
            ierr = -1
         end if
      else
         if (.not. c_associated(L)) then
            print *, "FLUA error in flua_newstate()"
            stop
         end if
      end if
   end function flua_newstate


   subroutine flua_close(L)
      !! Close a Lua state
      type(c_ptr) :: L                 !! Lua state to close
      call lua_close(L)

      L = C_NULL_PTR
   end subroutine flua_close


   subroutine flua_openlibs(L,ierr)
      !! Open all standard Lua libraries
      type(c_ptr)       :: L           !! Lua state
      integer, optional :: ierr        !! Optional error code

      call luaL_openlibs(L)
      if (present(ierr)) ierr=0
   end subroutine flua_openlibs


   subroutine flua_dostring(L, string, ierr)
      !! Execute a Lua string with error handling
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: string   !! Lua code to execute
      integer, optional            :: ierr     !! Optional error code
      integer :: ier

      ier = luaL_dostring(L, string)
      if (present(ierr)) then
         ierr = ier
      else
         if (ier /= 0) ier = lua_error(L)
      end if
   end subroutine flua_dostring


   subroutine flua_dofile(L, filename, ierr)
      !! Execute a Lua file with error handling
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: filename !! File path to execute
      integer, optional            :: ierr     !! Optional error code
      integer :: ier

      ier = luaL_dofile(L, filename)
      if (present(ierr)) then
         ierr = ier
      else
         if (ier /= 0) ier = lua_error(L)
      end if
   end subroutine flua_dofile


   !----------------------------------------------------------------------
   ! flua_push
   !----------------------------------------------------------------------
   subroutine flua_push_d(L, value, ierr)
      !! Push a real value onto the Lua stack
      type(c_ptr)                  :: L        !! Lua state
      real(C_DOUBLE), intent(in)   :: value    !! Real value to push
      integer, optional            :: ierr     !! Optional error code

      call lua_pushnumber(L, value)
      if (present(ierr)) ierr=0
   end subroutine flua_push_d


   subroutine flua_push_i(L, value, ierr)
      !! Push an integer value onto the Lua stack
      type(c_ptr)                  :: L        !! Lua state
      integer(c_int), intent(in)   :: value    !! Integer value to push
      integer, optional            :: ierr     !! Optional error code

      call lua_pushinteger(L, value)
      if (present(ierr)) ierr=0
   end subroutine flua_push_i


   subroutine flua_push_c(L, value, ierr)
      !! Push a character string onto the Lua stack
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: value    !! String to push
      integer, optional            :: ierr     !! Optional error code

      call lua_pushstring(L, value)
      if (present(ierr)) ierr=0
   end subroutine flua_push_c


   subroutine flua_push_l(L, value, ierr)
      !! Push a logical value onto the Lua stack
      type(c_ptr)                  :: L        !! Lua state
      logical, intent(in)          :: value    !! Logical value to push
      integer, optional            :: ierr     !! Optional error code

      call lua_pushboolean(L, value)
      if (present(ierr)) ierr=0
   end subroutine flua_push_l


   subroutine flua_push_d1(L, array, ierr)
      !! Push a real array onto the Lua stack as a table
      type(c_ptr)                  :: L        !! Lua state
      real(C_DOUBLE), intent(in)   :: array(:) !! Array to push
      integer, optional            :: ierr     !! Optional error code
      integer :: i

      call lua_createtable(L, size(array), 0)
      do i = 1, size(array)
         call lua_pushinteger(L, i)
         call lua_pushnumber(L, array(i))
         call lua_settable(L,-3)
      end do
      if (present(ierr)) ierr=0
   end subroutine flua_push_d1


   !----------------------------------------------------------------------
   ! flua_pop
   !----------------------------------------------------------------------
   subroutine flua_pop_d(L, value, ierr)
      !! Pop a real value from the Lua stack
      type(c_ptr)                  :: L        !! Lua state
      real(C_DOUBLE), intent(inout):: value    !! Real value to pop
      integer, optional            :: ierr     !! Optional error code

      if (lua_isnumber(L,-1)) then
         value = lua_tonumber(L,-1)
         if(present(ierr)) ierr = 0
      else
         if ( .not. present(ierr)) stop "Invalid value in flua_pop(double)"
         ierr = -1
      end if
      call lua_settop(L,-2)
   end subroutine flua_pop_d


   subroutine flua_pop_i(L, value, ierr)
      !! Pop an integer value from the Lua stack
      type(c_ptr)                  :: L        !! Lua state
      integer(c_int), intent(inout):: value    !! Integer value to pop
      integer, optional            :: ierr     !! Optional error code

      if (lua_isnumber(L,-1)) then
         value = lua_tointeger(L,-1)
         if(present(ierr)) ierr = 0
      else
         if ( .not. present(ierr)) stop "Invalid value in flua_pop(int)"
         ierr = -1
      end if
      call lua_settop(L,-2)
   end subroutine flua_pop_i


   subroutine flua_pop_c(L, value, ierr)
      !! Pop a character string from the Lua stack
      type(c_ptr)                    :: L      !! Lua state
      character(len=*), intent(inout):: value  !! String to pop
      integer, optional              :: ierr   !! Optional error code

      if (lua_isstring(L,-1)) then
         value = lua_tostring(L,-1,len(value))
         if(present(ierr)) ierr = 0
      else
         if ( .not. present(ierr)) stop "Invalid value in flua_pop(string)"
         ierr = -1
      end if
      call lua_settop(L,-2)
   end subroutine flua_pop_c


   subroutine flua_pop_l(L, value, ierr)
      !! Pop a logical value from the Lua stack
      type(c_ptr)                    :: L      !! Lua state
      logical, intent(inout)         :: value  !! Logical value to pop
      integer, optional              :: ierr   !! Optional error code

      if (lua_isboolean(L,-1)) then
         value = lua_toboolean(L,-1)
         if(present(ierr)) ierr = 0
      else
         if ( .not. present(ierr)) stop "Invalid value in flua_pop(bool)"
         ierr = -1
      end if
      call lua_settop(L,-2)
   end subroutine flua_pop_l


   subroutine flua_pop_d1(L, array, ierr)
      !! Pop a real array from the Lua stack
      type(c_ptr)                  :: L        !! Lua state
      real(C_DOUBLE), intent(inout):: array(:) !! Array to pop
      integer, optional            :: ierr     !! Optional error code
      integer :: i
      integer :: ie

      if (lua_istable(L,-1)) then
         do i = 1, size(array)
            call lua_pushinteger(L, i)
            call lua_gettable(L,-2)
            call flua_pop(L,array(i),ie)
            if (ie/=0) then
               if ( .not. present(ierr)) stop "Invalid value in flua_pop(double*)"
               ierr = i
               return
            end if
         end do
         if (present(ierr)) ierr = 0
      else
         if ( .not. present(ierr)) stop "Invalid value in flua_pop(double*)"
         ierr = -1
      end if
      call lua_settop(L,-2)
   end subroutine flua_pop_d1


   subroutine flua_pop_i1(L, array, ierr)
      !! Pop an integer array from the Lua stack
      type(c_ptr)                  :: L        !! Lua state
      integer(c_int), intent(inout):: array(:) !! Array to pop
      integer, optional            :: ierr     !! Optional error code
      integer :: i
      integer :: ie

      if (lua_istable(L,-1)) then
         do i = 1, size(array)
            call lua_pushinteger(L, i)
            call lua_gettable(L,-2)
            call flua_pop(L,array(i),ie)
            if (ie/=0) then
               if ( .not. present(ierr)) stop "Invalid value in flua_pop()"
               ierr = i
               return
            end if
         end do
         if (present(ierr)) ierr = 0
      else
         if ( .not. present(ierr)) stop "Invalid value in flua_pop()"
         ierr = -1
      end if
      call lua_settop(L,-2)
   end subroutine flua_pop_i1


   !----------------------------------------------------------------------
   ! flua_setvar
   !----------------------------------------------------------------------
   subroutine flua_setvar_d(L, name, value, ierr)
      !! Set a global real variable in Lua
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: name     !! Variable name
      real(C_DOUBLE), intent(in)   :: value    !! Real value to set
      integer, optional            :: ierr     !! Optional error code

      call flua_push(L,value)
      call lua_setglobal(L,name)
      if (present(ierr)) ierr=0
   end subroutine flua_setvar_d


   subroutine flua_setvar_i(L, name, value, ierr)
      !! Set a global integer variable in Lua
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: name     !! Variable name
      integer(c_int), intent(in)   :: value    !! Integer value to set
      integer, optional            :: ierr     !! Optional error code

      call flua_push(L,value)
      call lua_setglobal(L,name)
      if (present(ierr)) ierr=0
   end subroutine flua_setvar_i


   subroutine flua_setvar_c(L, name, value, ierr)
      !! Set a global string variable in Lua
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: name     !! Variable name
      character(len=*), intent(in) :: value    !! String value to set
      integer, optional            :: ierr     !! Optional error code

      call flua_push(L,value)
      call lua_setglobal(L,name)
      if (present(ierr)) ierr=0
   end subroutine flua_setvar_c


   subroutine flua_setvar_l(L, name, value, ierr)
      !! Set a global logical variable in Lua
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: name     !! Variable name
      logical, intent(in)          :: value    !! Logical value to set
      integer, optional            :: ierr     !! Optional error code

      call flua_push(L,value)
      call lua_setglobal(L,name)
      if (present(ierr)) ierr=0
   end subroutine flua_setvar_l


   subroutine flua_setvar_d1(L, name, array, ierr)
      !! Set a global real array variable in Lua
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: name     !! Variable name
      real(C_DOUBLE), intent(in)   :: array(:) !! Array value to set
      integer, optional            :: ierr     !! Optional error code
      integer :: i

      call flua_push(L, array)
      call lua_setglobal(L,name)
      if (present(ierr)) ierr=0
   end subroutine flua_setvar_d1


   !----------------------------------------------------------------------
   ! flua_getvar
   !----------------------------------------------------------------------
   subroutine flua_getvar_d(L, name, value, ierr)
      !! Get a global real variable from Lua
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: name     !! Variable name
      real(C_DOUBLE), intent(inout):: value    !! Real value to get
      integer, optional            :: ierr     !! Optional error code

      call lua_getglobal(L,name)
      if (present(ierr)) then
         call flua_pop(L, value, ierr)
      else
         call flua_pop(L, value)
      end if
   end subroutine flua_getvar_d


   subroutine flua_getvar_i(L, name, value, ierr)
      !! Get a global integer variable from Lua
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: name     !! Variable name
      integer(c_int), intent(inout):: value    !! Integer value to get
      integer, optional            :: ierr     !! Optional error code

      call lua_getglobal(L,name)
      if (present(ierr)) then
         call flua_pop(L, value, ierr)
      else
         call flua_pop(L, value)
      end if
   end subroutine flua_getvar_i


   subroutine flua_getvar_c(L, name, value, ierr)
      !! Get a global string variable from Lua
      type(c_ptr)                     :: L     !! Lua state
      character(len=*), intent(in)    :: name  !! Variable name
      character(len=*), intent(inout) :: value !! String value to get
      integer, optional               :: ierr  !! Optional error code
      call lua_getglobal(L,name)
      if (present(ierr)) then
         call flua_pop(L, value, ierr)
      else
         call flua_pop(L, value)
      end if
   end subroutine flua_getvar_c


   subroutine flua_getvar_l(L, name, value, ierr)
      !! Get a global logical variable from Lua
      type(c_ptr)                     :: L     !! Lua state
      character(len=*), intent(in)    :: name  !! Variable name
      logical, intent(inout)          :: value !! Logical value to get
      integer, optional               :: ierr  !! Optional error code

      call lua_getglobal(L,name)
      if (present(ierr)) then
         call flua_pop(L, value, ierr)
      else
         call flua_pop(L, value)
      end if
   end subroutine flua_getvar_l


   subroutine flua_getvar_d1(L, name, array, ierr)
      !! Get a global real array variable from Lua
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: name     !! Variable name
      real(C_DOUBLE), intent(inout):: array(:) !! Array value to get
      integer, optional            :: ierr     !! Optional error code

      call lua_getglobal(L,name)
      if (present(ierr)) then
         call flua_pop(L, array, ierr)
      else
         call flua_pop(L, array)
      end if
   end subroutine flua_getvar_d1


   subroutine flua_getvar_i1(L, name, array, ierr)
      !! Get a global integer array variable from Lua
      type(c_ptr)                  :: L        !! Lua state
      character(len=*), intent(in) :: name     !! Variable name
      integer(c_int), intent(inout):: array(:) !! Array value to get
      integer, optional            :: ierr     !! Optional error code

      call lua_getglobal(L,name)
      if (present(ierr)) then
         call flua_pop(L, array, ierr)
      else
         call flua_pop(L, array)
      end if
   end subroutine flua_getvar_i1


end module flua

