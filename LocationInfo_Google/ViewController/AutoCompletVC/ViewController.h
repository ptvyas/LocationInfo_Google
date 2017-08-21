//
//  ViewController.h
//  LocationInfo_Google
//
//  Copyright © 2017 Vyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Function.h"

@interface ViewController : UIViewController
{
    //----------------->
    __weak IBOutlet UIView *viewTitlebar;
    __weak IBOutlet UIButton *btnBack;
    __weak IBOutlet UILabel *lblTitle;
    
    //----------------->
    __weak IBOutlet UIView *viewButton;
    
    //----------------->
    __weak IBOutlet UIView *viewAddress;
    __weak IBOutlet NSLayoutConstraint *lc_ViewAddress_y;
    __weak IBOutlet UILabel *lblAddress;
}

- (IBAction)btnBackAction;

- (IBAction)btnFullScreenControlAction;
@end
