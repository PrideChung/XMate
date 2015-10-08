#import "IDEKit.h"
#import "DVTKit.h"
#import "IWSourceEditorController.h"
#import "IWSelectAction.h"
#import "IWAceJumpController.h"
#import "DVTSourceTextView+AceJump.h"


@interface IWSourceEditorController ()

@property (strong, nonatomic) DVTSourceTextView *activeEditor;
@end

@implementation IWSourceEditorController

#define DEBUG_SELECTION 1

- (id)init
{
    self = [super init];
    if (self) {
        // This notification will be triggered when you switch to another editor, like assistant editor.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(activeEditorContextDidChange:)
                                                     name:@"IDEEditorAreaLastActiveEditorContextDidChangeNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(activeTabDidChange:)
                                                     name:@"Active Workspace Tab Controller Changed Notification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidChangeSelection:)
                                                     name:NSTextViewDidChangeSelectionNotification
                                                   object:nil];
    }
    return self;
}

- (void)activeEditorContextDidChange:(NSNotification *)notification
{
    IDEEditorContext *context = [notification userInfo][@"IDEEditorContext"];
    self.activeEditor = [self sourceTextViewEditorContext:context];
    
#if DEBUG_SELECTION
    if (self.activeEditor) {
        NSLog(@"active editor changed to: %@", [self.activeEditor debugDescription]);
    }
#endif
}

- (void)activeTabDidChange:(NSNotification *)notification
{
    IDEWorkspaceTabController *controller = [notification object];
    
    IDEEditorContext *context = [[controller editorArea] lastActiveEditorContext];
    self.activeEditor = [self sourceTextViewEditorContext:context];
#if DEBUG_SELECTION
    if (self.activeEditor) {
        NSLog(@"active editor changed to: %@", [self.activeEditor debugDescription]);
    }
#endif
}
         
- (void)textViewDidChangeSelection:(NSNotification *)notification
{
    id textView =  [notification object];
    if ([textView isKindOfClass:[DVTSourceTextView class]]) {
        self.activeEditor = textView;
    }
}

- (void)selectScopeDidTrigger
{
    IWSelectAction *selectScopeAction = [[IWSelectAction alloc] initWithSourceEditor:self.activeEditor];
    [selectScopeAction selectScope];
}

- (void)selectBracketDidTrigger
{
    IWSelectAction *selectAction = [[IWSelectAction alloc] initWithSourceEditor:self.activeEditor];
    [selectAction selectPairedBrackets];
}

- (void)aceJumpDidTrigger:(IWAceJumpMode)mode
{
    if ([self.activeEditor isKindOfClass:[DVTSourceTextView class]]) {
        if (!self.activeEditor.aceJumpController.sourceTextView) {
            self.activeEditor.aceJumpController.sourceTextView = self.activeEditor;
        }
        [self.activeEditor.aceJumpController toggleAceJumpMode:mode];
    }
}

- (void)aceJumpCharDidTrigger
{
    [self aceJumpDidTrigger:IWAceJumpModeCharacter];
}

- (void)aceJumpWordDidTrigger
{
    [self aceJumpDidTrigger:IWAceJumpModeWord];
}

- (DVTSourceTextView *)sourceTextViewEditorContext:(IDEEditorContext *)context
{
    IDEEditor *editor = [context editor];
    NSScrollView *scrollView = [editor mainScrollView];
    NSClipView *clipView = [scrollView contentView];
    id documentView = [clipView documentView];
    if ([documentView isKindOfClass:[DVTSourceTextView class]]) {
        return documentView;
    } else {
        return nil;
    }
}

@end