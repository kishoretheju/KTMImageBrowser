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
        
        if (self.largeImageName)
        {
            self.imageView.image = [UIImage imageNamed:self.largeImageName];
            self.scrollView.delegate = self;
        }
        else if (self.largeImageUrl)
        {
            [self loadImageWithUrl:self.largeImageUrl];
        }
        
        [self addTapToZoomGestures];
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
                                       
                                       self.scrollView.delegate = self;
                                       
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
    self.scrollView.maximumZoomScale = 5.0;
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

#pragma mark - Tap to Zoom
- (void)addTapToZoomGestures
{
    UITapGestureRecognizer *dblRecognizer;
    dblRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handleDoubleTapFrom:)];
    [dblRecognizer setNumberOfTapsRequired:2];
    [self.scrollView addGestureRecognizer:dblRecognizer];
    
    UITapGestureRecognizer *recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(handleTapFrom:)];
    [recognizer requireGestureRecognizerToFail:dblRecognizer];
    
    [self.scrollView addGestureRecognizer:recognizer];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    zoomRect.size.height = [_imageView frame].size.height / scale;
    zoomRect.size.width  = [_imageView frame].size.width  / scale;
    
    center = [_imageView convertPoint:center fromView:self];
    
    zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));
    
    return zoomRect;
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)recognizer
{
    float newScale = self.scrollView.zoomScale * 4.0;
    
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    else
    {
        CGRect zoomRect = [self zoomRectForScale:newScale
                                      withCenter:[recognizer locationInView:recognizer.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark - Memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.imageView.image = nil;
    self.view = nil;
}

@end
