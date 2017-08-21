//
//  WSModel.m
//  PTVyasFramework
//
//  Created by Piyush Vyas on 3/28/17.
//  Copyright © 2017 whiteorangesoftware. All rights reserved.
//

#import "WSModel.h"
#import <AVKit/AVKit.h>
#import "Reachability.h"

#define TimeOutInterval             60.0f
#define MESS_CheckInternetConnction                     @"Please Check Internet Connection"
#define ShowNetworkIndicator(BOOL)          [UIApplication sharedApplication].networkActivityIndicatorVisible = BOOL

@implementation WSModel {
    NSArray *arrData;
    NSDictionary *dicData;
    NSError *errorData;
}

@synthesize responseData;

+ (void) CalledWebService:(NSString *)url
                    mehod:(NSString *)method
               parameters:(NSDictionary *)parameters
                  headers:(NSDictionary *)headers
             responseData:(void (^)(NSDictionary *dic, NSError *error))responseData {
    /*
    //Check Interner Connection
    if ([Function reachabilityCheck] == NO) {
        [Function showAlertMessage:MESS_CheckInternetConnction autoHide:YES];
        return;
    }
     */
    ShowNetworkIndicator(YES);
    NSString *strMethod = [method uppercaseString];
    
    NSLog(@"Token :%@",parameters);
    
#pragma mark GET
    //**************************************************************************************************************************************
    //  GET                 ****************************************************************************************************************
    //**************************************************************************************************************************************
    if ([strMethod isEqualToString:method_GET]) {
        __block NSDictionary * dictResponse = nil;
        __block NSError *jsonError = nil;
        
        NSString *apiNameConvert = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"==============  API URL (%@)  ====================",[method uppercaseString]);
        NSLog(@"%@",apiNameConvert);
        NSLog(@"=============================================");
        
        //Set Header
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeOutInterval];
        [request setTimeoutInterval:TimeOutInterval];
        
        NSArray *arrKey = [headers allKeys];
        for (NSString *str in arrKey) {
            NSString *strHeaderKey =  [Function trimmingString:str];
            NSString *strHeaderValue = [headers valueForKey:strHeaderKey];
            
            [request setValue:strHeaderValue forHTTPHeaderField:strHeaderKey];
        }
        //Set Defalut Header
        
        [request setHTTPMethod:strMethod];
        [request setURL:[NSURL URLWithString:apiNameConvert]];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (data) {
                      //NSData-to-NSDictionary
                      dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                  }
                  else if(error) {
                      NSString *errorMsg;
                      if ([[error domain] isEqualToString:NSURLErrorDomain]) {
                          switch ([error code]) {
                              case NSURLErrorTimedOut:
                                  errorMsg = NSLocalizedString(@"NSURLErrorTimedOut", nil);
                                  jsonError = error;
                                  break;
                              default:
                                  errorMsg = [error localizedDescription];
                                  jsonError = error;
                                  break;
                          }
                      }
                      else {
                          errorMsg = [error localizedDescription];
                          jsonError = error;
                      }
                  }
                  
                  //Send ResponseData
                  if (responseData != NULL) {
                      responseData(dictResponse,jsonError);
                  }
                  NSLog(@"==============  RESPONSE (%@) ==================",[method uppercaseString]);
                  NSLog(@"%@\n\n%@",dictResponse,jsonError);
                  NSLog(@"=============================================");
              });
              ShowNetworkIndicator(NO);
          }] resume];
    }
    
    #pragma mark POST
    //**************************************************************************************************************************************
    //  POST                ****************************************************************************************************************
    //**************************************************************************************************************************************
    else if ([strMethod isEqualToString:method_POST]) {
        __block NSDictionary * dictResponse = nil;
        __block NSError *jsonError = nil;
        
        NSLog(@"==============  API URL (%@)  ====================",[method uppercaseString]);
        NSLog(@"%@",url);
        NSLog(@"=============================================");
        
        //Set Header
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
        urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeOutInterval];
        //[urlRequest setTimeoutInterval:TimeOutInterval];
        
        NSArray *arrKey = [headers allKeys];
        for (NSString *str in arrKey) {
            NSString *strHeaderKey =  [Function trimmingString:str];
            NSString *strHeaderValue = [headers valueForKey:strHeaderKey];
            
            [urlRequest setValue:strHeaderValue forHTTPHeaderField:strHeaderKey];
        }
        //Set Defalut Header
        [urlRequest setHTTPMethod:[method uppercaseString]];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [urlRequest addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
        
        //NSDictionary-to-NSData
        NSData *parametersData = [NSKeyedArchiver archivedDataWithRootObject:parameters];
        NSError *err;
        parametersData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&err];
        
        //Set Parameter Content-Lenght
        NSString *jsonStr = @"";
        jsonStr = [[NSString alloc] initWithData:parametersData encoding:NSUTF8StringEncoding];
        jsonStr = [NSString stringWithFormat:@"%lu", (unsigned long)[parametersData length]];
        [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)jsonStr.length] forHTTPHeaderField:@"Content-Length"];
        [urlRequest setHTTPBody:parametersData]; //Set Parameter Data
        
        NSURLSession *urlSession = [[NSURLSession alloc] init];
        urlSession = [NSURLSession sharedSession];
        [[urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data.length != 0) {
                    //NSData-to-NSDictionary
                    dictResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                }
                else if(error) {
                    NSString *errorMsg;
                    if ([[error domain] isEqualToString:NSURLErrorDomain]) {
                        switch ([error code]) {
                            case NSURLErrorTimedOut:
                                errorMsg = NSLocalizedString(@"NSURLErrorTimedOut", nil);
                                jsonError = error;
                                break;
                            default:
                                errorMsg = [error localizedDescription];
                                jsonError = error;
                                break;
                        }
                    }
                    else {
                        errorMsg = [error localizedDescription];
                        jsonError = error;
                    }
                }
                
                //Send ResponseData
                if (responseData != NULL) {
                    responseData(dictResponse,jsonError);
                }
                NSLog(@"==============  RESPONSE (%@) ==================",[method uppercaseString]);
                NSLog(@"%@\n\n%@",dictResponse,jsonError);
                NSLog(@"=============================================");
            });
            ShowNetworkIndicator(NO);
        }] resume];
    }
    #pragma mark DELETE
    //**************************************************************************************************************************************
    //  DELETE                 ****************************************************************************************************************
    //**************************************************************************************************************************************
    else if ([strMethod isEqualToString:method_DELETE]) {
        __block NSDictionary * dictResponse = nil;
        __block NSError *jsonError = nil;
        
        NSString *apiNameConvert = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"==============  API URL (%@)  ====================",[method uppercaseString]);
        NSLog(@"%@",apiNameConvert);
        NSLog(@"=============================================");
        
        //Set Header
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeOutInterval];
        [request setTimeoutInterval:TimeOutInterval];
        
        NSArray *arrKey = [headers allKeys];
        for (NSString *str in arrKey) {
            NSString *strHeaderKey =  [Function trimmingString:str];
            NSString *strHeaderValue = [headers valueForKey:strHeaderKey];
            
            [request setValue:strHeaderValue forHTTPHeaderField:strHeaderKey];
        }
        //Set Defalut Header
        
        [request setHTTPMethod:strMethod];
        [request setURL:[NSURL URLWithString:apiNameConvert]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (data) {
                      //NSData-to-NSDictionary
                      dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                  }
                  else if(error) {
                      NSString *errorMsg;
                      if ([[error domain] isEqualToString:NSURLErrorDomain]) {
                          switch ([error code]) {
                              case NSURLErrorTimedOut:
                                  errorMsg = NSLocalizedString(@"NSURLErrorTimedOut", nil);
                                  jsonError = error;
                                  break;
                              default:
                                  errorMsg = [error localizedDescription];
                                  jsonError = error;
                                  break;
                          }
                      }
                      else {
                          errorMsg = [error localizedDescription];
                          jsonError = error;
                      }
                  }
                  
                  //Send ResponseData
                  if (responseData != NULL) {
                      responseData(dictResponse,jsonError);
                  }
                  NSLog(@"==============  RESPONSE (%@) ==================",[method uppercaseString]);
                  NSLog(@"%@\n\n%@",dictResponse,jsonError);
                  NSLog(@"=============================================");
              });
              ShowNetworkIndicator(NO);
          }] resume];
    }
}

- (void) set_responseArray:(NSArray *)arr {
    arrData = [[NSArray alloc] init];
    arrData = arr;
}

- (void) set_responseDictionary:(NSDictionary *)dic {
    dicData = [[NSDictionary alloc] init];
    dicData = dic;
}

- (void) set_responseError:(NSError *)error {
    errorData = [[NSError alloc] init];
    errorData = error;
}

- (NSArray *) responseArray {
    return arrData;
}

- (NSDictionary *) responseDictionary {
    return dicData;
}

- (NSError *) responseError {
    return errorData;
}
@end
