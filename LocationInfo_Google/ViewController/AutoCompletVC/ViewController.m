//
//  ViewController.m
//  LocationInfo_Google
//
//  Copyright © 2017 Vyas. All rights reserved.
//

#import "ViewController.h"

#import <GooglePlaces/GooglePlaces.h>
#define durationAnimation           0.30f

@interface ViewController () <UITextFieldDelegate, UISearchDisplayDelegate>
{
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //------------------------------>
    //View-Button
    viewButton.layer.cornerRadius = 5;
    viewButton.layer.masksToBounds = YES;
    
    //-------------------------------->
    //Address-View
    viewAddress.layer.cornerRadius = 5;
    viewAddress.layer.borderColor = [UIColor whiteColor].CGColor;
    viewAddress.layer.borderWidth = 1.0f;
    viewAddress.layer.masksToBounds = YES;
    
    lblAddress.text = @"";
    lblAddress.numberOfLines = 0;
    
    [self manage_Animation_AddressView_Show:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void) manage_Animation_AddressView_Show:(BOOL)show
{
    if (show == NO)
    {
        viewAddress.backgroundColor = viewTitlebar.backgroundColor;
        //Hide Button With Animation
        [UIView animateWithDuration:0.30f
                         animations:^{
                             lc_ViewAddress_y.constant = -(20 + viewAddress.frame.size.height);
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished)
         {
             //Code
         }];
    }
    else
    {
        viewAddress.backgroundColor = viewTitlebar.backgroundColor;
        
        lblAddress.numberOfLines = 0;
        lblAddress.textColor = [UIColor whiteColor];
        
        //Show Button With Animation
        [UIView animateWithDuration:0.30f
                         animations:^{
                             lc_ViewAddress_y.constant = 20;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished)
         {
             //Code
         }];
    }
}

#pragma mark - Button Action Methods
- (IBAction)btnBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnFullScreenControlAction
{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

#pragma mark - -----------------------------
#pragma mark Google Map Delegate Methods
#pragma mark Full Screen Control
// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
{
    // Do something with the selected place.
    NSLog(@"Place name: %@", place.name);
    NSLog(@"Place address: %@", place.formattedAddress);
    NSLog(@"Place attributions: %@", place.attributions.string);
    NSLog(@"Place location: %f,%f",place.coordinate.latitude,place.coordinate.longitude);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *strAddress = @"";
    NSString *strAdd_Lat = @"";
    NSString *strAdd_Long = @"";
    
    strAddress = place.formattedAddress;
    strAdd_Lat= [NSString stringWithFormat:@"%0.4f",place.coordinate.latitude];
    strAdd_Long = [NSString stringWithFormat:@"%0.4f",place.coordinate.longitude];
    strAddress = [NSString stringWithFormat:@"Latitude Longitude:\n%@, %@\n\n-- = -- = --\n\nAddress:\n%@",strAdd_Lat,strAdd_Long,strAddress];
    lblAddress.text = strAddress;
    
    [self manage_Animation_AddressView_Show:YES];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error
{
    NSLog(@"error: %ld", (long)[error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *strError = [error localizedDescription];
    [Function showAlertMessage:strError autoHide:NO];
    
    lblAddress.text = [NSString stringWithFormat:@"%@",strError];
    [self manage_Animation_AddressView_Show:YES];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController
{
    NSLog(@"Autocomplete was cancelled.");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
