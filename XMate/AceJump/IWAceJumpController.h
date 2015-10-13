#import <Foundation/Foundation.h>
#import "NSString+Searching.h"

@class DVTSourceTextView, IWAceJumpController, IWAceJumpTextField;


@interface IWAceJumpController : NSObject

@property (assign, nonatomic) DVTSourceTextView *sourceTextView;
@property (strong, nonatomic) IWAceJumpTextField *textField;

- (void)toggleAceJumpMode:(IWAceJumpMode)mode;

@end
