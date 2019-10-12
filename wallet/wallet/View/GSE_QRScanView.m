//
//  QRScanView.m
//  QRCodeDemo
//
//  Created by user on 12/30/15.
//  Copyright © 2015 VeslaChi. All rights reserved.
//

#import "GSE_QRScanView.h"

@interface GSE_QRScanView ()
@property (nonatomic, assign) CGRect scanRect;
@end

@implementation GSE_QRScanView

- (instancetype)initWithScanRect:(CGRect)rect {
	self = [super initWithFrame:[UIScreen mainScreen].bounds];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		_scanRect = rect;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();

	[[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];

	CGMutablePathRef screenPath = CGPathCreateMutable();
	CGPathAddRect(screenPath, NULL, self.bounds);

	//CGMutablePathRef scanPath = CGPathCreateMutable();
	//CGPathAddRect(scanPath, NULL, self.scanRect);
    
    // get our rounded rect as a path
    CGMutablePathRef scanPath = createRoundedCornerPath(self.scanRect, 15);
    //CGPathAddRect(scanPath, NULL, self.scanRect);

	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddPath(path, NULL, screenPath);
	CGPathAddPath(path, NULL, scanPath);

	CGContextAddPath(ctx, path);
    
	CGContextDrawPath(ctx, kCGPathEOFill);
    //CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 1 / [UIScreen mainScreen].scale);
    //CGContextStrokeRect(ctx, self.scanRect);
    
    
	CGPathRelease(screenPath);
	CGPathRelease(scanPath);
	CGPathRelease(path);
}

CGMutablePathRef createRoundedCornerPath(CGRect rect, CGFloat cornerRadius) {
    
    // create a mutable path
    CGMutablePathRef path = CGPathCreateMutable();
    
    // get the 4 corners of the rect
    CGPoint topLeft = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint topRight = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    CGPoint bottomRight = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPoint bottomLeft = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    
    // move to top left
    CGPathMoveToPoint(path, NULL, topLeft.x + cornerRadius, topLeft.y);
    
    // add top line
    CGPathAddLineToPoint(path, NULL, topRight.x - cornerRadius, topRight.y);
    
    // add top right curve
    CGPathAddQuadCurveToPoint(path, NULL, topRight.x, topRight.y, topRight.x, topRight.y + cornerRadius);
    
    // add right line
    CGPathAddLineToPoint(path, NULL, bottomRight.x, bottomRight.y - cornerRadius);
    
    // add bottom right curve
    CGPathAddQuadCurveToPoint(path, NULL, bottomRight.x, bottomRight.y, bottomRight.x - cornerRadius, bottomRight.y);
    
    // add bottom line
    CGPathAddLineToPoint(path, NULL, bottomLeft.x + cornerRadius, bottomLeft.y);
    
    // add bottom left curve
    CGPathAddQuadCurveToPoint(path, NULL, bottomLeft.x, bottomLeft.y, bottomLeft.x, bottomLeft.y - cornerRadius);
    
    // add left line
    CGPathAddLineToPoint(path, NULL, topLeft.x, topLeft.y + cornerRadius);
    
    // add top left curve
    CGPathAddQuadCurveToPoint(path, NULL, topLeft.x, topLeft.y, topLeft.x + cornerRadius, topLeft.y);
    
    // return the path
    return path;
}

@end


