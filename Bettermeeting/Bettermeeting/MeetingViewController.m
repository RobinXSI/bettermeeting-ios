#import "MeetingViewController.h"
#import "APIService.h"

@interface MeetingViewController ()

@end

@implementation MeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtMeetingGoal.text = _meeting.getGoal;
    NSArray *decisions = _meeting.getDecisions;
    self.txtDecision.text = [[NSNumber numberWithInteger:[decisions count]] stringValue];
    self.txtOrganizer.text = _meeting.getOrganizer;
    self.txtDate.text = _meeting.getDateAsString;
    
    if (_meeting.userDidVote) {
        [self.buttonLike setEnabled:NO];
        [self.buttonDislike setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)likeClicked:(id)sender {
    
}

- (IBAction)dislikeClicked:(id)sender {
}
@end
