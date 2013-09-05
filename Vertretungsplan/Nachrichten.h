//
//  Nachrichten.h
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Nachrichten : NSManagedObject

@property (nonatomic, retain) NSString * nachricht;
@property (nonatomic, retain) NSDate * datum;

@end
