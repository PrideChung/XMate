#import <Foundation/Foundation.h>

@class DVTSourceTextView;
@interface IWSelectAction : NSObject

- (instancetype)initWithSourceEditor:(DVTSourceTextView *)editor;
- (void)selectScope;
- (void)selectPairedBrackets;

@end
