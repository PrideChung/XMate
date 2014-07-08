#import "XMate.h"
#import "NSString+Searching.h"
#import "IWSourceEditorController.h"

@interface XMate()

@property (strong, nonatomic) NSString *selectedText;
@property (strong, nonatomic) IWSourceEditorController *editorController;
@end

@implementation XMate

static XMate *mate;

+ (void)pluginDidLoad: (NSBundle*) plugin
{
    NSLog(@"----- XMate Loaded -----");
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        mate = [[self alloc] init];
    });
}

+ (id)sharedMate
{
    return mate;
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(notificationListener:)
//                                                     name:nil object:nil];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
    self.editorController = [[IWSourceEditorController alloc] init];
    [self createMenuItem];
}

- (void)createMenuItem
{
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (editMenuItem) {
        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        // Select scope
        self.selectScopeMenuItem = [[NSMenuItem alloc] initWithTitle:@"XMate:Select Scope"
                                                              action:@selector(selectScopeDidTrigger)
                                                       keyEquivalent:@""];
        
        self.selectBracketMenuItem = [[NSMenuItem alloc] initWithTitle:@"XMate:Select between Brackets"
                                                                action:@selector(selectBracketDidTrigger)
                                                         keyEquivalent:@""];
        
        self.aceJumpMenuItem = [[NSMenuItem alloc] initWithTitle:@"XMate:Ace Jump"
                                                                action:@selector(aceJumpDidTrigger)
                                                         keyEquivalent:@""];

        [self.selectScopeMenuItem setTarget:self.editorController];
        [self.selectBracketMenuItem setTarget:self.editorController];
        [self.aceJumpMenuItem setTarget:self.editorController];
        [[editMenuItem submenu] addItem:self.selectScopeMenuItem];
        [[editMenuItem submenu] addItem:self.selectBracketMenuItem];
        [[editMenuItem submenu] addItem:self.aceJumpMenuItem];
    }
}

- (void)notificationListener:(NSNotification *)noti
{
//    NSString *name = [noti name];
//    if (
////        [name contains:@"Window"] ||
//        [name contains:@"Editor"]
//        || [name contains:@"Selection"]
//        || [name contains:@"Text"]
//        || [name contains:@"Tab"]
//        || [name contains:@"Edit"]
//        || [name contains:@"Scope"]
//        ) {
//        NSLog(@" Notification: %@", noti);
//    }
}

@end
