#import <Foundation/Foundation.h>

@interface IWSourceEditorController : NSObject

- (void)selectScopeDidTrigger;
- (void)selectBracketDidTrigger;
- (void)aceJumpDidTrigger;

@end
