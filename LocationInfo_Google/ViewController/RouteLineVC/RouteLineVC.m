//
//  RouteLineVC.m
//  LocationInfo_Google
//
//  Created by WOS_iMac_2 on 8/8/17.
//  Copyright © 2017 Vyas. All rights reserved.
//

#import "RouteLineVC.h"

#import "Function.h"
#import "WSModel.h"

#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMapsBase/GoogleMapsBase.h>

#define Mess_GettingAddress         @"Getting Address..."
#define Mess_GettingAddressError    @"Unable to get address"

enum enumAddress {
    enumAddress_None = 0,
    enumAddress_From,
    enumAddress_To
};

@interface RouteLineVC () <GMSMapViewDelegate>
{
    enum enumAddress objEnumAddress;
    CLLocation *Location_From, *Location_To;
    GMSMarker *market_centerPin;
    
    GMSMarker *marker_From, *marker_To;
}

@property (strong, nonatomic) IBOutlet GMSMapView *mapContainerView;
@end

@implementation RouteLineVC
//@synthesize obj

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    btnReset.hidden = YES;
    
    [self showMap_in_View];
    
    viewAddress.backgroundColor = [UIColor clearColor];
    [self manage_Animation_AddressView_Show:YES];
    
    btnDrowRouteLine.hidden = YES;
    btnLocation.hidden = YES;
    
    viewDone.hidden = YES;
    [self manage_Animation_DoneView_Show:NO];
    
    NSArray *arrObj = [[NSArray alloc] initWithObjects:viewAddress.layer, ViewTo.layer, ViewFrom.layer, btnDrowRouteLine.layer, viewDone.layer, btnDone.layer , nil];
    for (CALayer *objLayer in arrObj) {
        objLayer.cornerRadius = 5;
        objLayer.masksToBounds = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void) showMap_in_View
{
    //return;
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

- (void) manage_Animation_AddressView_Show:(BOOL)show
{
    if (show == NO)
    {
        viewAddress.hidden = YES;
    }
    else
    {
        viewAddress.hidden = NO;
    }
}

- (void) manage_Animation_DoneView_Show:(BOOL)show
{
    [self manage_DoneButton_Height];
    
    if (show == NO)
    {
        //Hide Button With Animation
        [UIView animateWithDuration:0.30f
                         animations:^{
                             lc_ViewDone_y.constant = -(20 + viewAddress.frame.size.height);
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished)
         {
             viewDone.hidden = YES;
         }];
    }
    else
    {
        viewDone.hidden = NO;
        
        lblAddress.numberOfLines = 0;
        lblAddress.textColor = [UIColor whiteColor];
        
        
        //Show Button With Animation
        [UIView animateWithDuration:0.30f
                         animations:^{
                             lc_ViewDone_y.constant = 20;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished)
         {
             //Code
         }];
    }
}

- (void) manage_DoneButton_Height
{
    if ([lblAddress.text isEqualToString:Mess_GettingAddress] || [lblAddress.text isEqualToString:Mess_GettingAddressError])
    {
        lc_btnDone_Height.constant = 0;
        [self.view layoutIfNeeded];
        //return;
    }
    else
    {
        lc_btnDone_Height.constant = 40;
        [self.view layoutIfNeeded];
    }
}

- (void) showAlertMessage:(NSString *)strMess autoHide:(BOOL)autoHide
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"Location Info" uppercaseString]
                                                                             message:@"Unable to get direction for this route location"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    //Auto Dismiss
    if (autoHide == YES)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:^{ //Set Completion Code
            }];
        });
    }
    else
    {
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
        {
            //Set Completion Code
        }]];
    }
    
    //Show Alert
    //[view presentViewController:alertController animated:YES completion:nil]; //set VC object for show alert
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Button Action Methods

- (IBAction)btnBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnResetAction
{
    [self viewDidLoad];
    
    objEnumAddress = enumAddress_None;
    
    lblAddress_From.text = @"-";
    lblAddress_To.text = @"-";
    
    lblAddress.text = Mess_GettingAddress;
    
    [self.mapContainerView clear];
    
    [self manage_Animation_AddressView_Show:YES];
}

- (IBAction)btnFromAction
{
    objEnumAddress = enumAddress_From;
    
    viewAddress.hidden = YES;
    btnDrowRouteLine.hidden = YES;
    btnLocation.hidden = NO;
    
    //Remove Addred Pin
    marker_From.map = nil;
    
    [self manage_Animation_AddressView_Show:NO];
    [self manage_Animation_DoneView_Show:YES];
}

