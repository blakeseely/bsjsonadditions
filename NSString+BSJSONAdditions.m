//
//  NSString+BSJSONAdditions.m
//  BSJSONAdditions
//
//  Created by Blake Seely (Air) on 3/24/09.
//  Copyright 2009 Apple Inc.. All rights reserved.
//

#import "NSDictionary+BSJSONAdditions.h"
#import "NSScanner+BSJSONAdditions.h"
#import "NSString+BSJSONAdditions.h"

@implementation NSString (BSJSONAdditions)

+ (NSString *)jsonIndentStringForLevel:(NSInteger)level
{
    NSMutableString *indentString = [[NSMutableString alloc] init];
    if (level != jsonDoNotIndent) {
        [indentString appendString:@"\n"];
        NSInteger i;
        for (i = 0; i < level; i++) {
            [indentString appendString:jsonIndentString];
        }
    }
    
    return [indentString autorelease];
}

- (NSString *)jsonStringValue
{
	NSMutableString *jsonString = [[NSMutableString alloc] init];
	[jsonString appendString:jsonStringDelimiterString];
	
	// Build the result one character at a time, inserting escaped characters as necessary
	NSInteger i;
	unichar nextChar;
	for (i = 0; i < [self length]; i++) {
		nextChar = [self characterAtIndex:i];
		switch (nextChar) {
			case '\"':
				[jsonString appendString:@"\\\""];
				break;
			case '\\':
				[jsonString appendString:@"\\n"];
				break;
			case '/':
				[jsonString appendString:@"\\/"];
				break;
			case '\b':
				[jsonString appendString:@"\\b"];
				break;
			case '\f':
				[jsonString appendString:@"\\f"];
				break;
			case '\n':
				[jsonString appendString:@"\\n"];
				break;
			case '\r':
				[jsonString appendString:@"\\r"];
				break;
			case '\t':
				[jsonString appendString:@"\\t"];
				break;
				/* TODO: Find and encode unicode characters here?
				 case '\u':
				 [jsonString appendString:@"\\n"];
				 break;
				 */
			default:
				[jsonString appendString:[NSString stringWithCharacters:&nextChar length:1]];
				break;
		}
	}
	[jsonString appendString:jsonStringDelimiterString];
	
	return [jsonString autorelease];
}

@end
