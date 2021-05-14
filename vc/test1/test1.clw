; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CTest1Dlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "test1.h"

ClassCount=4
Class1=CTest1App
Class2=CTest1Dlg
Class3=CAboutDlg

ResourceCount=3
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Resource3=IDD_TEST1_DIALOG

[CLS:CTest1App]
Type=0
HeaderFile=test1.h
ImplementationFile=test1.cpp
Filter=N

[CLS:CTest1Dlg]
Type=0
HeaderFile=test1Dlg.h
ImplementationFile=test1Dlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC

[CLS:CAboutDlg]
Type=0
HeaderFile=test1Dlg.h
ImplementationFile=test1Dlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_TEST1_DIALOG]
Type=1
Class=CTest1Dlg
ControlCount=1
Control1=IDC_BUTTON1,button,1342242816

