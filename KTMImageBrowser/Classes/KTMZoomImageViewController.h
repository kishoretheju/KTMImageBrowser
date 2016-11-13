//
//  KTMZoomImageViewController.h
//  PhotoZoomExample
//
//  Created by Kishore Thejasvi on 29/10/2016.
//  Copyright © 2016 Kishore Thejasvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMZoomImageViewController : UIViewController

@property (assign, nonatomic) NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/**
 *  Local image name.
 */
@property (strong, nonatomic) NSString *largeImageName;

/**
 *  URL of image.
 */
@property (strong, nonatomic) NSURL *largeImageUrl;

@end
