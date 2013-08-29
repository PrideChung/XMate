#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IWBracketsBalancingCounterSearchingBracket) {
    IWBracketsBalancingCounterOpenBracket,
    IWBracketsBalancingCounterClosingBracket
};

@interface IWBracketBalancingCounter : NSObject

@property (copy, nonatomic, readonly) NSString *openBracket;
@property (copy, nonatomic, readonly) NSString *closingBracket;
@property (nonatomic, readonly) IWBracketsBalancingCounterSearchingBracket searchingBracket;

- (instancetype)initWithOpenBracket:(NSString *)openBracket
                     closingBracket:(NSString *)closingBracket
                   searchingBracket:(IWBracketsBalancingCounterSearchingBracket)searchingBracket; // Specify which bracket want to seach, when this bracket break the counting balance means open bracket or closing bracket is located.

// If return YES, means the balancing is broken and open or closing bracket is located.
- (BOOL)countBracket:(NSString *)bracket;
@end
