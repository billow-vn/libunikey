// -*- coding:unix; mode:c++; tab-width:4; c-basic-offset:4; indent-tabs-mode:nil -*-
/*------------------------------------------------------------------------------
UniKey - Open-source Vietnamese Keyboard
Copyright (C) 2000-2005 Pham Kim Long
Contact:
  unikey@gmail.com
  http://unikey.org

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
--------------------------------------------------------------------------------*/

#if !defined(HAVE_SUITABLE_QT_VERSION)
/* Try to check Qt version, should be more or equal than 5.3.0 */
    #if defined(QT_VERSION) && defined(QT_VERSION_CHECK)
        #if (QT_VERSION >= QT_VERSION_CHECK(5, 3, 0))
            #define HAVE_SUITABLE_QT_VERSION 1
        #endif
    #endif /* End check Qt version */
#endif /* End check exestance of Qt suitable version */

#if !defined(__RE_OS_WINDOWS__) && !defined(__RE_OS_ANDROID__)
/* OS not selected, try detect OS */
    #if (defined(WIN32) || defined(_WIN32) || defined(WIN32_LEAN_AND_MEAN) || defined(_WIN64) || defined(WIN64))
        #define __RE_OS_WINDOWS__ 1
        #ifndef WIN32_LEAN_AND_MEAN
/* Exclude rarely-used stuff from Windows headers */
            #define WIN32_LEAN_AND_MEAN
        #endif /* WIN32_LEAN_AND_MEAN */

        #if !defined(__RE_COMPILER_MINGW__)
            #if defined(__MINGW32__) || defined(__MINGW64__) || defined(MINGW)
                #define __RE_COMPILER_MINGW__ 1
            #endif
        #endif
    #endif /* END CHECKING WINDOWS PLATFORM  */
/***********************************************************************************/
    #if defined(ANDROID_NDK) || defined(__ANDROID__) || defined(ANDROID)
        #define __RE_OS_ANDROID__ 1
    #endif /* END CHECKING ANDROID PLATFORM */
/***********************************************************************************/
#endif /* END DETECT OS */

#if defined(TARGET_OS_MAC) || defined(TARGET_OS_IPHONE) || defined(TARGET_IPHONE_SIMULATOR) || defined(__APPLE__)
    #ifndef __APPLE__
        #define __APPLE__ 1
    #endif
#endif

#if defined(__cplusplus) || defined(_cplusplus)
    #define __RE_EXTERN__ extern "C"
#else
    #define __RE_EXTERN__ extern
#endif

#if defined(__RE_OS_WINDOWS__) && !defined(HAVE_SUITABLE_QT_VERSION) && !defined(BKL_XUNIKEY_STATIC)
    #include <windows.h>

    #if defined(CMAKE_BUILD) || defined(__BUILDING_RECORE_DYNAMIC_LIBRARY__)
        #if defined(_MSC_VER) || defined(__RE_COMPILER_MINGW__)
            #define __RE_PUBLIC_CLASS_API__ __declspec(dllexport)
            #define __RE_EXPORT__ __RE_EXTERN__ __declspec(dllexport)
        #	elif defined(__GNUC__)
            #define __RE_PUBLIC_CLASS_API__ __attribute__((dllexport))
            #define __RE_EXPORT__ __RE_EXTERN__ __attribute__((dllexport))
        #	endif
    #else
        #if defined(_MSC_VER) || defined(__RE_COMPILER_MINGW__)
            #define __RE_PUBLIC_CLASS_API__ __declspec(dllimport)
            #define __RE_EXPORT__ __RE_EXTERN__ __declspec(dllimport)
        #	elif defined(__GNUC__)
            #define __RE_PUBLIC_CLASS_API__ __attribute__((dllimport))
            #define __RE_EXPORT__ __RE_EXTERN__ __attribute__((dllimport))
        #	endif
    #endif
#endif /* __RE_OS_WINDOWS__ */

#if defined(__GNUC__)
    #if __GNUC__ >= 4
        #if !defined(__RE_PUBLIC_CLASS_API__)
            #define __RE_PUBLIC_CLASS_API__ __attribute__ ((visibility("default")))
        #		endif
    #	endif
#endif

#ifndef __RE_EXPORT__
    #define __RE_EXPORT__ __RE_EXTERN__
#endif

#ifndef __RE_PUBLIC_CLASS_API__
    #define __RE_PUBLIC_CLASS_API__
