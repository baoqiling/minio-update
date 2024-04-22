!include "LogicLib.nsh"
!include "x64.nsh"
; WordReplace 
!include "WordFunc.nsh"
; ��װ�����ʼ���峣��
!define PRODUCT_NAME "BHWebServer"
!define PRODUCT_VERSION  "7.0.4.1(x64)"
!define FILE_VERSION     "7.0.4.1(x64)"
!define PRODUCT_PUBLISHER "BHXZ"
!define COMPANY_NAME "�����������ǿƼ��ɷ����޹�˾"
!define PRODUCT_WEB_SITE "http://www.bhxz.net"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_WELCOMEPAGE_TITLE "BHWebServer v${PRODUCT_VERSION}��װ��"

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
#!insertmacro MUI_PAGE_LICENSE "BHWebServer\Apache\Apache\LICENSE.txt"
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

; �������ԱȨ��
RequestExecutionLevel admin

InstallDirRegKey HKCU "Software\BHWebServer" ""

VIProductVersion "${PRODUCT_VERSION}" ;�汾�ţ���ʽΪ X.X.X.X (��ʹ����������) 
#VIAddVersionKey FileDescription "BH-WAMP(Apache2.4.48,PHP7.4.19)" ;�ļ�����(��׼��Ϣ) 
VIAddVersionKey FileVersion "${PRODUCT_VERSION}" ;�ļ��汾(��׼��Ϣ) 
VIAddVersionKey ProductName "${PRODUCT_NAME} ${PRODUCT_VERSION}" ;��Ʒ���� 
VIAddVersionKey ProductVersion "${PRODUCT_VERSION}" ;��Ʒ�汾 
VIAddVersionKey Comments "�����Ƽ�-��Ϣ��WAMP����" ;��ע 
VIAddVersionKey CompanyName "�����������ǿƼ��ɷ����޹�˾" ;��˾�� 
VIAddVersionKey LegalCopyright "��Ȩ��Ϣ (c) 2015�����Ƽ�" ;�Ϸ���Ȩ 
VIAddVersionKey InternalName "BH-WAMP" ;�ڲ����� 
VIAddVersionKey LegalTrademarks "bhxz" ;�Ϸ��̱� ; 
VIAddVersionKey OriginalFilename "BHWebServer.exe" ;Դ�ļ��� 
VIAddVersionKey PrivateBuild "" ;�����ڲ��汾˵�� 
VIAddVersionKey SpecialBuild "" ;�����ڲ�����˵�� 

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "BSServerSetup.exe"
InstallDir "D:\BHXZ\BHWebServer"
ShowInstDetails show
ShowUnInstDetails show
BrandingText "�����Ƽ�-��Ϣ�������� www.bhxz.net"
ShowInstDetails hide ;��װ���̣�����Ĭ��Ϊshow��hide��ʾ����ʾ��װ��Ϣ�������ʾ��ť����ʾ��
ShowUnInstDetails hide ;ж�ع��̣�����Ĭ��Ϊshow��hide��ʾ����ʾ��װ��Ϣ�������ʾ��ť����ʾ��

; ���װ��־��¼������־�ļ�������Ϊж���ļ�������(ע�⣬�����α����������������֮ǰ)
Section "-LogSetOn"
  LogSet on
SectionEnd

Section "Apache" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File /r "BHWebServer\bh-pulse-server\*.*"
  File /r "BHWebServer\mysql\*.*"
  File /r "BHWebServer\jdk\*.*"
  File /r "BHWebServer\soft\*.*"
  File /r "BHWebServer\BHWatchDog\*.*"
  File /r "BHWebServer\dcenter\*.*"

  
  Call InstallVC
  Call config
 # Call initMysqlData
SectionEnd

Section -AdditionalIcons
  
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  
  CreateDirectory "$SMPROGRAMS\BHXZ\BHWebServer"
  CreateShortCut "$SMPROGRAMS\BHXZ\BHWebServer\Uninstall.lnk" "$INSTDIR\uninst.exe"
  
