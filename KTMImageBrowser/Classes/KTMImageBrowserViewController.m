//
//  KTMImageBrowserViewController.m
//  PhotoZoomExample
//
//  Created by Kishore Thejasvi on 30/10/2016.
//  Copyright © 2016 Kishore Thejasvi. All rights reserved.
//

#import "KTMImageBrowserViewController.h"
#import "KTMPageViewController.h"
#import "KTMZoomImageViewController.h"
#import "KTMThumbnailCollectionViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface KTMImageBrowserViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailContainerTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailContainerLeading;

@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailCollectionView;

@property (weak, nonatomic) KTMPageViewController *pageVC;

@property (assign, nonatomic) BOOL loadViews;

@property (assign, nonatomic) BOOL hasThumbNailImages;
@property (assign, nonatomic) BOOL shouldLoadThumbNailsFromUrls;
@property (assign, nonatomic) BOOL shouldLoadLargeImagesFromUrls;

@end

@implementation KTMImageBrowserViewController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        
    }
    
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loadViews = YES;
    
    [self.thumbnailCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)dealloc
{
    [self.thumbnailCollectionView removeObserver:self forKeyPath:@"contentSize" context:NULL];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.loadViews)
    {
        self.loadViews = NO;
        
        [self initializeFlags];
        [self renderView];
        
        /**
         *  Show thumbnail images only if data is available for them,
         *  this is done by setting height of thumb nails container to 0.
         */
        self.thumbnailContainerHeight.constant = self.hasThumbNailImages?100:0;
        [self.view layoutIfNeeded];
    }
}

- (void)initializeFlags
{
    /**
     *  Thumbnail related flags.
     */
    if (self.thumbnailImageUrls && [self.thumbnailImageUrls count] > 0)
    {
        self.hasThumbNailImages = YES;
        self.shouldLoadThumbNailsFromUrls = YES;
    }
    else if (self.thumbnailImageNames && [self.thumbnailImageNames count] > 0)
    {
        self.hasThumbNailImages = YES;
        self.shouldLoadThumbNailsFromUrls = NO;
    }
    else
        self.hasThumbNailImages = NO;
    
    /**
     *  Large image related flags.
     */
    if (self.largeImageUrls && [self.largeImageUrls count] > 0)
    {
        self.shouldLoadLargeImagesFromUrls = YES;
    }
    else if (self.largeImageNames && [self.largeImageNames count] > 0)
    {
        self.shouldLoadLargeImagesFromUrls = NO;
    }
    else
    {
        NSAssert(NO, @"largeImageNames or largeImageUrls should have a valid value.");
    }
}

- (void)renderView
{
    [self initializePageVC];
    
    if (self.hasThumbNailImages)
        [self initializeCollectionView];
}

- (void)initializePageVC
{
    [self setViewControllersOfPageVcForIndex:0 withAnimation:NO andDirection:UIPageViewControllerNavigationDirectionForward];
    self.pageVC.dataSource = self;
    self.pageVC.delegate = self;
}

- (void)setViewControllersOfPageVcForIndex: (NSUInteger)index withAnimation: (BOOL)animation andDirection: (UIPageViewControllerNavigationDirection)direction
{
    KTMZoomImageViewController *vc = (KTMZoomImageViewController *)[self imageContainerViewControllerForIndex:index];
    NSArray *viewControllers = @[vc];
    [self.pageVC setViewControllers:viewControllers direction:direction animated:animation completion:nil];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    KTMZoomImageViewController *vc = (KTMZoomImageViewController *)viewController;
    
    KTMZoomImageViewController *newVC = nil;
    if (vc.pageIndex)
        newVC = (KTMZoomImageViewController *)[self imageContainerViewControllerForIndex:vc.pageIndex - 1];
    
    return newVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    KTMZoomImageViewController *vc = (KTMZoomImageViewController *)viewController;
    
    KTMZoomImageViewController *newVC = nil;
    if (vc.pageIndex < [self largeImagePageCount] - 1)
        newVC = (KTMZoomImageViewController *)[self imageContainerViewControllerForIndex:vc.pageIndex + 1];
    
    return newVC;
}

