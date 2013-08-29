#import <Foundation/Foundation.h>

@interface IWOpenBracketSearchResult : NSObject

@property (nonatomic) NSRange range;
@property (copy, nonatomic) NSString *openBracketChar;
@property (copy, nonatomic) NSString *closingBracketChar;

- (instancetype)initWithRange:(NSRange)range
                  openbracketChar:(NSString *)openBracket
          closingBracketChar:(NSString *)closingBracket;

@end