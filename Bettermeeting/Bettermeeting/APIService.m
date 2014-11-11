

#import "APIService.h"
#import "Meeting.h"

@implementation APIService {
    NSString *serverPath;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        serverPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IPServerAdress"];
    }
    return self;
}

- (void)configureRestKitForUser {
    
}

- (void)configureRestKitForMeeting
{
    // initialize AFNetworking HTTP Client
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:serverPath]];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *meetingMapping = [RKObjectMapping mappingForClass:[Meeting class]];
    
    [meetingMapping addAttributeMappingsFromDictionary:@{
                                                         @"goal": @"goal",
                                                         @"date": @"date",
                                                         @"organizer": @"organizer",
                                                         @"decisions": @"decisions",
                                                         @"votesUp": @"votesUp",
                                                         @"votesDown": @"votesDown",
                                                         @"actionPoints": @"actionPoints",
                                                         @"_id": @"_id",
                                                         }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:meetingMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/api/user/meetings"
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)getAllMeetingsOnSucces:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success onError:(void(^)(RKObjectRequestOperation *operation, NSError *error))error {
    [self configureRestKitForMeeting];
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/user/meetings"
                                           parameters:nil
                                              success: success
                                              failure:error
     ];
}


- (void)performGETonPath:(NSString *)path onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onError:(void(^)(AFHTTPRequestOperation *operation, NSError *error))error {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:serverPath]];
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", serverPath, path];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:fullPath
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:success failure:error];
    [operation start];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)performPUTonPath:(NSString *)path withParameters:(NSDictionary *)params onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:serverPath]];
    
    
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", serverPath, path];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient setDefaultHeader:@"Content-Type" value:@"text/json"];
    
    [httpClient putPath:fullPath
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"PUT Successfully delivered");
                    success(operation, responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    failure(operation, error);
                    NSLog(@"PUT not successfully delivered");
                }];
    
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
