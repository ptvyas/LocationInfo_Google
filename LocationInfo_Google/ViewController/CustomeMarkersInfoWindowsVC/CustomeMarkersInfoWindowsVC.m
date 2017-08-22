//
//  CustomeMarkersInfoWindowsVC.m
//  LocationInfo_Google
//
//  Created by WOS_iMac_2 on 8/19/17.
//  Copyright © 2017 Vyas. All rights reserved.
//

#import "CustomeMarkersInfoWindowsVC.h"
#import "MapAnnotationView.h"

#import "Function.h"

#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMapsBase/GoogleMapsBase.h>

#define _keyLat             @"keyLat"
#define _keyLong            @"keyLong"

#define IMG_CurrentLocation    @"CurrentLocation_w"
#define IMG_Droped             @"Droped_w"
#define IMG_Picked             @"Picked_w"

@interface CustomeMarkersInfoWindowsVC () <GMSMapViewDelegate>
{
    NSMutableArray *arrLocationPin;
    
}
@property (strong, nonatomic) IBOutlet GMSMapView *mapContainerView;
@property (strong, nonatomic) IBOutlet GMSMapView *mapContainerView_Custome;

@end

@implementation CustomeMarkersInfoWindowsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showMap_in_View:self.mapContainerView];
    [self showMap_in_View:self.mapContainerView_Custome];
    
    [self btnDefaultAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void) manage_SelectButton:(UIButton *)btn
{
    [self.mapContainerView clear];
    [self.mapContainerView_Custome clear];
    
    self.mapContainerView.hidden = YES;
    self.mapContainerView_Custome.hidden = YES;
    
    CGFloat position = 0;
    
    if (btn == btnDefault)
    {
        self.mapContainerView.hidden = NO;
        
        [self manage_CurretButtonAnimation_Position:position];
        [self manage_DefaultMarkers];
    }
    else if (btn == btnCustome)
    {
        self.mapContainerView_Custome.hidden = NO;
        
        position = CGRectGetWidth(viewButton.frame)/2;
        [self manage_CurretButtonAnimation_Position:position];
        [self manage_CustomeMarkers];
    }
    else
    {
        [self btnBackAction];
    }
}

-(void) manage_CurretButtonAnimation_Position:(CGFloat )position
{
    [UIView animateWithDuration:0.60f
                     animations:^{
                         lc_btnCurretnButton_x.constant = position;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished)
     {
         NSLog(@"Animation done.");
    }];
}

- (void) showMap_in_View:(GMSMapView *)View
{
    //GoogleMap Settings
    
    View.myLocationEnabled = YES;
    //View.settings.myLocationButton = NO;
    View.settings.allowScrollGesturesDuringRotateOrZoom = YES;
    View.settings.compassButton = YES;
    //View.settings.indoorPicker = NO;
    //View.settings.scrollGestures = NO;
    //View.settings.zoomGestures = NO;
    
    //View.mapType = kGMSTypeNone;
    //View.mapType = kGMSTypeHybrid;
    View.mapType = kGMSTypeNormal; //Default
    //View.mapType = kGMSTypeTerrain;
    //View.mapType = kGMSTypeSatellite;
    
    //GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:View.camera.target.latitude longitude:View.camera.target.latitude zoom:10];
    //View.camera = camera;
}

- (void) addLocationPinInMap_Lat:(CGFloat )Lat
                            Long:(CGFloat)Long
                           Title:(NSString *)strTitle
                        SubTitle:(NSString *)strSubTitle
                        pinImage:(UIImage *)pinImage
                          Onview:(GMSMapView *)View
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@(Lat).stringValue forKey:_keyLatitude];
    [dic setValue:@(Long).stringValue forKey:_keyLongitude];
    [dic setValue:strTitle forKey:_keyZip];
    [dic setValue:strTitle forKey:_keyTitle];
    [dic setValue:strSubTitle forKey:_keySubTitle];
    
    [arrLocationPin addObject:dic];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.appearAnimation = kGMSMarkerAnimationPop; //Animation
    
    //Set Values
    marker.position = CLLocationCoordinate2DMake(Lat,Long);
    marker.title = strTitle;
    marker.snippet = strSubTitle;
    if (pinImage == nil) { }
    else
    {
        marker.icon = pinImage;
    }
    marker.userData = dic;
    marker.map = View;
    
    CGFloat curretZoom = View.camera.zoom;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:Lat
                                                            longitude:Long
                                                                 zoom:curretZoom];
    View.camera = camera;
}

