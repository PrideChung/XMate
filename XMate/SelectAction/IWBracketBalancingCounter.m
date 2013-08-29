#import "IWBracketBalancingCounter.h"

@interface IWBracketBalancingCounter ()

@property (nonatomic) NSInteger balancingCount;

@end

@implementation IWBracketBalancingCounter

- (instancetype)initWithOpenBracket:(NSString *)openBracket
                     closingBracket:(NSString *)closingBracket
                   searchingBracket:(IWBracketsBalancingCounterSearchingBracket)searchingBracket
{
    self = [super init];
    if (self) {
        _openBracket = openBracket;
        _closingBracket = closingBracket;
        _searchingBracket = searchingBracket;
        _balancingCount = 0;
    }
    
    return self;
}

// If return YES, means the balancing is broken and open or closing bracket is located.
- (BOOL)countBracket:(NSString *)bracket
{
    if ([bracket isEqualToString:self.openBracket]) {
        self.balancingCount += 1;
        return [self checkBalancing];
        
    } else if ([bracket isEqualToString:self.closingBracket]) {
        self.balancingCount -= 1;
        return [self checkBalancing];
        
    } else {
        return NO; // Not the type of brackets I concerns, pass.
    }
}

- (BOOL)checkBalancing
{
    if (self.searchingBracket == IWBracketsBalancingCounterOpenBracket && self.balancingCount == 1) {
        return YES;
    } else if (self.searchingBracket == IWBracketsBalancingCounterClosingBracket && self.balancingCount == -1) {
        return YES;
    } else {
        return NO;
    }
}

@end
