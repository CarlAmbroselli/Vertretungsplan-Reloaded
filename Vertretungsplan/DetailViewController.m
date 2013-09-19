//
//  DetailViewController.m
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if(self.vertretung){
        self.lehrerAltLabel.text = self.vertretung.lehrerAlt;
        self.fachAltLabel.text = self.vertretung.fachAlt;
        self.lehrerNeuLabel.text = self.vertretung.vertreter;
        self.fachNeuLabel.text = self.vertretung.fachNeu;
        self.raumNeuLabel.text = self.vertretung.raumNeu;
        self.artNeuLabel.text = self.vertretung.art;
        self.vertretungsTextLabel.text = self.vertretung.vertretungstext;
    }
    
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0/255 green:120.0/255 blue:197.0/255 alpha:1.0]];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor colorWithRed:50.0/255 green:170.0/255 blue:247.0/255 alpha:1.0]];
}


@end
