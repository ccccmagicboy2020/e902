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
	unsigned int adc_raw = 0;		//adcʵʱֵ
	unsigned int bb = 0;			//�������ü�ʹ��
	unsigned int bb_timer = 0;		//���������ٶ�
	unsigned int adc_ac_sum = 0;	//��ͷ�����ۼ�ֵ
	unsigned int adc_ac_avg = 0;	//��ͷ����ƽ��ֵ
	unsigned int adc_dc_sum = 0;	//adc raw data�ۼӣ���������ڹ���
	unsigned int adc_dc_avg_history1 = 0;	//adc dc ƽ����ʷֵ
	unsigned int adc_dc_avg_history2 = 0;	//adc dc ƽ����ʷֵ
	unsigned int adc_dc_avg_history3 = 0;	//adc dc ƽ����ʷֵ
	unsigned int adc_dc_avg_history4 = 0;	//adc dc ƽ����ʷֵ
	unsigned int temp_val = 0;				
	unsigned int bb_adc_thersh1 = 0;		//��������
	unsigned int bb_adc_thersh2 = 0;		//��������
	unsigned int noise_config = 0;			//�趨��noiseֵ
	unsigned int used_noise_val = 0;		//ʵ���õ�noiseֵ������throshold2�仯�����߲����ڱ仯��
	unsigned int t1_val = 0;			//��Ӧ��ʱʱ��
	unsigned int t2_val = 0;			//����ͣ����ʱ
	unsigned int io_config = 0;			//������ŵĿ���

	printf ("=================== xbr820 pmu adc part test ==================\n\n");

	ret = target_read_memory(target, XBR820_PMU_BASE, (unsigned char *)rbuff, 128);	//pmu controller registers
	if (ret < 0) {
		return ret;
	}
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x30, (unsigned char *)&t1_val, 4);
	t1_val = 3*32000;	//����Ϊ3s�ĸ�Ӧ��ʱ
	target_write_memory(target, XBR820_PMU_BASE + 0x30, (unsigned char *)&t1_val, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x34, (unsigned char *)&t2_val, 4);
	t2_val = 1*32000;	//����Ϊ1s������ʱ�䣬�����̵����ĸ���
	target_write_memory(target, XBR820_PMU_BASE + 0x34, (unsigned char *)&t2_val, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x38, (unsigned char *)&io_config, 4);
	io_config |= 0x00000008;	//p2.1�㷨ģ�����ioʹ��
	target_write_memory(target, XBR820_PMU_BASE + 0x38, (unsigned char *)&io_config, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x44, (unsigned char *)&bb, 4);
	//bb = bb | 0x00000002;//ʹ��adc������bb����adc����ʹ��32���ƽ��
	bb = bb | 0x0000000e;//ʹ��adc������bb����adc����ʹ��256���ƽ��
	target_write_memory(target, XBR820_PMU_BASE + 0x44, (unsigned char *)&bb, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x28, (unsigned char *)&adc_raw, 4);
	adc_raw &= 0x00000FFF;//ȡ��adc��ֵ
	printf("adc raw value: 0x%04X(%d)\n", adc_raw, adc_raw);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x48, (unsigned char *)&bb_adc_thersh1, 4);
	bb_adc_thersh1 = 0x3fff;//��������Ե���Ӧ����
	target_write_memory(target, XBR820_PMU_BASE + 0x48, (unsigned char *)&bb_adc_thersh1, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x4C, (unsigned char *)&bb_adc_thersh2, 4);
	bb_adc_thersh2 = 0x1000;//���������ȥ��Ƶ���ţ�����һЩ�ֳ��ĸ���
	target_write_memory(target, XBR820_PMU_BASE + 0x4C, (unsigned char *)&bb_adc_thersh2, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	noise_config = 0x00000260;//д���ʼ����noise�Ա�ֵ
	target_write_memory(target, XBR820_PMU_BASE + 0x50, (unsigned char *)&noise_config, 4);
	//delay here
	//
	noise_config = 0x00001260;//ʹ���ݼ��ص��㷨ģ��
	target_write_memory(target, XBR820_PMU_BASE + 0x50, (unsigned char *)&noise_config, 4);
	target_read_memory(target, XBR820_PMU_BASE + 0x50, (unsigned char *)&temp_val, 4);
	used_noise_val = (temp_val & 0x0fff0000) >> 16;//ȡ��ֵ
	printf("used_noise_val value: 0x%08X\n", used_noise_val);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x54, (unsigned char *)&bb_timer, 4);
	bb_timer = (32000/1000) - 1;//1k����bb�ٶ�
	//bb_timer = (32000/8000) - 1;//8k����bb�ٶ�
	//bb_timer = (32000/16000) - 1;//16k����bb�ٶ�
	target_write_memory(target, XBR820_PMU_BASE + 0x54, (unsigned char *)&bb_timer, 4);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x70, (unsigned char *)&adc_ac_sum, 4);
	adc_ac_sum &= 0x003fffff;//ȡ��ֵ
	printf("adc_ac_sum value: 0x%08X(%d)\n", adc_ac_sum, adc_ac_sum);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x74, (unsigned char *)&adc_ac_avg, 4);
	adc_ac_avg &= 0x00000fff;//ȡ��ֵ
	printf("adc_ac_avg value: 0x%04X(%d)\n", adc_ac_avg, adc_ac_avg);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x78, (unsigned char *)&adc_dc_sum, 4);
	adc_dc_sum &= 0x003fffff;//ȡ��ֵ
	printf("adc_dc_sum value: 0x%08X(%d)\n", adc_dc_sum, adc_dc_sum);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x7C, (unsigned char *)&temp_val, 4);
	adc_dc_avg_history1 = temp_val & 0x00000fff;//ȡ��ֵ
	adc_dc_avg_history2 = (temp_val & 0x0fff0000) >> 16;//ȡ��ֵ
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x80, (unsigned char *)&temp_val, 4);
	adc_dc_avg_history3 = temp_val & 0x00000fff;//ȡ��ֵ
	adc_dc_avg_history4 = (temp_val & 0x0fff0000) >> 16;//ȡ��ֵ

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
