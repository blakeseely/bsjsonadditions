//
//  BSJSONScanner_UnitTests.m
//
//  History:
//
//	2006 Mar 24 garrison@standardorbit.net
//
//	Adapted from Jonathan Wight's CJSONScanner_UnitTests by Bill Garrison.

@interface NSScannerAdditionTests : SenTestCase
{
	BOOL scanOK;
	id parsed;
	id expected;
}
@end

@implementation NSScannerAdditionTests

#pragma mark -
#pragma mark Tests

- (void)testTrue
{
	STAssertNil( parsed, @"precondition violated" );
	
	scanOK= [[NSScanner scannerWithString:@"true"] scanJSONValue:&parsed];
	
	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertTrue( [parsed boolValue], @"postcondition violated");
}

- (void)testFalse
{
	STAssertNil( parsed, @"precondition violated" );
	
	scanOK= [[NSScanner scannerWithString:@"false"] scanJSONValue:&parsed];
	
	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertFalse( [parsed boolValue], @"postcondition violated");
}

- (void)testNull
{
	STAssertNil( parsed, @"precondition violated" );
	expected = [NSNull null];
	
	scanOK= [[NSScanner scannerWithString:@"null"] scanJSONValue:&parsed];
	
	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects(parsed, expected, @"postcondition violated");
}

#pragma mark -

- (void) testInvalidNumber;
{	
	STAssertNil( parsed, @"precondition violated" );
	
	BOOL isDecimal = [[NSScanner scannerWithString:@"abc"] scanJSONNumber:&parsed];
	
	STAssertFalse( isDecimal, @"postcondition violated" );
	STAssertNil( parsed, @"postcondition violated" );
}

