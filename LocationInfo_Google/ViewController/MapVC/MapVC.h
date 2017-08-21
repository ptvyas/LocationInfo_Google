//
//  MapVC.h
//  LocationInfo_Google
//
//  Created by WOS_iMac_2 on 8/5/17.
//  Copyright © 2017 Vyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapVC : UIViewController
{
    __weak IBOutlet UIView *viewAddress;
    __weak IBOutlet UILabel *lblLocation;
    
}

- (IBAction)btnBackAction;

@end
