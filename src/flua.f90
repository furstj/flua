module flua
   
   !! Fortran wrapper to the Lua scripting language (http://www.lua.org/)
   !!
   !! @note
   !! The bindings target the **Lua 5.1 API** on purpose, for compatibility
   !! with LuaJIT.
   !! @endnote

   use flua_c         !! Lua C-API bindings
   use flua_f95       !! Lua Fortran 95 bindings
   
end module flua

