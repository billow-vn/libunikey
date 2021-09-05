#import "XUnikey.h"

@interface XUnikey ()
@end

@implementation XUnikey

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (unsigned char *)buf {
    return UnikeyBuf;
}

- (int)backspaces {
    return UnikeyBackspaces;
}

- (int)bufChars {
    return UnikeyBufChars;
}

- (UkOutputType)output {
    return UnikeyOutput;
}

- (void)setup {
    UnikeySetup();
}

- (bool)isEnabled {
    return UnikeyIsEnabled();
}

- (bool)toggleIsEnabled {
    return UnikeyToggleIsEnabled();
}

- (void)cleanup {
    UnikeyCleanup();
}

- (void)resetBuf {
    UnikeyResetBuf();
}

- (void)filter:(uint)ch {
    UnikeyFilter(ch);
}

- (void)putChar:(uint)ch {
    UnikeyPutChar(ch);
}

- (void)setIsSendForward:(bool)flag {
    _isSendForward = flag;
}

- (void)setCapsState:(int)shiftPressed capsLockOn:(int)capsLockOn {
    UnikeySetCapsState(shiftPressed, capsLockOn);
}

- (void)backspacePress {
    UnikeyBackspacePress();
}

- (void)restoreKeyStrokes {
    UnikeyRestoreKeyStrokes();
}

- (bool)atWordBeginning {
    return UnikeyAtWordBeginning();;
}

- (void)setOptions:(UnikeyOptions)pOpt {
    UnikeySetOptions(&pOpt);
}

- (void)createDefaultOptions:(UnikeyOptions *)pOpt {
    CreateDefaultUnikeyOptions(pOpt);
}

- (UnikeyOptions)getOptions {
    UnikeyOptions pOpt;
    UnikeyGetOptions(&pOpt);

    return pOpt;
}

- (void)setSingleMode {
    UnikeySetSingleMode();
}

- (void)setInputMethod:(UkInputMethod)im {
    UnikeySetInputMethod(im);
}

- (UkInputMethod)getInputMethod {
    return UnikeyGetInputMethod();
}

- (int)setOutputCharset:(int)charset {
    return UnikeySetOutputCharset(charset);
}

- (int)getOutputCharset {
    return UnikeyGetOutputCharset();
}

- (int)loadMacroTable:(const char *)fileName {
    return UnikeyLoadMacroTable(fileName);
}

- (bool)hasMacroInput {
    return (bool)UnikeyHasMacroInput();
}

- (void)macroAddItem:(const char *)key text:(const char *)text {
    UnikeyMacroAddItem(key, text);
}

- (void)macroResetContent {
    UnikeyMacroResetContent();
}

- (void)macroSortData {
    UnikeyMacroSortData();
}

- (int)loadUserKeyMap:(const char *)fileName {
    return UnikeyLoadUserKeyMap(fileName);
}

@end