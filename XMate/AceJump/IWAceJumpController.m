#import "DVTKit.h"
#import "IWAceJumpController.h"
#import "NSString+Searching.h"
#import "IWAceJumpCandidateLabel.h"
#import "IWAceJumpTextField.h"
#import "IWAceJumpCharacterSet.h"

typedef NS_ENUM(NSUInteger, IWAceJumpState) {
    IWAceJumpStateInactive,
    IWAceJumpStateWaitingForCharacter, // This state indicates input textfield is popuped, and waiting for user to input the character to jump to.
    IWAceJumpStateShowingCandidates // This state indicates candidates are shown and waiting for user to chose one of them.
};

@interface IWAceJumpController () <NSTextFieldDelegate>

@property (nonatomic) IWAceJumpState state; // Indicates if ace jump mode is being active.
@property (nonatomic) IWAceJumpMode aceJumpMode; // Indicates which ace jump mode is active.
@property (strong, nonatomic) NSMutableArray *candidateLabels;

@property (strong, nonatomic) NSArray *candidateRanges;
@property (nonatomic) NSUInteger candidateOffset;

@end

@implementation IWAceJumpController

- (id)init
{
    self = [super init];
    if (self) {
        _candidateLabels = [NSMutableArray array];
    }
    return self;
}

- (void)toggleAceJumpMode:(IWAceJumpMode)mode
{
    if (self.state == IWAceJumpStateInactive) {
        self.aceJumpMode = mode;
        [self enterAceJumpMode];
    } else {
        [self quitAceJumpMode];
    }
}

- (void)enterAceJumpMode
{
    self.state = IWAceJumpStateWaitingForCharacter;
    NSLog(@"enter ace jump mode");
    NSClipView *clipView = (NSClipView *)[self.sourceTextView superview];
    NSRect rect = [clipView documentVisibleRect];
    NSRect textFieldFrame = NSMakeRect(rect.origin.x,
                                       rect.origin.y + rect.size.height - 25,
                                       25,
                                       25);
    
    self.textField = [[IWAceJumpTextField alloc] initWithFrame:textFieldFrame];
    [self.textField setDelegate:self];
    [self.textField setFont:[NSFont boldSystemFontOfSize:17]];
    [self.sourceTextView addSubview:self.textField];
    [[self.textField window] makeFirstResponder:self.textField];
}

- (void)quitAceJumpMode
{
    if (self.sourceTextView) {
        self.state = IWAceJumpStateInactive;
        NSLog(@"quit ace jump mode");
        [self.textField removeFromSuperview];
        [[self.sourceTextView window] makeFirstResponder:self.sourceTextView];
        
        [self clearCandidates];
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    [self quitAceJumpMode];
    NSLog(@"end editing");
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *textField = [obj object];
    if ([textField isEqual:self.textField]) {
        NSString *input = [self.textField stringValue];
        if ( self.state == IWAceJumpStateWaitingForCharacter && [input length] == 1) {
            [self showCandidates];
            
        } else if (self.state == IWAceJumpStateShowingCandidates && [input length] == 2) {
            NSString *chosenCharacter = [input substringWithRange:NSMakeRange(1, 1)];
            BOOL shouldMakeSelection = NO;
            if ([[IWAceJumpCharacterSet upperCaseCandidateCharacters] containsObject:chosenCharacter]) {
                shouldMakeSelection = YES;
                chosenCharacter = [chosenCharacter lowercaseString];
            }
            
            if ([[IWAceJumpCharacterSet candidateCharacters] containsObject:chosenCharacter] ) {
                NSUInteger index = [self candidateRangesIndexForCharacter:chosenCharacter];
                if (index < [self.candidateRanges count]) {
                    NSRange range = ((NSValue *)self.candidateRanges[index]).rangeValue;
                    [self jumpToRange:range shouldMakeSelection:shouldMakeSelection];
                    [self quitAceJumpMode];
                } else {
                    [self.textField setStringValue:[[self.textField stringValue] substringToIndex:1]];
                }
            } else {
                [self.textField setStringValue:[[self.textField stringValue] substringToIndex:1]];
            }
            
        } else if ( self.state == IWAceJumpStateShowingCandidates && [input length] == 0) {
            self.state = IWAceJumpStateWaitingForCharacter;
            [self clearCandidates];
        }
        NSLog(@"input: %@", [self.textField stringValue]);
    }
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(cancelOperation:)) {
        [self quitAceJumpMode];
        return YES;
    }

    if (commandSelector == @selector(insertNewline:) || commandSelector == @selector(insertTab:)) {
        if (self.state == IWAceJumpStateShowingCandidates) {
            [self nextCandidateBatch];
            return YES;
        }
    }
    
    return NO;
}

