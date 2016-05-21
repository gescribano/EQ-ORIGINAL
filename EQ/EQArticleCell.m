//
//  EQArticleCell.m
//  EQ
//
//  Created by Sebastian Borda on 5/18/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQArticleCell.h"

@implementation EQArticleCell


- (void)prepareForReuse
{
    self.articleImage.image = [UIImage imageNamed:@"catalogoFotoProductoInexistente.png"];
}

@end
