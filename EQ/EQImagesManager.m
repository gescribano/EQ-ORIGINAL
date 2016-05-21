//
//  EQImagesManager.m
//  EQ
//
//  Created by Sebastian Borda on 4/27/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQImagesManager.h"

@interface EQImagesManager()

@property (nonatomic,strong) NSMutableDictionary *cacheDictionary;

@end

NSString * const CACHE_DIRECTORY_FORMAT = @"%@/Caches/Pictures/%@";

@implementation EQImagesManager

+ (EQImagesManager *)sharedInstance
{
    static EQImagesManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EQImagesManager alloc] init];
        [sharedInstance loadCache];
    });
    return sharedInstance;
}

- (NSString *)documentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (void)loadCache{
    [APP_DELEGATE showLoadingView];
    self.cacheDictionary = [NSMutableDictionary dictionary];
    
    // make a directory for these
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDir;
    
    NSString *picturesPath = [NSString stringWithFormat:CACHE_DIRECTORY_FORMAT, [self documentDirectory],@""];
    
    if (![mgr fileExistsAtPath:picturesPath isDirectory:&isDir]) {
        NSError *error = nil;
        [mgr createDirectoryAtPath:picturesPath withIntermediateDirectories:YES attributes:nil error:&error];
    } else {
        // load pictures
        NSDirectoryEnumerator *dir = [mgr enumeratorAtPath: picturesPath];
        NSString *picture;
        while ((picture = [dir nextObject])) {
            NSString *fileName = [[picture componentsSeparatedByString:@"/"] lastObject];
            if ([fileName isEqualToString:@".DS_Store"]) //workaround, en el simulador, agrega este archivo y hace crashear la app.
            {
                continue;
            }
            if ([[fileName componentsSeparatedByString:@"."] count] == 1) {
                NSString *directory = [fileName copy];
                NSString *directoryPath = [picturesPath stringByAppendingFormat:@"%@/",directory];
                // load pictures
                NSDirectoryEnumerator *subDir = [mgr enumeratorAtPath:directoryPath];
                NSString *newPicture;
                while ((newPicture = [subDir nextObject])) {
                    
//                    UIImage *img = [UIImage imageWithContentsOfFile:[directoryPath stringByAppendingString:newPicture]];
                    
                    
                    fileName = [directory stringByAppendingFormat:@"/%@",newPicture];
                    [self.cacheDictionary setObject:[directoryPath stringByAppendingString:newPicture] forKey:fileName]; //Saving local image URL instead of the image itself.
                }
            } else {
//                UIImage *img = [UIImage imageWithContentsOfFile:[picturesPath stringByAppendingString:picture]];
                
                [self.cacheDictionary setObject:[picturesPath stringByAppendingString:picture] forKey:fileName];
            }
            
        }
    }
    
    [APP_DELEGATE hideLoadingView];
}

- (BOOL)saveImage:(UIImage *)image named:(NSString *)name{
    if (![self existImageNamed:name]) {
        // Save Image
        NSString *filePath = [NSString stringWithFormat:CACHE_DIRECTORY_FORMAT, [self documentDirectory], name];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 10);
        NSArray *nameParts = [name componentsSeparatedByString:@"/"];
        if ([nameParts count] > 1) {
            NSMutableArray *parts = [NSMutableArray arrayWithArray:nameParts];
            [parts removeLastObject];
            NSString *directory = [NSString stringWithFormat:CACHE_DIRECTORY_FORMAT, [self documentDirectory], [parts componentsJoinedByString:@"/"]];
            // make a directory for these
            NSFileManager *mgr = [NSFileManager defaultManager];
            BOOL isDir;
            if (![mgr fileExistsAtPath:directory isDirectory:&isDir]) {
                NSError *error = nil;
                [mgr createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
            }
        }
        
        NSError *error = nil;
        if ([imageData writeToFile:filePath options:NSDataWritingAtomic error:&error])
        { // Save image path to cache, not the image
            [self.cacheDictionary setObject:filePath forKey:name];
            return YES;
        }
    }
    
    return  NO;
}

- (BOOL)existImageNamed:(NSString *)name{
    return [self.cacheDictionary objectForKey:name] != nil;
}

- (UIImage *)imageNamed:(NSString *)name{
    NSString* url = [self.cacheDictionary objectForKey:name];
    UIImage *img = [UIImage imageWithContentsOfFile:url];
    return img;
}

@end
