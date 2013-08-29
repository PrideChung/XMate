#import <XCTest/XCTest.h>
#import "IWBracketBalancingCounter.h"

@interface IWBracketBalancingCounter ()

@property (nonatomic) NSInteger balancingCount;

- (BOOL)countBracket:(NSString *)bracket;
- (BOOL)checkBalancing;

@end


@interface IWBracketBalancingCounterTests : XCTestCase

@end

@implementation IWBracketBalancingCounterTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCountBracket
{
    // case 1
    IWBracketBalancingCounter *counter =
    [[IWBracketBalancingCounter alloc] initWithOpenBracket:@"{"
                                             closingBracket:@"}"
                                           searchingBracket:IWBracketsBalancingCounterOpenBracket];
    
    XCTAssertTrue([counter countBracket:@"{"]);
    
    // case 2
    counter =
    [[IWBracketBalancingCounter alloc] initWithOpenBracket:@"{"
                                            closingBracket:@"}"
                                          searchingBracket:IWBracketsBalancingCounterOpenBracket];
    
    XCTAssertFalse([counter countBracket:@"}"]);
    XCTAssertFalse([counter countBracket:@"{"]);
    XCTAssertTrue([counter countBracket:@"{"]);
    
    // case 3
    counter =
    [[IWBracketBalancingCounter alloc] initWithOpenBracket:@"{"
                                            closingBracket:@"}"
                                          searchingBracket:IWBracketsBalancingCounterClosingBracket];
    
    XCTAssertTrue([counter countBracket:@"}"]);
    
    // case 4
    counter =
    [[IWBracketBalancingCounter alloc] initWithOpenBracket:@"{"
                                            closingBracket:@"}"
                                          searchingBracket:IWBracketsBalancingCounterClosingBracket];
    XCTAssertFalse([counter countBracket:@"{"]);
    XCTAssertFalse([counter countBracket:@"}"]);
    XCTAssertTrue([counter countBracket:@"}"]);
}

- (void)testCheckBalancing
{
    IWBracketBalancingCounter *counter =
    [[IWBracketBalancingCounter alloc] initWithOpenBracket:@"{"
                                             closingBracket:@"}"
                                           searchingBracket:IWBracketsBalancingCounterOpenBracket];
    counter.balancingCount = 1;
    XCTAssertTrue([counter checkBalancing]);
    
    counter.balancingCount = 0;
    XCTAssertFalse([counter checkBalancing]);
    
    counter.balancingCount = -1;
    XCTAssertFalse([counter checkBalancing]);
    
    counter =
    [[IWBracketBalancingCounter alloc] initWithOpenBracket:@"{"
                                            closingBracket:@"}"
                                          searchingBracket:IWBracketsBalancingCounterClosingBracket];
    
    counter.balancingCount = -1;
    XCTAssertTrue([counter checkBalancing]);
    
    counter.balancingCount = 0;
    XCTAssertFalse([counter checkBalancing]);
    
    counter.balancingCount = 1;
    XCTAssertFalse([counter checkBalancing]);
}

@end
