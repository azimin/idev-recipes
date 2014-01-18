//
//  MapShape.h
//  QurtzCoreExample
//
//  Created by Alex Zimin on 11/01/14.
//  Copyright (c) 2014 Alex Zimin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapShape : NSObject

//Colors
@property (nonatomic, strong) UIColor *insideColor;
@property (nonatomic, strong) UIColor *lineColor;

//ColorSet
-(void)setInsideColorWithName:(NSString*)insideColorName;
-(void)setLineColorWithName:(NSString*)lineColorName;

//ArrOfPoints
@property (nonatomic, strong) NSArray *arrOfPoints;

//NameInfo
@property (nonatomic, strong) NSString *name;
@property (nonatomic) CGRect frameForName;

@end
