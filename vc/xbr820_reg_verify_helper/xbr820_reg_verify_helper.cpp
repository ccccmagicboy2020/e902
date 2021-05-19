// xbr820_reg_verify_helper.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "xbr820_reg_verify_helper.h"
#include "xbr820_reg_verify_helperDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// Cxbr820_reg_verify_helperApp

BEGIN_MESSAGE_MAP(Cxbr820_reg_verify_helperApp, CWinApp)
	//{{AFX_MSG_MAP(Cxbr820_reg_verify_helperApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// Cxbr820_reg_verify_helperApp construction

Cxbr820_reg_verify_helperApp::Cxbr820_reg_verify_helperApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only Cxbr820_reg_verify_helperApp object

Cxbr820_reg_verify_helperApp theApp;

/////////////////////////////////////////////////////////////////////////////
// Cxbr820_reg_verify_helperApp initialization

BOOL Cxbr820_reg_verify_helperApp::InitInstance()
{
	if (!AfxSocketInit())
	{
		AfxMessageBox(IDP_SOCKETS_INIT_FAILED);
		return FALSE;
	}

	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	Cxbr820_reg_verify_helperDlg dlg;
	m_pMainWnd = &dlg;
	int nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}
