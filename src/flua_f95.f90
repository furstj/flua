module flua_f95

   !! Fortran 95 api for flua library
   !!
   !! This module provides a Fortran 95 helpers for the flua library.
   !! It contains functions for creating and managing Lua states, executing Lua code, and interacting with Lua variables.

   use iso_c_binding
   use flua_c            !! Lua C-API bindings

   implicit none

   private

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

end module flua_f95
