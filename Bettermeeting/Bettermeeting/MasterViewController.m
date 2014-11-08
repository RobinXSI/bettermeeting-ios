//
//  MasterViewController.m
//  Bettermeeting
//
//  Created by Robin on 06.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import "MasterViewController.h"
#import "Meeting.h"
#import "APIService.h"
#import "UserService.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@interface MasterViewController () {
    APIService *apiService;
    UserService *userService;
}

@property (nonatomic, strong) NSArray *meetings;
@end

@implementation MasterViewController

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
    cell.textLabel.text = meeting.goal;
    NSLog(@"%@", meeting);
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
@end
