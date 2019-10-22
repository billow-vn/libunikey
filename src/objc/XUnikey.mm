#import "XUnikey.h"


#import "ukengine.h"
#import "charset.h"
#include "usrkeymap.h"

SyncMap UkToVkMethodList[] = {
    {UkOff, VKM_OFF},
    {UkTelex, VKM_TELEX},
    {UkVni, VKM_VNI},
    {UkViqr, VKM_VIQR},
    {UkUsrIM, VKM_USER}
};

SyncMap VkToUkMethodList[] = {
    {VKM_OFF, UkOff},
    {VKM_TELEX, UkTelex},
    {VKM_VNI, UkVni},
    {VKM_VIQR, UkViqr},
    {VKM_USER, UkUsrIM}
};

@interface XUnikey ()
@property(nonatomic, assign) UkEngine *pEngine;
@property(nonatomic, assign) UkSharedMem *pSharedMem;
@end

@implementation XUnikey
@synthesize pEngine = _pEngine;
@synthesize pSharedMem = _pSharedMem;

- (id)init {
    self = [super init];
    if (self) {
        _buf = new unsigned char[1024];
        [self setup];
    }

    return self;
}

- (void)setup {
    _backspaces = 0;
    _bufChars = 0;
    _isSendForward = false;
    _imVk = VKM_OFF;

    _pEngine = new UkEngine();
    _pSharedMem = new UkSharedMem();
    _pSharedMem->input.init();
    _pSharedMem->macStore.init();
    _pSharedMem->vietKey = 1;
    _pSharedMem->usrKeyMapLoaded = 0;
    _pEngine->setCtrlInfo(_pSharedMem);

    [self setInputMethod:VKM_TELEX];
    [self setOutputCharset:CONV_CHARSET_XUTF8];

    _pSharedMem->initialized = 1;
    [self createDefaultOptions:&_pSharedMem->options];
}

- (void)cleanup {
    delete _pSharedMem;
}

- (void)resetBuf {
    _pEngine->reset();
}

- (void)filter:(uint)ch {
    _bufChars = sizeof(_buf);
    _pEngine->process(ch, _backspaces, _buf, _bufChars, _outputType);
}

- (void)putChar:(uint)ch {
    _pEngine->pass(ch);
    _bufChars = 0;
    _backspaces = 0;
}

- (void)setIsSendForward:(bool)flag {
    _isSendForward = flag;
}

- (void)setCapsState:(int)shiftPressed capsLockOn:(int)capsLockOn {
    _capsLockOn = capsLockOn;
    _shiftPressed = shiftPressed;
    // capsAll = (shiftPressed && !capsLockOn) || (!shiftPressed && capsLockOn);
}

- (void)setCheckKbCase:(CheckKeyboardCaseCb)callback {
    _pEngine->setCheckKbCaseFunc(callback);
}

- (void)backspacePress {
    _bufChars = sizeof(_buf);
    _pEngine->processBackspace(_backspaces, _buf, _bufChars, _outputType);
    // NSLog(@"Backspaces: %d\n", _backspaces);
}

- (void)restoreKeyStrokes {
    _bufChars = sizeof(_buf);
    _pEngine->restoreKeyStrokes(_backspaces, _buf, _bufChars, _outputType);
}

- (void)setOptions:(UnikeyOptions *)pOpt {
    _pSharedMem->options.freeMarking = pOpt->freeMarking;
    _pSharedMem->options.modernStyle = pOpt->modernStyle;
    _pSharedMem->options.macroEnabled = pOpt->macroEnabled;
    _pSharedMem->options.useUnicodeClipboard = pOpt->useUnicodeClipboard;
    _pSharedMem->options.alwaysMacro = pOpt->alwaysMacro;
    _pSharedMem->options.spellCheckEnabled = pOpt->spellCheckEnabled;
    _pSharedMem->options.autoNonVnRestore = pOpt->autoNonVnRestore;
}

- (void)createDefaultOptions:(UnikeyOptions *)pOpt {
    pOpt->freeMarking = 1;
    pOpt->modernStyle = 0;
    pOpt->macroEnabled = 0;
    pOpt->useUnicodeClipboard = 0;
    pOpt->alwaysMacro = 0;
    pOpt->spellCheckEnabled = 1;
    pOpt->autoNonVnRestore = 0;
}

- (UnikeyOptions *)getOptions {
    return &_pSharedMem->options;
}

- (void)setSingleMode {
    _pEngine->setSingleMode();
}

- (void)setInputMethod:(VkInputMethod)vk_im {
    [self setInputMethodVk:vk_im];

    UkInputMethod im = (UkInputMethod) SyncTranslate(vk_im,
        VkToUkMethodList,
        sizeof(VkToUkMethodList) / sizeof(SyncMap),
        UkNone
    );

    if (im == UkTelex || im == UkVni || im == UkViqr) {
        _pSharedMem->input.setIM(im);
        _pEngine->reset();
    } else if (im == UkUsrIM && _pSharedMem->usrKeyMapLoaded) {
        _pSharedMem->input.setIM(_pSharedMem->usrKeyMap);
        _pEngine->reset();
    } else {
        _pSharedMem->input.setIM(im);
        _pEngine->reset();
    }
}

- (VkInputMethod)getInputMethod {
    return (VkInputMethod) SyncTranslate(_pSharedMem->input.getIM(),
        UkToVkMethodList,
        sizeof(UkToVkMethodList) / sizeof(SyncMap),
        VKM_OFF
    );
}

- (int)revertInputMethod {
    if (_imVk != VKM_OFF) {
        return 0;
    }

    [self setInputMethodVk:_imVk];

    return 1;
}

- (void)setInputMethodVk:(VkInputMethod)im {
    if (im != VKM_OFF) {
        _imVk = im;
    }
}

- (VkInputMethod)getInputMethodVk {
    return _imVk;
}

- (int)setOutputCharset:(int)charset {
    _pSharedMem->charsetId = charset;
    _pEngine->reset();
    return 1;
}

- (int)getOutputCharset {
    return _pSharedMem->charsetId;
}

- (int)loadMacroTable:(const char *)fileName {
    return _pSharedMem->macStore.loadFromFile(fileName);
}

- (int)loadUserKeyMap:(const char *)fileName {
    if (UkLoadKeyMap(fileName, _pSharedMem->usrKeyMap)) {
        // NSLog(@"User key map loaded!");
        _pSharedMem->usrKeyMapLoaded = 1;
        return 1;
    }

    return 0;
}

@end