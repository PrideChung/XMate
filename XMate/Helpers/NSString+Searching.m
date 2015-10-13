#import "NSString+Searching.h"

@implementation NSString (Searching)

- (BOOL)contains:(NSString *)string
{
    return [self rangeOfString:string].location != NSNotFound;
}

- (NSArray *)rangesOfCharacter:(NSString *)character range:(NSRange)searchRange mode:(IWAceJumpMode)mode
{
    NSMutableArray *ranges = [NSMutableArray array];
    
    [self enumerateSubstringsInRange:searchRange
                             options:(mode == IWAceJumpModeCharacter ? NSStringEnumerationByComposedCharacterSequences : NSStringEnumerationByWords)
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              if (mode == IWAceJumpModeCharacter)
                              {
                                  if ([substring isEqualToString:character]) {
                                      [ranges addObject:[NSValue valueWithRange:substringRange]];
                                  }
                              }
                              else if (mode == IWAceJumpModeWord)
                              {
                                  // Given "self.property" one should be able to jump to both "self" and "property".
                                  NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@".:{}"];
                                  NSArray *components = [substring componentsSeparatedByCharactersInSet:set];
                                  NSUInteger wordLocationInContainer = 0;
                                  for (NSString *word in components)
                                  {
                                      NSString *firstCharacter = [word substringWithRange:(NSRange){0,1}];
                                      if ([firstCharacter isEqualToString:character]) {
                                          [ranges addObject:[NSValue valueWithRange:NSMakeRange(substringRange.location + wordLocationInContainer, 1)]];
                                      }
                                      
                                      // Next word will be upstream of current word's length and separator.
                                      wordLocationInContainer += word.length + 1;
                                  }
                              }
                          }];
    
    return [ranges copy];
}

@end
