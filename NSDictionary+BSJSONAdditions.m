//
//  BSJSONAdditions
//
//  Created by Blake Seely on 2/1/06.
//  Copyright 2006 Blake Seely - http://www.blakeseely.com  All rights reserved.
//  Permission to use this code:
//
//  Feel free to use this code in your software, either as-is or 
//  in a modified form. Either way, please include a credit in 
//  your software's "About" box or similar, mentioning at least 
//  my name (Blake Seely).
//
//  Permission to redistribute this code:
//
//  You can redistribute this code, as long as you keep these 
//  comments. You can also redistribute modified versions of the 
//  code, as long as you add comments to say that you've made 
//  modifications (keeping these original comments too).
//
//  If you do use or redistribute this code, an email would be 
//  appreciated, just to let me know that people are finding my 
//  code useful. You can reach me at blakeseely@mac.com

#import "NSDictionary+BSJSONAdditions.h"
#import "NSScanner+BSJSONAdditions.h"

@implementation NSDictionary (BSJSONAdditions)

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString
{
	NSScanner *scanner = [[NSScanner alloc] initWithString:jsonString];
	NSDictionary *dictionary = nil;
	[scanner scanJSONObject:&dictionary];
	[scanner release];
	return dictionary;
}

- (NSString *)jsonStringValue
{
	NSMutableString *jsonString = [[NSMutableString alloc] init];
	[jsonString appendString:@" "];
	[jsonString appendString:jsonObjectStartString];
	
	NSEnumerator *keyEnum = [self keyEnumerator];
	NSString *keyString = [keyEnum nextObject];
	NSString *valueString;
	if (keyString != nil) {
		valueString = [self jsonStringForValue:[self objectForKey:keyString]];
		[jsonString appendFormat:@" %@ %@ %@", [self jsonStringForString:keyString], jsonKeyValueSeparatorString, valueString];
	}
	
	while (keyString = [keyEnum nextObject]) {
		valueString = [self jsonStringForValue:[self objectForKey:keyString]]; // TODO bail if valueString is nil? How to bail successfully from here?
		[jsonString appendFormat:@"%@ %@ %@ %@", jsonValueSeparatorString, [self jsonStringForString:keyString], jsonKeyValueSeparatorString, valueString];
	}
	
	[jsonString appendString:@"\n"];
	[jsonString appendString:jsonObjectEndString];
	
	return [jsonString autorelease];
}

@end

@implementation NSDictionary (PrivateBSJSONAdditions)

- (NSString *)jsonStringForValue:(id)value
{	
	NSString *jsonString;
	if ([value respondsToSelector:@selector(characterAtIndex:)]) // String
		jsonString = [self jsonStringForString:(NSString *)value];
	else if ([value respondsToSelector:@selector(keyEnumerator)]) // Dictionary
		jsonString = [(NSDictionary *)value jsonStringValue];
	else if ([value respondsToSelector:@selector(objectAtIndex:)]) // Array
		jsonString = [self jsonStringForArray:(NSArray *)value];
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

- (NSString *)jsonStringForArray:(NSArray *)array
{
	NSMutableString *jsonString = [[NSMutableString alloc] init];
	[jsonString appendString:jsonArrayStartString];
	
	if ([array count] > 0) {
		[jsonString appendString:[self jsonStringForValue:[array objectAtIndex:0]]];
	}
	
	int i;
	for (i = 1; i < [array count]; i++) {
		[jsonString appendFormat:@"%@ %@", jsonValueSeparatorString, [self jsonStringForValue:[array objectAtIndex:i]]];
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
		/* TODO: email out to json group on this - spec says to handlt his, examples and example code don't handle this.
		case '\/':
			[jsonString appendString:@"\\/"];
			break;
		*/ 
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
