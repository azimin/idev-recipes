//
//  MapView.m
//  QurtzCoreExample
//
//  Created by Alex Zimin on 08/01/14.
//  Copyright (c) 2014 Alex Zimin. All rights reserved.
//

#import "MapView.h"

#import <CoreText/CoreText.h>

@interface MapView ()

@property (nonatomic, strong) NSMutableArray *arrOfBuildings;

@property (nonatomic) float coeficent;

@end


@implementation MapView

#pragma mark - Getters

- (NSMutableArray *)arrOfBuildings
{
    if (!_arrOfBuildings)
        _arrOfBuildings = [NSMutableArray array];
    
    return _arrOfBuildings;
}


// -------------------------------------------------------------------------------------------------

- (float)coeficent
{
    if (_coeficent == 0)
        return 1;
    
    return _coeficent;
}

// -------------------------------------------------------------------------------------------------

- (float)zoomCoeficent
{
    if (_zoomCoeficent <= 0)
        return 1;
    
    return _zoomCoeficent;
}

// -------------------------------------------------------------------------------------------------

#pragma mark - Setters

- (void)addNewMapShape:(MapShape *)mapShape
{
    if (mapShape.arrOfPoints.count > 0) {
        float maxValueX = 0;
        float maxValueY = 0;
        
        for (NSDictionary *dic in mapShape.arrOfPoints) {
            float pointX = [[dic objectForKey:@"x"] floatValue];
            float pointY = [[dic objectForKey:@"y"] floatValue];
            if (pointX > maxValueX) maxValueX = pointX;
            if (pointY > maxValueY) maxValueY = pointY;
        }
        
        float coefX = maxValueX / 300;
        float coefY = maxValueY / 600;
        
        float coef = (MAX(coefX, coefY) > 1) ? MAX(coefX, coefY) : 1;
        if (self.coeficent < coef) self.coeficent = coef;

        [self.arrOfBuildings addObject:mapShape];
    }
}

// -------------------------------------------------------------------------------------------------

- (void)newMapWithMapShapesFromArray:(NSArray*)array
{
    self.arrOfBuildings = [NSMutableArray array];
    
    for (MapShape *mapShape in array) {
        [self addNewMapShape:mapShape];
    }
}

// -------------------------------------------------------------------------------------------------

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    [super setContentScaleFactor:contentScaleFactor];
}


// -------------------------------------------------------------------------------------------------

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    for (MapShape *mapShape in self.arrOfBuildings) {
       
        
        [mapShape.insideColor setFill];
        [mapShape.lineColor setStroke];
        
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake([[[mapShape.arrOfPoints lastObject] objectForKey:@"x"] floatValue] * self.zoomCoeficent / self.coeficent, [[[mapShape.arrOfPoints lastObject] objectForKey:@"y"] floatValue] * self.zoomCoeficent / self.coeficent)];
        
        for (NSDictionary *dic in mapShape.arrOfPoints) {
            [path addLineToPoint:CGPointMake([[dic objectForKey:@"x"] floatValue] * self.zoomCoeficent / self.coeficent, [[dic objectForKey:@"y"] floatValue] * self.zoomCoeficent / self.coeficent)];
        }
        
        path.lineWidth = 0.5;
        [path fill];
        [path stroke];
    }

}



@end
