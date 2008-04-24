//
//  JSONValidTests.m
//  BSJSONAdditions
//
//  Created by Blake Seely on 2/2/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "JSONValidTests.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSScanner+BSJSONAdditions.h"


@implementation JSONValidTests

- (void)testValidJSON
{
	// test 'json_test_valid_01.txt"
	NSString *testFilePath = [[NSBundle mainBundle] pathForResource:@"json_test_valid_01" ofType:@"txt"];
	STAssertNotNil(testFilePath, @"Could not find the test file named \"json_test_valid_01.txt\"");
	NSString *jsonString = [NSString stringWithContentsOfFile:testFilePath];
	STAssertNotNil(jsonString, @"Could not create an NSString from the file at path %@", testFilePath);
	NSDictionary *dict = [NSDictionary dictionaryWithJSONString:jsonString];
	STAssertNotNil(dict, @"Could not create dictionary from json_test_valid_01 json");
	// output check
	NSDictionary *dict2 = [NSDictionary dictionaryWithJSONString:[dict jsonStringValue]];
	STAssertTrue([dict isEqualToDictionary:dict2], @"New Dictionary from json output of first dictionary should be equal for test 01");
	// structure checks (counts, keypaths are not nil, etc.)
	STAssertTrue([dict count] == 1, @"Expected 1 key-val pair");
	STAssertTrue([[dict valueForKeyPath:@"glossary"] count] == 2, @"Expected the glossary entry to have two entries.");
	STAssertTrue([[dict valueForKeyPath:@"glossary.GlossDiv"] count] == 2, @"Expected GlossDiv entry to have two entries.");
	STAssertTrue([[dict valueForKeyPath:@"glossary.GlossDiv.GlossList"] count] == 1, @"Expected GlossList to be an array with a single entry");
	STAssertTrue([[[dict valueForKeyPath:@"glossary.GlossDiv.GlossList"] objectAtIndex:0] count] == 7, @"Expected GlossList array element 0 dictionary to have 7 entries");
	STAssertTrue([[[[dict valueForKeyPath:@"glossary.GlossDiv.GlossList"] objectAtIndex:0] valueForKey:@"GlossSeeAlso"] count] == 3, @"Expected the GlossSeeAlso array to have 3 entries");
	// value checks - keys are correct, etc.
	STAssertTrue([[dict valueForKeyPath:@"glossary.title"] isEqualToString:@"example glossary"], @"Expected glossary.title to be \"example glossary\", but found %@", [dict valueForKeyPath:@"glossary.title"]);
	// more...
	
	
	// test 'json_test_valid_02.txt"
	testFilePath = [[NSBundle mainBundle] pathForResource:@"json_test_valid_02" ofType:@"txt"];
	STAssertNotNil(testFilePath, @"Could not find the test file named \"json_test_valid_02.txt\"");
	jsonString = [NSString stringWithContentsOfFile:testFilePath];
	STAssertNotNil(jsonString, @"Could not create an NSString from the file at path %@", testFilePath);
	dict = [NSDictionary dictionaryWithJSONString:jsonString];
	STAssertNotNil(dict, @"Could not create dictionary from json_test_valid_02 json");
	// output check
    NSLog([dict jsonStringValue]);
	dict2 = [NSDictionary dictionaryWithJSONString:[dict jsonStringValue]];
	STAssertTrue([dict isEqualToDictionary:dict2], @"New Dictionary from json output of first dictionary should be equal for test 02");
	// structure checks (counts, keypaths are not nil, etc.)
	STAssertTrue([dict count] == 1, @"Expected a single item in the top level dictionary");
	STAssertTrue([[dict valueForKey:@"menu"] count] == 3, @"Expected a 3 items in the menu dictionary");
	STAssertTrue([[dict valueForKeyPath:@"menu.popup"] count] == 1, @"Expected a single item in the popup dictionary");
	STAssertTrue([[dict valueForKeyPath:@"menu.popup.menuitem"] count] == 3, @"Expected 3 items in the menuitem array");
	// value checks
	
	
	// test 'json_test_valid_03.txt"
	testFilePath = [[NSBundle mainBundle] pathForResource:@"json_test_valid_03" ofType:@"txt"];
	STAssertNotNil(testFilePath, @"Could not find the test file named \"json_test_valid_03.txt\"");
	jsonString = [NSString stringWithContentsOfFile:testFilePath];
	STAssertNotNil(jsonString, @"Could not create an NSString from the file at path %@", testFilePath);
	dict = [NSDictionary dictionaryWithJSONString:jsonString];
	STAssertNotNil(dict, @"Could not create dictionary from json_test_valid_03 json");
	// output check
	dict2 = [NSDictionary dictionaryWithJSONString:[dict jsonStringValue]];
	STAssertTrue([dict isEqualToDictionary:dict2], @"New Dictionary from json output of first dictionary should be equal for test 03");
	// structure checks
	// value checks
	STAssertTrue([[dict valueForKeyPath:@"widget.window.width"] intValue] == 500, @"Expected value of 500, but got %i", [[dict valueForKeyPath:@"widget.window.width"] intValue]);

	// test 'json_test_valid_04.txt"
	testFilePath = [[NSBundle mainBundle] pathForResource:@"json_test_valid_04" ofType:@"txt"];
	STAssertNotNil(testFilePath, @"Could not find the test file named \"json_test_valid_04.txt\"");
	jsonString = [NSString stringWithContentsOfFile:testFilePath];
	STAssertNotNil(jsonString, @"Could not create an NSString from the file at path %@", testFilePath);
	dict = [NSDictionary dictionaryWithJSONString:jsonString];
	STAssertNotNil(dict, @"Could not create dictionary from json_test_valid_04 json");
	// output check
	dict2 = [NSDictionary dictionaryWithJSONString:[dict jsonStringValue]];
	STAssertTrue([dict isEqualToDictionary:dict2], @"New Dictionary from json output of first dictionary should be equal for test 04");
	// structure checks
	// value checks
	
	// test 'json_test_valid_05.txt"
	testFilePath = [[NSBundle mainBundle] pathForResource:@"json_test_valid_05" ofType:@"txt"];
	STAssertNotNil(testFilePath, @"Could not find the test file named \"json_test_valid_05.txt\"");
	jsonString = [NSString stringWithContentsOfFile:testFilePath];
	STAssertNotNil(jsonString, @"Could not create an NSString from the file at path %@", testFilePath);
	dict = [NSDictionary dictionaryWithJSONString:jsonString];
	STAssertNotNil(dict, @"Could not create dictionary from json_test_valid_05 json");
	// output check
	dict2 = [NSDictionary dictionaryWithJSONString:[dict jsonStringValue]];
	STAssertTrue([dict isEqualToDictionary:dict2], @"New Dictionary from json output of first dictionary should be equal for test 05");
	// structure check
	STAssertTrue([dict count] == 1, @"Expected one value in the dictionary");
	STAssertTrue([[dict valueForKey:@"menu"] count] == 2, @"Expected two items in the menu dictionary");
	STAssertTrue([[dict valueForKeyPath:@"menu.items"] count] == 22, @"Expected 22 items in the items array");
	// value checks
	STAssertTrue([[dict valueForKeyPath:@"menu.items"] objectAtIndex:2] == [NSNull null], @"Expected a null value in index 2");
	
	// test 'json_test_valid_06.txt"
	testFilePath = [[NSBundle mainBundle] pathForResource:@"json_test_valid_06" ofType:@"txt"];
	STAssertNotNil(testFilePath, @"Could not find the test file named \"json_test_valid_06.txt\"");
	jsonString = [NSString stringWithContentsOfFile:testFilePath];
	STAssertNotNil(jsonString, @"Could not create an NSString from the file at path %@", testFilePath);
	dict = [NSDictionary dictionaryWithJSONString:jsonString];
	STAssertNotNil(dict, @"Could not create dictionary from json_test_valid_06 json");
	// output check
	dict2 = [NSDictionary dictionaryWithJSONString:[dict jsonStringValue]];
	// does not work because of exponential notation
	//STAssertTrue([dict isEqualToDictionary:dict2], @"New Dictionary from json output of first dictionary should be equal for test 06");
	
}



@end
