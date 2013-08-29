//
//  IWAceJumpCharacterSet.h
//  XMate
//
//  Created by 钟 子豪 on 13-8-12.
//  Copyright (c) 2013年 Indie Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWAceJumpCharacterSet : NSObject

+ (NSOrderedSet *)candidateCharacters;
+ (NSOrderedSet *)upperCaseCandidateCharacters;


@end
