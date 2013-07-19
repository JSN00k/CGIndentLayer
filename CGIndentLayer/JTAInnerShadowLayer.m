//
//  JTAIndentLayer.m
//  IndentLayer
//
//  Created by James Snook on 24/05/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import "JTAInnerShadowLayer.h"

@implementation JTAInnerShadowLayer

@synthesize insideShadowColor;
@synthesize outsideShadowColor;
@synthesize outsideShadowSize;
@synthesize outsideShadowRadius;
@synthesize insideShadowSize;
@synthesize insideShadowRadius;
@synthesize useColorDodge;
@synthesize drawOriginalImage;
@synthesize clipForAnyAlpha;

/*###TODO:Swivel the setContents pointer so that I can indent set images as the
          contents and these will be indented. We need to keep the original 
          setContents method so that we can use this at the end of the display
          method. */

+ (BOOL)needsDisplayForKey:(NSString *)key
{
  if ([key isEqualToString:@"transform"])
    return YES;
  
  return [super needsDisplayForKey:key];
}

void dataRelease (void *info, const void *data, size_t size)
{
  free ((void *)data);
}

- (void)display
{
  /* We want to turn whatever is in the drawRect code into an indent. */
  CGRect bounds = [self bounds];
  CGFloat width = ceilf (bounds.size.width);
  CGFloat height = ceilf (bounds.size.height);
  if (!width || !height)
    return;
  
  uint8_t *dataBytes = malloc (width * height * sizeof(uint32_t));
  CGFloat bytesPerDrawingRow = width * 4;
  CGFloat bytesPerDrawingComponent = 4;
  CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB ();
  CGContextRef bitmapCtx = CGBitmapContextCreate (dataBytes,
                                                  width,
                                                  height,
                                                  8,
                                                  bytesPerDrawingRow,
                                                  rgbSpace,
                                                  kCGImageAlphaPremultipliedLast);
  
  id delegate = [self delegate];
  CGImageRef mask;
  
  CGContextSaveGState (bitmapCtx);
  if (delegate && [delegate respondsToSelector:@selector (displayLayer:)]) {
    [delegate displayLayer:self];
    id content = [self contents];
    if ([content isKindOfClass:[UIImage class]])
      mask = (CGImageRef)CFRetain ((__bridge CGImageRef)[self contents]);
    else {
      /* CGLayers save things in a backing form that isn't documented normally. */
      CFRelease (rgbSpace);
      CFRelease (bitmapCtx);
      free (dataBytes);
      [super display];
      return;
    }
  } else {
    if (delegate && [delegate respondsToSelector:@selector (drawLayer:inContext:)])
      [delegate drawLayer:self inContext:bitmapCtx];
    else
      [self drawInContext:bitmapCtx];
    
    mask = CGBitmapContextCreateImage (bitmapCtx);
  }
  CGContextRestoreGState (bitmapCtx);
  
  union dataUnion {
    uint32_t intVal;
    uint8_t byteVals[4];
  };
  
  union dataUnion baseData;
  baseData.byteVals[0] = 0.0;
  baseData.byteVals[1] = 0.0;
  baseData.byteVals[2] = 0.0;
  unsigned inverseSize = width * height * sizeof (uint32_t);
  uint32_t *shadowImageData = malloc(inverseSize);
  
  /* Create the inverse mask. This does a lot of operations, possibly could be
     done with OpenGL shader, or using the Accellerate framewok. */
  for (int row = 0; row < height; ++row) {
    for (int column = 0; column < width; ++column) {
      if (clipForAnyAlpha) {
      if (dataBytes[(int)(row * bytesPerDrawingRow + column * bytesPerDrawingComponent) + 3] > 1)
        baseData.byteVals[3] = 0;
      else
        baseData.byteVals[3] = 255;
      
      } else {
        baseData.byteVals[3] = 255 - dataBytes[(int)(row * bytesPerDrawingRow + column * bytesPerDrawingComponent) + 3];
      }
      shadowImageData[(int)(row * width + column)] = baseData.intVal;
    }
  }
  
  CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL,
                                                                shadowImageData,
                                                                inverseSize,
                                                                dataRelease);
  CGImageRef image = CGImageCreate (width,
                                    height,
                                    8,
                                    32,
                                    4 * width,
                                    rgbSpace,
                                    kCGImageAlphaPremultipliedLast,
                                    dataProvider,
                                    NULL,
                                    NO,
                                    kCGRenderingIntentDefault);
  CFRelease (dataProvider);
  CGContextClearRect (bitmapCtx, bounds);
  /* Create a bitmap of all the space that isn't drawn. This will make a mask 
     that can be used to draw only into the area previously drawn, and also will
     be the the correct values for drawing the shadow. */
  
  CGContextConcatCTM (bitmapCtx, CGAffineTransformMake (1.0, 0.0,
                                                        0.0, -1.0, 0.0, height));
  
  CGContextSaveGState(bitmapCtx);
  if (!drawOriginalImage)
    CGContextClipToMask (bitmapCtx, bounds, image);
  
  CGColorRef outsideShadow;
  
  if (!outsideShadowColor) {
    CGFloat whiteCol[] = { 1.0, 1.0, 1.0, 0.4 };
    outsideShadow = CGColorCreate (rgbSpace, whiteCol);
  } else
    outsideShadow = (CGColorRef)CFRetain ([outsideShadowColor CGColor]);
  
  
  CGSize shadowSize = CGSizeMake (0.0, -1.0);
  CGFloat radius = 2.0;
  
  if (outsideShadowSize) {
    [outsideShadowSize getValue:&shadowSize];
    shadowSize = CGSizeMake (shadowSize.width, -shadowSize.height);
  }
  
  if (outsideShadowRadius)
    radius = [outsideShadowRadius floatValue];
  
  CGContextSetShadowWithColor (bitmapCtx, shadowSize, radius, outsideShadow);
  CGContextDrawImage (bitmapCtx, bounds, mask);
  CGContextRestoreGState (bitmapCtx);
  
  CGContextSaveGState(bitmapCtx);
  CGContextClipToMask (bitmapCtx, bounds, mask);
  shadowSize = CGSizeMake (0.0, -2.0);
  radius = 2.0;
  
  if (insideShadowSize) {
    [insideShadowSize getValue:&shadowSize];
    shadowSize = CGSizeMake (shadowSize.width, -shadowSize.height);
  }
  
  if (insideShadowRadius)
    radius = [insideShadowRadius floatValue];
  
  
  CGColorRef shadowColor;
  if (insideShadowColor)
    shadowColor = (CGColorRef)CFRetain ([insideShadowColor CGColor]);
  else {
    CGFloat defaultVals[] = { 0.0, 0.0, 0.0, 0.75 };
    shadowColor = CGColorCreate (rgbSpace, defaultVals);
  }
  
  CGContextSetShadowWithColor (bitmapCtx, shadowSize, radius, shadowColor);
  CGContextDrawImage (bitmapCtx, bounds, image);
  CGContextRestoreGState(bitmapCtx);
  CFRelease (shadowColor);

  CFRelease (mask);
  CFRelease (outsideShadow);
  CFRelease (image);

  CGImageRef result = CGBitmapContextCreateImage (bitmapCtx);
  CFRelease (bitmapCtx);
  
  [self setContents:(__bridge id)(result)];
  CFRelease (result);
  free (dataBytes);
}

- (void)setInsideShadowSize:(CGSize)size
                     radius:(CGFloat)radius
{
  insideShadowSize = [NSValue valueWithCGSize:size];
  insideShadowRadius = [NSNumber numberWithFloat:radius];
}

- (void)setOutsideShadowSize:(CGSize)size
                      radius:(CGFloat)radius
{
  outsideShadowSize = [NSValue valueWithCGSize:size];
  outsideShadowRadius = [NSNumber numberWithFloat:radius];
}

@end
