#import "IWAceJumpCandidateLabel.h"

@implementation IWAceJumpCandidateLabel

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:NSInsetRect(frame, -1, 0)];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    [[NSColor yellowColor] set];
	NSRectFill(dirtyRect);
    
    [self.candidateCharacter drawInRect:NSInsetRect(dirtyRect, 2, -1)
                          withAttributes:@{NSForegroundColorAttributeName: [NSColor blackColor],
                                           NSFontAttributeName: [NSFont fontWithName:@"Menlo Regular" size:12]}];
}

@end
