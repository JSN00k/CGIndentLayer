//
//  JTAIndentImageView.h
//  IndentLayer
//
//  Created by James Snook on 22/06/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTAIndentImageView : UIView

- (id)initWithImage:(UIImage *)i;
- (id)initWithImage:(UIImage *)i andScale:(CGAffineTransform)scalingTrans;

- (void)beginDisplaying;
- (void)endDisplaying;

@end
