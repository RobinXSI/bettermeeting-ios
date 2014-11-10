
#import <UIKit/UIKit.h>
#import "Meeting.h"

@interface MeetingViewController : UIViewController
@property (nonatomic, strong) Meeting *meeting;

@property (weak, nonatomic) IBOutlet UILabel *txtMeetingGoal;
@property (weak, nonatomic) IBOutlet UILabel *txtDecision;
@property (weak, nonatomic) IBOutlet UILabel *txtOrganizer;
@property (weak, nonatomic) IBOutlet UILabel *txtDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonLike;
@property (weak, nonatomic) IBOutlet UIButton *buttonDislike;

- (IBAction)likeClicked:(id)sender;
- (IBAction)dislikeClicked:(id)sender;

@end
