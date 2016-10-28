//
//  ReachabilityManager.h
//  Created by Nitish Makhija on 27/10/16.


#import <Foundation/Foundation.h>

@interface ReachabilityManager : NSObject

/**
 Network connectivity singleton

 @return instance variable for RCReachabilityManager
 */
+ (instancetype)sharedManager;


/**
 Gives the device reachablity status for the host

 @return Boolean indicating device reachablity status for the host
 */
+ (BOOL)isInternetAvailable;

@end
