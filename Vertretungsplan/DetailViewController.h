//
//  DetailViewController.h
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vertretung.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lehrerAltLabel;
@property (weak, nonatomic) IBOutlet UILabel *fachAltLabel;
@property (weak, nonatomic) IBOutlet UILabel *raumAltLabel;
@property (weak, nonatomic) IBOutlet UILabel *lehrerNeuLabel;
@property (weak, nonatomic) IBOutlet UILabel *fachNeuLabel;
@property (weak, nonatomic) IBOutlet UILabel *raumNeuLabel;
@property (weak, nonatomic) IBOutlet UILabel *artNeuLabel;
@property (weak, nonatomic) IBOutlet UILabel *vertretungsTextLabel;
@property (strong, nonatomic) Vertretung *vertretung;

@end
