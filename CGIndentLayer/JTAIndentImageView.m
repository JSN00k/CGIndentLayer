//
//  JTAIndentImageView.m
//  IndentLayer
//
//  Created by James Snook on 22/06/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import "JTAIndentImageView.h"
#import "JTAInnerShadowLayer.h"
#import <CoreMotion/CoreMotion.h>

#define radiansPerSecond 1

@implementation JTAIndentImageView
{
  UIImage *image;
  CGAffineTransform scale;
  CGAffineTransform rotation;
  
  CADisplayLink *displayLink;
  CMMotionManager *motionManager;
  CGFloat previousAngle;
  
  CGSize insideShadSize;
  CGSize outsideShadowSize;
}

+ (Class)layerClass
{
  return [JTAInnerShadowLayer class];
}

- (id)initWithImage:(UIImage *)i
{
  return [self initWithImage:i andScale:CGAffineTransformIdentity];
}

- (id)initWithImage:(UIImage *)i andScale:(CGAffineTransform)scalingTrans
{
  if ((self = [super initWithFrame:
               CGRectApplyAffineTransform ((CGRect) {
    (CGPoint){ 0.0, 0.0 },
    [i size]
  },
                                           scalingTrans)])){
                 
    JTAInnerShadowLayer *innerShadow = (JTAInnerShadowLayer *)[self layer];
    insideShadSize = CGSizeMake (0.0, 4.0);
    outsideShadowSize = CGSizeMake (0.0, 1.0);
                 
    [innerShadow setOutsideShadowSize:outsideShadowSize radius:1.0];
    [innerShadow setInsideShadowSize:insideShadSize radius:6.0];
    [innerShadow setDrawOriginalImage:YES];
                 
    motionManager = [[CMMotionManager alloc] init];
    [motionManager setAccelerometerUpdateInterval:1.0 / 60.0];
    [motionManager startAccelerometerUpdates];
     
    image = i;
    scale = scalingTrans;
  }
  
  return self;
}

- (void)beginDisplaying
{
  displayLink = [CADisplayLink displayLinkWithTarget:self
                                            selector:@selector(rotateForGravity)];
  [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                    forMode:NSDefaultRunLoopMode];
  previousAngle = 0.0;
}

- (void)endDisplaying
{
  [displayLink invalidate];
  displayLink = nil;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext ();
  CGContextConcatCTM (ctx, CGAffineTransformMake (1.0, 0.0, 0.0, -1.0,
                                                  0.0, rect.size.height));
  CGContextDrawImage (ctx, rect, [image CGImage]);
}

- (void)rotateForGravity
{
  CMAccelerometerData *data = [motionManager accelerometerData];
  CMAcceleration acceleration = [data acceleration];
  CGFloat angle = -atan2f (acceleration.x, -acceleration.y);
  if ((fabs (acceleration.x) > 0.2 || fabs (acceleration.y) > 0.2)
      && fabs (previousAngle - angle) > 0.1) {
    previousAngle = angle;
    JTAInnerShadowLayer *innerShad = (JTAInnerShadowLayer *)[self layer];
    CGAffineTransform rotationTrans = CGAffineTransformMakeRotation (angle);
    CGSize rotated = CGSizeApplyAffineTransform (insideShadSize, rotationTrans);
    [innerShad setInsideShadowSize:[NSValue valueWithCGSize:rotated]];
    rotated = CGSizeApplyAffineTransform (outsideShadowSize, rotationTrans);
    [innerShad setOutsideShadowSize:[NSValue valueWithCGSize:rotated]];
    [innerShad setNeedsDisplay];
  }
  
  
}

@end
