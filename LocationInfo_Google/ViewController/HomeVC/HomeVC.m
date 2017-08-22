//
//  HomeVC.m
//  LocationInfo_Google
//
//  Created by WOS_iMac_2 on 8/5/17.
//  Copyright © 2017 Vyas. All rights reserved.
//

#import "HomeVC.h"
#import "HomeCell.h"

#import "Constant.h"

#import "ViewController.h"
#import "MapVC.h"
#import "RouteLineVC.h"
#import "CustomeMarkersInfoWindowsVC.h"

#define Title_SearchAutoComplet                 @"Search Autocomplete"
#define Title_GoogleMap                         @"Google Map"
#define Title_GoogleRouteLine                   @"Google Route line"
#define Title_GoogleMarkers                     @"Google Markers"

@interface HomeVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arrTableList;
}
@end

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //------------------------>
    arrTableList = [[NSMutableArray alloc] init];
    
    //------------------------>
    tblHome.delegate = self;
    tblHome.dataSource = self;
    tblHome.estimatedRowHeight = UITableViewAutomaticDimension;
    tblHome.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //tblHome.backgroundColor = Color_PopupBG;
    //tblHome.layer.cornerRadius = 5;
    tblHome.layer.masksToBounds = YES;
    
    //------------------------>
    NSString *strTitle = @"";
    NSString *strSubTitle = @"";
    
    strTitle = Title_SearchAutoComplet;
    strSubTitle = @"When you start a search on Google, you can find the information you’re looking for faster using search predictions.";
    [self addObjectInTableList_Title:strTitle SubTitle:strSubTitle];
    
    strTitle = Title_GoogleMap;
    strSubTitle = @"Select Current Place and Show Details on a Google Map.";
    [self addObjectInTableList_Title:strTitle SubTitle:strSubTitle];
    
    strTitle = Title_GoogleRouteLine;
    strSubTitle = @"It is drawn as a physical line between the points specified in path";
    [self addObjectInTableList_Title:strTitle SubTitle:strSubTitle];
    
    strTitle = Title_GoogleMarkers;
    strSubTitle = @"By default, markers use a standard icon that has the common Google Maps look and feel. If you want to customize your marker, you can change the color of the default marker, or replace the marker image with a custom icon, or change other properties of the marker.";
    [self addObjectInTableList_Title:strTitle SubTitle:strSubTitle];
    
    [tblHome reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void) addObjectInTableList_Title:(NSString *)strTitle SubTitle:(NSString *)strSubTitle
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:strTitle forKey:_keyTitle];
    [dic setValue:strSubTitle forKey:_keySubTitle];
    
    [arrTableList addObject:dic];
}

