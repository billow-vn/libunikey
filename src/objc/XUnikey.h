#import "vnconv.h"
#import "keycons.h"
#import "unikey.h"

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

@property(nonatomic, readonly) unsigned char *buf;
@property(nonatomic, readonly) int backspaces;
@property(nonatomic, readonly) int bufChars;
@property(nonatomic, readonly) UkOutputType output;
@property(assign) bool isSendForward;

- (void)setOptions:(UnikeyOptions)pOpt;
- (UnikeyOptions)getOptions;
- (void)createDefaultOptions:(UnikeyOptions *)pOpt;
- (void)setInputMethod:(UkInputMethod)im;
- (UkInputMethod)getInputMethod;

- (void)setup;
- (bool)isEnabled;
- (bool)toggleIsEnabled;
- (void)cleanup;
- (void)resetBuf;
- (void)filter:(uint)ch;
- (void)putChar:(uint)ch;
- (void)setIsSendForward:(bool)flag;
- (void)setCapsState:(int)shiftPressed capsLockOn:(int)capsLockOn;
- (void)backspacePress;
- (void)restoreKeyStrokes;
- (bool)atWordBeginning;
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
