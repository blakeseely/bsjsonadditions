//
//  NSArray_UnitTests.m
//  BSJSONAdditions
//
//  Created by Blake Seely (Air) on 3/24/09.
//  Copyright 2009 Apple Inc.. All rights reserved.
//

#import "NSArray_UnitTests.h"
#import "NSArray+BSJSONAdditions.h"

@implementation NSArray_UnitTests

- (void)testSimpleArray
{
	NSArray *jsonArray = [NSArray arrayWithJSONString:@"[\"hello\", \"world\", \"hello\"]"];
	NSArray *controlArray = [NSArray arrayWithObjects:@"hello", @"world", @"hello", nil];
	STAssertNotNil(jsonArray, @"Failed to create a simple array from a json string");
	STAssertEqualObjects(controlArray, jsonArray, @"Array created from the json string was not equal to the control array");
}

- (void)testNestedArray
{
	NSArray *jsonArray = [NSArray arrayWithJSONString:@"[\"hello\", [\"world\", \"hello\"]]"];
	NSArray *controlArray = [NSArray arrayWithObjects:@"hello", [NSArray arrayWithObjects:@"world", @"hello", nil], nil];
	STAssertNotNil(jsonArray, @"Failed to create a simple array from a json string");
	STAssertEqualObjects(controlArray, jsonArray, @"Array created from the json string was not equal to the control array");
}

- (void)testPaddedSimpleArray
{
	NSArray *jsonArray = [NSArray arrayWithJSONString:@"   \n\n\n       [\"hello\", \"world\", \"hello\"]        "];
	NSArray *controlArray = [NSArray arrayWithObjects:@"hello", @"world", @"hello", nil];
	STAssertNotNil(jsonArray, @"Failed to create a simple array from a json string");
	STAssertEqualObjects(controlArray, jsonArray, @"Array created from the json string was not equal to the control array");
}

- (void)testArrayEncoding
{
  NSArray *array = [NSArray arrayWithObjects: [NSNumber numberWithInt: 5],
                                              [NSNumber numberWithBool: YES],
                                              @"a short string",
                                              [NSArray arrayWithObjects: @"foo", @"bar", nil],
                                              @"xxx",
                                              nil];
  NSString *encoded = [array jsonStringValue];
  NSString *expected = @"[5, true, \"a short string\", [\"foo\", \"bar\"], \"xxx\"]";
  STAssertNotNil(encoded, @"Array could not be encoded");
  STAssertEqualObjects(expected, encoded, @"Array was encoded incorrectly");
}

@end
