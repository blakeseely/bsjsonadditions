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

#import "NSArray+BSJSONAdditions.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSScanner+BSJSONAdditions.h"
#import "NSString+BSJSONAdditions.h"

NSString *jsonIndentString = @"\t"; // Modify this string to change how the output formats.
const NSInteger jsonDoNotIndent = -1;

@interface NSDictionary (PrivateBSJSONAdditions)
- (NSString *)jsonStringForValue:(id)value withIndentLevel:(NSInteger)level;
@end

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
    return [self jsonStringValueWithIndentLevel:0];
}

- (NSString *)jsonStringValueWithIndentLevel:(NSInteger)level
{
	NSMutableString *jsonString = [[NSMutableString alloc] initWithString:jsonObjectStartString];
	
  BOOL first = YES;
	NSString *valueString;
  for (NSString *keyString in self) {
    valueString = [self jsonStringForValue:[self objectForKey:keyString] withIndentLevel:level];
    if (!first) {
      [jsonString appendString:jsonValueSeparatorString];
    }
    if (level != jsonDoNotIndent) { // indent before each key
      [jsonString appendString:[NSString jsonIndentStringForLevel:level]];
    }
    [jsonString appendFormat:@" %@ %@ %@", [keyString jsonStringValue], jsonKeyValueSeparatorString, valueString];
    first = NO;
  }
	
	[jsonString appendString:jsonObjectEndString];
	return [jsonString autorelease];
}

@end

@implementation NSDictionary (PrivateBSJSONAdditions)

- (NSString *)jsonStringForValue:(id)value withIndentLevel:(NSInteger)level
{	
	NSString *jsonString;
	if ([value respondsToSelector:@selector(characterAtIndex:)]) // String
		jsonString = [(NSString *)value jsonStringValue];
	else if ([value respondsToSelector:@selector(keyEnumerator)]) // Dictionary
		jsonString = [(NSDictionary *)value jsonStringValueWithIndentLevel:(level + 1)];
	else if ([value respondsToSelector:@selector(objectAtIndex:)]) // Array
		jsonString = [(NSArray *)value jsonStringValueWithIndentLevel:level];
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

@end
