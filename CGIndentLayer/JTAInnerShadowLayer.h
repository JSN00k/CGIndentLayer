//
//  JTAIndentLayer.h
//  IndentLayer
//
//  Created by James Snook on 24/05/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CALayerDelegate <NSObject>

/* This is called if drawOriginalImage is NO, and the delegate implements it.
   It allows you to draw where the alpha values of the original image were. */
@optional
- (void)drawToshadowedRegionInContext:(CGContextRef)ctx;

@end

@interface JTAInnerShadowLayer : CALayer

@property (weak) id<CALayerDelegate> delegate;
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