#endif

#ifndef __UNIKEY_H
    #define __UNIKEY_H

    #include "keycons.h"

/*----------------------------------------------------
Initialization steps:
   1. UnikeySetup: This will initialized Unikey module,
      with default options, input method = TELEX, output format = UTF-8
   2. If you want a different settings:
     + Call UnikeySetInputMethod to change input method
     + Call UnikeySetOutputVIQR/UTF8 to chang output format
     + Call UnikeySetOptions to change extra options

Key event handling:

- Call UnikeyFilter when a key event occurs, examine results in
    + UnikeyBackspaces: number of backspaces that need to be sent
    + UnikeyBufChars: number of chars in buffer that need to be sent
    + UnikeyAnsiBuf: buffer containing output characters.
    + UnikeyUniBuf: not used

  You should also call UnikeySetCapsState() before calling UnikeyFilter.

  To make this module portable across platforms, UnikeyFilter should not
  be called on special keys: Enter, Tab, movement keys, delete, backspace...

- Special events:
    + Call UnikeyResetBuf to reset the engine's state in situations such as:
      focus lost, movement keys: arrow keys, pgup, pgdown....
    + If a backspace is received, call UnikeyBackspacePress,
      then examine the result:
      UnikeyBackspaces is the number of backspaces actually required to
      remove one character.

Clean up:
- When the Engine is no longer needed, call UnikeyCleanup
------------------------------------------------------*/

__RE_EXPORT__ unsigned char UnikeyBuf[];
__RE_EXPORT__ int UnikeyBackspaces;
__RE_EXPORT__ int UnikeyBufChars;
__RE_EXPORT__ UkOutputType UnikeyOutput;

__RE_EXPORT__ void UnikeySetup(); // always call this first
__RE_EXPORT__ void UnikeyCleanup(); // call this when unloading unikey module
__RE_EXPORT__ bool UnikeyIsEnabled();
__RE_EXPORT__ bool UnikeyToggleIsEnabled();

// call this to reset Unikey's state when focus, context is changed or
// some control key is pressed
__RE_EXPORT__ void UnikeyResetBuf();

// main handler, call every time a character input is received
__RE_EXPORT__ void UnikeyFilter(unsigned int ch);
__RE_EXPORT__ void UnikeyPutChar(unsigned int ch); // put new char without filtering

// call this before UnikeyFilter for correctly processing some TELEX shortcuts
__RE_EXPORT__ void UnikeySetCapsState(int shiftPressed, int CapsLockOn);

// call this when backspace is pressed
__RE_EXPORT__ void UnikeyBackspacePress();

// call this to restore to original key strokes
__RE_EXPORT__ void UnikeyRestoreKeyStrokes();

//set extra options
__RE_EXPORT__ void UnikeySetOptions(UnikeyOptions *pOpt);
__RE_EXPORT__ void CreateDefaultUnikeyOptions(UnikeyOptions *pOpt);

__RE_EXPORT__ void UnikeyGetOptions(UnikeyOptions *pOpt);

// set input method
//   im: TELEX_INPUT, VNI_INPUT, VIQR_INPUT, VIQR_STAR_INPUT
__RE_EXPORT__ void UnikeySetInputMethod(UkInputMethod im);
__RE_EXPORT__ UkInputMethod UnikeyGetInputMethod();

// set output format
//  void UnikeySetOutputVIQR();
// void UnikeySetOutputUTF8();
__RE_EXPORT__ int UnikeySetOutputCharset(int charset);
__RE_EXPORT__ int UnikeyGetOutputCharset();

__RE_EXPORT__ int UnikeyLoadMacroTable(const char *fileName);
__RE_EXPORT__ int UnikeyLoadUserKeyMap(const char *fileName);

__RE_EXPORT__ bool UnikeyHasMacroInput();
__RE_EXPORT__ void UnikeyMacroAddItem(const char *key, const char *text);
__RE_EXPORT__ void UnikeyMacroResetContent();
__RE_EXPORT__ void UnikeyMacroSortData();

//call this to enable typing vietnamese even in a non-vn sequence
//e.g: GD&DDT,QDDND...
//The engine will return to normal mode when a word-break occurs.
__RE_EXPORT__ void UnikeySetSingleMode();
__RE_EXPORT__ bool UnikeyAtWordBeginning();

#endif