SectionEnd

Section -Post
	WriteRegDword HKLM "${PRODUCT_UNINST_KEY}" "Installed" 1
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKCU "Software\BHWebServer" "" $INSTDIR
SectionEnd

Section -Service

	Call addEnvironment
	Call InstallMySqlService
	Call InstallWatchDogService
	
	Call StartService
	#Call InstallSQL
SectionEnd


/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/
 
; ���ݰ�װ��־ж���ļ��ĵ��ú�
!macro DelFileByLog LogFile
  ifFileExists `${LogFile}` 0 +4
    Push `${LogFile}`
    Call un.DelFileByLog
    Delete `${LogFile}`
!macroend

Section Uninstall

	Call un.stopService
	Call un.removeMysqlService
	Call un.removeEnvironment
	Call un.removeWatchDogService
	Call un.stopJavaProcessor
	Call un.stopConsulProcessor
	Delete "$INSTDIR\${PRODUCT_NAME}.url"
	Delete "$SMPROGRAMS\BHXZ\BHWebServer\Uninstall.lnk"
	RMDir "$SMPROGRAMS\BHXZ\BHWebServer"
	RMDir /r "$INSTDIR\mysql\data"
    
    ; ���ú�ֻ���ݰ�װ��־ж�ذ�װ�����Լ���װ�����ļ�
    !insertmacro DelFileByLog "$INSTDIR\install.log"
    ; �����װ���򴴽�������ж��ʱ����Ϊ�յ���Ŀ¼�����ڵݹ���ӵ��ļ�Ŀ¼���������ڲ����Ŀ¼��ʼ���(ע�⣬��Ҫ�� /r �����������ʧȥ DelFileByLog ������)
	DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
    DeleteRegKey /ifempty HKCU "Software\BHWebServer"
    SetAutoClose true
	

SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

#��ֹ�ظ���װ
Function .onInit
	;��ֹ��ΰ�װʵ�� start
	ReadRegDWORD $0 HKLM '${PRODUCT_UNINST_KEY}' "Installed"
	IntCmp $0 +1 +4
	MessageBox MB_OK|MB_USERICON '$(^Name) �Ѱ�װ�ڼ�����С��������°�װ����ж�����еİ�װ��'
	Quit
	nop
	;��ֹ��ΰ�װʵ�� end

InitPluginsDir
    ;���������ֹ�ظ�����
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "BHWebServer_installer") i .r1 ?e'
  Pop $R0
  StrCmp $R0 0 +3
    MessageBox MB_OK|MB_ICONEXCLAMATION "��һ�� BHWebServer ��װ���Ѿ����У�"
    Abort
FunctionEnd

; ��װVC����
Function InstallVC
#	ExecWait "$INSTDIR\soft\vc_redist.x64_2015.exe /q:a"   ;�������ڣ�ִ�о�Ĭ��װ
#	ExecWait "$INSTDIR\soft\vc_redist.x86_2015.exe /q:a"   ;�������ڣ�ִ�о�Ĭ��װ
#	ExecWait '"$INSTDIR\soft\vcredist_x86.exe"'   ;�������ڣ�ִ�о�Ĭ��װ
#	ExecWait '"$INSTDIR\soft\vcredist_x64.exe"'   ;�������ڣ�ִ�о�Ĭ��װ
	ExecWait '"$INSTDIR\soft\vcredist_x64_2013.exe"'   ;�������ڣ�ִ�о�Ĭ��װ
#	ExecWait '"$INSTDIR\soft\vcredist_x86_2013.exe"'   ;�������ڣ�ִ�о�Ĭ��װ
#	ExecWait '"$INSTDIR\soft\vcredist_x86_vc9.exe"'   ;�������ڣ�ִ�о�Ĭ��װ
#	ExecWait '"$INSTDIR\soft\VC_redist.x64.exe"'   ;�������ڣ�ִ�о�Ĭ��װ
#	ExecWait '"$INSTDIR\soft\VC_redist.x86.exe"'   ;�������ڣ�ִ�о�Ĭ��װ
FunctionEnd

