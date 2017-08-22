//
//  CustomeMarkersInfoWindowsVC.h
//  LocationInfo_Google
//
//  Created by WOS_iMac_2 on 8/19/17.
//  Copyright © 2017 Vyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeMarkersInfoWindowsVC : UIViewController
{
    __weak IBOutlet UIView *viewButton;
    __weak IBOutlet UIButton *btnDefault;
    __weak IBOutlet UILabel *btnCurretButton;
    __weak IBOutlet NSLayoutConstraint *lc_btnCurretnButton_x;
    
    __weak IBOutlet UIButton *btnCustome;
}

- (IBAction)btnBackAction;


- (IBAction)btnDefaultAction;
- (IBAction)btnCustomeAction;

@end
