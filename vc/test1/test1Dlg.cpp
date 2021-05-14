// test1Dlg.cpp : implementation file
//

#include "stdafx.h"
#include "test1.h"
#include "test1Dlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTest1Dlg dialog

CTest1Dlg::CTest1Dlg(CWnd* pParent /*=NULL*/)
	: CDialog(CTest1Dlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CTest1Dlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CTest1Dlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CTest1Dlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CTest1Dlg, CDialog)
	//{{AFX_MSG_MAP(CTest1Dlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON1, OnButton1)
	ON_WM_CLOSE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTest1Dlg message handlers

BOOL CTest1Dlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	//
	//
	//
	//

	
	init_default_config(&cfg);

	/* Init verbose output channel. */
	dbg_debug_channel_init (cfg.misc.msgout, cfg.misc.errout, cfg.misc.verbose);
	
	/* Create target.  */
    if (target_init (&cfg)) {
        //
		//
		return TRUE;
    }

	/* Print target version. */
    target_print_version ();
    if (cfg.misc.print_version) {
		//
		return TRUE;
    }

    /* Open device. */
    cfg.target = target_open (&cfg);
    if (!(cfg.target && target_is_connected (cfg.target))) {
		//
		return TRUE;
    }

	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CTest1Dlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CTest1Dlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CTest1Dlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

int CTest1Dlg::test_memory( struct target *target )
{
	unsigned char rbuff[128];
	int ret = 0;
	unsigned int adc_raw = 0;		//adc实时值
	unsigned int bb = 0;			//基带设置及使能
	unsigned int bb_timer = 0;		//基带采样速度
	unsigned int adc_ac_sum = 0;	//馒头波的累计值
	unsigned int adc_ac_avg = 0;	//馒头波的平均值
	unsigned int adc_dc_sum = 0;	//adc raw data累加，如可以用于光敏
	unsigned int adc_dc_avg_history1 = 0;	//adc dc 平均历史值
	unsigned int adc_dc_avg_history2 = 0;	//adc dc 平均历史值
	unsigned int adc_dc_avg_history3 = 0;	//adc dc 平均历史值
	unsigned int adc_dc_avg_history4 = 0;	//adc dc 平均历史值
	unsigned int temp_val = 0;				
	unsigned int bb_adc_thersh1 = 0;		//距离门限
	unsigned int bb_adc_thersh2 = 0;		//底躁门限
	unsigned int noise_config = 0;			//设定的noise值
	unsigned int used_noise_val = 0;		//实际用的noise值（基于throshold2变化，或者不基于变化）
	unsigned int t1_val = 0;			//感应延时时间
	unsigned int t2_val = 0;			//锁定停顿延时
	unsigned int io_config = 0;			//输出引脚的控制

	printf ("=================== xbr820 pmu adc part test ==================\n\n");

	ret = target_read_memory(target, XBR820_PMU_BASE, (unsigned char *)rbuff, 128);	//pmu controller register
	if (ret < 0) {
		return ret;
	}
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x30, (unsigned char *)&t1_val, 4);
	t1_val = 3*32000;	//设置为3s的感应延时
	target_write_memory(target, XBR820_PMU_BASE + 0x30, (unsigned char *)&t1_val, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x34, (unsigned char *)&t2_val, 4);
	t2_val = 1*32000;	//设置为1s的死区时间，如解决继电器的干扰
	target_write_memory(target, XBR820_PMU_BASE + 0x34, (unsigned char *)&t2_val, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x38, (unsigned char *)&io_config, 4);
	io_config |= 0x00000008;	//p2.1算法模块输出io使能
	target_write_memory(target, XBR820_PMU_BASE + 0x38, (unsigned char *)&io_config, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x44, (unsigned char *)&bb, 4);
	//bb = bb | 0x00000002;//使能adc并且用bb控制adc并且使能32点的平均
	bb = bb | 0x0000000e;//使能adc并且用bb控制adc并且使能256点的平均
	target_write_memory(target, XBR820_PMU_BASE + 0x44, (unsigned char *)&bb, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x28, (unsigned char *)&adc_raw, 4);
	adc_raw &= 0x00000FFF;//取出adc的值
	printf("adc raw value: 0x%04X(%d)\n", adc_raw, adc_raw);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x48, (unsigned char *)&bb_adc_thersh1, 4);
	bb_adc_thersh1 = 0x3fff;//调这里可以调感应距离
	target_write_memory(target, XBR820_PMU_BASE + 0x48, (unsigned char *)&bb_adc_thersh1, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x4C, (unsigned char *)&bb_adc_thersh2, 4);
	bb_adc_thersh2 = 0x1000;//调这里可以去工频干扰，或者一些现场的干扰
	target_write_memory(target, XBR820_PMU_BASE + 0x4C, (unsigned char *)&bb_adc_thersh2, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	noise_config = 0x00000260;//写入初始环境noise对比值
	target_write_memory(target, XBR820_PMU_BASE + 0x50, (unsigned char *)&noise_config, 4);
	noise_config = 0x00001260;//使数据加载到算法模块
	target_write_memory(target, XBR820_PMU_BASE + 0x50, (unsigned char *)&noise_config, 4);
	target_read_memory(target, XBR820_PMU_BASE + 0x50, (unsigned char *)&temp_val, 4);
	used_noise_val = (temp_val & 0x0fff0000) >> 16;//取出值
	printf("used_noise_val value: 0x%08X\n", used_noise_val);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x54, (unsigned char *)&bb_timer, 4);
	bb_timer = (32000/1000) - 1;//1k采样bb速度
	//bb_timer = (32000/8000) - 1;//8k采样bb速度
	//bb_timer = (32000/16000) - 1;//16k采样bb速度
	target_write_memory(target, XBR820_PMU_BASE + 0x54, (unsigned char *)&bb_timer, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x70, (unsigned char *)&adc_ac_sum, 4);
	adc_ac_sum &= 0x003fffff;//取出值
	printf("adc_ac_sum value: 0x%08X(%d)\n", adc_ac_sum, adc_ac_sum);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x74, (unsigned char *)&adc_ac_avg, 4);
	adc_ac_avg &= 0x00000fff;//取出值
	printf("adc_ac_avg value: 0x%04X(%d)\n", adc_ac_avg, adc_ac_avg);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x78, (unsigned char *)&adc_dc_sum, 4);
	adc_dc_sum &= 0x003fffff;//取出值
	printf("adc_dc_sum value: 0x%08X(%d)\n", adc_dc_sum, adc_dc_sum);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x7C, (unsigned char *)&temp_val, 4);
	adc_dc_avg_history1 = temp_val & 0x00000fff;//取出值
	adc_dc_avg_history2 = (temp_val & 0x0fff0000) >> 16;//取出值
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x80, (unsigned char *)&temp_val, 4);
	adc_dc_avg_history3 = temp_val & 0x00000fff;//取出值
	adc_dc_avg_history4 = (temp_val & 0x0fff0000) >> 16;//取出值

	return 0;
}

void CTest1Dlg::OnButton1() 
{
	// TODO: Add your control notification handler code here
	/* Memory access test.  */
	test_memory(cfg.target);
}

void CTest1Dlg::PostNcDestroy() 
{
	// TODO: Add your specialized code here and/or call the base class
	
	CDialog::PostNcDestroy();
}

void CTest1Dlg::OnClose() 
{
	// TODO: Add your message handler code here and/or call default
	target_close (cfg.target);

	CDialog::OnClose();
}
