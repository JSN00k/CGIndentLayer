//
//  JTAViewController.h
//  IndentLayer
//
//  Created by James Snook on 24/05/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTAIndentLabel;
@class JTAEmbossLabel;

@interface JTAViewController : UIViewController <UIScrollViewDelegate>
{
  UIScrollView *scrollView;
}

@property IBOutlet UIView *labelsView;


@end
