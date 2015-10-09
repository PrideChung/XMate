#import <XCTest/XCTest.h>
#import "NSString+Searching.h"

@interface NSStringSearchingTests : XCTestCase

@property (nonatomic) IWAceJumpMode mode;

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
    self.mode = IWAceJumpModeCharacter;
    
    //              0123456789
    NSString *s = @"foo*bar.fo";
    NSArray *ranges = [s rangesOfCharacter:@"f" range:NSMakeRange(0, [s length]) mode:self.mode];
    XCTAssertEqual([ranges count], 2ul);
    XCTAssertTrue(NSEqualRanges([ranges[0] rangeValue], NSMakeRange(0, 1)));
    XCTAssertTrue(NSEqualRanges([ranges[1] rangeValue], NSMakeRange(8, 1)));
    
    ranges = [s rangesOfCharacter:@"f" range:NSMakeRange(1, [s length] - 1) mode:self.mode];
    XCTAssertEqual([ranges count], 1ul);
    XCTAssertTrue(NSEqualRanges([ranges[0] rangeValue], NSMakeRange(8, 1)));
    
    ranges = [s rangesOfCharacter:@"*" range:NSMakeRange(1, [s length] - 1) mode:self.mode];
    XCTAssertEqual([ranges count], 1ul);
    XCTAssertTrue(NSEqualRanges([ranges[0] rangeValue], NSMakeRange(3, 1)));
    
    ranges = [s rangesOfCharacter:@"." range:NSMakeRange(1, [s length] - 1) mode:self.mode];
    XCTAssertEqual([ranges count], 1ul);
    XCTAssertTrue(NSEqualRanges([ranges[0] rangeValue], NSMakeRange(7, 1)));
}

- (void)testRangesOfFirstWordCharacterInRange
{
    self.mode = IWAceJumpModeWord;
    
    NSString *s = @"[self.textField setStringValue:[[self.textField stringValue] substringToIndex:1]];";
    
    NSArray *ranges = [s rangesOfCharacter:@"f" range:NSMakeRange(0, [s length]) mode:self.mode];
    XCTAssertEqual([ranges count], 0ul);
    
    ranges = [s rangesOfCharacter:@"1" range:NSMakeRange(1, [s length] - 1) mode:self.mode];
    XCTAssertEqual([ranges count], 1ul);
    XCTAssertTrue(NSEqualRanges([ranges[0] rangeValue], NSMakeRange(s.length-4, 1)));
    
    ranges = [s rangesOfCharacter:@"t" range:NSMakeRange(1, [s length] - 1) mode:self.mode];
    XCTAssertEqual([ranges count], 2ul);
    XCTAssertTrue(NSEqualRanges([ranges[0] rangeValue], NSMakeRange(6, 1)));
    XCTAssertTrue(NSEqualRanges([ranges[1] rangeValue], NSMakeRange(38, 1)));
    
    ranges = [s rangesOfCharacter:@"s" range:NSMakeRange(1, [s length] - 1) mode:self.mode];
    XCTAssertEqual([ranges count], 5ul);
    XCTAssertTrue(NSEqualRanges([ranges[2] rangeValue], NSMakeRange(33, 1)));
}
@end
