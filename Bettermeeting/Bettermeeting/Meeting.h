#import <Foundation/Foundation.h>

@class ActionPoint;

@interface Meeting : NSObject

@property (nonatomic, strong) NSString *goal;
@property (nonatomic, strong) NSNumber *date;
@property (nonatomic, strong) NSString *organizer;
@property (nonatomic, strong) NSArray *decisions;
@property (nonatomic, strong) NSArray *votesUp;
@property (nonatomic, strong) NSArray *votesDown;
@property (nonatomic, strong) NSArray *actionPoints;
@property (nonatomic, strong) NSDictionary *_id;

- (NSString *) getId;
- (NSString *) getGoal;
- (NSString *) getOrganizer;
- (NSDate *) getDate;
- (NSArray *) getActionPoints;
- (NSArray *) getDecisions;
- (NSArray *) getVotesUp;
- (NSArray *) getVotesDown;
- (BOOL) userDidVote;


@end
