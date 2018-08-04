@echo off
call global_var.bat
set compile=%Tools%\tp3.exe
set disktool=%Tools%\dsktool_new.exe
set CopyToFloppy=%disktool% A %Build%\%DiskName%
if exist %source%\error.txt del %source%\error.txt
if exist %vdos% goto :vDOScompile
echo %date%-%time%-[make]: WARNING: there is a problem with DOSBOX that may cause
echo %date%-%time%-[make]: nonsense error messages and fail compilation.
echo %date%-%time%-[make]: Please install VDOS: https://www.vdos.info/download.html
echo %date%-%time%-[make]: and set the path to it in global_var.bat.
Echo %date%-%time%-[make]: [Fallback attempt] Creating batch file for DOSBox

echo set path=c:\%Tools% > DOSComp.bat
echo c: >> DOSComp.bat
echo cd %Source% >> DOSComp.bat
echo tp3 %SourceFile% /H /S2E9B /ED200 /Rerror.txt >> DOSComp.bat
echo exit >> DOSComp.bat

Echo %date%-%time%-[make]: [Fallback attempt] Launching DOSBox
%Tools%\DOSBOX.exe DOSComp.bat -conf %Tools%\dosbox.conf -noconsole
if exist stderr.txt (
	type stderr.txt
	del stderr.txt
)
if exist stdout.txt (
	type stdout.txt
	del stdout.txt
)
del DOSComp.bat
goto :ErrorHandler
:vDOScompile
Echo %date%-%time%-[make]: Creating batch file for vDOS

echo set path=c:\%Tools% > autoexec.txt
echo c: >> autoexec.txt
echo cd %Source% >> autoexec.txt
echo tp3 %SourceFile% /H /S2E9B /ED200 /Rerror.txt >> autoexec.txt
echo exit >> autoexec.txt
Echo %date%-%time%-[make]: Attempting to start vDOS
%vdos% 

del autoexec.txt
:ErrorHandler
if exist %source%\error.txt (
	echo %date%-%time%-[make]: Compiler error:
	call :OutputErrorStandard
	if exist %source%\%SourceFile%.CHN del %source%\%SourceFile%.CHN
	goto :eof
) else (
	Echo %date%-%time%-[make]: Composing COM file chain
	copy %Tools%\runtime.com/b + %source%\%SourceFile%.chn/b %Build%\%COMname%.com /y
	Echo %date%-%time%-[make]: Cleanup
	del %source%\%SourceFile%.CHN
	if [%DiskName%]==[] goto :runemulator
	Echo %date%-%time%-[make]: Building virtual floppy 
	if exist %Build%\%DiskName% del %Build%\%DiskName%
	%CopyToFloppy% %Tools%\msxdos.sys %Tools%\command.com
	rem  Optional! Create autoexec.bat file
	echo %comname% > %Build%\AUTOEXEC.BAT
	%CopyToFloppy% %Build%\autoexec.bat
	%CopyToFloppy% %Build%\%COMname%.com
	rem All other files to be included on the virtual floppy:
	for %%I in (resources\*.*) do %CopyToFloppy% %%I
	
)

:runEmulator
if [%emulpath%]==[] (
    Echo %date%-%time%-[make]: No emulator Launching
) else (
    Echo %date%-%time%-[make]: Attempt to launch emulator
	if exist %emulpath% call %emulPath% -diska %build%\%diskname% %emulArgs%
)
goto :eof
:OutputErrorStandard
rem Format output similar to C and JS compilers for handling by problemmatcher in tasks.json
		< %source%\error.txt (
 		set /p ErrFile=
  		set /p ErrLine=
		set /p ErrColumn=
		set /p ErrorCode=
		set /p ErrorMsg=
	)
	
		echo %source%/%ErrFile%:%ErrLine%:%ErrColumn%:error:%ErrorMsg%-%ErrorCode%
	

:eof