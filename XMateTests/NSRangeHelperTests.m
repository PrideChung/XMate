#import <XCTest/XCTest.h>
#import "NSRangeHelper.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

@interface NSRangeHelperTests : XCTestCase

@end

@implementation NSRangeHelperTests

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

- (void)testRangeContainsRange
{
    NSRange range1 = NSMakeRange(0, 5);
    NSRange range2 = NSMakeRange(1, 3);
    XCTAssertTrue(NSRangeContainsRange(range1, range2), @"");
    
    range1 = NSMakeRange(1, 7);
    range2 = NSMakeRange(1, 7);
    XCTAssertFalse(NSRangeContainsRange(range1, range2), @"");
}

- (void)testRangeContainsRangeAllowEndpointOverlapping
{
    NSRange range1 = NSMakeRange(0, 5);
    NSRange range2 = NSMakeRange(2, 2);
    XCTAssertTrue(NSRangeContainsRangeAllowEndpointOverlapping(range1, range2), @"range1 should contains range2");
    
    range1 = NSMakeRange(0, 5);
    range2 = NSMakeRange(0, 5);
    XCTAssertTrue(NSRangeContainsRangeAllowEndpointOverlapping(range1, range2), @"range1 should contains range2");
    
    range1 = NSMakeRange(0, 5);
    range2 = NSMakeRange(10, 2);
    XCTAssertFalse(NSRangeContainsRangeAllowEndpointOverlapping(range1, range2), @"range1 should not contains range2");
    
    range1 = NSMakeRange(3, 3);
    range2 = NSMakeRange(2, 4);
    XCTAssertFalse(NSRangeContainsRangeAllowEndpointOverlapping(range1, range2), @"range1 should not contains range2");
}

- (void)testRangeWithoutEndpointFromRange
{
    NSRange range = NSMakeRange(0, 3);
    NSRange rangeWithoutEndpoint = NSRangeWithoutEndpointFromRange(range);
    XCTAssertEqual(rangeWithoutEndpoint.location, 1ul);
    XCTAssertEqual(rangeWithoutEndpoint.length, 1ul);
    
    range = NSMakeRange(4, 2);
    rangeWithoutEndpoint = NSRangeWithoutEndpointFromRange(range);
    XCTAssertEqual(rangeWithoutEndpoint.location, 4ul);
    XCTAssertEqual(rangeWithoutEndpoint.length, 2ul);
    
    range = NSMakeRange(4, 6);
    rangeWithoutEndpoint = NSRangeWithoutEndpointFromRange(range);
    XCTAssertEqual(rangeWithoutEndpoint.location, 5ul);
    XCTAssertEqual(rangeWithoutEndpoint.length, 4ul);
    
    range = NSMakeRange(3, 5);
    rangeWithoutEndpoint = NSRangeWithoutEndpointFromRange(range);
    XCTAssertNotEqual(rangeWithoutEndpoint.location, 3ul);
    XCTAssertNotEqual(rangeWithoutEndpoint.length, 5ul);
}

@end
