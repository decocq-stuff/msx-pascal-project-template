@echo off
*** MAKE for MSX Turbo Pascal by S. de Cocq 2018
call global_var.bat
set compile=%Tools%\tp3.exe
set disktool=%Tools%\dsktool_new.exe
set CopyToFloppy=%disktool% A %Build%\%DiskName%

Echo %date%-%time%-[make]: Creating TEMP file
copy %source%\%SourceFile%.PAS %source%\TEMP.PAS /y

Echo %date%-%time%-[make]: Creating batch file for DOSBox

echo set path=c:\%Tools% > DOSComp.bat
echo c: >> DOSComp.bat
echo cd %Source% >> DOSComp.bat
echo tp3 TEMP /H /S2E9B /ED200 /Rerror.txt >> DOSComp.bat
echo exit >> DOSComp.bat

Echo %date%-%time%-[make]: Launching DOSBox

%Tools%\DOSBOX.exe DOSComp.bat -conf %Tools%\dosbox.conf -noconsole - -exit
if exist stderr.txt (
	type stderr.txt
	del stderr.txt
)
if exist stdout.txt (
	type stdout.txt
	del stdout.txt
)
del DOSComp.bat

if exist %source%\error.txt (
	echo %date%-%time%-[make]: Compiler error:
	call :OutputErrorStandard
	
	del %source%\error.txt
	if exist %source%\TEMP.PAS del %source%\TEMP.PAS
	if exist %source%\TEMP.CHN del %source%\TEMP.CHN
	exit
) else (
	if exist %Build%\%DiskName% del %Build%\%DiskName%
	Echo %date%-%time%-[make]: Composing COM file chain
	copy %Tools%\runtime.com/b + %source%\TEMP.chn/b %Build%\%COMname%.com /y
	Echo %date%-%time%-[make]: Building virtual floppy 
	%CopyToFloppy% %Tools%\msxdos.sys %Tools%\command.com
	rem  Optional! Create autoexec.bat file
	echo %comname% > %Build%\AUTOEXEC.BAT
	%CopyToFloppy% %Build%\autoexec.bat
	%CopyToFloppy% %Build%\%COMname%.com
	rem All other files to be included on the virtual floppy:
	for %%I in (resources\*.*) do %CopyToFloppy% %%I
	rem %CopyToFloppy% resources\*.*
	Echo %date%-%time%-[make]: Cleanup
	del %source%\TEMP.PAS
	del %source%\TEMP.CHN

rem	call "C:\Program Files\OpenMSX\OpenMSX.exe" -diska %build%\%diskname% -machine Philips_NMS_8255

	goto :eof
)
:OutputErrorStandard
rem Format output similar to C and JS compilers for handling by problemmatcher in tasks.json
		< %source%\error.txt (
 		set /p ErrFile=
  		set /p ErrLine=
		set /p ErrColumn=
		set /p ErrorCode=
		set /p ErrorMsg=
	)
	if "%ErrFile%"=="TEMP.PAS"  (
		echo %source%/%SourceFile%.PAS:%ErrLine%:%ErrColumn%:error:%ErrorMsg%-%ErrorCode%
		goto :eof
	) else (
		echo %source%/%ErrFile%:%ErrLine%:%ErrColumn%:error:%ErrorMsg% -%ErrorCode%
		goto :eof
	)

:eof
