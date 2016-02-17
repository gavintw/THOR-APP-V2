//
//  ImageViewController.h
//  THOR
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJISDK.h>
#import "DJIRootViewController.h"

@interface ImageViewController : UIViewController

@property(atomic) int numberOfPhotos;

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
