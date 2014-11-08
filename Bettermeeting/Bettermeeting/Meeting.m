#import "Meeting.h"

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

@end
