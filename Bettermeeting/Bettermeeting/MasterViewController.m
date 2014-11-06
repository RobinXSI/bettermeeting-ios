//
//  MasterViewController.m
//  Bettermeeting
//
//  Created by Robin on 06.11.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

#import "MasterViewController.h"
#import <RestKit/RestKit.h>
#import "Meeting.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *meetings;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureRestKit];
    [self authenticateUserGet];
    //[self logoutUser];

    

    
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTP Client
    NSURL *baseURL = [NSURL URLWithString:@"http://localhost:9000"];
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *meetingMapping = [RKObjectMapping mappingForClass:[Meeting class]];
    
    [meetingMapping addAttributeMappingsFromDictionary:@{
                                                         @"goal": @"goal",
                                                         @"date": @"date"
                                                         }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:meetingMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/api/meetings"
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    
    
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    
    
    
    
    
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)authenticateUserGet {
    [self getRequestWithoutResponse:@"http://localhost:9000/api/user/login?username=p1meier@hsr.ch&password=p1meier" withMethodAfter:@selector(loadMeetings)];
}


- (void)logoutUser {
    [self getRequestWithoutResponse:@"http://localhost:9000/api/user/logout" withMethodAfter:@selector(loadMeetings)];
}

- (void)getRequestWithoutResponse:(NSString *)path withMethodAfter:(SEL)functionAfter{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:9000/"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:path
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [self performSelector:functionAfter withObject:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)loadMeetings {
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/meetings"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _meetings = mappingResult.array;
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
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
    NSLog(@"%@", meeting.date.stringValue);
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



@end
