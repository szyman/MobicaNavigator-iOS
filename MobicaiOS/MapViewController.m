//
//  MapViewController.m
//  MobicaiOS
//
//  Created by masy on 7/8/13.
//  Copyright (c) 2013 masy. All rights reserved.
//

#import "MapViewController.h"
#import "MobicaOffice.h"
#import "HintsViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    CLLocationManager *locationManager;
    NSNumber *longitudeNum;
    NSNumber *latitudeNum;
    NSMutableData *responseData;
    NSString *officeName;
    CLLocationCoordinate2D officeCoordinate;
    NSDictionary * hintsDict;
    NSString *waypointsString;
    MKUserLocation *currentLocation;
    
    MKPolyline *polyline;
    NSMutableArray *hintPointsArray;
    NSMutableArray *hintPointsArrayInit;
    NSMutableArray *hintStringArray;
    MKPolyline *polylineInit;
    NSMutableArray *waypointsArray;
}

@synthesize selectedOfficeString;
@synthesize mapTitle;
@synthesize mapView;
@synthesize spinner;
@synthesize responseData = _responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //if (selectedOfficeString == nil)
        //    selectedOfficeString = @"SZCZECIN";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    locationManager = [[CLLocationManager alloc] init];
    
    officeName = selectedOfficeString;
    //officeName = @"SZCZECIN";
    selectedOfficeString =  [selectedOfficeString stringByAppendingString:@" map"];
    mapTitle.title = selectedOfficeString;
    waypointsString = [[NSString alloc] init];
    
    MobicaOffice *mobicaOffice = [[MobicaOffice alloc] init];
    officeCoordinate = [mobicaOffice getLocation:officeName];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = officeCoordinate;
    point.title = officeName;
    [self.mapView addAnnotation:point];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(longpressToSetWaypoint:)];
    lpgr.minimumPressDuration = 2.0;
    [mapView addGestureRecognizer:lpgr];
    
}

