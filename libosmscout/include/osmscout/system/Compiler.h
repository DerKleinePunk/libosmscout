#ifndef OSMSCOUT_SYSTEM_COMPILER_H
#define OSMSCOUT_SYSTEM_COMPILER_H

/*
  This source is part of the libosmscout library
  Copyright (C) 2016  Tim Teulings

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
*/

#if defined(SWIG)
  #define CLASS_FINAL
#else
  #define CLASS_FINAL final
#endif

/**
 * Some temporary variables used in asserts may be unused
 * on production build, when asserts are wiped out.
 *
 * Usage of this macro for such variables makes production
 * build happy, and avoids unused-variable warning
 *
 * TODO: use [[maybe_unused]] attribute with C++17
 */
#define unused(x) ((void)(x))

#endif
