//
//  IWAceJumpCharacterSet.m
//  XMate
//
//  Created by 钟 子豪 on 13-8-12.
//  Copyright (c) 2013年 Indie Works. All rights reserved.
//

#import "IWAceJumpCharacterSet.h"

@implementation IWAceJumpCharacterSet

//+ (NSArray *) sharedlowerCaseLetters;
+ (NSOrderedSet *)candidateCharacters
{
	static NSOrderedSet* _candidateCharacters;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_candidateCharacters = [NSOrderedSet orderedSetWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
	});
	
	return _candidateCharacters;
}

+ (NSOrderedSet *)upperCaseCandidateCharacters
{
    static NSOrderedSet* _uppercaseCandidateCharacters;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_uppercaseCandidateCharacters = [NSOrderedSet orderedSetWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
	});
	
	return _uppercaseCandidateCharacters;
}


@end