- (NSUInteger)largeImagePageCount
{
    if (self.shouldLoadLargeImagesFromUrls)
        return [self.largeImageUrls count];
    
    return [self.largeImageNames count];
}

#pragma mark - UIPageViewControllerDelegate
- (void)initializeCollectionView
{
    NSBundle *podBundle = [NSBundle bundleForClass:[KTMImageBrowserViewController class]];
    NSURL *bundleUrl = [podBundle URLForResource:@"KTMImageBrowser" withExtension:@"bundle"];
    
    if (bundleUrl)
    {
        NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
        if (bundle)
        {
            UINib *cellNib = [UINib nibWithNibName:@"KTMThumbnailCollectionViewCell" bundle:bundle];
            
            [self.thumbnailCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"thumbnailIdentifier"];
            self.thumbnailCollectionView.dataSource = self;
            self.thumbnailCollectionView.delegate = self;
        }
        else
        {
            NSAssert(NO, @"KTMImageBrowser bundle missing, could not load KTMThumbnailCollectionViewCell.xib");
        }
        
    }
    else
    {
        NSAssert(NO, @"KTMImageBrowser bundle missing, could not load KTMThumbnailCollectionViewCell.xib");
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        KTMZoomImageViewController *vc = (KTMZoomImageViewController *)[pageViewController.viewControllers objectAtIndex:0];
        self.selectedIndex = vc.pageIndex;
        [self.thumbnailCollectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.shouldLoadThumbNailsFromUrls)
        return [self.thumbnailImageUrls count];
    
    return [self.thumbnailImageNames count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KTMThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"thumbnailIdentifier" forIndexPath:indexPath];
    cell.isSelected = self.selectedIndex == indexPath.row;
    
    if (self.shouldLoadThumbNailsFromUrls)
    {
        NSString *urlString = [self.thumbnailImageUrls objectAtIndex:indexPath.row];
        NSURL *imageUrl = [NSURL URLWithString:urlString];
        
        if (imageUrl)
            [cell.imageView setImageWithURL:imageUrl];
    }
    else
        cell.imageView.image = [UIImage imageNamed:[self.thumbnailImageNames objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex != indexPath.row)
    {
        UIPageViewControllerNavigationDirection direction = indexPath.row > self.selectedIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
        self.selectedIndex = indexPath.row;
        [self.thumbnailCollectionView reloadData];
        [self setViewControllersOfPageVcForIndex:self.selectedIndex withAnimation:YES andDirection:direction];
    }
}

#pragma mark - Reusability
- (UIViewController *)imageContainerViewControllerForIndex: (NSUInteger)index
{
    KTMZoomImageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"KTMZoomImageViewController"];
    vc.pageIndex = index;
    
    if (self.shouldLoadThumbNailsFromUrls)
    {
        NSURL *imageUrlString = [self.largeImageUrls objectAtIndex:index];
        vc.imageUrl = [[NSURL alloc] initWithString:imageUrlString];
    }
    else
        vc.imageName = [self.largeImageNames objectAtIndex:index];
    
    CGRect frame = vc.view.frame;
    frame.size.width = self.pageVC.view.frame.size.width;
    frame.size.height = self.pageVC.view.frame.size.height;
    vc.view.frame = frame;
    
    [vc.view setNeedsLayout];
    [vc.view layoutIfNeeded];
    
    return vc;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"KTMPageViewControllerEmbeddedSegue"])
        self.pageVC = segue.destinationViewController;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
    // You will get here when the reloadData finished
    [self updateConstraintsOfCollectionView];
}

- (void)updateConstraintsOfCollectionView
{
    CGFloat diff = self.view.bounds.size.width - self.thumbnailCollectionView.contentSize.width;
    diff = MAX(0, diff);
    
    self.thumbnailContainerLeading.constant = diff/2;
    self.thumbnailContainerTrailing.constant = diff/2;
}

#pragma mark - Memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
