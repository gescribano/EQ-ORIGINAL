//
//  EQNewOrderTestCase.m
//  EQ
//
//  Created by Sebastian Borda on 4/14/14.
//  Copyright (c) 2014 Sebastian Borda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EQNewOrderViewModel.h"

@interface EQNewOrderViewModel (TestMethod)
- (void)AddQuantity:(int)quantity canAdd:(BOOL)canAdd;
@end

@implementation EQNewOrderViewModel (TestMethod)

- (void)AddQuantity:(int)quantity canAdd:(BOOL)canAdd {

}

- (void)initilize {

}

@end

@implementation Articulo (TestMethod)

- (NSNumber *)minimoPedido{
    return @3;
}

- (NSNumber *)multiploPedido{
    return @3;
}

@end


@interface EQNewOrderTestCase : XCTestCase

@property (nonatomic,strong) Pedido *order;
@property (nonatomic,strong) Articulo *article;

@property (nonatomic,strong) EQNewOrderViewModel *model;

@end

@implementation EQNewOrderTestCase

- (void)setUp
{
    [super setUp];
    self.model = [EQNewOrderViewModel new];
    self.article = [Articulo new];
    self.model.articleSelected = self.article;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssertTrue(![self.model addItemQuantity:2], @"Success 2");
    XCTAssertTrue([self.model addItemQuantity:3], @"Success 3");
    XCTAssertTrue(![self.model addItemQuantity:4], @"Success 4");
    XCTAssertTrue(![self.model addItemQuantity:5], @"Success 5");
    XCTAssertTrue([self.model addItemQuantity:6], @"Success 6");
    XCTAssertTrue([self.model addItemQuantity:9], @"Success 9");
}

@end
