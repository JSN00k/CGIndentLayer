//
//  JTALabel.m
//  IndentLayer
//
//  Created by James Snook on 26/05/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import "JTAIndentLabel.h"
#import "JTAInnerShadowLayer.h"

@implementation JTAIndentLabel

static void commonInit (JTAIndentLabel *self)
{
  [self setBackgroundColor:[UIColor clearColor]];
  JTAInnerShadowLayer *innerShadow = (JTAInnerShadowLayer *)[self layer];
  [innerShadow setClipForAnyAlpha:YES];
  [innerShadow setInsideShadowColor:[UIColor colorWithWhite:0.0 alpha:0.9]];
  [innerShadow setOutsideShadowSize:CGSizeMake(0.0, 1.0) radius:1.0];
  [innerShadow setInsideShadowSize:CGSizeMake (0.0, 4.0) radius:7.0];
  /* Uncomment this to make the label also draw the text (won't work well
     with black text!*/
  //[innerShadow drawOriginalImage];
}

+ (Class)layerClass
{
  return [JTAInnerShadowLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
    commonInit (self);
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
    commonInit (self);
  
  return self;
}

@end
