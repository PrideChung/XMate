#import <ParseKit/PKToken.h>
#import "IWBracketSearcher.h"
#import "IWOpenBracketSearchResult.h"
#import "IWBracketBalancingCounter.h"
#import "NSRangeHelper.h"

@interface IWBracketSearcher ()

@property (copy, nonatomic) NSArray *tokens;
@property (nonatomic) NSRange selectedRange;

@end

@implementation IWBracketSearcher

- (instancetype)initWithTokens:(NSArray *)tokens selectedRange:(NSRange)range
{
    self = [super init];
    if (self) {
        // Don't border to check those not-brackets tokens
        NSSet *acceptableBrackets = [NSSet setWithObjects:@"{", @"}", @"[", @"]", @"(", @")", nil];
        NSPredicate *predicate =
        [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            PKToken *token = (PKToken *)evaluatedObject;
            return [acceptableBrackets containsObject:[token stringValue]];
        }];
        
        _tokens = [tokens filteredArrayUsingPredicate:predicate];
        _selectedRange = range;
    }
    return self;
}

- (NSRange)rangeForClosestBracketPair
{
    NSRange result = NSMakeRange(NSNotFound, 0);
    IWOpenBracketSearchResult *openBracketSearchResult = [self searchForOpenBracket];
    if (openBracketSearchResult.range.location != NSNotFound) {
        NSRange closingRange = [self rangeForClosingBracket:openBracketSearchResult.closingBracketChar
                                           usingOpenBracket:openBracketSearchResult.openBracketChar
                                            searchingOffset:openBracketSearchResult.range.location];
        result = NSUnionRange(openBracketSearchResult.range, closingRange);
    }
    
    return result;
}

- (IWOpenBracketSearchResult *)searchForOpenBracket
{
//    if (self.selectedRange.length <= 1) { // The easiest situation, user only selected one charecter or nothing
//        return [self searchForOpenBracketBeforeCaret];
//    } else {
//        return [self searchForOpenBracketBeforeSelectedRange];
//    }
    
     return [self searchForOpenBracketBeforeCaret];
}

- (IWOpenBracketSearchResult *)searchForOpenBracketBeforeCaret
{
    __block IWOpenBracketSearchResult *result = [[IWOpenBracketSearchResult alloc] initWithRange:NSMakeRange(NSNotFound, 0)
                                                                                 openbracketChar:nil
                                                                              closingBracketChar:nil];
    NSArray *counters = [self balancingCountersForOpenBrackets];
    
    // Search from backward to find the first open bracket token which is located at the left side of selected range
    [self.tokens enumerateObjectsWithOptions:NSEnumerationReverse
                                  usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                      PKToken *token = (PKToken *)obj;
                                      
                                      if (token.offset < self.selectedRange.location) {
                                          for (IWBracketBalancingCounter *counter in counters) {
                                              if ([counter countBracket:token.stringValue]) {
                                                  result.range = NSRangeFromToken(token);//Bingo!
                                                  result.openBracketChar = counter.openBracket;
                                                  result.closingBracketChar = counter.closingBracket;
                                                  *stop = YES;
                                              }
                                          }
                                      }
                                  }];
    
    return result;
}

- (NSRange)rangeForClosingBracket:(NSString *)closingBracket
                 usingOpenBracket:(NSString *)openBracket
                  searchingOffset:(NSUInteger)offset
{
    IWBracketBalancingCounter *counter =
    [[IWBracketBalancingCounter alloc] initWithOpenBracket:openBracket
                                            closingBracket:closingBracket
                                          searchingBracket:IWBracketsBalancingCounterClosingBracket];
    for (PKToken *token in self.tokens) {
        if (token.offset > offset) {
            if ([counter countBracket:token.stringValue]) {
                return NSRangeFromToken(token);
            }
        }
    }
    
    return NSMakeRange(NSNotFound, 0);
}

- (NSArray *)balancingCountersForOpenBrackets
{
    IWBracketBalancingCounter *curlyBracketsCounter
    = [[IWBracketBalancingCounter alloc] initWithOpenBracket:@"{"
                                               closingBracket:@"}"
                                             searchingBracket:IWBracketsBalancingCounterOpenBracket];
    
    IWBracketBalancingCounter *squareBracketsCounter
    = [[IWBracketBalancingCounter alloc] initWithOpenBracket:@"["
                                               closingBracket:@"]"
                                             searchingBracket:IWBracketsBalancingCounterOpenBracket];
    
    IWBracketBalancingCounter *parenthesisCounter
    = [[IWBracketBalancingCounter alloc] initWithOpenBracket:@"("
                                               closingBracket:@")"
                                             searchingBracket:IWBracketsBalancingCounterOpenBracket];
    
    return @[curlyBracketsCounter, squareBracketsCounter, parenthesisCounter];
}

@end