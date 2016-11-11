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
@property (strong, nonatomic) NSArray *largeImageNames;
/**
 *  Specify image names for thumbnail images here.
 */
@property (strong, nonatomic) NSArray *thumbnailImageNames;

/**
 *  Specify image urls for large images here.
 */
@property (strong, nonatomic) NSArray *largeImageUrls;
/**
 *  Specify image urls for thumbnail images here.
 */
@property (strong, nonatomic) NSArray *thumbnailImageUrls;

@property (assign, nonatomic) NSUInteger selectedIndex;

#pragma mark - Customization
/**
 *  Height of thumbnails container view, pass zero if thumbnails not needed.
 */
@property (assign, nonatomic) CGFloat thumbnailHeight;
/**
 *  Background of thumbnails container view.
 */
@property (strong, nonatomic) UIColor *thumbnailBackground;

@end
