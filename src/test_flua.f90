program test_flua

   use testdrive, only : run_testsuite, new_testsuite, testsuite_type, error_type, check
   use iso_fortran_env, only : error_unit

   implicit none

   integer :: stat, is
   type(testsuite_type), allocatable :: testsuites(:)
   character(len=*), parameter :: fmt = '("#", *(1x, a))'

   stat = 0

   testsuites = [ &
      new_testsuite("New state", collect_new_state) &
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


   subroutine collect_new_state(testsuite)
      use testdrive, only : new_unittest, unittest_type
      type(unittest_type), allocatable, intent(out) :: testsuite(:)

      testsuite = [ &
         new_unittest("luaL_newstate", test_luaL_newstate), &
         new_unittest("flua_newstate", test_flua_newstate) &
         ]
   end subroutine collect_new_state


   subroutine test_luaL_newstate(error)
      use flua, only: luaL_newstate, lua_close
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


   subroutine test_flua_newstate(error)
      use flua, only: flua_newstate, lua_close
      use iso_c_binding, only: c_ptr, c_associated
      type(error_type), allocatable, intent(out) :: error
      type(c_ptr) :: L

      L = flua_newstate()
      if (.not. c_associated(L)) then
         call check(error, .false., "Failed to create Lua state")
         return
      end if
      call lua_close(L)
   end subroutine test_flua_newstate


end program test_flua
