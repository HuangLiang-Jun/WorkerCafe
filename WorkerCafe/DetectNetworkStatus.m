//
//  DetectNetworkStatus.m
//  twBike
//
//  Created by huang on 2016/11/28.
//  Copyright © 2016年 Huang. All rights reserved.
//

#import "DetectNetworkStatus.h"
#import "Reachability.h"

@interface DetectNetworkStatus()
{
    
    Reachability *serverReach ;
}

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) Reachability* reachability;
@end

static DetectNetworkStatus *_detectNetworkStatus;

@implementation DetectNetworkStatus
HMSingletonM(DetectNetworkStatus)

+ (instancetype) shareInstanceWithVC:(UIViewController *)vc {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _detectNetworkStatus = [DetectNetworkStatus sharedDetectNetworkStatus];
        
    });
    _detectNetworkStatus.vc = vc;
    
    return _detectNetworkStatus;
    
}

- (instancetype) initWithVC:(UIViewController *)viewController{
    self = [super init];
    
    if (self) {
        _detectNetworkStatus.vc = viewController;
        
    }
    return self;
}

//** 監測網路的方式     **//
//** 針對網路或對應網址  **//

-(void) startDetectNetworkStatus {

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(currentNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    [self currentNetworkStatus];
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    
    
    
}

-(void) startDetectNetworkWithHost:(NSString *)hostName {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(currentNetworkStatus) name:kReachabilityChangedNotification object:nil];
   
 
    [self currentNetworkStatus];
    _reachability = [Reachability reachabilityWithHostName:hostName];
    [_reachability startNotifier];
    
    
}

//** 網路狀態改變 **//

- (void) currentNetworkStatus {
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    
    if ([wifi currentReachabilityStatus] != NotReachable || [conn currentReachabilityStatus] != NotReachable ) {
        
        NSLog(@"Online");
        [_detectNetworkStatus.delegate networkConnectionWith:true];
        
    }else{
        NSLog(@"offLine");
        [_detectNetworkStatus.delegate networkConnectionWith:false];
    }
}


//** 沒有連網會出現警告 **//

- (void) noNetworkRemind{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"目前沒有網路"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    
    [alert addAction:ok];
    [_vc presentViewController:alert animated:TRUE completion:nil];
    
}




@end
