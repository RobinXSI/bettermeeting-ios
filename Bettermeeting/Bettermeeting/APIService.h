

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface APIService : NSObject

- (void)performGETonPath:(NSString *)path onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onError:(void(^)(AFHTTPRequestOperation *operation, NSError *error))error;
- (void)performPUTonPath:(NSString *)path withParameters:(NSDictionary *)params onSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getAllMeetingsOnSucces:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success onError:(void(^)(RKObjectRequestOperation *operation, NSError *error))error;


@end
