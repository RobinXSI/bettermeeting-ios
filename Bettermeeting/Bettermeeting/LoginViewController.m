#import "LoginViewController.h"
#import "User.h"
#import "APIService.h"
#import "UserService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    User *actualUser;
    APIService *apiService;
    UserService *userService;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    apiService = [[APIService alloc] init];
    userService = [[UserService alloc] init];
    
    actualUser = [userService getLoggedInUserOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self performSegueWithIdentifier:@"login_success" sender:self];
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.lblWarnings.text = @"Login nicht möglich";
    }];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSDictionary *userDictionary = [defaults objectForKey:@"ActualUser"];
    
    /*if(userDictionary != nil) {
        actualUser = [User createFromDictionary:userDictionary];
        NSLog(@"Try Login");
        [self authenticateUserWithUsername:actualUser.email withPassword:actualUser.password];
    }
    */
    self.lblWarnings.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - UI

- (IBAction)signinClicked:(id)sender {
    if([[self.txtUsername text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""] ) {
        self.lblWarnings.text = @"Please enter Username and Password";
    } else {
        [userService doLoginWithEmail:[self.txtUsername text] andPassword:[self.txtPassword text]onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self performSegueWithIdentifier:@"login_success" sender:self];
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.lblWarnings.text = @"Login nicht möglich";
        }];
    }
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType == UIReturnKeyNext) {
        UIView *next = [[textField superview] viewWithTag:textField.tag + 1];
        [next becomeFirstResponder];
    } else if (textField.returnKeyType == UIReturnKeyGo) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - REST
/*
- (void)doLogin {
        actualUser = [[User alloc] init];
        
        actualUser.email = [self.txtUsername text];
        actualUser.password = [self.txtPassword text];
        
        [self registerPushTokenOnUser];
        
        [self authenticateUserWithUsername:actualUser.email withPassword:actualUser.password];
}
*/

/*
- (void)registerPushTokenOnUser {
    NSString *pushToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"PushToken"];
    if (pushToken != nil || "") {
        actualUser.pushToken = pushToken;
    }
    // UPDATE PUSH TOKEN ONLINE
}
 
 */
/*
- (void) persistUserSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[actualUser createDictionary] forKey:@"ActualUser"];
}
 */
/*
- (void)authenticateUserWithUsername:(NSString *)username withPassword:(NSString *)password {
    NSString *path = [NSString stringWithFormat:@"/api/user/login?username=%@&password=%@", username, password];
    [apiService performGETonPath:path
                          onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                              [self registerPushTokenOnUser];
                              [self persistUserSettings];
                              [self performSegueWithIdentifier:@"login_success" sender:self];
                          }
                            onError:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", error);
                                self.lblWarnings.text = @"Login nicht möglich";
                            }];
}
 */

@end
