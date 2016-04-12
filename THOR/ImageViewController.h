//
//  ImageViewController.h
//  THOR
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJISDK.h>
#import "DJIRootViewController.h"
#import "AWSInteraction.h"

@interface ImageViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *postProcessedImage;

@property(atomic) int numberOfPhotos;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;


-(IBAction)onDownloadButtonClicked:(id)sender;
-(IBAction)onUploadButtonClicked:(id)sender;

@property (nonatomic, strong) AWSInteraction *AWS;

@property(nonatomic, strong) UIColor *myColorBlue;
@property(nonatomic, strong) UIColor *myColorGreen;

@property (atomic) int missionCount;

@property(strong,nonatomic) NSMutableArray *imageArray;
@property(strong, nonatomic) UIImage *ndviProcessedImage;
@property(strong, nonatomic) UIImage *ndviProcessedImageDisplay;
@property (weak, nonatomic) IBOutlet UIImageView *ndviProcessedImageView;


@property(strong, nonatomic) UIAlertController* downloadProgressAlert;

//Drone, Camera, and RootView
@property(nonatomic, strong) DJIDrone* phantomDrone;
@property(nonatomic, strong) DJIPhantom3ProCamera *camera;

@end
