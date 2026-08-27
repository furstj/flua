program test_flua_c

   use testdrive, only : run_testsuite, new_testsuite, testsuite_type, error_type, check
   use iso_fortran_env, only : error_unit
   use flua_c

   implicit none

   integer :: stat, is
   type(testsuite_type), allocatable :: testsuites(:)
   character(len=*), parameter :: fmt = '("#", *(1x, a))'

   stat = 0

   testsuites = [ &
      new_testsuite("New state", collect_new_state), &
      new_testsuite("Load file", collect_load_file), &
      new_testsuite("Read variables", collect_read_variables) &
      ]

   do is = 1, size(testsuites)
      write(error_unit, fmt) "Testing:", testsuites(is)%name
      call run_testsuite(testsuites(is)%collect, error_unit, stat)
   end do

   if (stat > 0) then
      write(error_unit, '(i0, 1x, a)') stat, "test(s) failed!"
      error stop
   end if

contains

   !==================================================================================
   ! Collect test cases for creating a new Lua state
   !==================================================================================
   subroutine collect_new_state(testsuite)
      use testdrive, only : new_unittest, unittest_type
      type(unittest_type), allocatable, intent(out) :: testsuite(:)

      testsuite = [ &
         new_unittest("luaL_newstate", test_luaL_newstate) &
         ]
   end subroutine collect_new_state


   subroutine test_luaL_newstate(error)
      use flua_c, only: luaL_newstate, lua_close
      use iso_c_binding, only: c_ptr, c_associated
      type(error_type), allocatable, intent(out) :: error
      type(c_ptr) :: L

      L = luaL_newstate()
      if (.not. c_associated(L)) then
         call check(error, .false., "Failed to create Lua state")
         return
      end if
      call lua_close(L)
   end subroutine test_luaL_newstate


   !==================================================================================
   ! Collect test cases for loading a Lua file
   !==================================================================================
   subroutine collect_load_file(testsuite)
      use testdrive, only : new_unittest, unittest_type
      type(unittest_type), allocatable, intent(out) :: testsuite(:)

      testsuite = [ &
         new_unittest("luaL_dofile", test_load_file) &
         ]
   end subroutine collect_load_file


   function load_file(filename, error) result(L)
      use flua_c, only : luaL_newstate, luaL_dofile, lua_close
      use iso_c_binding, only : c_ptr, c_associated, c_null_ptr
      type(error_type), allocatable, intent(out) :: error
      type(c_ptr) :: L
      character(len=*), intent(in) :: filename
      integer :: ierr

      L = luaL_newstate()
      if (.not. c_associated(L)) then
         call check(error, .false., "Failed to create Lua state")
         L = c_null_ptr
         return
      end if

      ierr = luaL_dofile(L, filename)
      if (ierr /= 0) then
         call check(error, .false., "Failed to load " // filename)
         call lua_close(L)
         L = c_null_ptr
         return
      end if
   end function load_file


   subroutine test_load_file(error)
      use iso_c_binding, only : c_ptr, c_associated
      type(error_type), allocatable, intent(out) :: error
      type(c_ptr)       :: L
      integer :: i, ierr
  
      L = load_file("test/data.lua", error)
      if (.not. c_associated(L)) return
      L = luaL_newstate()
      call lua_close(L)

   end subroutine test_load_file

   !==================================================================================
   ! Collect test cases for reading variables from Lua
   !==================================================================================
   subroutine collect_read_variables(testsuite)
      use testdrive, only : new_unittest, unittest_type
      type(unittest_type), allocatable, intent(out) :: testsuite(:)

      testsuite = [ &
         new_unittest("lua_getglobal - number", test_getglobal_number), &
         new_unittest("lua_getglobal - string", test_getglobal_string), &
         new_unittest("lua_getglobal - boolean", test_getglobal_boolean), &
         new_unittest("lua_getglobal - array", test_getglobal_array) &
         ]

   end subroutine collect_read_variables

   subroutine test_getglobal_number(error)
      use flua_c, only : lua_getglobal, &
         lua_isnumber, lua_tonumber, lua_settop, lua_close
      use iso_c_binding, only : c_ptr, c_associated
      use iso_fortran_env, only : real64
      type(error_type), allocatable, intent(out) :: error
      type(c_ptr)       :: L
      real(real64)  :: x

      L = load_file("test/data.lua", error)
      if (.not. c_associated(L)) return

      call lua_getglobal(L, "x")
      if (.not. lua_isnumber(L, -1)) then
         call check(error, .false., "x is not a number")
         call lua_close(L)
         return
      end if
      x = lua_tonumber(L, -1)
      if (x /= 1.0d0) then
         call check(error, .false., "x /= 1.0")
         call lua_close(L)
         return
      end if

      call lua_settop(L, 0)
      call lua_close(L)
   end subroutine test_getglobal_number


   subroutine test_getglobal_string(error)
      use flua_c, only : lua_getglobal, lua_isstring, lua_tostring, &
         lua_settop, lua_close
      use iso_c_binding, only : c_ptr, c_associated
      type(error_type), allocatable, intent(out) :: error
      type(c_ptr)       :: L
      character(len=32) :: s

      L = load_file("test/data.lua", error)
      if (.not. c_associated(L)) return

      call lua_getglobal(L, "text")
      if (.not. lua_isstring(L, -1)) then
         call check(error, .false., "text is not a string")
         call lua_close(L)
         return
      end if
      s = lua_tostring(L, -1, 32)
      if (s /= "Hello world!") then
         call check(error, .false., "text /= 'Hello world!'")
         call lua_close(L)
         return
      end if

      call lua_settop(L, 0)
      call lua_close(L)
   end subroutine test_getglobal_string


   subroutine test_getglobal_boolean(error)
      use flua_c, only : lua_getglobal, lua_isboolean, lua_toboolean, &
         lua_settop, lua_close
      use iso_c_binding, only : c_ptr, c_associated
      type(error_type), allocatable, intent(out) :: error
      type(c_ptr)       :: L
      logical :: b

      L = load_file("test/data.lua", error)
      if (.not. c_associated(L)) return

      call lua_getglobal(L, "bool")
      if (.not. lua_isboolean(L, -1)) then
         call check(error, .false., "bool is not a boolean")
         call lua_close(L)
         return
      end if
      b = lua_toboolean(L, -1)
      if (b .neqv. .true.) then
         call check(error, .false., "bool is not .true.")
         call lua_close(L)
         return
      end if

      call lua_settop(L, 0)
      call lua_close(L)
   end subroutine test_getglobal_boolean


   subroutine test_getglobal_array(error)
      use flua_c, only : lua_getglobal, lua_istable, lua_objlen, &
         lua_pushinteger, lua_gettable, lua_tointeger, &
         lua_settop, lua_close
      use iso_c_binding, only : c_ptr, c_associated
      type(error_type), allocatable, intent(out) :: error
      type(c_ptr)       :: L
      integer :: i, n
      character(len=64) :: msg

      L = load_file("test/data.lua", error)
      if (.not. c_associated(L)) return

      call lua_getglobal(L, "a")
      if (.not. lua_istable(L, -1)) then
         call check(error, .false., "a is not a table")
         call lua_close(L)
         return
      end if
      n = lua_objlen(L, -1)
      if (n /= 10) then
         call check(error, .false., "length of a /= 10")
         call lua_close(L)
         return
      end if

      do i = 1, 10
         call lua_pushinteger(L, i)
         call lua_gettable(L, -2)
         n = lua_tointeger(L, -1)
         if (n /= i*i) then
            write(msg, '(a,i0,a,i0,a)') "a(", i, ") /= ", i*i, ""
            call check(error, .false., trim(msg))
            call lua_close(L)
            return
         end if
         call lua_settop(L, -2)
      end do

      call lua_settop(L, 0)
      call lua_close(L)
   end subroutine test_getglobal_array

end program test_flua_c
