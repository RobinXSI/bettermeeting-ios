//
//  LoginViewController.h
//  Bettermeeting
//
//  Created by Robin on 06.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblWarnings;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)signinClicked:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
