//
//  NSString+BSJSONAdditions.h
//  BSJSONAdditions
//
//  Created by Blake Seely (Air) on 3/24/09.
//  Copyright 2009 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (BSJSONAdditions)

+ (NSString *)jsonIndentStringForLevel:(int)level;
- (NSString *)jsonStringValue;

@end
