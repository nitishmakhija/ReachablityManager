# ReachablityManager
A simple reachability singleton manager using apple's reachability abstraction
Written by Nitish Makhija, October 2016.

Installation

Just drop the files in your Xcode project.

Usage

#import "ReachablityManager" in AppDelegate 

then simply use '[ReachablityManager sharedManager];' in your '- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;' method.

and then use [ReachablityManager isInternetAvailable]; which returns a boolean for device reachablity status for the host address provided.
