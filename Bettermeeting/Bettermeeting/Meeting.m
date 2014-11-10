#import "Meeting.h"
#import "User.h"

@implementation Meeting

-(NSString *) description {
    return [NSString stringWithFormat:@"\r\
            ID: %@\r\
            Goal: %@\r\
            Date: %@\r\
            ActionPoints: %@\r\
            Decisions: %@\r\
            VotesUp: %@\r\
            VotesDown: %@\r\
            ", [self getId], [self getDate], [self getOrganizer], [self getActionPoints], [self getDecisions], [self getVotesUp], [self getVotesDown]];
}

- (NSString *) getId {
    return [self._id objectForKey:@"$oid"];
}

- (NSString *) getGoal {
    return self.goal;
}
- (NSString *) getOrganizer {
    return self.organizer;
}
- (NSDate *) getDate {
    return [[NSDate alloc] initWithTimeIntervalSince1970:([self.date doubleValue] / 1000)];
}

- (NSString *) getDateAsString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [formatter stringFromDate:[self getDate]];
}

- (NSArray *) getActionPoints {
    NSMutableArray *actionPointArray = [[NSMutableArray alloc] init];
    for (NSDictionary* actionPoint in self.actionPoints) {
        [actionPointArray addObject:[actionPoint objectForKey:@"subject"]];
    }
    return actionPointArray;
}

- (NSArray *) getDecisions {
    NSMutableArray *decisionsArray = [[NSMutableArray alloc] init];
    for (NSDictionary* decision in self.decisions) {
        [decisionsArray addObject:[decision objectForKey:@"subject"]];
    }
    return decisionsArray;
}

- (NSArray *) getVotesUp {
    NSMutableArray *votesUpArray = [[NSMutableArray alloc] init];
    for (NSDictionary* voteUp in self.votesUp) {
        [votesUpArray addObject:[voteUp objectForKey:@"email"]];
    }
    return votesUpArray;
}
- (NSArray *) getVotesDown {
    NSMutableArray *votesDownArray = [[NSMutableArray alloc] init];
    for (NSDictionary* voteDown in self.votesDown) {
        [votesDownArray addObject:[voteDown objectForKey:@"email"]];
    }
    return votesDownArray;
}

- (NSComparisonResult)compare:(Meeting *)otherObject {
    return [self.getDate compare:otherObject.getDate];
}

- (BOOL) userDidVote {
    User* actualUser = [User createFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"ActualUser"]];
    
    for (NSString* email in self.getVotesUp) {
        if ([email isEqualToString:actualUser.email]) {
            return true;
        }
    }
    for (NSString* email in self.getVotesDown) {
        if ([email isEqualToString:actualUser.email]) {
            return true;
        }
    }
    return false;
}

@end
