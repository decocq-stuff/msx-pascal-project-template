rem This file sets the variables for your project, you must adjust these:

rem ** File name of your program without extension (.PAS assumed)
    set SourceFile=PROGRAM
rem ** File name of disk file output; no disk created if blank
rem ** MSX-DOS1 is also copied to the image
    set DiskName=PROGRAM.dsk
rem ** File name of MSX-DOS executable without extension (.COM assigned)
    set COMname=PROGRAM
rem ** If set to True, an autoexec.bat is created in the build folder to run %comname%.com
rem ______not yet implemented, autoexec is always made, and command.com/msxdos.sys always copied
    set MakeAutoexec=True

rem **VDOS should be present on the system; define path\executable here:
rem ** If not set or not found, automatic fallback to DOSBox
rem ** VDOS is available at https://www.vdos.info/download.html

    set vDos=bin\vdos.exe

rem **Path to your emulator. Only starts after compilation, if the executable exists:
rem Example: set emulPath="C:\Program Files\OpenMSX\OpenMSX.exe"

    set emulPath=

rem **Additional parameters to pass to the emulator
rem **Do not use the "-diska" option; it is added automatically if the disk file exists
rem Example: set emulArgs=-machine Philips_NMS_8255

    set emulArgs=

rem ********** System input/output folder structure/ 
rem ********** do not change unless you really really have to.
    set Source=source
    set Tools=bin
    set Build=build

echo %date%-%time%-[global_var]: Global Variables set
