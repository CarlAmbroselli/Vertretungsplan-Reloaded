//
//  Vertretung+costumHeader.m
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 19.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import "Vertretung+costumHeader.h"

@implementation Vertretung (costumHeader)

- (NSString *) header {
    [self willAccessValueForKey:@"header"];
    
    NSString *headerString;
    
    if([self.datum compare:[[NSDate alloc] init]] == NSOrderedAscending){
        headerString = [NSString stringWithFormat:@"Heute - %@", self.stunde];
    }
    else if ([self.datum compare:[[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24]] == NSOrderedAscending){
        headerString = [NSString stringWithFormat:@"Morgen - %@", self.stunde];
    }
    else{
        headerString = [NSString stringWithFormat:@"Montag - %@", self.stunde];
    }
    [self didAccessValueForKey:@"header"];
    return headerString;
}

@end
