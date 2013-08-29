#import "DVTSourceTextView+AceJump.h"
#import "IWAceJumpController.h"
#import <objc/objc-runtime.h>

static char kAceJumpControllerKey;

@implementation DVTSourceTextView (AceJump)

- (IWAceJumpController *)aceJumpController
{
    IWAceJumpController *controller = objc_getAssociatedObject(self, &kAceJumpControllerKey);
    if (!controller) {
        controller = [[IWAceJumpController alloc] init];
        objc_setAssociatedObject(self, &kAceJumpControllerKey, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return controller;
}

@end
