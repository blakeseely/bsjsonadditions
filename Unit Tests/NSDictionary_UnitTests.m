//
//  NSDictionary_UnitTests.m
//  BSJSONAdditions
//

#import "NSDictionary_UnitTests.h"
#import "NSDictionary+BSJSONAdditions.h"

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

  NSString *encoded = [dict jsonStringValue];
  NSString *expected = @"{\n \"hobbies\" : [\"football\", \"tv\"],\n \"age\" : 31,\n \"name\" : \"John Smith\","
                        "\n \"employed\" : true,"
                        "\n \"languages\" : {\n\t \"English\" : \"perfect\",\n\t \"German\" : \"good\"}}";

  STAssertNotNil(encoded, @"Encoding result was nil.");
  STAssertEqualObjects(expected, encoded, @"Dictionary was incorrectly encoded");
}

@end
