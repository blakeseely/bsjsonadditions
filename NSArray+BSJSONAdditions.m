//
//  NSArray+BSJSONAdditions.m
//  BSJSONAdditions
//
//  Created by Blake Seely (Air) on 3/24/09.
//  Copyright 2009 Apple Inc.. All rights reserved.
//

#import "NSArray+BSJSONAdditions.h"
#import "NSScanner+BSJSONAdditions.h"
#import "NSString+BSJSONAdditions.h"

@interface NSArray (PrivateBSJSONAdditions)
- (NSString *)jsonStringForValue:(id)value withIndentLevel:(NSInteger)level;
@end

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

- (NSString *)jsonStringValueWithIndentLevel:(NSInteger)level
{
	NSMutableString *jsonString = [[NSMutableString alloc] init];
	[jsonString appendString:jsonArrayStartString];
	
	if ([self count] > 0) {
		[jsonString appendString:[self jsonStringForValue:[self objectAtIndex:0] withIndentLevel:level]];
	}
	
	NSInteger i;
	for (i = 1; i < [self count]; i++) {
		[jsonString appendFormat:@"%@ %@", jsonValueSeparatorString, [self jsonStringForValue:[self objectAtIndex:i] withIndentLevel:level]];
	}
	
	[jsonString appendString:jsonArrayEndString];
	return [jsonString autorelease];
}

@end

@implementation NSArray (PrivateBSJSONAdditions)

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
