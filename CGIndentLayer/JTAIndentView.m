//
//  JTAIndentView.m
//  IndentLayer
//
//  Created by James Snook on 24/05/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import "JTAIndentView.h"
#import "JTAInnerShadowLayer.h"

@implementation JTAIndentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Class)layerClass
{
  return [JTAInnerShadowLayer class];
}


- (void)drawRect:(CGRect)rect
{
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextMoveToPoint (ctx, 0.0, 0.0);
  CGContextAddLineToPoint (ctx, 500, 500);
  CGContextSetLineWidth (ctx, 20);
  CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB ();
  CGContextSetStrokeColorSpace (ctx, rgbSpace);
  CFRelease (rgbSpace);
  
  CGFloat color[] = { 0.0, 0.0, 0.0, 1.0 };
  CGContextSetStrokeColor (ctx, color);
  CGContextStrokePath (ctx);
}

@end
