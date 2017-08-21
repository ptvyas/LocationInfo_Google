//
//  Function.h
//  AutoComplet_GoogleAPI
//
//  Created by WOS_iMac_2 on 8/4/17.
//  Copyright © 2017 Vyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

#import "AppDelegate.h"
#import "Constant.h"


@interface Function : NSObject

#pragma mark - AlertView
+ (void) showAlertMessage:(NSString *)strMess autoHide:(BOOL)autoHide;
+ (void) showAlertMessage:(NSString *)strMess autoHide:(BOOL)autoHide OnView:(UIViewController *)view;

#pragma mark - String
+ (BOOL) string_isEmpty:(NSString *)str;
+ (NSString *) placeHolderValue:(NSString *)value1 :(NSString *)value2;
+ (NSString *) trimmingString:(NSString *)str;

+ (NSString *) replaceString:(NSString *)strMain replaceValue:(NSString *)strReplaceValue  withString:(NSString *)strWithString;
+ (NSString *) keyExisteOnDictionary:(NSMutableDictionary *)dic key:(NSString *)strKey;
#pragma mark - Label
+ ( void) setLabelDesign_label:(UILabel *)label text:(NSString *)strText textColor:(UIColor *)textColor font:(NSString *)fontName fontSize:(CGFloat)fontSize;

#pragma mark - TableView
+ (void) setPlaceholder_OnTableView:(UITableView *)tableView PlaceHolderText:(NSString *)strPlaceHolder image:(UIImage *)imgPlaceHolder;
@end