#��װApache
#FunctionEnd
Function InstallWatchDogService
	ExecWait "$INSTDIR\BHWatchDog\BHWatchDogService.exe -i"
FunctionEnd
#��װMysql����
Function InstallMySqlService
	ExecWait "$INSTDIR\mysql\bin\mysqld --install BHMysql --defaults-file=$INSTDIR\mysql\my.ini"	
FunctionEnd

# Function InstallSQL
#     ExecWait "cmd /C $INSTDIR\mysql\bin\mysql.exe -uroot -pbhxz  -P3310 dcenter < $INSTDIR\mysql\dcenter.sql"
# FunctionEnd

#jdk
Function addEnvironment
	ReadRegStr $0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
	WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$0;$INSTDIR\jdk\bin" 
	;TIMEOUT 
	SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment"  /TIMEOUT=3000
FunctionEnd

Function un.removeEnvironment
		ReadRegStr $R0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
		${WordReplace} $R0 ";$INSTDIR\jdk\bin" "" "+" $R1
		WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$R1"

FunctionEnd
#��������
Function StartService
	ExecWait "net start BHMysql"
FunctionEnd

Function config

	Push "mysql_dir_flag"
	Push "$INSTDIR\mysql"
	Push all
	Push all
	Push "$INSTDIR\mysql\my.ini"
	Call AdvReplaceInFile
	
	Push "dcenter_dir_flag"
	Push "$INSTDIR\dcenter\lib"
	Push all
	Push all
	Push "$INSTDIR\BHWatchDog\BHWatchDogService.ini"
	Call AdvReplaceInFile
	
FunctionEnd

#Function initMysqlData
#	nsExec::ExecToLog 'cmd /C $INSTDIR\mysql\mysql.exe -uroot -hlocalhost -P3310 < "$INSTDIR\mysql\dcenter.sql"'
#FunctionEnd

#Function initMysqlData
#	ExecWait "$INSTDIR\mysql\bin mysql -uroot -pbhxz -D dcenter < $INSTDIR\mysql\dcenter.sql"
#FunctionEnd

/*�滻����function*/
Function AdvReplaceInFile
Exch $0 ;file to replace in
Exch
Exch $1 ;number to replace after
Exch
Exch 2
Exch $2 ;replace and onwards
Exch 2
Exch 3
Exch $3 ;replace with
Exch 3
Exch 4
Exch $4 ;to replace
Exch 4
Push $5 ;minus count
Push $6 ;universal
Push $7 ;end string
Push $8 ;left string
Push $9 ;right string
Push $R0 ;file1
Push $R1 ;file2
Push $R2 ;read
Push $R3 ;universal
Push $R4 ;count (onwards)
Push $R5 ;count (after)
Push $R6 ;temp file name

  GetTempFileName $R6
  FileOpen $R1 $0 r ;file to search in
  FileOpen $R0 $R6 w ;temp file
   StrLen $R3 $4
   StrCpy $R4 -1
   StrCpy $R5 -1

loop_read:
 ClearErrors
 FileRead $R1 $R2 ;read line
 IfErrors exit

   StrCpy $5 0
   StrCpy $7 $R2

loop_filter:
   IntOp $5 $5 - 1
   StrCpy $6 $7 $R3 $5 ;search
   StrCmp $6 "" file_write2
   StrCmp $6 $4 0 loop_filter

StrCpy $8 $7 $5 ;left part
IntOp $6 $5 + $R3
IntCmp $6 0 is0 not0
is0:
StrCpy $9 ""
Goto done
not0:
StrCpy $9 $7 "" $6 ;right part
done:
StrCpy $7 $8$3$9 ;re-join

IntOp $R4 $R4 + 1
StrCmp $2 all file_write1
StrCmp $R4 $2 0 file_write2
IntOp $R4 $R4 - 1

IntOp $R5 $R5 + 1
StrCmp $1 all file_write1
StrCmp $R5 $1 0 file_write1
IntOp $R5 $R5 - 1
Goto file_write2

