//
//  ViewController.m
//  QurtzCoreExample
//
//  Created by Alex Zimin on 08/01/14.
//  Copyright (c) 2014 Alex Zimin. All rights reserved.
//

#import "ViewController.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#import "MapView.h"
#import "MapShape.h"

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet MapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//LevelControl
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIStepper *levelStepper;
- (IBAction)levelStepperAction:(UIStepper *)sender;

@property (nonatomic) NSMutableDictionary *dicOfLevels;
@property (nonatomic) NSMutableArray *arrOfLevelNames;

//Layout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewWidthConstraint;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api-srv.2rg.biz/level/map?&apptoken=1385899044249&id=16"]];
    [request setHTTPMethod:@"GET"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self createInfoAfterDic:dic];
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 3.5f;
    self.scrollView.zoomScale = 1.0f;
    _testView.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)createInfoAfterDic:(NSDictionary*)dic
{
    _dicOfLevels = [NSMutableDictionary dictionary];
    _arrOfLevelNames = [NSMutableArray array];
    
    if (![[dic objectForKey:@"res"] isEqualToString:@"ok"]) return;
    
    NSArray *levels = [dic objectForKey:@"levels"];
    //[objects addObject:[levels objectAtIndex:1]];
    for (NSDictionary* levelInfo in levels) {
        NSMutableArray *arrOfMapShapes = [NSMutableArray array];
        
        MapShape *mainMapShape = [MapShape new];
        [mainMapShape setInsideColorWithName:NULL_TO_NIL([levelInfo objectForKey:@"bg"])];
        [mainMapShape setLineColorWithName:NULL_TO_NIL([levelInfo objectForKey:@"col"])];
        if ([levelInfo objectForKey:@"coord"])
            mainMapShape.arrOfPoints = [NSJSONSerialization JSONObjectWithData:[[levelInfo objectForKey:@"coord"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        [arrOfMapShapes addObject:mainMapShape];
        
        if (NULL_TO_NIL([levelInfo objectForKey:@"objects"])) {
            for (NSDictionary *housInfo in [levelInfo objectForKey:@"objects"]) {
                MapShape *mapShape = [MapShape new];
                [mapShape setInsideColorWithName:NULL_TO_NIL([housInfo objectForKey:@"bg"])];
                [mapShape setLineColorWithName:NULL_TO_NIL([housInfo objectForKey:@"col"])];
                
                if ([housInfo objectForKey:@"coord"])
                    mapShape.arrOfPoints = [NSJSONSerialization JSONObjectWithData:[[housInfo objectForKey:@"coord"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
                
                [arrOfMapShapes addObject:mapShape];
            }
        }
        
        
        if (NULL_TO_NIL([levelInfo objectForKey:@"name"])) {
            [_dicOfLevels setObject:arrOfMapShapes forKey:[levelInfo objectForKey:@"name"]];
            [_arrOfLevelNames addObject:[levelInfo objectForKey:@"name"]];
        }
    }
    
    if (_arrOfLevelNames.count > 0) {
        _levelStepper.maximumValue = _arrOfLevelNames.count - 1;
        _levelStepper.minimumValue = 0;
        _levelStepper.value = 0;
        
        _levelLabel.text = [_arrOfLevelNames firstObject];
        
        [_mapView newMapWithMapShapesFromArray:[_dicOfLevels objectForKey:_arrOfLevelNames[0]]];
        [_mapView setNeedsDisplay];
    }
}


#pragma mark - Zoom Delegates

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    
     return self.mapView;
    //return [UIView new];
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
    //self.mapView.zoomCoeficent = scrollView.zoomScale;
    //[self.mapView setNeedsDisplay];
    
    //_mapViewWidthConstraint.constant = 320 * scrollView.zoomScale;
    //_mapViewHeightConstraint.constant = 568 * scrollView.zoomScale;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [_mapView setContentScaleFactor:scale*2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)levelStepperAction:(UIStepper *)sender {
    if ([_arrOfLevelNames objectAtIndex:sender.value]) {
        _levelLabel.text = [_arrOfLevelNames objectAtIndex:sender.value];
        [_mapView newMapWithMapShapesFromArray:[_dicOfLevels objectForKey:[_arrOfLevelNames objectAtIndex:sender.value]]];
        [_mapView setNeedsDisplay];
    }
}
@end
