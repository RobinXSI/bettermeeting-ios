
#import "MeetingsViewController.h"
#import "Meeting.h"
#import "APIService.h"
#import "UserService.h"
#import "User.h"
#import "MeetingViewController.h"

@interface MeetingsViewController ()

@property NSMutableArray *objects;
@end

@interface MeetingsViewController () {
    APIService *apiService;
    UserService *userService;
}

@property (nonatomic, strong) NSArray *meetings;
@end

@implementation MeetingsViewController


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    apiService = [[APIService alloc] init];
    userService = [[UserService alloc] init];
    [self loadMeetings];

}

- (void)loadMeetings {
    
    [apiService getAllMeetingsOnSucces:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        _meetings = mappingResult.array;
        _meetings = [_meetings sortedArrayUsingSelector:@selector(compare:)];
        [self.tableView reloadData];
    } onError:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no meeting?' : %@", error);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Meeting *meeting = self.meetings[indexPath.row];
    cell.textLabel.text = [meeting getGoal];
    
    User *actualUser = [User createFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"ActualUser"]];
    
    if ([meeting.getOrganizer isEqualToString:actualUser.email])
        cell.detailTextLabel.text = [NSString stringWithFormat:@"[Organizer] %@", [meeting getDateAsString]];
    else if (meeting.userDidVote) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"[Voted] %@", [meeting getDateAsString]];
    } else {
        cell.detailTextLabel.text = [meeting getDateAsString];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.337 green:0.486 blue:0.639 alpha:1.0];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (IBAction)logoutClicked:(id)sender {
    [userService doLogoutOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismissViewControllerAnimated:YES completion:nil ];
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"meeting_selected"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MeetingViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.meeting = [_meetings objectAtIndex:indexPath.row];
    }
}
@end
