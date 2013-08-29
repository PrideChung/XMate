
#import <Foundation/Foundation.h>

// This class is responsible for find the closest bracket pair that surrounding the given selected range

@interface IWBracketSearcher : NSObject

- (instancetype)initWithTokens:(NSArray *)tokens selectedRange:(NSRange)range;

- (NSRange)rangeForClosestBracketPair;


@end

