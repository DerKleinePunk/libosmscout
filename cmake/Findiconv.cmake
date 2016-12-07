
# Copyright (C) 2012-2014 Daniel Scharrer
#
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the author(s) be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

# Try to find the iconv library and include path for iconv.h.
# Once done this will define
#
# ICONV_FOUND
# ICONV_INCLUDE_DIR   Where to find iconv.h
# ICONV_LIBRARIES     The libiconv library or empty if none was found
# ICONV_DEFINITIONS   Definitions to use when compiling code that uses iconv
#
# An empty ICONV_LIBRARIES is not an error as iconv is often included in the system libc.
#
# Typical usage could be something like:
#   find_package(iconv REQUIRED)
#   include_directories(SYSTEM ${ICONV_INCLUDE_DIR})
#   add_definitions(${ICONV_DEFINITIONS})
#   ...
#   target_link_libraries(myexe ${ICONV_LIBRARIES})
#

if(APPLE)
	# Prefer local iconv.h location over the system iconv.h location as /opt/local/include
	# may be added to the include path by other libraries, resulting in the #include
	# statements finding the local copy while we will link agains the system lib.
	# This way we always find both include file and library in /opt/local/ if there is one.
	find_path(ICONV_INCLUDE_DIR iconv.h
		PATHS /opt/local/include
		DOC "The directory where iconv.h resides"
		NO_CMAKE_SYSTEM_PATH
	)
endif(APPLE)

find_path(ICONV_INCLUDE_DIR iconv.h
	PATHS /opt/local/include
	DOC "The directory where iconv.h resides"
)
mark_as_advanced(ICONV_INCLUDE_DIR)

# Prefer libraries in the same prefix as the include files
string(REGEX REPLACE "(.*)/include/?" "\\1" ICONV_BASE_DIR ${ICONV_INCLUDE_DIR})

find_library(ICONV_LIBRARY iconv libiconv
	HINTS "${iconv_BASE_DIR}/lib"
	PATHS /opt/local/lib
	DOC "The iconv library"
)
mark_as_advanced(ICONV_LIBRARY)

set(ICONV_DEFINITIONS)
#if(WIN32 AND ICONV_USE_STATIC_LIBS)
#	set(ICONV_DEFINITIONS -DLIBICONV_STATIC -DUSING_STATIC_LIBICONV)
#endif()

# handle the QUIETLY and REQUIRED arguments and set ICONV_FOUND to TRUE if 
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(iconv DEFAULT_MSG ICONV_INCLUDE_DIR)

# For some reason, find_package_... uppercases it's first argument. Nice!
if(ICONV_FOUND)
	set(ICONV_LIBRARIES)
	if(ICONV_LIBRARY)
		list(APPEND ICONV_LIBRARIES ${ICONV_LIBRARY})
	endif()
endif(ICONV_FOUND)
