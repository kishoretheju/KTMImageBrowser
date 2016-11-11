//
//  KTMZoomImageViewController.m
//  PhotoZoomExample
//
//  Created by Kishore Thejasvi on 29/10/2016.
//  Copyright © 2016 Kishore Thejasvi. All rights reserved.
//

#import "KTMZoomImageViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface KTMZoomImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTrailingConstraint;

@property (assign, nonatomic) BOOL initializeViews;

@end

@implementation KTMZoomImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.initializeViews = YES;
}

- (void)viewDidLayoutSubviews
{
    [self updateMinZoomScaleForSize:self.view.bounds.size];
    
    if (self.initializeViews)
    {
        self.initializeViews = NO;
        self.scrollView.delegate = self;
        
        if (self.pageIndex%2 == 0)
            self.view.backgroundColor = [UIColor blueColor];
        else
            self.view.backgroundColor = [UIColor grayColor];
        
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.imageView.backgroundColor = [UIColor magentaColor];
        
        if (self.imageName)
        {
            self.imageView.image = [UIImage imageNamed:self.imageName];
        }
        else if (self.imageUrl)
        {
            [self loadImageWithUrl:self.imageUrl];
        }
    }
}

- (void)loadImageWithUrl: (NSURL *)url
{
    __block __typeof__(self) _self = self;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"placeholder"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       _self.imageView.image = image;
                                       [_self.imageView setNeedsLayout];
                                       [_self.imageView layoutIfNeeded];
                                       
                                       [_self updateConstraintsForSize:_self.view.bounds.size];
                                       
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       
                                   }];
}

#pragma mark - Logic
- (void)updateMinZoomScaleForSize: (CGSize)size
{
    CGFloat widthScale = size.width/self.imageView.bounds.size.width;
    CGFloat heightScale = size.height/self.imageView.bounds.size.height;
    
    CGFloat minScale = MIN(widthScale, heightScale);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
}

- (void)updateConstraintsForSize: (CGSize)size
{
    CGFloat yOffset = MAX((size.height - self.imageView.frame.size.height)/2, 0);
    self.imageViewTopConstraint.constant = yOffset;
    self.imageViewBottomConstraint.constant = yOffset;
    
    CGFloat xOffset = MAX((size.width - self.imageView.frame.size.width)/2, 0);
    self.imageViewLeadingConstraint.constant = xOffset;
    self.imageViewTrailingConstraint.constant = xOffset;
    
    [self.view layoutIfNeeded];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self updateConstraintsForSize:self.view.bounds.size];
}

#pragma mark - Memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.imageView.image = nil;
    self.view = nil;
}

//- (void)dealloc
//{
//    NSLog(@"Dealloc called KTMZoomImageViewController.");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
