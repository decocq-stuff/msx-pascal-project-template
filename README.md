# msx-pascal-project-template
Template build environment for Turbo Pascal with MS Visual Code IDE integration

This Make script will compile with Turbo Pascal 3.3f to a MSX-dos compatible COM file, even on a Windows 10 machine. 
It works completely stand-alone, and includes setting files to integrate with MS Visual Code.
Runs on Windows Vista and later (tested), probably runs on all NT versions since it also works on ReactOS! 
Running MAKE.BAT creates a DSK file in the build folder. The included PAS file is a simple Hello World application. 

When using MS Visual Code editor, open the folder; the tasks.json has a default build task with problem matcher, so compiler errors are handled (SHIFT+CTRL+B). Install Pascal language from the marketplace for correct formatting (in the settings.json, the .inc file type is already set to be Pascal syntax, you may want to add other file types depending how you call your include files)

(When using the option to create a floppy image .DSK file, you may need a specific Microsoft VC Runtime Library when you receive an error message about a missing DLL)

The project includes:
vDOS - https://www.vdos.info

dsktool by Ricardo Bittencourt, Updated 2010 by Tony Cruise 

Turbo Pascal 3.3f MSX Computer Club Enschede 1993