#pragma mark - Tableview Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int noOfRow = 0;
    noOfRow = (int)arrTableList.count;
    //noOfRow = 0;
    
    if (noOfRow == 0) {
        //NSString *Mess = [MESS_NoDataFound uppercaseString];
        //[Function setPlaceholder_OnTableView:tblLocation PlaceHolderText:Mess image:nil];
    }
    else {
        //tableView.backgroundView = [[UIView alloc] init];
    }
    return noOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *strTitle = @"";
    NSString *strSubTitle = @"";
    
    if (arrTableList.count == 0) {
        return cell;
    }
    
    dic = [arrTableList objectAtIndex:indexPath.row];
    strTitle = [dic valueForKey:_keyTitle];
    strSubTitle = [dic valueForKey:_keySubTitle];;

    cell.lblTitle.text = strTitle;
    [Function setLabelDesign_label:cell.lblTitle text:strTitle textColor:[UIColor blackColor] font:Font_Helvetica_Bold fontSize:14];
    cell.lblTitle.numberOfLines = 0;
    
    cell.lblSubTitle.text = strSubTitle;
    [Function setLabelDesign_label:cell.lblSubTitle text:strSubTitle textColor:[UIColor lightGrayColor] font:Font_Helvetica_Light fontSize:12];
    cell.lblSubTitle.numberOfLines = 0;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    tableView.separatorColor = [UIColor grayColor];
    
    [self.view layoutIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic = [arrTableList objectAtIndex:indexPath.row];
    
    NSString *strTitle = @"";
    strTitle = [dic valueForKey:_keyTitle];
    strTitle  = [strTitle uppercaseString];
    
    if ([strTitle isEqualToString:[Title_SearchAutoComplet uppercaseString]])
    {
        ViewController *objVC = loadViewController(@"Main", @"ViewController");
        [self.navigationController pushViewController:objVC animated:YES];
    }
    else if ([strTitle isEqualToString:[Title_GoogleMap uppercaseString]])
    {
        MapVC *objVC = loadViewController(@"Main", @"MapVC");
        [self.navigationController pushViewController:objVC animated:YES];
    }
    else if ([strTitle isEqualToString:[Title_GoogleRouteLine uppercaseString]])
    {
        RouteLineVC *objVC = loadViewController(@"Main", @"RouteLineVC");
        [self.navigationController pushViewController:objVC animated:YES];
    }
    else if ([strTitle isEqualToString:[Title_GoogleMarkers uppercaseString]]) {
        CustomeMarkersInfoWindowsVC *objVC = loadViewController(@"Main", @"CustomeMarkersInfoWindowsVC");
        [self.navigationController pushViewController:objVC animated:YES];
    }
    else {
        [Function showAlertMessage:Mess_SomethingWasWrong autoHide:YES];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//-------------------------------------------------------------------------------->
/*
 
 - (UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
 {
 MapAnnotationView *mapAnnotation = (MapAnnotationView *)[[[NSBundle mainBundle] loadNibNamed:@"MapAnnotationView" owner:self options:nil] objectAtIndex:0];
 NSDictionary *dict = marker.userData;
 
 [self APIForNavigateDrawLineAddressGet:[[dict valueForKey:@"lat"] doubleValue] Lng:[[dict valueForKey:@"lng"] doubleValue]];
 
 mapAnnotation.viewMain.layer.cornerRadius = 4.0f;
 mapAnnotation.viewMain.layer.masksToBounds=YES;
 mapAnnotation.lblTitle.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"stand_name"]];
 mapAnnotation.lblDistance.text = [NSString stringWithFormat:@"%@ away",[dict valueForKey:@"distance"]];
 [Function ImageProgressIndicator:mapAnnotation.imgPhoto URL:[NSURL URLWithString:[dict valueForKey:@"profile_pic"]] defaultImg:[UIImage imageNamed:IMG_EMPTY]];
 return mapAnnotation;
 }
 - (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
 {
 NSDictionary *dict = marker.userData;
 
 Popup_ProductVC *objPopupVC = loadViewController(storybord_Main, @"Popup_ProductVC");
 objPopupVC.delegate = self;
 objPopupVC.strProductDistance = [NSString stringWithFormat:@"%@",[dict valueForKey:@"distance"]];
 objPopupVC.strProductTitle1 = [NSString stringWithFormat:@"%@",[dict valueForKey:@"stand_name"]];
 objPopupVC.strProductTitle2 = [NSString stringWithFormat:@"%@",[dict valueForKey:@"address"]];
 objPopupVC.strProductImg = [NSString stringWithFormat:@"%@",[dict valueForKey:@"profile_pic"]];
 strValForSellerID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"seller_id"]];
 
 [Function Popup_Show_onVC:objPopupVC BGColor:Color_Clear];
 
 }
 
 -(bool)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
 
 //    UIButton *directionsButton = [[UIButton alloc] init];
 //    [directionsButton setTitle:@"" forState:UIControlStateNormal];
 //    [directionsButton setImage:[UIImage imageNamed:@"Correct-select"] forState:UIControlStateNormal];
 //    [directionsButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
 //    [directionsButton setFrame:CGRectMake(16, self.mapContainerView.frame.size.height - 66, 50, 50)];
 //    [directionsButton addTarget:self action:@selector(markerClick) forControlEvents:UIControlEventTouchUpInside];
 //    [directionsButton setTag:1];
 //    [[self view] addSubview:directionsButton];
 
 return NO;
 }
 
*/
@end
