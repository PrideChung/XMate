#import "NSString+Searching.h"

@implementation NSString (Searching)

- (BOOL)contains:(NSString *)string
{
    return [self rangeOfString:string].location != NSNotFound;
}

- (NSArray *)rangesOfCharacter:(NSString *)character range:(NSRange)searchRange
{
    NSMutableArray *ranges = [NSMutableArray array];
    
    [self enumerateSubstringsInRange:searchRange
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              if ([substring isEqualToString:character]) {
                                  [ranges addObject:[NSValue valueWithRange:substringRange]];
                              }
                          }];
    
    return [ranges copy];
}
@end
