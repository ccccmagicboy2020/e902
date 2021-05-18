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

	//thread
	int i;
	
	for (i=0;i<MAXIMUM_WAIT_OBJECTS;i++)
	{
		m_event_handle[i] = m_event[i].m_hObject;
	}
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
	ON_WM_TIMER()
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

	init_timer();
	init_thread();

	
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

	TRACE("=================== xbr820 pmu adc part test ==================\n\n");

	ret = target_read_memory(target, XBR820_PMU_BASE, (unsigned char *)rbuff, 128);	//pmu controller registers
	if (ret < 0) {
		return ret;
	}
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x30, (unsigned char *)&t1_val, 4);
	TRACE("delay time read back: %d = %ds", t1_val, t1_val/32000);
	t1_val = 3*32000;	//����Ϊ3s�ĸ�Ӧ��ʱ
	target_write_memory(target, XBR820_PMU_BASE + 0x30, (unsigned char *)&t1_val, 4);
	TRACE("new delay time write: %d = %ds", t1_val, t1_val/32000);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x34, (unsigned char *)&t2_val, 4);
	TRACE("dead time read back: %d = %ds", t2_val, t2_val/32000);
	t2_val = 1*32000;	//����Ϊ1s������ʱ�䣬�����̵����ĸ���
	target_write_memory(target, XBR820_PMU_BASE + 0x34, (unsigned char *)&t2_val, 4);
	TRACE("new dead time write: %d = %ds", t2_val, t2_val/32000);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x38, (unsigned char *)&io_config, 4);
	io_config |= 0x00000008;	//p2.1�㷨ģ�����ioʹ��
	target_write_memory(target, XBR820_PMU_BASE + 0x38, (unsigned char *)&io_config, 4);
	TRACE("enable the p2.1 io output!");
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x44, (unsigned char *)&bb, 4);
	//bb = bb | 0x00000002;//ʹ��adc������bb����adc����ʹ��32���ƽ��
	bb = bb | 0x0000000e;//ʹ��adc������bb����adc����ʹ��256���ƽ��
	target_write_memory(target, XBR820_PMU_BASE + 0x44, (unsigned char *)&bb, 4);
	TRACE("enable bb 256 points avg!");
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x28, (unsigned char *)&adc_raw, 4);
	adc_raw &= 0x00000FFF;//ȡ��adc��ֵ
	TRACE("adc raw value: 0x%04X(%d)\n", adc_raw, adc_raw);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x48, (unsigned char *)&bb_adc_thersh1, 4);
	TRACE("bb_adc_thersh1 read back: 0x%06X(%d)", bb_adc_thersh1, bb_adc_thersh1);
	bb_adc_thersh1 = 0x3fff;//��������Ե���Ӧ����
	target_write_memory(target, XBR820_PMU_BASE + 0x48, (unsigned char *)&bb_adc_thersh1, 4);
	TRACE("new bb_adc_thersh1 write: 0x%06X(%d)", bb_adc_thersh1, bb_adc_thersh1);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x4C, (unsigned char *)&bb_adc_thersh2, 4);
	TRACE("bb_adc_thersh2 read back: 0x%06X(%d)", bb_adc_thersh2, bb_adc_thersh2);
	bb_adc_thersh2 = 0x1000;//���������ȥ��Ƶ���ţ�����һЩ�ֳ��ĸ���
	target_write_memory(target, XBR820_PMU_BASE + 0x4C, (unsigned char *)&bb_adc_thersh2, 4);
	TRACE("new bb_adc_thersh2 write: 0x%06X(%d)", bb_adc_thersh2, bb_adc_thersh2);
//////////////////////////////////////////////////////////////////////////////////////////////////
	noise_config = 0x00000260;//д���ʼ����noise�Ա�ֵ
	target_write_memory(target, XBR820_PMU_BASE + 0x50, (unsigned char *)&noise_config, 4);
	//delay here
	Sleep(10);
	noise_config = 0x00001260;//ʹ���ݼ��ص��㷨ģ��
	target_write_memory(target, XBR820_PMU_BASE + 0x50, (unsigned char *)&noise_config, 4);
	TRACE("load new noise_config to bb: 0x%03X(%d)", noise_config & 0x00000fff, noise_config & 0x00000fff);
	target_read_memory(target, XBR820_PMU_BASE + 0x50, (unsigned char *)&temp_val, 4);
	used_noise_val = (temp_val & 0x0fff0000) >> 16;//ȡ��ֵ
	TRACE("used_noise_val value: 0x%08X(%d)", used_noise_val, used_noise_val);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x54, (unsigned char *)&bb_timer, 4);
	bb_timer = (32000/1000) - 1;//1k����bb�ٶ�
	//bb_timer = (32000/8000) - 1;//8k����bb�ٶ�
	//bb_timer = (32000/16000) - 1;//16k����bb�ٶ�
	target_write_memory(target, XBR820_PMU_BASE + 0x54, (unsigned char *)&bb_timer, 4);
	TRACE("bb timer is set to 1KHz!");
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x70, (unsigned char *)&adc_ac_sum, 4);
	adc_ac_sum &= 0x003fffff;//ȡ��ֵ
	TRACE("adc_ac_sum value: 0x%08X(%d)", adc_ac_sum, adc_ac_sum);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x74, (unsigned char *)&adc_ac_avg, 4);
	adc_ac_avg &= 0x00000fff;//ȡ��ֵ
	TRACE("adc_ac_avg value: 0x%04X(%d)", adc_ac_avg, adc_ac_avg);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x78, (unsigned char *)&adc_dc_sum, 4);
	adc_dc_sum &= 0x003fffff;//ȡ��ֵ
	TRACE("adc_dc_sum value: 0x%08X(%d)", adc_dc_sum, adc_dc_sum);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x7C, (unsigned char *)&temp_val, 4);
	adc_dc_avg_history1 = temp_val & 0x00000fff;//ȡ��ֵ
	adc_dc_avg_history2 = (temp_val & 0x0fff0000) >> 16;//ȡ��ֵ
	TRACE("adc_dc_avg_history1 value: 0x%04X(%d)", adc_dc_avg_history1, adc_dc_avg_history1);
	TRACE("adc_dc_avg_history2 value: 0x%04X(%d)", adc_dc_avg_history2, adc_dc_avg_history2);
