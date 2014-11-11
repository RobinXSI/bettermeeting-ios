#import "MeetingViewController.h"
#import "MeetingService.h"
#import "APIService.h"


@interface MeetingViewController ()

@end

@implementation MeetingViewController {
    MeetingService *meetingService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtMeetingGoal.text = _meeting.getGoal;
    NSArray *decisions = _meeting.getDecisions;
    self.txtDecision.text = [[NSNumber numberWithInteger:[decisions count]] stringValue];
    self.txtOrganizer.text = _meeting.getOrganizer;
    self.txtDate.text = _meeting.getDateAsString;
    
    
    meetingService = [[MeetingService alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)likeClicked:(id)sender {
    
    NSLog(@"Like Clicked");
    [meetingService doLikeMeeting:_meeting onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Meeting liked Sucessfully");
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error Liking Meeting");
    }];
    
    
}

- (IBAction)dislikeClicked:(id)sender {
    [meetingService doDislikeMeeting:_meeting onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Meeting disliked Sucessfully");
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error Disliking Meeting");
    }];
}
@end