- (void) testDecimalNumber;
{
	STAssertNil( parsed, @"precondition violated" );
	
	BOOL isDecimal = [[NSScanner scannerWithString:@"3.1415"] scanJSONNumber:&parsed];
	
	STAssertTrue( isDecimal, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualsWithAccuracy( [parsed doubleValue], 3.1415, 0.00001, @"postcondition violated" );
}

- (void) testInteger;
{
	STAssertNil( parsed, @"precondition violated" );
	
	BOOL isDecimal = [[NSScanner scannerWithString:@"42"] scanJSONNumber:&parsed];
	
	STAssertTrue( isDecimal, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEquals([parsed integerValue], 42, @"postcondition violated");
}

- (void) testExponential;
{
	STAssertNil( parsed, @"precondition violated" );
	
	BOOL isDecimal = [[NSScanner scannerWithString:@"3.14e2"] scanJSONNumber:&parsed];
	
	STAssertTrue( isDecimal, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEquals([parsed doubleValue], 3.14e2, @"postcondition violated");
}

- (void) testExponentialWithPositiveSign
{
	STAssertNil( parsed, @"precondition violated" );
	
	BOOL isDecimal = [[NSScanner scannerWithString:@"3.14E+2"] scanJSONNumber:&parsed];
	
	STAssertTrue( isDecimal, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEquals([parsed doubleValue], 3.14e2, @"postcondition violated");
}

- (void) testExponentialWithNegativeSign
{
	STAssertNil( parsed, @"precondition violated" );
	
	BOOL isDecimal = [[NSScanner scannerWithString:@"3.14E-2"] scanJSONNumber:&parsed];
	
	STAssertTrue( isDecimal, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEquals([parsed doubleValue], 3.14e-2, @"postcondition violated");
}

#pragma mark -

- (void)testString
{
	STAssertNil( parsed, @"precondition violated" );
	expected = @"Hello world.";
	
	scanOK = [[NSScanner scannerWithString:@"\"Hello world.\""] scanJSONString:&parsed];
	
	STAssertTrue( scanOK, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated");
}

- (void)testStringWithPadding
{
	STAssertNil( parsed, @"precondition violated" );
	expected = @"Hello world.";
	
	scanOK = [[NSScanner scannerWithString:@"    \"Hello world.\"      "] scanJSONString:&parsed];
	
	STAssertTrue( scanOK, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated");
}

- (void)testStringEscaping
{
	STAssertNil( parsed, @"precondition violated" );
	expected = @"\r\n\f\b\\";
	
	scanOK = [[NSScanner scannerWithString:@"\"\\r\\n\\f\\b\\\\\""] scanJSONString:&parsed];
	
	STAssertTrue( scanOK, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated");
}

- (void)testStringEscaping2
{
	STAssertNil( parsed, @"precondition violated" );
	expected = @"Hello\r\rworld.";
	
	scanOK = [[NSScanner scannerWithString:@"\"Hello\r\rworld.\""] scanJSONString:&parsed];
	
	STAssertTrue( scanOK, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated");
}

- (void)testStringUnicodeEscaping
{
	STAssertNil( parsed, @"precondition violated" );
	expected = @"xxxx";
	
	scanOK = [[NSScanner scannerWithString:@"\"x\\u0078xx\""] scanJSONString:&parsed];

	STAssertTrue( scanOK, @"postcondition violated" );
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated");
}


- (void)testStringUnicodeEscapingWhacked
{
	STAssertNil( parsed, @"precondition violated" );
	expected = nil;
	
	scanOK = [[NSScanner scannerWithString:@"\"x\\u00QQxx\""] scanJSONString:&parsed];

	// Expect invalid escaped JSON unicode to not parse.
	
	STAssertFalse( scanOK, @"postcondition violated" );
	STAssertNil( parsed, @"postcondition violated" );
}


#pragma mark -

- (void)testSimpleDictionary
{
	STAssertNil( parsed, @"precondition violated" );
	expected = [NSDictionary dictionaryWithObject:@"foo" forKey:@"bar"];

	scanOK= [[NSScanner scannerWithString:@"{\"bar\":\"foo\"}"] scanJSONObject:&parsed];
	
	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated" );
}

- (void)testNestedDictionary
{
	STAssertNil( parsed, @"precondition violated" );
	
	// The expected dictionary has nested dictionary value under the key @"USD"
	NSDictionary *nested = [NSDictionary dictionaryWithObject:@"US Dollar" forKey:@"currency"];
	expected =  [NSDictionary dictionaryWithObject:nested forKey:@"USD"];
	
	scanOK= [[NSScanner scannerWithString:@"{\"USD\":{\"currency\":\"US Dollar\"}}"] scanJSONObject:&parsed];
	
	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated" );
}

#pragma mark -

- (void)testSimpleArray
{
	STAssertNil( parsed, @"precondition violated" );
	expected = [NSArray arrayWithObjects:@"bar", @"foo", nil];

	scanOK= [[NSScanner scannerWithString:@"[\"bar\",\"foo\"]"] scanJSONArray:&parsed];
	
	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated" );
}

- (void)testNestedArray
{
	STAssertNil( parsed, @"precondition violated" );

	// The expected array contains a nested array as well as a regular string.
	NSArray *nested = [NSArray arrayWithObjects:@"Glen", @"Glenda", nil];
	expected = [NSArray arrayWithObjects:@"Ed Wood", nested, nil];
	
	scanOK= [[NSScanner scannerWithString:@"[\"Ed Wood\", [\"Glen\", \"Glenda\"]]"] scanJSONArray:&parsed];
	
	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated" );
}

#pragma mark -

- (void)scanWhitespace1
{
	STAssertNil( parsed, @"precondition violated" );
	expected = @"Hello world.";
	
	scanOK= [[NSScanner scannerWithString:@"    \"Hello world.\"      "] scanJSONString:&parsed];
	
	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated" );
}

- (void)scanWhitespace2
{
	STAssertNil( parsed, @"precondition violated" );
	expected = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], nil];
	
	scanOK= [[NSScanner scannerWithString:@"[ true, false ]"] scanJSONObject:&parsed];

	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated" );
}

- (void)scanWhitespace3
{
	STAssertNil( parsed, @"precondition violated" );
	NSArray *nested = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:2], nil];
	expected = [NSDictionary dictionaryWithObject:nested forKey:@"x"];
	
	scanOK= [[NSScanner scannerWithString:@"{ \"x\" : [ 1 , 2 ] }"] scanJSONObject:&parsed];

	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated" );
}

#pragma mark -

- (void)scanComments1
{
	STAssertNil( parsed, @"precondition violated" );
	expected = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:2], nil];
	
	scanOK= [[NSScanner scannerWithString:@"/* blah */ [ 1, /* blah */ 2 ] /* blah */"] scanJSONObject:&parsed];

	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated" );
}

- (void)scanComments2
{
	STAssertNil( parsed, @"precondition violated" );
	expected = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:2], nil];

	scanOK= [[NSScanner scannerWithString:@"[ 1, // blah, blah, blah \r 2 ]"] scanJSONObject:&parsed];

	STAssertTrue(scanOK, @"Scan return failure.");
	STAssertNotNil( parsed, @"postcondition violated" );
	STAssertEqualObjects( parsed, expected, @"postcondition violated" );
}

@end
