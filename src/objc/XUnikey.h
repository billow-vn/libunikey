#import "vnconv.h"
#import "keycons.h"

#if defined(UIKIT_EXTERN)
    #define BKL_XUNIKEY_EXTERN UIKIT_EXTERN
#elif defined(FOUNDATION_EXTERN)
    #define BKL_XUNIKEY_EXTERN FOUNDATION_EXTERN
#else
    #ifdef __cplusplus
        #define BKL_XUNIKEY_EXTERN extern "C"
    #else
        #define BKL_XUNIKEY_EXTERN extern
    #endif
#endif

#ifndef BKL_XUNIKEY_H
    #define BKL_XUNIKEY_H

    typedef void (* CheckKeyboardCaseCb)(int *pShiftPressed, int *pCapslockOn);

@interface XUnikey : NSObject
@property(nonatomic, assign) unsigned char *buf;
@property(nonatomic, assign) int backspaces;
@property(nonatomic, assign) int bufChars;
@property(nonatomic, assign) int capsLockOn;
@property(nonatomic, assign) int shiftPressed;
@property(nonatomic, assign) bool isSendForward;
@property(nonatomic, assign) UkOutputType outputType;
@property(nonatomic, assign) VkInputMethod imPrev;


- (void)setOptions:(UnikeyOptions *)pOpt;
- (UnikeyOptions *)getOptions;
- (void)createDefaultOptions:(UnikeyOptions *)pOpt;
- (void)setInputMethod:(VkInputMethod)im;
- (VkInputMethod)getInputMethod;
- (void)setInputMethodVk:(VkInputMethod)im;
- (VkInputMethod)getInputMethodVk;

- (void)setup;
- (bool)isEnabled;
- (void)setIsEnabled:(int)flag;
- (bool)toggleIsEnabled;
- (void)cleanup;
- (void)resetBuf;
- (void)filter:(uint)ch;
- (void)putChar:(uint)ch;
- (void)setIsSendForward:(bool)flag;
- (void)setCapsState:(int)shiftPressed capsLockOn:(int)capsLockOn;
- (void)setCheckKbCase:(CheckKeyboardCaseCb)callback;
- (void)backspacePress;
- (void)restoreKeyStrokes;
- (void)setSingleMode;
- (int)setOutputCharset:(int)charset;
- (int)getOutputCharset;

- (int)loadMacroTable:(const char *)fileName;

- (bool)hasMacroInput;
- (void)macroAddItem:(const char *)key text:(const char *)text;
- (void)macroResetContent;
- (void)macroSortData;

- (int)loadUserKeyMap:(const char *)fileName;
@end

#endif //BKL_XUNIKEY_H
