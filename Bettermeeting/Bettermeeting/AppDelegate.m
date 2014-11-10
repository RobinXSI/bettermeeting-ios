#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "MeetingViewController.h"
#import "Meeting.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [deviceToken description];
    NSString *tokenWithoutWhitespace = [[[token stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:tokenWithoutWhitespace forKey:@"pushToken"];
    NSLog(@"%@", tokenWithoutWhitespace);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Registration failed: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSString *meetingId = [[userInfo valueForKey:@"aps"] valueForKey:@"meetingId"];
    NSLog(@"Received Notification");
    NSLog(@"%@", meetingId);
    
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a Remote Notification"
                                                            message:[NSString stringWithFormat:@"Your App name received this notification while it was running:\n%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"Show"
                                                  otherButtonTitles:@"Cancel", nil];
        
        
        [alertView show];
    }
    
    /*
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.]
    MeetingViewController *meetingViewController = [[MeetingViewController alloc] init];
    
    Meeting *meeting = [[Meeting alloc] init];
    meeting.goal = @"Test bestanden";
    meetingViewController.meeting = meeting;
    [navigationController.visibleViewController.navigationController pushViewController:meetingViewController animated:NO];
     
     */
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        NSLog(@"OK Button pressed");
        //MeetingViewController *meetingViewController = [[MeetingViewController alloc] init];
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        MeetingViewController *meetingViewController = [mainstoryboard instantiateViewControllerWithIdentifier:@""];
        Meeting *meeting = [[Meeting alloc] init];
        meeting.goal = @"Test bestanden";
        meetingViewController.meeting = meeting;
        
        
        
        [self.window.rootViewController presentViewController:meetingViewController animated:YES completion:nil];
    } else {
        NSLog(@"Cancel Button pressed");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