- (IBAction)btnToAction
{
    objEnumAddress = enumAddress_To;
    
    viewAddress.hidden = YES;
    btnDrowRouteLine.hidden = YES;
    btnLocation.hidden = NO;
    
    //Remove Addred Pin
    marker_To.map = nil;
    
    [self manage_Animation_AddressView_Show:NO];
    [self manage_Animation_DoneView_Show:YES];
}

- (IBAction)btnDrowRouteLineAction
{
    objEnumAddress = enumAddress_None;
    
    [self googleMapDirection_latitude_Source:Location_From.coordinate.latitude
                            longitude_Source:Location_From.coordinate.longitude
                        latitude_Destination:Location_To.coordinate.latitude
                       longitude_Destination:Location_To.coordinate.longitude];
}

- (IBAction)btnDoneAction
{
    if ([lblAddress.text isEqualToString:Mess_GettingAddress] || [lblAddress.text isEqualToString:Mess_GettingAddressError])
    {
        return;
    }
    
    if (objEnumAddress == enumAddress_From)
    {
        lblAddress_From.text = lblAddress.text;
        
        marker_From = [[GMSMarker alloc] init];
        marker_From.position = Location_From.coordinate;
        marker_From.appearAnimation = kGMSMarkerAnimationPop;
        //marker_From.icon = [UIImage imageNamed:@"Droped_w"];
        marker_From.map = self.mapContainerView;
        marker_From.snippet = lblAddress_From.text;
        marker_From.map = self.mapContainerView;
    }
    else if (objEnumAddress == enumAddress_To)
    {
        lblAddress_To.text = lblAddress.text;
        
        marker_To = [[GMSMarker alloc] init];
        marker_To.position = Location_To.coordinate;
        marker_To.appearAnimation = kGMSMarkerAnimationPop;
        //marker_To.icon = [UIImage imageNamed:@"Droped_w"];
        marker_To.map = self.mapContainerView;
        marker_To.snippet = lblAddress_To.text;
        marker_To.map = self.mapContainerView;
    }
    
    objEnumAddress = enumAddress_None;
    
    btnLocation.hidden = YES;
    [self manage_Animation_AddressView_Show:YES];
    [self manage_Animation_DoneView_Show:NO];
    
    if ([lblAddress_From.text isEqualToString:@"-"] ||
        [lblAddress_To.text isEqualToString:@"-"])
    {
        btnDrowRouteLine.hidden = YES;
        btnReset.hidden = NO;
    }
    else
    {
        btnDrowRouteLine.hidden = NO;
    }
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
         
         lblAddress.text =[NSString stringWithFormat:@"%@",locatedAt];
         [self manage_DoneButton_Height];
         
         if (objEnumAddress == enumAddress_From)
         {
             Location_From = [[CLLocation alloc] initWithLatitude:Lat longitude:Long];
         }
         else if (objEnumAddress == enumAddress_To)
         {
             Location_To = [[CLLocation alloc] initWithLatitude:Lat longitude:Long];
         }
         else if (objEnumAddress == enumAddress_None)
         {
             
         }
     }];
}

- (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation*)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@origin=%@&destination=%@", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     if(error)
                                                     {
                                                         if(completionHandler)
                                                             completionHandler(nil);
                                                         return;
                                                     }
                                                     
                                                     NSArray *routesArray = [json objectForKey:@"routes"];
                                                     
                                                     GMSPolyline *polyline = nil;
                                                     if ([routesArray count] > 0)
                                                     {
                                                         NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                         NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                         NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                         GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                         polyline = [GMSPolyline polylineWithPath:path];
                                                     }
                                                     
                                                     // run completionHandler on main thread                                           
                                                     dispatch_sync(dispatch_get_main_queue(), ^{
                                                         if(completionHandler)
                                                         {
                                                             completionHandler(polyline);
                                                         }                                                         
                                                     });
                                                 }];
    [fetchDirectionsTask resume];
}

