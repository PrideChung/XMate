#import <XCTest/XCTest.h>
#import "NSString+Searching.h"

@interface NSStringSearchingTests : XCTestCase

@end

@implementation NSStringSearchingTests

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

- (void)testRangesOfStringInRange
{
    //              0123456789
    NSString *s = @"foo*bar.fo";
    NSArray *ranges = [s rangesOfCharacter:@"f" range:NSMakeRange(0, [s length])];
    XCTAssertEqual([ranges count], 2ul);
    XCTAssertEqual([ranges[0] rangeValue], NSMakeRange(0, 1));
    XCTAssertEqual([ranges[1] rangeValue], NSMakeRange(8, 1));
    
    ranges = [s rangesOfCharacter:@"f" range:NSMakeRange(1, [s length] - 1)];
    XCTAssertEqual([ranges count], 1ul);
    XCTAssertEqual([ranges[0] rangeValue], NSMakeRange(8, 1));
    
    ranges = [s rangesOfCharacter:@"*" range:NSMakeRange(1, [s length] - 1)];
    XCTAssertEqual([ranges count], 1ul);
    XCTAssertEqual([ranges[0] rangeValue], NSMakeRange(3, 1));
    
    ranges = [s rangesOfCharacter:@"." range:NSMakeRange(1, [s length] - 1)];
    XCTAssertEqual([ranges count], 1ul);
    XCTAssertEqual([ranges[0] rangeValue], NSMakeRange(7, 1));
}
@end