#pragma mark Default Markers
- (void) manage_DefaultMarkers
{
    arrLocationPin = [[NSMutableArray alloc] init];
    
    [self addLocationPinInMap_Lat:22.303708
                             Long:71.081543
                            Title:@"Location Title_1"
                         SubTitle:@"Location Sub-Title_1"
                         pinImage:nil
                           Onview:self.mapContainerView];
    
    [self addLocationPinInMap_Lat:09.337962 Long:77.607422
                            Title:@"Location Title_2"
                         SubTitle:@"Location Sub-Title_2"
                         pinImage:nil
                           Onview:self.mapContainerView];
    
    [self addLocationPinInMap_Lat:26.195790 Long:93.863196
                            Title:@"Location Title_3"
                         SubTitle:@"Location Sub-Title_3"
                         pinImage:nil
                           Onview:self.mapContainerView];
    
    [self addLocationPinInMap_Lat:34.953493
                             Long:76.586423
                            Title:@"Location Title_4"
                         SubTitle:@"Location Sub-Title_4"
                         pinImage:nil
                           Onview:self.mapContainerView];
    
    [self addLocationPinInMap_Lat:20.593684
                             Long:78.962880
                            Title:@"Location Title_5"
                         SubTitle:@"Location Sub-Title_5"
                         pinImage:nil
                           Onview:self.mapContainerView];
}
#pragma mark Custome Markers
- (void) manage_CustomeMarkers
{
    arrLocationPin = [[NSMutableArray alloc] init];
    
    [self addLocationPinInMap_Lat:30.047699
                             Long:77.255859
                            Title:@"Title_1"
                         SubTitle:@"Sub-Title_1"
                         pinImage:[UIImage imageNamed:@"pin_2"]
                           Onview:self.mapContainerView_Custome];
    
    [self addLocationPinInMap_Lat:28.127706
                             Long:73.564453
                            Title:@"Title_2"
                         SubTitle:@"Sub-Title_2"
                         pinImage:[UIImage imageNamed:@"pin_3"]
                           Onview:self.mapContainerView_Custome];
    
    [self addLocationPinInMap_Lat:27.972572
                             Long:79.980469
                            Title:@"Title_3"
                         SubTitle:@"Sub-Title_3"
                         pinImage:[UIImage imageNamed:@"pin_4"]
                           Onview:self.mapContainerView_Custome];
    
    [self addLocationPinInMap_Lat:25.539963
                             Long:86.660156
                            Title:@"Title_4"
                         SubTitle:@"Sub-Title_4"
                         pinImage:[UIImage imageNamed:@"pin_5"]
                           Onview:self.mapContainerView_Custome];
    
    [self addLocationPinInMap_Lat:22.245887
                             Long:84.726563
                            Title:@"Title_5"
                         SubTitle:@"Sub-Title_5"
                         pinImage:[UIImage imageNamed:@"pin_6"]
                           Onview:self.mapContainerView_Custome];
    
    [self addLocationPinInMap_Lat:23.056989
                             Long:76.992188
                            Title:@"Title_6"
                         SubTitle:@"Sub-Title_6"
                         pinImage:[UIImage imageNamed:@"pin_7"]
                           Onview:self.mapContainerView_Custome];
    
    [self addLocationPinInMap_Lat:22.327212
                             Long:71.542969
                            Title:@"Title_7"
                         SubTitle:@"Sub-Title_7"
                         pinImage:[UIImage imageNamed:@"pin_8"]
                           Onview:self.mapContainerView_Custome];
    
    [self addLocationPinInMap_Lat:21.020419
                             Long: 81.65039
                            Title:@"Title_8"
                         SubTitle:@"Sub-Title_8"
                         pinImage:[UIImage imageNamed:@"pin_9"]
                           Onview:self.mapContainerView_Custome];
    
   [self addLocationPinInMap_Lat:19.204835
                            Long:74.531250
                           Title:@"Title_9"
                        SubTitle:@"Sub-Title_9"
                        pinImage:[UIImage imageNamed:@"pin_4"]
                          Onview:self.mapContainerView_Custome];
   
   
   [self addLocationPinInMap_Lat:18.706090
                            Long:81.386719
                           Title:@"Title_10"
                        SubTitle:@"Sub-Title_11"
                        pinImage:[UIImage imageNamed:@"pin_6"]
                          Onview:self.mapContainerView_Custome];
   
   [self addLocationPinInMap_Lat:16.359674
                            Long:75.937500
                           Title:@"Title_12"
                        SubTitle:@"Sub-Title_12"
                        pinImage:[UIImage imageNamed:@"pin_8"]
                          Onview:self.mapContainerView_Custome];
   
   [self addLocationPinInMap_Lat:22.379286
                            Long: 75.278320
                           Title:@"Title_13"
                        SubTitle:@"Sub-Title_13"
                        pinImage:[UIImage imageNamed:@"pin_2"]
                          Onview:self.mapContainerView_Custome];
}

#pragma mark - Button Action Method
- (void)btnBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDefaultAction
{
    [self manage_SelectButton:btnDefault];
}

- (IBAction)btnCustomeAction
{
    [self manage_SelectButton:btnCustome];
}


#pragma mark - Markers Tap Action Methods
- (UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    if (mapView == self.mapContainerView_Custome)
    {
        MapAnnotationView *mapAnnotation = (MapAnnotationView *)[[[NSBundle mainBundle] loadNibNamed:@"MapAnnotationView" owner:self options:nil] objectAtIndex:0];
        NSDictionary *dict = marker.userData;
    
        mapAnnotation.backgroundColor = [UIColor clearColor];
        mapAnnotation.viewMain.layer.cornerRadius = 8.0f;
        mapAnnotation.viewMain.layer.masksToBounds=YES;
        mapAnnotation.imgPhoto.image = [UIImage imageNamed:[dict valueForKey:_keyZip]];
        mapAnnotation.lblTitle.text = [NSString stringWithFormat:@"%@", [dict valueForKey:_keyTitle]];
        mapAnnotation.lblSubTitle.text = [NSString stringWithFormat:@"%@", [dict valueForKey:_keySubTitle]];
    
        return mapAnnotation;
    }
    return nil;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    if (mapView == self.mapContainerView_Custome)
    {
        NSDictionary *dict = marker.userData;
        NSString *strTitle = [NSString stringWithFormat:@"You have Tapped...\n %@ | %@",[dict valueForKey:_keyTitle],[dict valueForKey:_keySubTitle]];
        [Function showAlertMessage:strTitle autoHide:YES];
    }
}

@end
