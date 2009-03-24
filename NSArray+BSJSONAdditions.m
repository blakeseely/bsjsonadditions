//
//  NSArray+BSJSONAdditions.m
//  BSJSONAdditions
//
//  Created by Blake Seely (Air) on 3/24/09.
//  Copyright 2009 Apple Inc.. All rights reserved.
//

#import "NSArray+BSJSONAdditions.h"
#import "NSScanner+BSJSONAdditions.h"

@implementation NSArray (BSJSONAdditions)

+ (NSArray *)arrayWithJSONString:(NSString *)jsonString
{
	NSScanner *scanner = [[NSScanner alloc] initWithString:jsonString];
	NSArray *array = nil;
	[scanner scanJSONArray:&array];
	[scanner release];
	
	return array;
}

- (NSString *)jsonStringValue
{
	return [self jsonStringValueWithIndentLevel:0];
}


@end

@implementation NSArray (PrivateBSJSONAdditions)

- (NSString *)jsonStringValueWithIndentLevel:(int)level
{
	/*
	NSMutableString *jsonString = [[NSMutableString alloc] init];
    [jsonString appendString:jsonArrayStartString];
	
	NSEnumerator *enumerator = [self objectEnumerator];
	id value = [enumerator nextObject];
	NSString *valueString = nil;
	if (value != nil)
	{
		valueString = [self jsonStringForValue:value withIndentLevel:level];
		if (level != jsonDoNotIndent)
			[jsonString appendString:[self jsonIndentStringForLevel:level]];
		
		[jsonString appendString:valueString];
	}

	while (value = [enumerator nextObject]) {
		valueString = [self jsonStringForValue:value withIndentLevel:level]; // TODO bail if valueString is nil? How to bail successfully from here?
        [jsonString appendString:jsonValueSeparatorString];
        if (level != jsonDoNotIndent) { // indent before each key
            [jsonString appendFormat:@"%@", [self jsonIndentStringForLevel:level]];
        }
		[jsonString appendString:valueString];
	}
	
	//[jsonString appendString:@"\n"];
	[jsonString appendString:jsonArrayEndString];
	
	return [jsonString autorelease];
	 */
	return [self jsonStringForArray:self withIndentLevel:level];
}

- (NSString *)jsonStringForValue:(id)value withIndentLevel:(int)level
{	
	NSString *jsonString;
	if ([value respondsToSelector:@selector(characterAtIndex:)]) // String
		jsonString = [self jsonStringForString:(NSString *)value];
	else if ([value respondsToSelector:@selector(keyEnumerator)]) // Dictionary
		jsonString = [(NSDictionary *)value jsonStringValueWithIndentLevel:(level + 1)];
	else if ([value respondsToSelector:@selector(objectAtIndex:)]) // Array
		jsonString = [self jsonStringForArray:(NSArray *)value withIndentLevel:level];
	else if (value == [NSNull null]) // null
		jsonString = jsonNullString;
	else if ([value respondsToSelector:@selector(objCType)]) { // NSNumber - representing true, false, and any form of numeric
		NSNumber *number = (NSNumber *)value;
		if (((*[number objCType]) == 'c') && ([number boolValue] == YES)) // true
			jsonString = jsonTrueString;
		else if (((*[number objCType]) == 'c') && ([number boolValue] == NO)) // false
			jsonString = jsonFalseString;
		else // attempt to handle as a decimal number - int, fractional, exponential
			// TODO: values converted from exponential json to dict and back to json do not format as exponential again
			jsonString = [[NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]] stringValue];
	} else {
		// TODO: error condition - it's not any of the types that I know about.
		return nil;
	}
	
	return jsonString;
}

- (NSString *)jsonStringForArray:(NSArray *)array withIndentLevel:(int)level
{
	NSMutableString *jsonString = [[NSMutableString alloc] init];
	[jsonString appendString:jsonArrayStartString];
	
	if ([array count] > 0) {
		[jsonString appendString:[self jsonStringForValue:[array objectAtIndex:0] withIndentLevel:level]];
	}
	
	int i;
	for (i = 1; i < [array count]; i++) {
		[jsonString appendFormat:@"%@ %@", jsonValueSeparatorString, [self jsonStringForValue:[array objectAtIndex:i] withIndentLevel:level]];
	}
	
	[jsonString appendString:jsonArrayEndString];
	return [jsonString autorelease];
}

- (NSString *)jsonStringForString:(NSString *)string
{
	NSMutableString *jsonString = [[NSMutableString alloc] init];
	[jsonString appendString:jsonStringDelimiterString];
	
	// Build the result one character at a time, inserting escaped characters as necessary
	int i;
	unichar nextChar;
	for (i = 0; i < [string length]; i++) {
		nextChar = [string characterAtIndex:i];
		switch (nextChar) {
			case '\"':
				[jsonString appendString:@"\\\""];
				break;
			case '\\':
				[jsonString appendString:@"\\n"];
				break;
			 case '\/':
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

- (NSString *)jsonIndentStringForLevel:(int)level
{
    NSMutableString *indentString = [[NSMutableString alloc] init];
    if (level != jsonDoNotIndent) {
        [indentString appendString:@"\n"];
        int i;
        for (i = 0; i < level; i++) {
            [indentString appendString:jsonIndentString];
        }
    }
    
    return [indentString autorelease];
}

@end
