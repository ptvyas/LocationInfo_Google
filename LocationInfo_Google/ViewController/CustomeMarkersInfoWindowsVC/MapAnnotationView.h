//
//  MapAnnotationView.h
//  izitin
//
//  Created by WOS_iMac_2 on 7/5/17.
//  Copyright © 2017 wos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapAnnotationView : UIView

@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@end
