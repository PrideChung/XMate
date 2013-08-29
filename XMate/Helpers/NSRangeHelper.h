#import <Foundation/Foundation.h>
@class PKToken;

// Returns a NSRange structure from a token's position.
NSRange NSRangeFromToken(PKToken *token);

// Returns whether the range1 contains range2 completely ( Without endpoint overlapping)
BOOL NSRangeContainsRange(NSRange range1, NSRange range2);

// Returns whether the range1 contains range2 ( Allow endpoint overlapping, will return YES even if range1 is equals to range2
BOOL NSRangeContainsRangeAllowEndpointOverlapping(NSRange range1, NSRange range2);

// Returns a NSRange structure with it's endpoint trimmed. ie: {0, 3} becomes {1, 1}
NSRange NSRangeWithoutEndpointFromRange(NSRange range);