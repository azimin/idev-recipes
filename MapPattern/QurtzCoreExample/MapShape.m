//
//  MapShape.m
//  QurtzCoreExample
//
//  Created by Alex Zimin on 11/01/14.
//  Copyright (c) 2014 Alex Zimin. All rights reserved.
//

#import "MapShape.h"

@implementation MapShape

#pragma mark Setters

- (void)setInsideColorWithName:(NSString*)insideColorName
{
    if (insideColorName)
        _insideColor = [UIColor colorWithHexString:insideColorName andAlpha:1.0];
    else
        _insideColor = [UIColor clearColor];
}

// -------------------------------------------------------------------------------------------------

- (void)setLineColorWithName:(NSString*)lineColorName
{
    if (lineColorName)
        _insideColor = [UIColor colorWithHexString:lineColorName andAlpha:1.0];
    else
        _insideColor = [UIColor colorWithHexString:@"000000" andAlpha:1.0];
}

// -------------------------------------------------------------------------------------------------

#pragma mark Getters

- (NSArray *)arrOfPoints
{
    if (!_arrOfPoints) _arrOfPoints = [NSArray array];
    return _arrOfPoints;
}

// -------------------------------------------------------------------------------------------------

- (UIColor *)insideColor
{
    if (!_insideColor) _insideColor = [UIColor clearColor];
    return _insideColor;
}

// -------------------------------------------------------------------------------------------------

- (UIColor *)lineColor
{
    if (!_lineColor) _lineColor = [UIColor colorWithHexString:@"000000" andAlpha:1.0];
    return _lineColor;
}

// -------------------------------------------------------------------------------------------------

- (CGRect)frameForName
{
    if (_frameForName.size.height == 0 && _frameForName.size.width == 0)
        _frameForName = [self calculateRectInPath];
    
    return _frameForName;
}

// -------------------------------------------------------------------------------------------------

#pragma mark AditionalMethod

- (CGRect)calculateRectInPath
{
    CGRect frame;
    
    if (self.arrOfPoints.count < 3)
        return frame;
    
    CGPoint firstPoint;
    CGPoint secondPoint;
    CGPoint thirdPoint;
    CGFloat maxDistance = 0;
    
    CGFloat maxX = 0;
    CGFloat maxY = 0;
    CGFloat minX = MAXFLOAT;
    CGFloat minY = MAXFLOAT;
    
    for (int i = 0; i < self.arrOfPoints.count - 1; i++) {
        
        CGPoint pointOne = CGPointMake([[self.arrOfPoints[i] objectForKey:@"x"] floatValue], [[self.arrOfPoints[i] objectForKey:@"y"] floatValue]);
        CGPoint pointTwo = CGPointMake([[self.arrOfPoints[i + 1] objectForKey:@"x"] floatValue], [[self.arrOfPoints[i + 1] objectForKey:@"y"] floatValue]);
        
        if ([self distanceBetweenFirstPoint:pointOne andSecondPoint:pointTwo] > maxDistance) {
            maxDistance = [self distanceBetweenFirstPoint:pointOne andSecondPoint:pointTwo];
            firstPoint = pointOne;
            secondPoint = pointTwo;
        }
        
        if (maxX < pointOne.x)
            maxX = pointOne.x;
        
        if (maxY < pointOne.y)
            maxY = pointOne.y;
        
        if (minX > pointOne.x)
            minX = pointOne.x;
        
        if (minY > pointOne.y)
            minY = pointOne.y;
        
    }
    
    CGFloat minPoint = MAXFLOAT;
    
    if (ABS(firstPoint.x - secondPoint.x) > ABS(firstPoint.y - secondPoint.y)) {
        
        for (NSDictionary *dic in self.arrOfPoints) {
            CGPoint currentPoint = CGPointMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue]);
            
            if ((currentPoint.x > firstPoint.x && currentPoint.x < secondPoint.x) || (currentPoint.x < firstPoint.x && currentPoint.x > secondPoint.x)) {
                
                float coeficent = ABS(firstPoint.x - secondPoint.x) / ABS(firstPoint.x - currentPoint.x);
                float result = (ABS(firstPoint.y - secondPoint.y) * coeficent) - currentPoint.y;
                
                if (ABS(result) < ABS(minPoint)) {
                    minPoint = result;
                    thirdPoint = currentPoint;
                }
                
            }
        }
        
        if (minPoint == MAXFLOAT)
            thirdPoint = CGPointMake(0, MIN(firstPoint.y, secondPoint.y) + (maxY - minY));
        
        return CGRectMake(MIN(firstPoint.x, secondPoint.x), MIN(firstPoint.y, secondPoint.y), ABS(firstPoint.x - secondPoint.x), ABS(MIN(firstPoint.y, secondPoint.y) - thirdPoint.y));
        
    } else {
        
        for (NSDictionary *dic in self.arrOfPoints) {
            CGPoint currentPoint = CGPointMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue]);
            
            if ((currentPoint.y > firstPoint.y && currentPoint.y < secondPoint.y) || (currentPoint.y < firstPoint.y && currentPoint.y > secondPoint.y)) {
                
                float coeficent = ABS(firstPoint.y - secondPoint.y) / ABS(firstPoint.y - currentPoint.y);
                float result = (ABS(firstPoint.x - secondPoint.x) * coeficent) - currentPoint.x;
                
                if (ABS(result) < ABS(minPoint)) {
                    minPoint = result;
                    thirdPoint = currentPoint;
                }
                
            }
        }
        
        if (minPoint == MAXFLOAT)
            thirdPoint = CGPointMake(MIN(firstPoint.x, secondPoint.x) + maxX - minX, 0);
        
        NSLog(@"%@ and %f", self.arrOfPoints , ABS(MIN(firstPoint.x, secondPoint.x) - thirdPoint.x));
        
        return CGRectMake(MIN(firstPoint.x, secondPoint.x), MIN(firstPoint.y, secondPoint.y), ABS(MIN(firstPoint.x, secondPoint.x) - thirdPoint.x), ABS(firstPoint.y - secondPoint.y));

    }
    
    return frame;
}

- (CGFloat) distanceBetweenFirstPoint:(CGPoint)p1 andSecondPoint:(CGPoint)p2
{
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    
    return sqrt(dx*dx + dy*dy);
}

@end
