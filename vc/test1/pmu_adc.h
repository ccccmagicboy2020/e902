// pmu_adc.h : main header file for the pmu_adc application
//

#if !defined(AFX_pmu_adc_H__61121FF6_25BD_4873_A48A_67CD0F9FF2C1__INCLUDED_)
#define AFX_pmu_adc_H__61121FF6_25BD_4873_A48A_67CD0F9FF2C1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// Cpmu_adcApp:
// See pmu_adc.cpp for the implementation of this class
//

class Cpmu_adcApp : public CWinApp
{
public:
	Cpmu_adcApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(Cpmu_adcApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(Cpmu_adcApp)
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

#endif // !defined(AFX_pmu_adc_H__61121FF6_25BD_4873_A48A_67CD0F9FF2C1__INCLUDED_)
