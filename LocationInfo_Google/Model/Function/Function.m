//
//  Function.m
//  AutoComplet_GoogleAPI
//
//  Created by WOS_iMac_2 on 8/4/17.
//  Copyright © 2017 Vyas. All rights reserved.
//

#import "Function.h"

@implementation Function

#pragma mark - AlertView
+ (void) showAlertMessage:(NSString *)strMess autoHide:(BOOL)autoHide {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strMess message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    //Auto Dismiss
    if (autoHide == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:^{ //Set Completion Code
            }];
        });
    }
    else {
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        //Set Completion Code
                                    }]];
    }
    //Show Alert
    //[view presentViewController:alertController animated:YES completion:nil]; //set VC object for show alert
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void) showAlertMessage:(NSString *)strMess autoHide:(BOOL)autoHide OnView:(UIViewController *)view {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strMess message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    //Auto Dismiss
    if (autoHide == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:^{ //Set Completion Code
            }];
        });
    }
    else {
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //Set Completion Code
        }]];
    }
    
    //Show Alert
    [view presentViewController:alertController animated:YES completion:nil]; //set VC object for show alert
    //[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - String
+ (BOOL) string_isEmpty:(NSString *)str {
    if(str.length==0
       || [str isKindOfClass:[NSNull class]]
       || [str isEqualToString:@""]
       || [str isEqualToString:NULL]
       || [str isEqualToString:@"(null)"]
       || [str isEqualToString:[@"(null)" uppercaseString]]
       || str==nil
       || [str isEqualToString:@"<null>"]
       || [str isEqualToString:[@"<null>" uppercaseString]]) {
        return YES;
    }
    return NO;
}

+ (NSString *) placeHolderValue:(NSString *)value1 :(NSString *)value2 {
    if ([Function string_isEmpty:value1] == YES) {
        return value2;
    }
    return value1;
}

+ (NSString *) trimmingString:(NSString *)str {
    if ([Function string_isEmpty:str] == YES) {
        return @"";
    }
    NSString *strValue =  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return strValue;
}

+ (NSString *) replaceString:(NSString *)strMain replaceValue:(NSString *)strReplaceValue  withString:(NSString *)strWithString {
    NSString *newString = @"";
    newString = [strMain stringByReplacingOccurrencesOfString:strReplaceValue withString:strWithString];
    return newString;
}

+ (NSString *) keyExisteOnDictionary:(NSMutableDictionary *)dic key:(NSString *)strKey {
    if([dic valueForKey:@"strKey"] != nil) {
        // The key existed...
        //return YES;
        return @" ";
    }
    else {
        // No joy...
        //return NO;
        return [dic valueForKey:strKey];
    }
    //return NO;
    return @" ";
}

#pragma mark - Label
+ ( void) setLabelDesign_label:(UILabel *)label text:(NSString *)strText textColor:(UIColor *)textColor font:(NSString *)fontName fontSize:(CGFloat)fontSize
{
    //Set Value
    NSString *labelVale = [Function trimmingString:strText];
    label.text = labelVale;
    
    //Set Color
    label.textColor = textColor;
    
    //set font and Size
    label.font = [UIFont fontWithName:fontName size:fontSize];
}

#pragma mark - TableView
+ (void) setPlaceholder_OnTableView:(UITableView *)tableView PlaceHolderText:(NSString *)strPlaceHolder image:(UIImage *)imgPlaceHolder
{
    CGRect frame;
    UIView *viewPlaceHolder;
    UILabel *lblMessage;
    UIImageView *imgView;
    
    frame = tableView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    viewPlaceHolder = [[UIView alloc] initWithFrame:frame];
    viewPlaceHolder.backgroundColor = [UIColor whiteColor];
    
    frame = tableView.frame;
    frame.origin.x = 0;
    frame.size.width = CGRectGetWidth(tableView.frame);
    if (imgPlaceHolder == nil) {
        frame.origin.y = 0;
        frame.size.height = 0;
    }
    else {
        frame.origin.y = 20;
        frame.size.height = tableView.frame.size.height*0.10;
    }
    imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.image = imgPlaceHolder;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [viewPlaceHolder addSubview:imgView];
    
    frame = tableView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0 + CGRectGetHeight(imgView.frame) + 16;
    frame.size.height = tableView.frame.size.height*0.10;
    lblMessage = [[UILabel alloc] initWithFrame:frame];
    NSString *mess = [Function trimmingString:strPlaceHolder];
    if ([Function string_isEmpty:mess]) {
        mess = @"no data available!";
    }
    [Function setLabelDesign_label:lblMessage text:strPlaceHolder textColor:[UIColor lightGrayColor] font:Font_Helvetica fontSize:18];
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.numberOfLines = 2;
    lblMessage.text = mess;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.shadowOffset = CGSizeMake(0, 2);
    
    [viewPlaceHolder addSubview:lblMessage];
    //imgView.backgroundColor = [UIColor yellowColor];
    //lblMessage.backgroundColor = [UIColor redColor];
    
    //[tableView addSubview:viewPlaceHolder];
    tableView.backgroundView = viewPlaceHolder;
}

@end
