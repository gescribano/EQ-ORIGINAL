//
//  EQImagesManager.h
//  EQ
//
//  Created by Sebastian Borda on 4/27/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_DOWNLOAD_PROGRESS @"DOWNLOAD_PROGRESS_IMAGES"
#define CATALOG_DOWNLOAD_PROGRESS @"DOWNLOAD_PROGRESS_CATALOG"

extern NSString * const CACHE_DIRECTORY_FORMAT;

@interface EQImagesManager : UIImageView

+ (EQImagesManager *)sharedInstance;
- (void)loadCache;
- (BOOL)saveImage:(UIImage *)image named:(NSString *)name;
- (BOOL)existImageNamed:(NSString *)name;
- (UIImage *)imageNamed:(NSString *)name;

@end
