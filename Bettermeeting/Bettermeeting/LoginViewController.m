#import "LoginViewController.h"
#import "User.h"
#import "APIService.h"
#import "UserService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    APIService *apiService;
    UserService *userService;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    apiService = [[APIService alloc] init];
    userService = [[UserService alloc] init];
    
    [userService getLoggedInUserOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self performSegueWithIdentifier:@"login_success" sender:self];
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
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

@end
