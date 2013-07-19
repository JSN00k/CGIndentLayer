//
//  JTAViewController.m
//  IndentLayer
//
//  Created by James Snook on 24/05/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import "JTAViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JTAInnerShadowLayer.h"
#import <CoreImage/CoreImage.h>
#import "JTAIndentImageView.h"

@implementation JTAViewController
{
  CGSize scrollViewSize;
  UIView *imageView;
}

@synthesize labelsView;

- (void)loadView
{
  scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen]
                                                    applicationFrame]];
  [scrollView setDelegate:self];
  [self setView:scrollView];
  [self viewDidLoad];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[NSBundle mainBundle] loadNibNamed:@"JTALabelsView" owner:self options:nil];
  [scrollView setPagingEnabled:YES];
  [scrollView setShowsHorizontalScrollIndicator:NO];
  scrollViewSize = [scrollView bounds].size;
  [scrollView setContentSize:CGSizeMake (7 * scrollViewSize.width,
                                         scrollViewSize.height)];
  [scrollView setContentOffset:CGPointMake (3 * scrollViewSize.width, 0)];
  [labelsView setFrame:CGRectMake (3 * scrollViewSize.width, 0,
                                   scrollViewSize.width, scrollViewSize.height)];
  [scrollView addSubview:labelsView];
  
  UIImage *wunelli = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                      pathForResource:@"TwistedApeLogo"
                                                      ofType:@"png"]];
  UIImage *metal = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                    pathForResource:@"metal"
                                                    ofType:@"png"]];
  imageView = [[UIImageView alloc] initWithImage:metal];
  JTAIndentImageView *wunelliView = [[JTAIndentImageView alloc] initWithImage:wunelli
                                                                    andScale:CGAffineTransformMakeScale (1.0, 1.0)];
  [wunelliView setCenter:CGPointMake(376, 512)];
  [imageView addSubview:wunelliView];
  [imageView setFrame:CGRectMake (scrollViewSize.width, 0.0,
                                  scrollViewSize.width, scrollViewSize.height)];
  [scrollView addSubview:imageView];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewFramesForOffset:(CGFloat)offset
{
  unsigned viewNumber = floor (offset / scrollViewSize.width);
  if (viewNumber & 1) {
    [labelsView setFrame:CGRectMake (viewNumber * scrollViewSize.width, 0.0,
                                     scrollViewSize.width, scrollViewSize.height)];
    [imageView setFrame:CGRectMake ((viewNumber + 1) * scrollViewSize.width, 0.0,
                                    scrollViewSize.width, scrollViewSize.height)];
  } else {
    [imageView setFrame:CGRectMake (viewNumber * scrollViewSize.width, 0.0,
                                    scrollViewSize.width, scrollViewSize.height)];
    [labelsView setFrame:CGRectMake ((viewNumber + 1) * scrollViewSize.width, 0.0,
                                     scrollViewSize.width, scrollViewSize.height)];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)sv
{
  [self setViewFramesForOffset:[sv contentOffset].x];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)sv
{
  [[[imageView subviews] objectAtIndex:0] endDisplaying];
  /* If the starting position isn't within the cetral three then move it to the 
     central 3 before the scolling starts. */
  CGFloat offsetWidth = [sv contentOffset].x;
  unsigned viewNumber = floor ([sv contentOffset].x / scrollViewSize.width);
  CGFloat newOffset;
  if (viewNumber < 2) {
    newOffset = 4 * scrollViewSize.width + offsetWidth;
    [sv setContentOffset:CGPointMake (newOffset,
                                      0.0) animated:NO];
    [self setViewFramesForOffset:newOffset];
    return;
  } else if (viewNumber > 4) {
    newOffset = offsetWidth - 4 * scrollViewSize.width;
    [sv setContentOffset:CGPointMake(newOffset, 0.0) animated:NO];
    [self setViewFramesForOffset:newOffset];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv
{
  if (!((int)(round ([sv contentOffset].x / scrollViewSize.width)) & 1))
    [[[imageView subviews] objectAtIndex:0] beginDisplaying];
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
  return NO;
}

@end
