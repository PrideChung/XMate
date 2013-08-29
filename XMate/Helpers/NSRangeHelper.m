#import "NSRangeHelper.h"
#import <ParseKit/ParseKit.h>

NSRange NSRangeFromToken(PKToken *token)
{
    return NSMakeRange(token.offset, [[token stringValue] length]);
}

BOOL NSRangeContainsRange(NSRange range1, NSRange range2)
{
    return (range2.location > range1.location) &&
    ( NSMaxRange(range2) < NSMaxRange(range1) );
}

BOOL NSRangeContainsRangeAllowEndpointOverlapping(NSRange range1, NSRange range2)
{
    return (range2.location >= range1.location) &&
    ( NSMaxRange(range2) <= NSMaxRange(range1) );
}

NSRange NSRangeWithoutEndpointFromRange(NSRange range)
{
    if (range.length < 3) {
        return range; // There is no way to try a range's endpoint if the original range's length less than 3.
    }
    
    NSUInteger location = range.location + 1;
    NSUInteger length = range.length - 2;
    return NSMakeRange(location, length);
}