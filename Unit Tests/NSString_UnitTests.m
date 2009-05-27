//
//  NSString_UnitTests.m
//  BSJSONAdditions
//

#import "NSString_UnitTests.h"
#import "NSString+BSJSONAdditions.h"

@implementation NSString_UnitTests

- (void)testStringEncoding
{
  NSString *string = @"test string with \"double\" and 'single' quotes, \n"
                      "newlines, /slashes/, \\backslashes\\ \t\t\t and other stuff.";
  NSString *encoded = [string jsonStringValue];
  NSString *expected = @"\"test string with \\\"double\\\" and 'single' quotes, \\n"
                        "newlines, \\/slashes\\/, \\\\backslashes\\\\ \\t\\t\\t and other stuff.\"";
  STAssertNotNil(encoded, @"Encoding result was nil.");
  STAssertEqualObjects(expected, encoded, @"String was incorrectly encoded");
}

- (void)testIndentString
{
  NSString *indentString = [NSString jsonIndentStringForLevel: 6];
  STAssertEqualObjects(@"\n\t\t\t\t\t\t", indentString, @"Indent string was incorrect");
}

@end
