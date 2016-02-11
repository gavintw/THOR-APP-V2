//
//  ImageViewController.m
//  THOR
//
//  Created by Dan Vasilyonok on 2/10/16.
//  Copyright © 2016 DJI. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

-(void)initUI
{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"thorbar.png"]];
    
    self.myColorBlue = [UIColor colorWithRed:45/255.0 green:188/255.0 blue:220/255.0 alpha:1.0];
    self.myColorGreen = [UIColor colorWithRed:104/255.0 green:175/255.0 blue:97/255.0 alpha:1.0];
    
    self.downloadBtn.backgroundColor = self.myColorGreen;
    [self.downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.processBtn.backgroundColor = self.myColorGreen;
    [self.processBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.uploadBtn.backgroundColor = self.myColorBlue;
    [self.uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(IBAction)onDownloadButtonClicked:(id)sender
{
    
}

-(IBAction)onUploadButtonClicked:(id)sender
{
    
}



@end