file_write1:
 FileWrite $R0 $7 ;write modified line
Goto loop_read

file_write2:
 FileWrite $R0 $R2 ;write unmodified line
Goto loop_read

exit:
  FileClose $R0
  FileClose $R1

   SetDetailsPrint none
  Delete $0
  Rename $R6 $0
  Delete $R6
   SetDetailsPrint both

Pop $R6
Pop $R5
Pop $R4
Pop $R3
Pop $R2
Pop $R1
Pop $R0
Pop $9
Pop $8
Pop $7
Pop $6
Pop $5
Pop $0
Pop $1
Pop $2
Pop $3
Pop $4
FunctionEnd

#ֹͣ����

Function un.stopService
	ExecWait "net stop BHMysql"
	ExecWait "net stop ZBHService_dcenter"
FunctionEnd

#ɾ������

Function un.removeWatchDogService
	ExecWait "sc delete ZBHService_dcenter"
FunctionEnd

Function un.removeMysqlService
	ExecWait "sc delete BHMysql"
FunctionEnd
Function un.stopJavaProcessor
	ExecWait "taskkill /F /IM javaw.exe"
FunctionEnd
Function un.stopConsulProcessor
	ExecWait "taskkill /F /IM consul.exe"
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  #MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
   MessageBox MB_YESNO|MB_ICONQUESTION|MB_TOPMOST "$(^Name) �ѳɹ��ش����ļ�����Ƴ����������������Ա�����������!" IDNO +2
  Reboot
  
FunctionEnd

; ������ж�س���ͨ����װ��־ж���ļ���ר�ú������벻Ҫ�����޸�
Function un.DelFileByLog
  Exch $R0
  Push $R1
  Push $R2
  Push $R3
  FileOpen $R0 $R0 r
  ${Do}
    FileRead $R0 $R1
    ${IfThen} $R1 == `` ${|} ${ExitDo} ${|}
    StrCpy $R1 $R1 -2
    StrCpy $R2 $R1 11
    StrCpy $R3 $R1 20
    ${If} $R2 == "File: wrote"
    ${OrIf} $R2 == "File: skipp"
    ${OrIf} $R3 == "CreateShortCut: out:"
    ${OrIf} $R3 == "created uninstaller:"
      Push $R1
      Push `"`
      Call un.DelFileByLog.StrLoc
      Pop $R2
      ${If} $R2 != ""
        IntOp $R2 $R2 + 1
        StrCpy $R3 $R1 "" $R2
        Push $R3
        Push `"`
        Call un.DelFileByLog.StrLoc
        Pop $R2
        ${If} $R2 != ""
          StrCpy $R3 $R3 $R2
          Delete /REBOOTOK $R3
        ${EndIf}
      ${EndIf}
    ${EndIf}
    StrCpy $R2 $R1 7
    ${If} $R2 == "Rename:"
      Push $R1
      Push "->"
      Call un.DelFileByLog.StrLoc
      Pop $R2
      ${If} $R2 != ""
        IntOp $R2 $R2 + 2
        StrCpy $R3 $R1 "" $R2
        Delete /REBOOTOK $R3
      ${EndIf}
    ${EndIf}
  ${Loop}
  FileClose $R0
  Pop $R3
  Pop $R2
  Pop $R1
  Pop $R0
FunctionEnd

Function un.DelFileByLog.StrLoc
  Exch $R0
  Exch
  Exch $R1
  Push $R2
  Push $R3
  Push $R4
  Push $R5
  StrLen $R2 $R0
  StrLen $R3 $R1
  StrCpy $R4 0
  ${Do}
    StrCpy $R5 $R1 $R2 $R4
    ${If} $R5 == $R0
    ${OrIf} $R4 = $R3
      ${ExitDo}
    ${EndIf}
    IntOp $R4 $R4 + 1
  ${Loop}
  ${If} $R4 = $R3
    StrCpy $R0 ""
  ${Else}
    StrCpy $R0 $R4
  ${EndIf}
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd
