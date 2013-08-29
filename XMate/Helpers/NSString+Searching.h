#import <Foundation/Foundation.h>

@interface NSString (Searching)

- (BOOL)contains:(NSString *)string; // Returns if a string contains another string

// Returns all occurrences of the given string in receiver, within given search range.
- (NSArray *)rangesOfCharacter:(NSString *)character range:(NSRange)searchRange;

@end
