//
//  MobicaOffice.m
//  MobicaiOS
//
//  Created by masy on 7/11/13.
//  Copyright (c) 2013 masy. All rights reserved.
//

#import "MobicaOffice.h"

@implementation MobicaOffice{
    NSDictionary *officeDict;
}
-(id)init
{
    NSArray *szczecinArray = [NSArray arrayWithObjects:
                         [NSNumber numberWithDouble:53.429152],
                         [NSNumber numberWithDouble:14.556139], nil];
    
    NSArray *warszawArray = [NSArray arrayWithObjects:
                              [NSNumber numberWithDouble:52.172175],
                              [NSNumber numberWithDouble:21.0254902], nil];
    officeDict = [NSDictionary dictionaryWithObjectsAndKeys: szczecinArray,@"SZCZECIN", warszawArray, @"WARSAW", nil];
    return self;
}

-(CLLocationCoordinate2D)getLocation:(NSString *) officeName
{
    for(id key in officeDict) {
        NSString *keyAsString = (NSString *)key;
        NSLog(@"key: %@", keyAsString);
        if([keyAsString isEqual: officeName])
        {
            id value = [officeDict objectForKey:key];
            NSArray * array = (NSArray *) value;
            
            return CLLocationCoordinate2DMake([array[0] doubleValue], [array[1] doubleValue]);
        }
    }
    return CLLocationCoordinate2DMake(0, 0);
}

@end
