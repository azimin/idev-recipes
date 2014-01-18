//
//  MapView.h
//  QurtzCoreExample
//
//  Created by Alex Zimin on 08/01/14.
//  Copyright (c) 2014 Alex Zimin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapShape.h"

@interface MapView : UIView

@property (nonatomic) float zoomCoeficent;

// -------------------------------------------------------------------------------------------------

- (void)addNewMapShape:(MapShape*)mapShape;
- (void)newMapWithMapShapesFromArray:(NSArray*)array;

@end
