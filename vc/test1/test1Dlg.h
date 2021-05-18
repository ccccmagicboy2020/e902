// test1Dlg.h : header file
//

#if !defined(AFX_TEST1DLG_H__2FA31913_73F8_4C8C_B6BC_1C2497ACD5CD__INCLUDED_)
#define AFX_TEST1DLG_H__2FA31913_73F8_4C8C_B6BC_1C2497ACD5CD__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


/////////////////////////////////////////////////////////////////////////////
// CTest1Dlg dialog

class CTest1Dlg : public CDialog
{
// Construction
public:
	CTest1Dlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CTest1Dlg)
	enum { IDD = IDD_TEST1_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CTest1Dlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual void PostNcDestroy();
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CTest1Dlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButton1();
	afx_msg void OnClose();
	afx_msg void OnTimer(UINT nIDEvent);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

public:
	static UINT Read_ac( void* p_Param );		//thread0

public:
	CEvent	m_event[MAXIMUM_WAIT_OBJECTS];	//for thread0
	HANDLE	m_event_handle[MAXIMUM_WAIT_OBJECTS];
	//
	int test_memory (struct target *target);
	void init_timer();
	void init_thread();
	void waitThreads();
	void update_var_display();
public:
	dbg_server_cfg_t cfg;
	struct halt_info info;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TEST1DLG_H__2FA31913_73F8_4C8C_B6BC_1C2497ACD5CD__INCLUDED_)
