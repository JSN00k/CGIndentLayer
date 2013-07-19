//
//  JTAIndentLayer.h
//  IndentLayer
//
//  Created by James Snook on 24/05/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface JTAInnerShadowLayer : CALayer

@property (strong, nonatomic) UIColor *insideShadowColor;
@property (strong, nonatomic) UIColor *outsideShadowColor;
@property (strong, nonatomic) NSValue *outsideShadowSize;
@property (strong, nonatomic) NSNumber *outsideShadowRadius;
@property (strong, nonatomic) NSValue *insideShadowSize;
@property (strong, nonatomic) NSNumber *insideShadowRadius;
@property BOOL useColorDodge;
@property BOOL drawOriginalImage;
@property BOOL clipForAnyAlpha;

- (void)setInsideShadowSize:(CGSize)size
                     radius:(CGFloat)radius;
- (void)setOutsideShadowSize:(CGSize)size
                      radius:(CGFloat)radius;

@end
