//
//  DetectNetworkStatus.h
//  twBike
//
//  Created by huang on 2016/11/28.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StatusSingleton.h"


@protocol NetworkConnectionDelegate <NSObject>

@optional

-(void) networkConnectionWith:(BOOL)isOnline;

@end

@interface DetectNetworkStatus : NSObject
HMSingletonH(DetectNetworkStatus)

@property (nonatomic, weak) id<NetworkConnectionDelegate> delegate;

+ (instancetype) shareInstanceWithVC:(UIViewController *) vc;

- (instancetype) initWithVC:(UIViewController *)viewController;

- (void) currentNetworkStatus;

- (void) startDetectNetworkStatus;

- (void) startDetectNetworkWithHost:(NSString *)hostName;



@end



