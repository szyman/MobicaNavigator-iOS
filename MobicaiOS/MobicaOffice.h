//
//  MobicaOffice.h
//  MobicaiOS
//
//  Created by masy on 7/11/13.
//  Copyright (c) 2013 masy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#include <CoreLocation/CLLocationManagerDelegate.h>
#include <CoreLocation/CLError.h>
#include <CoreLocation/CLLocation.h>
#include <CoreLocation/CLLocationManager.h>

@interface MobicaOffice : NSObject
-(CLLocationCoordinate2D)getLocation:(NSString *) officeName;

@end
