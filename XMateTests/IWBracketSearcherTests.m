#import <XCTest/XCTest.h>
#import "IWBracketSearcher.h"
#import "IWOpenBracketSearchResult.h"
#import <ParseKit/PKToken.h>


#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface IWBracketSearcher ()

@property (copy, nonatomic) NSArray *tokens;

@property (nonatomic) NSRange selectedRange;

- (IWOpenBracketSearchResult *)searchForOpenBracketBeforeCaret;

- (NSRange)rangeForClosingBracket:(NSString *)closingBracket
                 usingOpenBracket:(NSString *)openBracket
                  searchingOffset:(NSUInteger)offset;
- (NSArray *)tokensUnderSelection;
@end

@interface IWBracketSearcherTests : XCTestCase

@property (copy, nonatomic) NSArray *mockTokens1;
@property (copy, nonatomic) NSArray *mockTokens2;

@end

@implementation IWBracketSearcherTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    PKToken *t1 = mock([PKToken class]);
    PKToken *t2 = mock([PKToken class]);
    /* Mock tokens should looks like this, pipe means cusor position :
     0 1 2
     { | }
     */
    [given([t1 stringValue]) willReturn:@"{"];
    [given([t1 offset]) willReturnUnsignedInteger:0];
    
    [given([t2 stringValue]) willReturn:@"}"];
    [given([t2 offset]) willReturnUnsignedInteger:2];
    
    self.mockTokens1 = @[t1, t2];
    
    /* Mock tokens should looks like this, pipe means cusor position :
     0 1 2 3 4 5 6 7 8 9
     {   [   ( ) | ]   }
     */
    PKToken *t3 = mock([PKToken class]);
    PKToken *t4 = mock([PKToken class]);
    PKToken *t5 = mock([PKToken class]);
    PKToken *t6 = mock([PKToken class]);
    PKToken *t7 = mock([PKToken class]);
    PKToken *t8 = mock([PKToken class]);
    
    [given([t3 stringValue]) willReturn:@"{"];
    [given([t3 offset]) willReturnUnsignedInteger:0];
    
    [given([t4 stringValue]) willReturn:@"}"];
    [given([t4 offset]) willReturnUnsignedInteger:9];
    
    [given([t5 stringValue]) willReturn:@"["];
    [given([t5 offset]) willReturnUnsignedInteger:2];
    
    [given([t6 stringValue]) willReturn:@"]"];
    [given([t6 offset]) willReturnUnsignedInteger:7];
    
    [given([t7 stringValue]) willReturn:@"("];
    [given([t7 offset]) willReturnUnsignedInteger:4];
    
    [given([t8 stringValue]) willReturn:@")"];
    [given([t8 offset]) willReturnUnsignedInteger:5];
    
    self.mockTokens2 = @[t3, t4, t5, t6, t7, t8];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSearchForOpenBracketBeforeCaret
{
    // case 1
    IWBracketSearcher *searcher = [[IWBracketSearcher alloc] initWithTokens:self.mockTokens1
                                                              selectedRange:NSMakeRange(1, 0)];
    IWOpenBracketSearchResult *result = [searcher searchForOpenBracketBeforeCaret];
    XCTAssertEqual(result.range, NSMakeRange(0, 1));
    XCTAssertEqualObjects(result.openBracketChar, @"{");
    XCTAssertEqualObjects(result.closingBracketChar, @"}");
    
    // case 2
    searcher = [[IWBracketSearcher alloc] initWithTokens:self.mockTokens2
                                        selectedRange:NSMakeRange(6, 0)];
    result = [searcher searchForOpenBracketBeforeCaret];
    XCTAssertEqual(result.range, NSMakeRange(2, 1));
    XCTAssertEqualObjects(result.openBracketChar, @"[");
    XCTAssertEqualObjects(result.closingBracketChar, @"]");
}

- (void)testRangeFromOpenBracketToClosingBracketSearchingOffset
{
    /* Mock tokens should looks like this,  caret means searching offset :
     0 1 2
     { | }
     ^
     */
    IWBracketSearcher *searcher = [[IWBracketSearcher alloc] initWithTokens:self.mockTokens1
                                                          selectedRange:NSMakeRange(NSNotFound, 0)];
    

    XCTAssertEqual([searcher rangeForClosingBracket:@"}"
                                usingOpenBracket:@"{"
                                 searchingOffset:0], NSMakeRange(2, 1));
    
   /* Mock tokens should looks like this, caret means searching offset :
    0 1 2 3 4 5 6 7 8 9
    {   [   ( )   ]   }
        ^
    */
    searcher = [[IWBracketSearcher alloc] initWithTokens:self.mockTokens2
                                        selectedRange:NSMakeRange(NSNotFound, 0)];
    XCTAssertEqual([searcher rangeForClosingBracket:@"]"
                                 usingOpenBracket:@"["
                                  searchingOffset:2], NSMakeRange(7, 1));
}

@end
