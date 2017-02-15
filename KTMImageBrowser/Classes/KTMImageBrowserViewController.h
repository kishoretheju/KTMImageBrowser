//
//  KTMImageBrowserViewController.h
//  PhotoZoomExample
//
//  Created by Kishore Thejasvi on 30/10/2016.
//  Copyright © 2016 Kishore Thejasvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMImageBrowserViewController : UIViewController

#pragma mark - Data
/**
 *  Specify image names for large images here.
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *largeImageNames;

/**
 *  Specify image names for thumbnail images here.
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *thumbnailImageNames;

/**
 *  Specify image urls for large images here.
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *largeImageUrls;

/**
 *  Specify image urls for thumbnail images here.
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *thumbnailImageUrls;

/**
 *  Image to be selected.
 */
@property (assign, nonatomic) NSUInteger selectedIndex;

#pragma mark - Customization
/**
 *  To show/hide thumbnails view.
 */
@property (assign, nonatomic) BOOL needThumbnails;

/**
 *  Background of thumbnails container view.
 */
@property (nullable, strong, nonatomic) UIColor *thumbnailBackground;

/**
 *  If YES border will be given to thumbnail cell, this will be YES by default.
 */
@property (assign, nonatomic) BOOL needThumbnailBorder;

/**
 *  Border color for selected thumbnail.
 */
@property (nullable, strong, nonatomic) UIColor *selectedThumbnailBorderColor;

/**
 *  Border color of normal(all unselected) thumnail.
 */
@property (nullable, strong, nonatomic) UIColor *normalThumbnailBorderColor;

/**
 *  Use this utility function to create an instance of KTMImageBrowserViewController *.
 *  @return Instance of KTMImageBrowserViewController *.
 */
+ (nullable instancetype)browserView;

@end
