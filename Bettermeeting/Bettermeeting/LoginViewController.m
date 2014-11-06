//
//  LoginViewController.m
//  Bettermeeting
//
//  Created by Robin on 06.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import "LoginViewController.h"
#import <RestKit/RestKit.h>
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

User *actualUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblWarnings.text = @"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDictionary = [defaults objectForKey:@"ActualUser"];
    
    if(userDictionary != nil) {
        actualUser = [User createFromDictionary:userDictionary];
        NSLog(@"Try Login");
        [self authenticateUserWithUsername:actualUser.email withPassword:actualUser.password];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UI

- (IBAction)signinClicked:(id)sender {
        if([[self.txtUsername text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""] ) {
            self.lblWarnings.text = @"Please enter Username and Password";
        } else {
            actualUser = [[User alloc] init];
            
            actualUser.email = [self.txtUsername text];
            actualUser.password = [self.txtPassword text];
            
            [self authenticateUserWithUsername:actualUser.email withPassword:actualUser.password];
        }
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - REST

- (void)authenticateUserWithUsername:(NSString *)username withPassword:(NSString *)password {
    NSString *path = [NSString stringWithFormat:@"http://localhost:9000/api/user/login?username=%@&password=%@", username, password];
    [self getRequestWithoutResponse:path];
}


- (void)getRequestWithoutResponse:(NSString *)path{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:9000/"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:path
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[actualUser createDictionary] forKey:@"ActualUser"];
        [self performSegueWithIdentifier:@"login_success" sender:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.lblWarnings.text = @"Login nicht möglich";
    }];
    [operation start];
}



@end
