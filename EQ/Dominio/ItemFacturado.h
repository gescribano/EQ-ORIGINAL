//
//  ItemFacturado.h
//  EQ
//
//  Created by Sebastian Borda on 9/10/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ItemFacturado : NSManagedObject

@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSDate * facturado;

@end
