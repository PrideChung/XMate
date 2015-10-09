#import "IWSelectAction.h"
#import "NSView+Dump.h"

#import <ParseKit/PKToken.h>
#import "NSRangeHelper.h"
#import "IWObjcTokenizer.h"
#import "IWBracketSearcher.h"
#import "DVTKit.h"

#define DEBUG_SELECTION 1

@interface IWSelectAction ()

@property (assign, nonatomic) DVTSourceTextView *editor;
@end

@implementation IWSelectAction

- (instancetype)initWithSourceEditor:(DVTSourceTextView *)editor
{
    self = [super init];
    if (self) {
        _editor = editor;
    }
    return self;
}

// Here's the magic happens
- (void)selectScope
{
#if DEBUG_SELECTION
    NSLog(@"selectScope fired");
#endif
    
    if (!self.editor) {
        // Do nothing if no editor is active
#if DEBUG_SELECTION
        NSLog(@"No active editor");
#endif
        return;
    }

    NSRange selectedRange = [self.editor selectedRange];
    NSString *editorText = [[self.editor textStorage] string];
    NSArray *tokens = [IWObjcTokenizer tokensWithString:editorText];
    PKToken *token = [self findTokenContainsRange:selectedRange inArray:tokens];
    
#if DEBUG_SELECTION
    NSLog(@"token under selection: %@ { %ld, %ld }", [token debugDescription], token.offset, [token.stringValue length]);
#endif
    
    NSRange tokenRange = NSRangeFromToken(token);
    if ([token isWord]){
        
        if (NSEqualRanges(self.editor.selectedRange, tokenRange)) {
            [self selectPairedBracketsWithTokens:tokens];
        } else {
            [self.editor setSelectedRange:tokenRange];
        }
        
    } else if ([token isQuotedString]) {
        NSRange rangeWithoutEndpoint = NSRangeWithoutEndpointFromRange(tokenRange);
        if (NSEqualRanges(rangeWithoutEndpoint, self.editor.selectedRange)) {
            [self.editor setSelectedRange:tokenRange];
            
        } else if (NSEqualRanges(self.editor.selectedRange, tokenRange)) {
            [self selectPairedBracketsWithTokens:tokens];
            
        } else {
            [self.editor setSelectedRange:rangeWithoutEndpoint];
        }
    } else {
        [self selectPairedBracketsWithTokens:tokens];
    }
}

- (PKToken *)findTokenContainsRange:(NSRange)range inArray:(NSArray *)array
{
    for (PKToken *token in array) {
        NSRange tokenRange = NSRangeFromToken(token);
//        NSLog(@"token range: %@ :: selectedRange: %@", NSStringFromRange(tokenRange), NSStringFromRange(range));
        if (NSRangeContainsRangeAllowEndpointOverlapping(tokenRange, range) &&
            ([token isWord] || [token isQuotedString])) {
            return token;
        }
    }
    
    return nil;
}

// Extend selection to paired brackets, including square brackets, curly brackets and parenthesis
- (void)selectPairedBrackets
{
    // I'm not capable to write a robust objective-c BNF grammer defination to parse objective-c syntax,
    // so I gonna play dirty: counting brackets instead.
    NSArray *tokens = [IWObjcTokenizer tokensWithString:[[self.editor textStorage] string]];
    [self selectPairedBracketsWithTokens:tokens];
}

// Same as above, but provide tokens instead of analyze the source code again
- (void)selectPairedBracketsWithTokens:(NSArray *)tokens
{
    IWBracketSearcher *searcher = [[IWBracketSearcher alloc] initWithTokens:tokens
                                                              selectedRange:[self.editor selectedRange]];
    NSRange rangeAtPairedBrackets = [searcher rangeForClosestBracketPair];
    
    if (rangeAtPairedBrackets.location != NSNotFound) {
        NSRange rangeAtPairedBracketsWithoutEndpoint = NSRangeWithoutEndpointFromRange(rangeAtPairedBrackets);
        
        if (NSEqualRanges([self.editor selectedRange], rangeAtPairedBracketsWithoutEndpoint)) {
            [self.editor setSelectedRange:rangeAtPairedBrackets];
        } else {
            [self.editor setSelectedRange:rangeAtPairedBracketsWithoutEndpoint];
        }
    }
}

@end