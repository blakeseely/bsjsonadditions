//
//  NSDictionary_UnitTests.m
//  BSJSONAdditions
//

@interface NSDictionary_UnitTests : SenTestCase
{
}
@end

@implementation NSDictionary_UnitTests

- (void)testDictionaryEncoding
{
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSNumber numberWithInt: 31], @"age",
						  @"John Smith", @"name",
						  [NSNumber numberWithBool: YES], @"employed",
						  [NSArray arrayWithObjects: @"football", @"tv", nil], @"hobbies",
						  [NSDictionary dictionaryWithObjectsAndKeys: @"perfect", @"English", @"good", @"German", nil], @"languages",
						  nil];
	
	// Encode dictionary as JSON representation
	NSString *encoded = [dict jsonStringValue];
	STAssertNotNil(encoded, @"Encoding result was nil.");
	
	// Decode JSON representation as a dictionary.
	NSDictionary *decodedDict = [NSDictionary dictionaryWithJSONString:encoded];
	STAssertNotNil( decodedDict, @"Decoding result was nil" );
	
	// Test JSON encoding validity by comparing the decoded dictionary with the original.  If the JSON dictionary encoding is bad, the decoded dictionary derived from it will not be equal to the original.
	STAssertEqualObjects(decodedDict, dict, @"Dictionary was incorrectly encoded");
}

@end
