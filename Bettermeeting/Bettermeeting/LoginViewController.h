#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblWarnings;
- (IBAction)signinClicked:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