#pragma mark - Web Service : Get Google Address Using Lat-Log.
- (void) webService_GetGoogleAddress_LatLog:(CLLocationCoordinate2D)locationCoordinate2D
{
    NSString *strlatLog = [NSString stringWithFormat:@"%@,%@",@(locationCoordinate2D.latitude).stringValue, @(locationCoordinate2D.longitude).stringValue];
    NSString *strKey = [NSString stringWithFormat:@"%@",GoogleAPI_Key]; //Live
    NSString *signUpRequest = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@&key=%@",strlatLog,strKey];
    NSLog(@"signUpRequest:\n%@",signUpRequest);
    
    NSData *data=[signUpRequest dataUsingEncoding:NSASCIIStringEncoding];
    NSString* webStringURL = [signUpRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* urlRequestString = [NSURL URLWithString:webStringURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlRequestString];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data , NSURLResponse *response , NSError *err)
      {
          if (data != nil)
          {
              NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
              
              //NSLog(@"Responce :%@",dic);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  @try
                  {
                      NSMutableArray *arrResult = [dic valueForKey:@"results"];
                      NSString *strValue = @"";
                      if (arrResult.count == 0)
                      {
                          strValue = [dic valueForKey:@"error_message"];
                          
                          if ([Function string_isEmpty:strValue] == YES)
                              strValue = [dic valueForKey:@"status"];
                          
                          //[Function showAlertMessage:strMessage autoHide:NO];
                          strValue = Mess_GettingAddressError;
                      }
                      else
                      {
                          NSString *strFormatedAddress = @"";
                          strFormatedAddress = [[arrResult firstObject] valueForKey:@"formatted_address"];
                          
                          if (objEnumAddress == enumAddress_From)
                          {
                              Location_From = [[CLLocation alloc] initWithLatitude:locationCoordinate2D.latitude longitude:locationCoordinate2D.longitude];
                          }
                          else if (objEnumAddress == enumAddress_To)
                          {
                              Location_To = [[CLLocation alloc] initWithLatitude:locationCoordinate2D.latitude longitude:locationCoordinate2D.longitude];
                          }
                          strValue =[NSString stringWithFormat:@"%@",strFormatedAddress];
                      }
                      lblAddress.text = [NSString stringWithFormat:@"%@",strValue];
                      [self manage_DoneButton_Height];
                  }
                  @catch (NSException *exception)
                  {
                      NSLog(@"Exception:%@",exception);
                  }
                  @finally
                  {
                      
                  }
                  
              });
          }
      }] resume];
}

