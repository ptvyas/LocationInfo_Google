//
//  WSModel.h
//  PTVyasFramework
//
//  Created by Piyush Vyas on 3/28/17.
//  Copyright © 2017 whiteorangesoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"
#import "Function.h"

#define method_POST                @"POST"
#define method_GET                 @"GET"
#define method_DELETE                @"DELETE"

@interface WSModel : NSObject {
}

@property (copy, nonatomic) void (^responseData)(NSDictionary *dic, NSError *error);

+ (void) CalledWebService:(NSString *)url
                    mehod:(NSString *)method
               parameters:(NSDictionary *)parameters
               headers:(NSDictionary *)headers
             responseData:(void (^)(NSDictionary *dic, NSError *error))responseData;

- (NSArray *) responseArray;
- (NSDictionary *) responseDictionary;
- (NSError *) responseError;
@end
