//
//  MapVC.m
//  LocationInfo_Google
//
//  Created by WOS_iMac_2 on 8/5/17.
//  Copyright © 2017 Vyas. All rights reserved.
//

#import "MapVC.h"

#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapVC () <GMSMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLPlacemark *placemark;

}
@property (strong, nonatomic) IBOutlet GMSMapView *mapContainerView;
@end

@implementation MapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showMap_in_View];
    
    viewAddress.layer.cornerRadius = 10;
    viewAddress.layer.borderColor = [UIColor darkGrayColor].CGColor;
    viewAddress.layer.borderWidth = 0.80f;
    viewAddress.layer.masksToBounds = YES;
    
    lblLocation.numberOfLines = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void) showMap_in_View
{
    //GoogleMap Settings
    self.mapContainerView.myLocationEnabled = YES;
    //self.mapContainerView.settings.myLocationButton = YES;
    self.mapContainerView.settings.allowScrollGesturesDuringRotateOrZoom = YES;
    self.mapContainerView.settings.compassButton = YES;
    
    //self.mapContainerView.mapType = kGMSTypeNone;
    //self.mapContainerView.mapType = kGMSTypeHybrid;
    self.mapContainerView.mapType = kGMSTypeNormal; //Default
    //self.mapContainerView.mapType = kGMSTypeTerrain;
    //self.mapContainerView.mapType = kGMSTypeSatellite;
    
    //GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:21.1702 longitude:72.8311 zoom:16];
    //self.mapContainerView.camera = camera;
    
    /*
    //Map Pin
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(21.1702, 72.8311);
    marker.title = @"Current Location";
    marker.snippet = @"Current Location";
    marker.map = self.mapContainerView;
    */
}

#pragma mark - Button Action Methods

- (IBAction)btnBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - -----------------------------
- (void)CallLocationGetAddress:(double)Lat Long:(double)Long
{
    CLGeocoder *ceo = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:Lat longitude:Long];
    
    [ceo reverseGeocodeLocation: loc completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemarkLocation = [placemarks objectAtIndex:0];
         NSLog(@"==============================================");
         NSLog(@"placemark :-%@",placemarkLocation);
         
         //String to hold address
         NSString *locatedAt = [[placemarkLocation.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"addressDictionary:\n%@",placemarkLocation.addressDictionary);
         
         NSLog(@"==============================================");
         NSLog(@"region                         :-%@",placemarkLocation.region);
         NSLog(@"country                        :-%@",placemarkLocation.country);  // Give Country Name
         NSLog(@"locality                       :-%@",placemarkLocation.locality); // Extract the city name
         NSLog(@"name                           :-%@",placemarkLocation.name);
         NSLog(@"ocean                          :-%@",placemarkLocation.ocean);
         NSLog(@"postalCode                     :-%@",placemarkLocation.postalCode);
         NSLog(@"subLocality                    :-%@",placemarkLocation.subLocality);
         NSLog(@"ISOcountryCode                 :-%@",placemarkLocation.ISOcountryCode);
         NSLog(@"administrativeArea             :-%@",placemarkLocation.administrativeArea);
         NSLog(@"subAdministrativeArea          :-%@",placemarkLocation.subAdministrativeArea);
         NSLog(@"subLocality                    :-%@",placemarkLocation.subLocality);
         NSLog(@"thoroughfare                   :-%@",placemarkLocation.thoroughfare);
         NSLog(@"subThoroughfare                :-%@",placemarkLocation.subThoroughfare);
         NSLog(@"timeZone                       :-%@",placemarkLocation.timeZone);
         NSLog(@"location                       :-%@",placemarkLocation.location);
         NSLog(@"==============================================");
         //Print the location to console
         NSLog(@"I am currently at :-%@",locatedAt);
         NSLog(@"==============================================");
        
         lblLocation.text =[NSString stringWithFormat:@"%@",locatedAt];
     }];
}

#pragma mark  Google Map Delegate Methods
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    NSLog(@"Moving LAT:%f LONG:%f",latitude,longitude);
    lblLocation.text = @"Getting Address...";
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    NSLog(@"Complited LAT:%f LONG:%f",latitude,longitude);
    [self CallLocationGetAddress:latitude Long:longitude];
}
@end
