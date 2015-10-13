#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IWAceJumpMode) {
    IWAceJumpModeCharacter,
    IWAceJumpModeWord,
};


@interface NSString (Searching)

- (BOOL)contains:(NSString *)string; // Returns if a string contains another string

// Returns all occurrences of the given character in receiver, within given search range and according to jump mode.
- (NSArray *)rangesOfCharacter:(NSString *)character range:(NSRange)searchRange mode:(IWAceJumpMode)mode;

@end
