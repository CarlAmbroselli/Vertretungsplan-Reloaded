//
//  Vertretung.h
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Vertretung : NSManagedObject

@property (nonatomic, retain) NSString * klasse;
@property (nonatomic, retain) NSString * stunde;
@property (nonatomic, retain) NSString * lehrerAlt;
@property (nonatomic, retain) NSString * fachAlt;
@property (nonatomic, retain) NSString * raumAlt;
@property (nonatomic, retain) NSString * vertreter;
@property (nonatomic, retain) NSString * fachNeu;
@property (nonatomic, retain) NSString * raumNeu;
@property (nonatomic, retain) NSString * art;
@property (nonatomic, retain) NSString * vertretungstext;
@property (nonatomic, retain) NSDate * datum;

@end
