// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__CFF3F76C_57AF_4CEF_A543_385A6B9C238A__INCLUDED_)
#define AFX_STDAFX_H__CFF3F76C_57AF_4CEF_A543_385A6B9C238A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define VC_EXTRALEAN		// Exclude rarely-used stuff from Windows headers

#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions
#include <afxdisp.h>        // MFC Automation classes
#include <afxdtctl.h>		// MFC support for Internet Explorer 4 Common Controls
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>			// MFC support for Windows Common Controls
#endif // _AFX_NO_AFXCMN_SUPPORT

#include <afxsock.h>		// MFC socket extensions

#include <afxmt.h>

//cklink sdk lib
#include "./includes/dbg-cfg.h"
#include "./includes/dbg-target.h"
#include "./includes/debug.h"
#pragma comment (lib, "XmlParser.lib")
#pragma comment (lib, "Utils.lib")
#pragma comment (lib, "Target.lib")
#pragma comment (lib, "libusb-1.0.lib")

//xbr820 mcu register
#include "xbr820/xbr820.h"

///增强调试TRACE输出
#ifdef _DEBUG
#include "3rd_part\xtracestd\xtrace.h"
#include "3rd_part\xtracestd\xtracestd.h"
#endif

///thread name
#include "3rd_part\thread_name\thread_name.h"

///mdebug输出
#include "3rd_part/mdebug/mdebug.h"


//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__CFF3F76C_57AF_4CEF_A543_385A6B9C238A__INCLUDED_)
