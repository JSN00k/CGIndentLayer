//
//  JTAEmbossLabel.m
//  IndentLayer
//
//  Created by James Snook on 26/05/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import "JTAEmbossLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "JTAInnerShadowLayer.h"

@implementation JTAEmbossLabel

static void commonInit (JTAEmbossLabel *self)
{
  JTAInnerShadowLayer *layer = (JTAInnerShadowLayer *)[self layer];
  [self setFont:[UIFont fontWithName:@"Cochin-Italic" size:120]];
  [layer setClipForAnyAlpha:YES];
  [layer setInsideShadowColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
  [layer setOutsideShadowColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
  [layer setOutsideShadowSize:CGSizeMake (0.0, 3.0) radius:1.0];
  [layer setInsideShadowSize:CGSizeMake (0.0, 2.2) radius:1.5];
  
  [layer setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    commonInit (self);
  }

  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
    commonInit(self);
  
  return self;
}

+ (Class)layerClass
{
  return [JTAInnerShadowLayer class];
}

@end
