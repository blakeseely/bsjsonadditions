//
//  BSJSONScanner_UnitTests.m
//
//  History:
//
//	2006 Mar 24 garrison@standardorbit.net
//
//	Adapted from Jonathan Wight's CJSONScanner_UnitTests by Bill Garrison.

#import "BSJSONScanner_UnitTests.h"

#import "NSScanner+BSJSONAdditions.h"

inline id TXPropertyList(NSString *inString)
{
	NSData *theData = [inString dataUsingEncoding:NSUTF8StringEncoding];
	
	NSPropertyListFormat theFormat;
	NSString *theError = NULL;
	
	id thePropertyList = [NSPropertyListSerialization propertyListFromData:theData 
														  mutabilityOption:NSPropertyListImmutable 
																	format:&theFormat 
														  errorDescription:&theError];
	return(thePropertyList);
}

inline BOOL ScanObject(NSString *inString, id *outResult)
{
	NSScanner *theScanner = [NSScanner scannerWithString:inString];
	BOOL theResult = [theScanner scanJSONObject:outResult];
	return(theResult);
}

inline BOOL ScanString(NSString *inString, id *outResult)
{
	NSScanner *theScanner = [NSScanner scannerWithString:inString];
	BOOL theResult = [theScanner scanJSONString:outResult];
	return(theResult);	
}

inline BOOL ScanValue(NSString *inString, id *outResult)
{
	NSScanner *theScanner = [NSScanner scannerWithString:inString];
	BOOL theResult = [theScanner scanJSONValue:outResult];
	return(theResult);	
}

inline BOOL ScanArray(NSString *inString, id *outResult)
{
	NSScanner *theScanner = [NSScanner scannerWithString:inString];
	BOOL theResult = [theScanner scanJSONArray:outResult];
	return(theResult);	
}

@implementation BSJSONScanner_UnitTests

- (void) tearDown 
{
	[theScanner release]; theScanner = nil;
}


- (void)testTrue
{
	id theObject = nil;
	BOOL theResult = ScanValue(@"true", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject boolValue], @"Result of scan didn't match expectations.");
}

- (void)testFalse
{
	id theObject = nil;
	BOOL theResult = ScanValue(@"false", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertFalse([theObject boolValue], @"Result of scan didn't match expectations.");
}

- (void)testNull
{
	id theObject = nil;
	BOOL theResult = ScanValue(@"null", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertEqualObjects(theObject, [NSNull null], @"Result of scan didn't match expectations.");
}

- (void)testNumber
{
	id theObject = nil;
	BOOL theResult = ScanValue(@"3.14", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertEqualsWithAccuracy([theObject doubleValue], 3.14, 0.01, @"Result of scan didn't match expectations.");
}

- (void)testEngineeringNumber
{
	id theObject = nil;
	BOOL theResult = ScanValue(@"3.14e4", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertEquals([theObject doubleValue], 3.14e4, @"Result of scan didn't match expectations.");
}

#pragma mark -

- (void)testString
{
	id theObject = nil;
	BOOL theResult = ScanString(@"\"Hello world.\"", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:@"Hello world."], @"Result of scan didn't match expectations.");
}

- (void)testStringWithPadding
{
	id theObject = nil;
	BOOL theResult = ScanString(@"    \"Hello world.\"      ", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:@"Hello world."], @"Result of scan didn't match expectations.");
}

- (void)testStringEscaping
{
	id theObject = nil;
	BOOL theResult = ScanString(@"\"\\r\\n\\f\\b\\\\\"", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:@"\r\n\f\b\\"], @"Result of scan didn't match expectations.");
}

- (void)testStringEscaping2
{
	id theObject = nil;
	BOOL theResult = ScanString(@"\"Hello\r\rworld.\"", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:@"Hello\r\rworld."], @"Result of scan didn't match expectations.");
}

- (void)testStringUnicodeEscaping
{
	id theObject = nil;
	BOOL theResult = ScanString(@"\"x\\u0078xx\"", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertEqualObjects(theObject, @"xxxx", @"Expected %@ but got %@", @"xxxx", theObject);
}


- (void)testStringUnicodeEscapingWhacked
{
	id theObject = nil;
	BOOL theResult = ScanString(@"\"x\\u00QQxx\"", &theObject);
	STAssertFalse(theResult, @"Scan return failure.");
	STAssertEqualObjects(theObject, nil, @"Expected %@ but got %@", @"xxxx", theObject);
}


#pragma mark -

- (void)testSimpleDictionary
{
	id theObject = nil;
	BOOL theResult = ScanObject(@"{\"bar\":\"foo\"}", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:TXPropertyList(@"{bar = foo; }")], @"Result of scan didn't match expectations.");
}

- (void)testNestedDictionary
{
	id theObject = nil;
	BOOL theResult = ScanObject(@"{\"bar\":{\"bar\":\"foo\"}}", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:TXPropertyList(@"{bar = {bar = foo; }; }")], @"Result of scan didn't match expectations.");
}

#pragma mark -

- (void)testSimpleArray
{
	id theObject = nil;
	BOOL theResult = ScanArray(@"[\"bar\",\"foo\"]", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:TXPropertyList(@"(bar, foo)")], @"Result of scan didn't match expectations.");
}

- (void)testNestedArray
{
	id theObject = nil;
	BOOL theResult = ScanArray(@"[\"bar\",[\"bar\",\"foo\"]]", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:TXPropertyList(@"(bar, (bar, foo))")], @"Result of scan didn't match expectations.");
}

#pragma mark -

- (void)scanWhitespace1
{
	id theObject = nil;
	BOOL theResult = ScanString(@"    \"Hello world.\"      ", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:@"Hello world."], @"Result of scan didn't match expectations.");
}

- (void)scanWhitespace2
{
	id theObject = nil;
	BOOL theResult = ScanString(@"[ true, false ]", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:TXPropertyList(@"(1, 0)")], @"Result of scan didn't match expectations.");
}

- (void)scanWhitespace3
{
	id theObject = nil;
	BOOL theResult = ScanObject(@"{ \"x\" : [ 1 , 2 ] }", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:TXPropertyList(@"{x, (1, 2)}")], @"Result of scan didn't match expectations.");
}

#pragma mark -

- (void)scanComments1
{
	id theObject = nil;
	BOOL theResult = ScanArray(@"/* cmt */ [ 1, /* cmt */ 2 ] /* cmt */", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:@"(1, 2)"], @"Result of scan didn't match expectations.");
}

- (void)scanComments2
{
	id theObject = nil;
	BOOL theResult = ScanArray(@"[ 1, // cmt \r 2 ]", &theObject);
	STAssertTrue(theResult, @"Scan return failure.");
	STAssertTrue([theObject isEqual:@"(1, 2)"], @"Result of scan didn't match expectations.");
}

@end