//////////////////////////////////////////////////////////////////////////////////////////////////
	target_read_memory(target, XBR820_PMU_BASE + 0x80, (unsigned char *)&temp_val, 4);
	adc_dc_avg_history3 = temp_val & 0x00000fff;//ȡ��ֵ
	adc_dc_avg_history4 = (temp_val & 0x0fff0000) >> 16;//ȡ��ֵ
	TRACE("adc_dc_avg_history3 value: 0x%04X(%d)", adc_dc_avg_history3, adc_dc_avg_history3);
	TRACE("adc_dc_avg_history4 value: 0x%04X(%d)", adc_dc_avg_history4, adc_dc_avg_history4);
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
	waitThreads();
	
	CDialog::PostNcDestroy();
}

void CTest1Dlg::OnClose() 
{
	// TODO: Add your message handler code here and/or call default
	target_close (cfg.target);

	CDialog::OnClose();
}

void CTest1Dlg::init_timer()
{
	SetTimer(0, 200, NULL);	//200msһ��
}

void CTest1Dlg::init_thread()
{
	CString	thread_str;
	
	//����дӲ��������ư�
	CWinThread *th0 = AfxBeginThread(Read_ac, this, THREAD_PRIORITY_NORMAL, 0, CREATE_SUSPENDED);
	SetThreadName(th0->m_nThreadID, "read_ac");
	th0->ResumeThread();

}

void CTest1Dlg::OnTimer(UINT nIDEvent) 
{
	switch (nIDEvent)
	{
	case 0:
		update_var_display();
		break;
	case 1:
		break;
	case 2:
		break;
	case 3:
		break;
	case 4:
		break;
	default:
		break;
	}
	
	CDialog::OnTimer(nIDEvent);
}

UINT CTest1Dlg::Read_ac( void* p_Param )
{
	CTest1App* global_var = (CTest1App *)AfxGetApp();
	CTest1Dlg* pThis = (CTest1Dlg*)p_Param;

	unsigned int adc_ac_sum = 0;	//��ͷ�����ۼ�ֵ
	
	while(1)
	{
		DWORD thread_status;
		
		thread_status = WaitForMultipleObjects(MAXIMUM_WAIT_OBJECTS, pThis->m_event_handle, FALSE, 100);	//100ms duty
		
		if (WAIT_TIMEOUT == thread_status)
		{	
			//do some thing!
			//user define
			target_read_memory(pThis->cfg.target, XBR820_PMU_BASE + 0x70, (unsigned char *)&adc_ac_sum, 4);
			adc_ac_sum &= 0x003fffff;//ȡ��ֵ
			global_var->g_adc_ac_sum = adc_ac_sum;
			//
			//
			
			continue;
		}
		else if (WAIT_FAILED == thread_status)
		{
			continue;
		}
		else
		{
			switch (thread_status)
			{
			case WAIT_OBJECT_0:
				pThis->m_event[1].SetEvent();
				return	0x11111111;
			case WAIT_OBJECT_0 + 2:
				break;
			default:
				break;
			}
		}
	}
	
	return 0x11111111;
}

void CTest1Dlg::waitThreads()
{
	DWORD thread_status;
	
	m_event[0].SetEvent();//�˳��߳�0
	thread_status = WaitForSingleObject(m_event[1], INFINITE);
	TRACE("th0 quit!");
}

void CTest1Dlg::update_var_display()
{
	CTest1App* global_var = (CTest1App *)AfxGetApp();
	//read g_adc_ac_sum and display it below!
	TRACE("adc_ac_sum value: 0x%08X(%d)", global_var->g_adc_ac_sum, global_var->g_adc_ac_sum);
}
