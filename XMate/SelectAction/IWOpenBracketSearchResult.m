#import "IWOpenBracketSearchResult.h"

@implementation IWOpenBracketSearchResult

- (instancetype)initWithRange:(NSRange)range
                  openbracketChar:(NSString *)openBracket
          closingBracketChar:(NSString *)closingBracket
{
    self = [super init];
    if (self) {
        _range = range;
        _openBracketChar = openBracket;
        _closingBracketChar = closingBracket;
    }
    return self;
}

@end
