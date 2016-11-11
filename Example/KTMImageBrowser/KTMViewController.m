//
//  KTMViewController.m
//  KTMImageBrowser
//
//  Created by Kishore Thejasvi on 11/11/2016.
//  Copyright (c) 2016 Kishore Thejasvi. All rights reserved.
//

#import "KTMViewController.h"
#import "KTMImageBrowserViewController.h"

@interface KTMViewController ()

@end

@implementation KTMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showImageBrowser:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ImageBrowser" bundle:[NSBundle bundleForClass:[KTMImageBrowserViewController class]]];
    KTMImageBrowserViewController *vc = [sb instantiateViewControllerWithIdentifier:@"KTMImageBrowserViewController"];
    
    vc.largeImageUrls = @[@"https://cdn.pixabay.com/photo/2013/02/05/18/29/robin-78092_960_720.jpg",
                          @"https://cdn.pixabay.com/photo/2016/05/17/14/47/redbreast-1398230_960_720.jpg",
                          @"https://cdn.pixabay.com/photo/2016/05/17/14/48/bird-1398239_960_720.jpg"];
    vc.thumbnailImageUrls = @[@"https://cdn.pixabay.com/photo/2013/02/05/18/29/robin-78092__180.jpg",
                              @"https://cdn.pixabay.com/photo/2016/05/17/14/47/redbreast-1398230__180.jpg",
                              @"https://cdn.pixabay.com/photo/2016/05/17/14/48/bird-1398239__180.jpg"];
    
    
    
//    vc.largeImageNames = @[@"image_first", @"image_second", @"image_third", @"image_fourth"];
//    vc.thumbnailImageNames = @[@"image_first", @"image_second", @"image_third", @"image_fourth"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