#pragma mark - Google Map Direction
-(void)googleMapDirection_latitude_Source:(double)latitudeSource
                         longitude_Source:(double)longitude_Source
                     latitude_Destination:(double)latitude_Destination
                    longitude_Destination:(double)longitude_Destination
{
    //    NSString *strLatDestination = [NSString stringWithFormat:@"%.2f",latDestination];
    //    NSString *strLonDestination = [NSString stringWithFormat:@"%.2f",latDestination];
    
    if (latitude_Destination != 0 && longitude_Destination != 0)
    {
        NSString *strOrigin;
        strOrigin = [NSString stringWithFormat:@"%@",lblAddress_To.text];
        strOrigin = [NSString stringWithFormat:@"%f,%f",latitudeSource,longitude_Source];
        NSString *strDestination;
        strDestination = [NSString stringWithFormat:@"%@",lblAddress_From.text];
        strDestination = [NSString stringWithFormat:@"%f,%f",latitude_Destination,longitude_Destination];
        
        NSString *strMode = [NSString stringWithFormat:@"%@",@"driving+walking "];
//NSString *strKey = [NSString stringWithFormat:@"%@",@"AIzaSyCxb-3NivGE0YzosX8IzXR5YBsN_vuicuA"]; //Test

        NSString *strKey = [NSString stringWithFormat:@"%@",GoogleAPI_Key]; //Live
        
        NSString *signUpRequest = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=%@&key=%@",strOrigin,strDestination,strMode,strKey];
        NSLog(@"signUpRequest: %@",signUpRequest);
        
        NSData *data=[signUpRequest dataUsingEncoding:NSASCIIStringEncoding];
        NSString* webStringURL = [signUpRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* urlRequestString = [NSURL URLWithString:webStringURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlRequestString];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data , NSURLResponse *response , NSError *err)
          {
              if (data != nil)
              {
                  NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                  //NSLog(@"Responce :%@",dic);
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      @try
                      {
                          if (dic != nil || !err || data)
                          {
                              //[self.mapContainerView clear];
                              NSMutableArray *arrRoutes = [dic valueForKey:@"routes"];
                              if (arrRoutes.count == 0)
                              {
                                  NSString *strValue = @"";
                                  strValue = [dic valueForKey:@"error_message"];
                                  
                                  if ([Function string_isEmpty:strValue] == YES)
                                  {
                                      strValue = [dic valueForKey:@"status"];
                                      //strValue = Mess_GettingAddressError;
                                      strValue = [strValue uppercaseString];
                                    if ([strValue isEqualToString:[@"ZERO_RESULTS" uppercaseString]] ||
                                        [strValue isEqualToString:[@"OK" uppercaseString]])
                                   {
                                        strValue = [NSString stringWithFormat:@"Sorry, %@ could not calculate directions\n From:\"%@\" \nTo:\"%@\"",AppName,location_To.snippet,location_From.snippet];
                                   }
                                  }
                                  [Function showAlertMessage:strValue autoHide:NO];
                              }
                              else
                              {
                                  NSMutableArray *arrLegs = [[NSMutableArray alloc] init];
                                  NSMutableArray *arrSteps = [[NSMutableArray alloc] init];
                                  
                                  arrLegs = [[arrRoutes firstObject] objectForKey:@"legs"];
                                  arrSteps = [[arrLegs firstObject] objectForKey:@"steps"] ;
                                  
                                  NSMutableArray *coordinates = [[NSMutableArray alloc] initWithCapacity:arrSteps.count];
                                  GMSPolyline *singleLine = [[GMSPolyline alloc] init];
                                  for (int i = 0; i < arrSteps.count; i++)
                                  {
                                      NSString *toDecode = [[[arrSteps objectAtIndex:i] objectForKey:@"polyline"] valueForKey:@"points"];
                                      NSArray *locations;
                                      
                                      locations = [[self class] decodePolylineWithString:toDecode];
                                      GMSMutablePath *path = [GMSMutablePath pathFromEncodedPath:toDecode];
                                      
                                      singleLine = [GMSPolyline polylineWithPath:path];
                                      singleLine.strokeColor = [UIColor colorWithRed:1.0f/255.0f green:115.0f/255.0f blue:141.0f/255.0f alpha:1.0];
                                      singleLine.strokeWidth = 5.0f;
                                      singleLine.map = self.mapContainerView;
                                      //[arrPolyline addObject:singleLine];
                                      for (int i = 0 ; i < locations.count ; i++)
                                      {
                                          if (i != locations.count - 1)
                                          {
                                              CLLocation *start = [locations objectAtIndex:i];
                                              CLLocation *finish = [locations objectAtIndex:i + 1];
                                              [coordinates addObject:@{ @"start" : start, @"finish" : finish }];
                                          }
                                      }
                                  }
                                  //CGFloat zoomLavel = self.mapContainerView.camera.zoom;
                                  //GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitudeSource longitude:longitude_Source zoom:zoomLavel];
                                  //self.mapContainerView.camera = camera;
                                   
                                  [self manage_Animation_AddressView_Show:NO];
                                  btnDrowRouteLine.hidden = YES;
                              }
                          }
                      }
                      @catch (NSException *exception)
                      {
                          NSLog(@"Exception:%@",exception);
                      }
                      @finally
                      {
                          
                      }
                  });
              }
          }] resume];
    }
    else
    {
        [self.mapContainerView clear];
        
        GMSCameraPosition *camera;
        camera = [GMSCameraPosition cameraWithLatitude:Location_From.coordinate.latitude longitude:Location_From.coordinate.longitude zoom:9];
        [self.mapContainerView setCamera:camera];
        [self.mapContainerView setDelegate:self];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitudeSource, longitude_Source);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.icon = [UIImage imageNamed:@"Pickup_pin"];
        marker.map = self.mapContainerView;
        marker.snippet = lblAddress_From.text;
        [self.mapContainerView setMyLocationEnabled:NO];
    }
}

+ (NSArray*)decodePolylineWithString:(NSString *)encodedString
{
    NSMutableArray *coordinates = [NSMutableArray array];
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length)
    {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do
        {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:finalLat longitude:finalLon];
        [coordinates addObject:location];
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    free(coords);
    return coordinates;
}

#pragma mark  Google Map Delegate Methods
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    NSLog(@"0. LAT | LONG : %f | %f",latitude,longitude);
    
    //    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    lblAddress.text = Mess_GettingAddress;
    [self manage_DoneButton_Height];
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    NSLog(@"1. LAT | LONG : %f | %f",latitude,longitude);
    
    latitude = position.target.latitude;
    longitude = position.target.longitude;
    NSLog(@"2. LAT | LONG : %f | %f",latitude,longitude);
    
    if (objEnumAddress == enumAddress_None)
    {
        NSLog(@"None Lat-Log");
    }
    else
    {
        NSLog(@"Get Lat-Log");
        [self CallLocationGetAddress:latitude Long:longitude];
        //[self webService_GetGoogleAddress_LatLog:position.target];
    }
}
@end