- (void)showCandidates
{
    self.state = IWAceJumpStateShowingCandidates;
    self.candidateOffset = 0;
    NSString *character = [[self.textField stringValue] substringWithRange:NSMakeRange(0, 1)];
    self.candidateRanges = [[[self.sourceTextView textStorage] string] rangesOfCharacter:character
                                                                                   range:[self visibleTextRangeInSourceTextView]
                                                                                    mode:self.aceJumpMode];
    
    [self nextCandidateBatch];
}

- (void)nextCandidateBatch
{
    if ([self.candidateRanges count] < 1) {
        return;
    }
    
    [self clearCandidateLabel];
   
    NSUInteger batchSize = [[IWAceJumpCharacterSet candidateCharacters] count];
    NSUInteger endIndex = self.candidateOffset + batchSize - 1;
    NSUInteger candidateRangesEndIndex = [self.candidateRanges count] - 1;
    endIndex = endIndex > candidateRangesEndIndex ? candidateRangesEndIndex : endIndex;
    
    for (NSUInteger i = self.candidateOffset; i <= endIndex; i++) {
        NSRange range = [self.candidateRanges[i] rangeValue];
        NSRect candidateRect = [self rectInSourceTextViewFromCharacterRange:range];
        IWAceJumpCandidateLabel *label = [[IWAceJumpCandidateLabel alloc] initWithFrame:candidateRect];
        label.candidateCharacter = [IWAceJumpCharacterSet candidateCharacters][i - self.candidateOffset];
        [self.sourceTextView addSubview:label];
        [self.candidateLabels addObject:label];
    }
    
    self.candidateOffset += batchSize;
    self.candidateOffset = self.candidateOffset >= candidateRangesEndIndex ? 0 : self.candidateOffset;
}

- (void)clearCandidates
{
    [self clearCandidateLabel];
    self.candidateRanges = nil;
    self.candidateOffset = 0;
}

- (void)clearCandidateLabel
{
    for (IWAceJumpCandidateLabel *label in self.candidateLabels) {
        [label removeFromSuperview];
    }
    [self.candidateLabels removeAllObjects];
}

- (NSUInteger)candidateRangesIndexForCharacter:(NSString *)character
{
    NSUInteger index = [[IWAceJumpCharacterSet candidateCharacters] indexOfObject:character];
    NSUInteger batchSize = [[IWAceJumpCharacterSet candidateCharacters] count];
    index = self.candidateOffset >= batchSize ? index + self.candidateOffset - batchSize : [self.candidateRanges count] - [self.candidateRanges count] % batchSize + index;
    return index;
}

- (void)jumpToRange:(NSRange)range shouldMakeSelection:(BOOL)shouldMakeSelection
{
    if (shouldMakeSelection) {
        range = NSUnionRange(self.sourceTextView.selectedRange, range);
    } else {
        range.length = 0;
    }
    [self.sourceTextView setSelectedRange:range];
}

- (NSRect)rectInSourceTextViewFromCharacterRange:(NSRange)range
{
    NSRect selectionRectOnScreen = [self.sourceTextView firstRectForCharacterRange:range];
    NSRect selectionRectInWindow = [self.sourceTextView.window convertRectFromScreen:selectionRectOnScreen];
    NSRect selectionRectInView = [self.sourceTextView convertRect:selectionRectInWindow fromView:nil];
    return selectionRectInView;
}

// Returns the range of visible string in self.sourcesourceTextView
- (NSRange)visibleTextRangeInSourceTextView
{
    NSClipView *clipView = (NSClipView *)[self.sourceTextView superview];
    NSRange glyphRange = [self.sourceTextView.layoutManager glyphRangeForBoundingRect:[clipView documentVisibleRect]
                                                                      inTextContainer:[self.sourceTextView textContainer]];
    return [self.sourceTextView.layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
}

@end
