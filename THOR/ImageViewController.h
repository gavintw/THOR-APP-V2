//
//  ImageViewController.h
//  THOR
//
//  Created by Dan Vasilyonok on 2/10/16.
//  Copyright © 2016 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *processBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

-(IBAction)onDownloadButtonClicked:(id)sender;
-(IBAction)onUploadButtonClicked:(id)sender;

@property(nonatomic, strong) UIColor *myColorBlue;
@property(nonatomic, strong) UIColor *myColorGreen;

@property(strong,nonatomic) NSMutableArray *imageArray;

@end
