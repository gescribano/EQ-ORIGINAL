//
//  Unit_Test.m
//  Unit Test
//
//  Created by Sebastian Borda on 4/14/14.
//  Copyright (c) 2014 Sebastian Borda. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Unit_Test : XCTestCase

@end

@implementation Unit_Test

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
