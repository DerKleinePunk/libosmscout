#ifndef OSMSCOUT_CLIENT_QT_PRIVATE_IMPORT_EXPORT_H
#define OSMSCOUT_CLIENT_QT_PRIVATE_IMPORT_EXPORT_H

/*
  This source is part of the libosmscout-map-svg library
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

#include <osmscout/ClientQtFeatures.h>

// Shared library support
#if defined(_WIN32)
  #if defined(OSMSCOUT_CLIENT_QT_EXPORT_SYMBOLS)
    #if defined(DLL_EXPORT) || defined(_WINDLL)
      #define OSMSCOUT_CLIENT_QT_EXPTEMPL
      #define OSMSCOUT_CLIENT_QT_API __declspec(dllexport)
    #else
      #define OSMSCOUT_CLIENT_QT_API
    #endif
  #else
    #define OSMSCOUT_CLIENT_QT_API __declspec(dllimport)
    #define OSMSCOUT_CLIENT_QT_EXPTEMPL extern
  #endif

  #define OSMSCOUT_CLIENT_QT_DLLLOCAL
#else
  #define OSMSCOUT_CLIENT_QT_IMPORT
  #define OSMSCOUT_CLIENT_QT_EXPTEMPL

  #if defined(OSMSCOUT_CLIENT_QT_EXPORT_SYMBOLS)
    #define OSMSCOUT_CLIENT_QT_EXPORT __attribute__ ((visibility("default")))
    #define OSMSCOUT_CLIENT_QT_DLLLOCAL __attribute__ ((visibility("hidden")))
  #else
    #define OSMSCOUT_CLIENT_QT_EXPORT
    #define OSMSCOUT_CLIENT_QT_DLLLOCAL
  #endif

  #if defined(OSMSCOUT_CLIENT_QT_EXPORT_SYMBOLS)
    #define OSMSCOUT_CLIENT_QT_API OSMSCOUT_CLIENT_QT_EXPORT
  #else
    #define OSMSCOUT_CLIENT_QT_API OSMSCOUT_CLIENT_QT_IMPORT
  #endif

#endif

// Throwable classes must always be visible on GCC in all binaries
#if defined(_WIN32)
  #define OSMSCOUT_CLIENT_QT_EXCEPTIONAPI(api) api
#elif defined(OSMSCOUT_CLIENT_QT_EXPORT_SYMBOLS)
  #define OSMSCOUT_CLIENT_QT_EXCEPTIONAPI(api) OSMSCOUT_CLIENT_QT_EXPORT
#else
  #define OSMSCOUT_CLIENT_QT_EXCEPTIONAPI(api)
#endif

#if defined(_MSC_VER)
  #define OSMSCOUT_CLIENT_QT_INSTANTIATE_TEMPLATES
#endif
#endif

