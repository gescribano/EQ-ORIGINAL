//
//  EQImageView.m
//  EQ
//
//  Created by Sebastian Borda on 4/27/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQImageView.h"
#import "AFNetworking.h"
#import "EQImagesManager.h"
#import "EQDataManager.h"

@interface EQImageView()

@end

@implementation EQImageView

- (void)loadURL:(NSString *)imagePath{
    if (imagePath) {
        NSString *fileName = [imagePath lastPathComponent];
        [[EQDataManager sharedInstance] downloadImageWithPath:imagePath
                                                     withName:fileName
                                                      isImage:YES
                                                      success:^(UIImage *image)
        {
            [self setImage:image];
        }
                                                      failure:^(NSError *error)
        {
            [self setImage:[UIImage imageNamed:@"catalogoFotoProductoInexistente.png"]];
        }];
    }
}

@end
