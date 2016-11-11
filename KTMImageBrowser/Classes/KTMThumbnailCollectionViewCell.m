//
//  KTMThumbnailCollectionViewCell.m
//  PhotoZoomExample
//
//  Created by Kishore Thejasvi on 30/10/2016.
//  Copyright © 2016 Kishore Thejasvi. All rights reserved.
//

#import "KTMThumbnailCollectionViewCell.h"

@implementation KTMThumbnailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 3.0f;
    self.layer.borderWidth = 1.0f;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.alpha = isSelected ? 1 : 0.4;
    
    self.layer.borderColor = isSelected ? [UIColor colorWithRed:139/255.0 green:195/255.0 blue:74/255.0 alpha:1.0].CGColor : [UIColor clearColor].CGColor;
}

@end
