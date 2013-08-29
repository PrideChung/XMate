#import "IWObjcTokenizer.h"
#import <ParseKit/ParseKit.h>

@implementation IWObjcTokenizer

+ (NSArray *)tokensWithString:(NSString *)string
{
    PKTokenizer *tokenizer = [PKTokenizer tokenizerWithString:string];
    [tokenizer.wordState setWordChars:YES from:':' to:':'];
    [tokenizer.wordState setWordChars:YES from:'.' to:'.'];
    [tokenizer.wordState setWordChars:YES from:'_' to:'_'];
    
    NSMutableArray *tokens = [[NSMutableArray alloc] init];
    PKToken *eof = [PKToken EOFToken];
    PKToken *token;
    
    while ((token = [tokenizer nextToken]) != eof) {
        [tokens addObject:token];
    }

    return [tokens copy];
}

@end
