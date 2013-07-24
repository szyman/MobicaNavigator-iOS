//
//  MapViewController.h
//  MobicaiOS
//
//  Created by masy on 7/8/13.
//  Copyright (c) 2013 masy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#include <CoreLocation/CLLocationManagerDelegate.h>
#include <CoreLocation/CLError.h>
#include <CoreLocation/CLLocation.h>
#include <CoreLocation/CLLocationManager.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) NSString *selectedOfficeString;
@property (weak, nonatomic) IBOutlet UINavigationItem *mapTitle;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableData *responseData;
@property (weak, nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revertChangesButton;
@property (weak, nonatomic) IBOutlet UISwitch *followSwitch;

- (IBAction)getCurrentLocation:(id)sender;
- (IBAction)clickRefreshButton:(id)sender;
- (IBAction)clickRevertButton:(id)sender;
- (IBAction)clickFollowSwitch:(id)sender;


@end
