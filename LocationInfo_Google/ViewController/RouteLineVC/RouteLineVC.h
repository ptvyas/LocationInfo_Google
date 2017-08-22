//
//  RouteLineVC.h
//  LocationInfo_Google
//
//  Created by WOS_iMac_2 on 8/8/17.
//  Copyright © 2017 Vyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteLineVC : UIViewController
{
    
    __weak IBOutlet UIButton *btnReset;
    
    __weak IBOutlet UIView *viewAddress;
    
    __weak IBOutlet UIView *ViewFrom;
    __weak IBOutlet UILabel *lblAddress_From;
    
    __weak IBOutlet UIView *ViewTo;
    __weak IBOutlet UILabel *lblAddress_To;

    __weak IBOutlet UIButton *btnDrowRouteLine;

    __weak IBOutlet UIButton *btnLocation;
    
    __weak IBOutlet UIView *viewDone;
    __weak IBOutlet UILabel *lblAddress;
    __weak IBOutlet NSLayoutConstraint *lc_ViewDone_y;
    __weak IBOutlet UIButton *btnDone;
    __weak IBOutlet NSLayoutConstraint *lc_btnDone_Height;
}

- (IBAction)btnBackAction;
- (IBAction)btnResetAction;

- (IBAction)btnFromAction;
- (IBAction)btnToAction;

- (IBAction)btnDrowRouteLineAction;

- (IBAction)btnDoneAction;

@end
