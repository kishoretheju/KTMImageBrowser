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

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSURL *imageUrl;

@end
