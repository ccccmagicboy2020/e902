// xbr820_reg_verify_helper.h : main header file for the xbr820_reg_verify_helper application
//

#if !defined(AFX_xbr820_reg_verify_helper_H__61121FF6_25BD_4873_A48A_67CD0F9FF2C1__INCLUDED_)
#define AFX_xbr820_reg_verify_helper_H__61121FF6_25BD_4873_A48A_67CD0F9FF2C1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// Cxbr820_reg_verify_helperApp:
// See xbr820_reg_verify_helper.cpp for the implementation of this class
//

class Cxbr820_reg_verify_helperApp : public CWinApp
{
public:
	Cxbr820_reg_verify_helperApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(Cxbr820_reg_verify_helperApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(Cxbr820_reg_verify_helperApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

public:
	unsigned int g_adc_ac_sum;
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_xbr820_reg_verify_helper_H__61121FF6_25BD_4873_A48A_67CD0F9FF2C1__INCLUDED_)
