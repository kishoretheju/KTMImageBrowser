//
//  KTMThumbnailCollectionViewCell.h
//  PhotoZoomExample
//
//  Created by Kishore Thejasvi on 30/10/2016.
//  Copyright © 2016 Kishore Thejasvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMThumbnailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) BOOL isSelected;

/**
 *  Border color for selected thumbnail.
 */
@property (nullable, strong, nonatomic) UIColor *selectedThumbnailBorderColor;

/**
 *  Border color of normal(all unselected) thumnail.
 */
@property (nullable, strong, nonatomic) UIColor *normalThumbnailBorderColor;

/**
 *  If YES border will be given to thumbnail cell, this will be YES by default.
 */
@property (assign, nonatomic) BOOL needBorder;

@end
