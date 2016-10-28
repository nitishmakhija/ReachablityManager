//
//  ReachabilityManager.m
//  RoadCast
//
//  Created by Nitish Makhija on 27/10/16.

#import "ReachabilityManager.h"
#import "APLReachability.h"

#error replace with your host ddress
static NSString *kHostAddress = @"www.google.com";

@interface ReachabilityManager ()

@property (nonatomic) APLReachability *hostReachability;
@property (nonatomic) APLReachability *internetReachability;

@end

@implementation ReachabilityManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        self.hostReachability = [APLReachability reachabilityWithHostName:kHostAddress];
        [self.hostReachability startNotifier];
        
        self.internetReachability = [APLReachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ReachabilityManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    
    return sharedManager;
}

- (void)reachabilityChanged:(NSNotification *)notification {
    APLReachability *currentReachablity = [notification object];

    if (currentReachablity == self.hostReachability) {
        //host is unreachable
        //internet is not available
        NetworkStatus internetStatus = [currentReachablity currentReachabilityStatus];
        
        switch (internetStatus) {
            case NotReachable:
                //change the online status to no here
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"internetReachablity"];
                NSLog(@"No internet available");
                break;
                
            case ReachableViaWWAN:
                if (![currentReachablity connectionRequired]) {
                    //change the online status to yes
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"internetReachablity"];
                    NSLog(@"YES internet available");
                }
                break;
                
            case ReachableViaWiFi:
                //change the status to yes
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"internetReachablity"];
                NSLog(@"YES internet available");
                break;
                
            default:
                break;
        }

    }
    if (currentReachablity == self.internetReachability) {
        //checking the internet connectivity
        //just checks wheather the device is connected to a routing interface
        //host reachablity can tell the same thing
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self.hostReachability stopNotifier];
    [self.internetReachability stopNotifier];
}

+ (BOOL)isInternetAvailable {
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"internetReachablity"] isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}

@end