- (void)connectToService:(MKUserLocation *)myLocation{

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myLocation.coordinate, 400000, 400000);
    [self.mapView setRegion: region animated:YES];
    
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner = tempSpinner;
    UIView *view = self.view;
    CGRect spinnerRect = spinner.frame;
    spinnerRect.origin.x = view.frame.size.width /2;
    spinnerRect.origin.y = view.frame.size.height/2;
    spinner.frame = spinnerRect;
    //[self.spinner frameForAlignmentRect:CGRectMake(100, 100, 55, 55)];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];

    double latitude = myLocation.coordinate.latitude;
    double longitude = myLocation.coordinate.longitude;
    double latitudeOffice = officeCoordinate.latitude;
    double longitudeOffice = officeCoordinate.longitude;

    NSString *url = @"http://maps.googleapis.com/maps/api/directions/json?origin=";
    NSString *url2 = [NSString stringWithFormat:@"%f,%f%@%f,%f", latitude, longitude, @"&destination=", latitudeOffice, longitudeOffice];
    NSString *url3 = [NSString stringWithFormat:@"%@%@%@", @"&waypoints=", waypointsString, @"&sensor=false"];
    url = [[url stringByAppendingString:url2] stringByAppendingString:url3];
    //url = [[[[[[[[url stringByAppendingString:[latitude stringValue]] stringByAppendingString:@","] stringByAppendingString:[longitude stringValue]] stringByAppendingString:@"&destination="] stringByAppendingString:[latitudeOffice stringValue]] stringByAppendingString:@","] stringByAppendingString:[longitudeOffice stringValue]] stringByAppendingString:@"&sensor=false"];
    //http://maps.googleapis.com/maps/api/directions/json?origin=51.1078852,17.0385376&destination=50.0755381,14.4378005&sensor=false
    //http://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&sensor=false
    NSLog(@"url: %@", url);
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:url]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self ];
    if(!conn)
    {
        NSLog(@"Error url conn occur");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:nil];
    hintStringArray = [[NSMutableArray alloc] init];
    NSArray *legs = [[[res objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"];
    NSLog(@"Legs %d", legs.count);
    
    for(int j = 0; j < legs.count; j++){
        NSArray *steps = [[legs objectAtIndex:j] objectForKey:@"steps"];

        hintsDict = [[NSDictionary alloc] init];
        
        if(!hintPointsArray)
            hintPointsArray = [[NSMutableArray alloc] init];

        for(NSDictionary *step in steps){
            double hintLat = [[[step objectForKey:@"start_location"] objectForKey:@"lat"] doubleValue];
            double hintLong = [[[step objectForKey:@"start_location"] objectForKey:@"lng"] doubleValue];
            NSString *hintString = [step objectForKey:@"html_instructions"];
            NSString *hintStringCut = [[NSString alloc] initWithString:hintString];
            //NSLog(@"HintLoc %@ - %f : %f", hintString, hintLat, hintLong);
    
            hintStringCut = [[[[hintString stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""] stringByReplacingOccurrencesOfString:@"<div style=\"font-size:0.9em\">" withString:@""] stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
            
            MKPointAnnotation *hintPoint = [[MKPointAnnotation alloc] init];
            hintPoint.coordinate = CLLocationCoordinate2DMake(hintLat, hintLong);
            hintPoint.title = hintStringCut;
            hintPoint.subtitle = hintStringCut;
            [self.mapView addAnnotation:hintPoint];
            
            [hintPointsArray addObject:hintPoint];
            [hintStringArray addObject:hintString];

        }
        //hintsDict = [NSDictionary dictionaryWithObjectsAndKeys:(NSMutableArray *) hintsStringArray, (NSMutableArray *) hintsLocArray, nil];
    }
    NSString *poly = [[[res objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"overview_polyline"];
    //NSLog(@"poly %@", poly);
    NSString *points = [poly valueForKey:@"points"];
    
    if(!hintPointsArrayInit)
        hintPointsArrayInit = [[NSMutableArray alloc] initWithArray:hintPointsArray];
    [self decodePolyAndDraw:points];
    [self.spinner stopAnimating];
    
}

- (void)longpressToSetWaypoint:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    [mapView removeOverlay:polyline];
    [mapView removeAnnotations:hintPointsArray];
    [mapView removeOverlay:polylineInit];
    [mapView removeAnnotations:hintPointsArrayInit];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D location =
    [mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    if(waypointsString.length >0){
        waypointsString = [waypointsString stringByAppendingString:@"%7C"];
    }
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    NSString *touchPosString = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
    waypointsString = [waypointsString stringByAppendingString:touchPosString];
    
    MKPointAnnotation *waypoint = [[MKPointAnnotation alloc] init];
    waypoint.coordinate = location;
    waypoint.title = @"waypoint";
    [mapView addAnnotation:waypoint];
    
    if(!waypointsArray)
        waypointsArray = [[NSMutableArray alloc] init];
    [waypointsArray addObject:waypoint];
    
    
    [self connectToService:currentLocation];
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    if ([[annotation title] isEqualToString:@"Current Location"] || [[annotation title] isEqualToString:officeName]
            || [[annotation title] isEqualToString:@"waypoint"]) {
        return nil;
    }
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.image = [UIImage imageNamed:@"info_icon.png"];
    
    UITextView *textVIew = [[UITextView alloc] init];
    textVIew.text = @"tesxt";
    textVIew.frame = CGRectMake(0, 0, annView.frame.origin.x, annView.frame.origin.y);
    //annView.leftCalloutAccessoryView = textVIew;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [infoButton addTarget:self action:@selector(showDetailsView:)
         forControlEvents:UIControlEventTouchUpInside];
    annView.rightCalloutAccessoryView = infoButton;
     annView.canShowCallout = YES;
    return annView;
}

-(IBAction)showDetailsView:(id)sender{
    
}

-(MKMapPoint)decodePolyAndDraw:(NSString*) encoded
{
    //NSMutableArray *polyArray = [[NSMutableArray alloc] init];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0, i = 0;
    
    MKMapPoint *polyArray = malloc(sizeof(CLLocationCoordinate2D) * len);
    
    while (index < len) {
        int b, shift = 0, result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        
        polyArray[i++] = MKMapPointForCoordinate(CLLocationCoordinate2DMake((double) lat / 1E5, (double) lng / 1E5));
    }
    
    polyline = [MKPolyline polylineWithPoints:polyArray count:i -1 ];
    [self.mapView addOverlay:polyline];
    
    if(!polylineInit)
        polylineInit = [MKPolyline polylineWithPoints:polyArray count:i -1];
    
    return *polyArray;
    free(polyArray);
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)myLocation
{
    
    if(currentLocation == nil)
        [self connectToService:myLocation];
    currentLocation = myLocation;
    }

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 1.0;
    
    return polylineView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickRefreshButton:(id)sender {
    [mapView removeOverlay:polyline];
    [mapView removeAnnotations:hintPointsArray];
    [self connectToService:currentLocation];
}

- (IBAction)clickRevertButton:(id)sender {
    [mapView removeOverlay:polyline];
    [mapView removeAnnotations:hintPointsArray];
    [mapView removeAnnotations:waypointsArray];
    
    [mapView addOverlay:polylineInit];
    [mapView addAnnotations:hintPointsArrayInit];
    
    [hintPointsArray removeAllObjects];
    polyline = [polyline init];
    waypointsString = @"";
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HintsViewSegue"] ) {
        HintsViewController *destViewController = segue.destinationViewController;
        destViewController.hintsArray = hintStringArray;
    }
}


@end
