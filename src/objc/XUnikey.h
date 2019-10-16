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

@interface XUnikey : NSObject
@property(nonatomic, assign) unsigned char *buf;
@property(nonatomic, assign) int backspaces;
@property(nonatomic, assign) int bufChars;
@property(nonatomic, assign) int capsLockOn;
@property(nonatomic, assign) int shiftPressed;
@property(nonatomic, assign) UkOutputType outputType;
@property(nonatomic, assign) VkInputMethod imVk;


- (void)setOptions:(UnikeyOptions *)pOpt;
- (void)getOptions:(UnikeyOptions *)pOpt;
- (void)createDefaultOptions:(UnikeyOptions *)pOpt;
- (void)setInputMethod:(VkInputMethod)im;
- (VkInputMethod)getInputMethod;
- (int)revertInputMethod;
- (void)setInputMethodVk:(VkInputMethod)im;
- (VkInputMethod)getInputMethodVk;

- (void)setup;
- (void)cleanup;
- (void)resetBuf;
- (void)filter:(uint)ch;
- (void)putChar:(uint)ch;
- (void)setCapsState:(int)shiftPressed capsLockOn:(int)capsLockOn;
- (void)checkKbCase:(int *)pShiftPressed pCapsLockOn:(int *)pCapsLockOn;
- (void)backspacePress;
- (void)restoreKeyStrokes;
- (void)setSingleMode;
- (int)setOutputCharset:(int)charset;
- (int)getOutputCharset;

- (int)loadMacroTable:(const char *)fileName;
- (int)loadUserKeyMap:(const char *)fileName;
@end

#endif //BKL_XUNIKEY_H
