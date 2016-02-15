//
//  ImageViewController.h
//  THOR
//
//  Created by Dan Vasilyonok on 2/10/16.
//  Copyright © 2016 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJISDK.h>
#import "DJIRootViewController.h"

@interface ImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

-(IBAction)onDownloadButtonClicked:(id)sender;
-(IBAction)onUploadButtonClicked:(id)sender;

@property(nonatomic, strong) UIColor *myColorBlue;
@property(nonatomic, strong) UIColor *myColorGreen;

@property(strong,nonatomic) NSMutableArray *imageArray;
@property(strong, nonatomic) UIAlertController* downloadProgressAlert;

//Drone, Camera, and RootView
@property(nonatomic, strong) DJIDrone* phantomDrone;
@property(nonatomic, strong) DJIPhantom3ProCamera *camera;

@end
