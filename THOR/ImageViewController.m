//
//  ImageViewController.m
//  THOR
//

#import "ImageViewController.h"

@interface ImageViewController () <DJICameraDelegate> {
    __block NSMutableData *_downloadedFileData;
    __block int _selectedPhotoNumber;
    __block long totalFileSize;
    __block NSString *targetFileName;
}
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDrone];
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.missionCount = 0;
}

-(void)initUI
{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"thorbar.png"]];
    
    self.myColorBlue = [UIColor colorWithRed:45/255.0 green:188/255.0 blue:220/255.0 alpha:1.0];
    self.myColorGreen = [UIColor colorWithRed:104/255.0 green:175/255.0 blue:97/255.0 alpha:1.0];
    
    self.downloadBtn.backgroundColor = self.myColorGreen;
    [self.downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.uploadBtn.backgroundColor = self.myColorBlue;
    [self.uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSString *message = [NSString stringWithFormat:@"%i Photos Available for Download", self.numberOfPhotos];
    self.AWS = [[AWSInteraction alloc]init];
    [self.AWS setUpIdentity];
    
    [self displayAlertWithMessage:message andTitle:@"Photos" withActionOK:@"OK" withActionCancel:nil];
}

-(void)initDrone
{
    self.phantomDrone = [[DJIDrone alloc] initWithType:DJIDrone_Phantom3Professional];
    self.camera = (DJIPhantom3ProCamera*)self.phantomDrone.camera;
    self.camera.delegate = self;
}

#pragma mark DJICameraDelegate
-(void) camera:(DJICamera *)camera didUpdatePlaybackState:(DJICameraPlaybackState*)playbackState
{
    _selectedPhotoNumber=playbackState.numbersOfSelected;
}
-(void)camera:(DJICamera *)camera didReceivedVideoData:(uint8_t *)videoBuffer length:(int)length
{
    
}

-(IBAction)onDownloadButtonClicked:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [_camera setCameraWorkMode:CameraWorkModePlayback withResult:^(DJIError *error) {
        if (error.errorCode == ERR_Succeeded) {
            [weakSelf displayAlertWithMessage:@"Entering playback mode" andTitle:@"Camera WorkMode" withActionOK:@"OK" withActionCancel:nil];
            [weakSelf selectPhotos];
        }else {
            [weakSelf displayAlertWithMessage:@"Enter playback mode failed" andTitle:@"Camera WorkMode" withActionOK:@"OK" withActionCancel:nil];
        }
    }];
}



-(void)selectPhotos {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.camera enterMultiplePreviewMode];
        sleep(1);
        [self.camera enterMultipleEditMode];
        sleep(1);
        
        while (_selectedPhotoNumber!=self.numberOfPhotos) {
            [self.camera selectAllFilesInPage];
            sleep(1);
            
            if(_selectedPhotoNumber>self.numberOfPhotos){
                for(int unselectFileIndex=0; _selectedPhotoNumber!=self.numberOfPhotos;unselectFileIndex++){
                    [self.camera unselectFileAtIndex:unselectFileIndex];
                    sleep(1);
                }
                break;
            }
            else if(_selectedPhotoNumber <self.numberOfPhotos){
                [self.camera multiplePreviewPreviousPage];
                sleep(1);
            }
        }
        [self downloadPhotos];
    });
}

-(void)downloadPhotos {
    __block int finishedFileCount=0;
    __weak typeof(self) weakSelf = self;
    __block NSTimer *timer;
    self.imageArray=[NSMutableArray new];
    
    [_camera downloadAllSelectedFilesWithPreparingBlock:^(NSString* fileName, DJIDownloadFileType fileType, NSUInteger fileSize, BOOL* skip) {
        totalFileSize=(long)fileSize;
        _downloadedFileData=[NSMutableData new];
        targetFileName=fileName;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showDownloadProgressAlert];
            [weakSelf.downloadProgressAlert setTitle:[NSString stringWithFormat:@"Download (%d/%d)", finishedFileCount + 1, self.numberOfPhotos]];
            [weakSelf.downloadProgressAlert setMessage:[NSString stringWithFormat:@"FileName:%@ FileSize:%0.1fKB Downloaded:0.0KB", fileName, fileSize / 1024.0]];
            timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateDownloadProgress) userInfo:nil repeats:YES];
            [timer fire];
        });
    } dataBlock:^(NSData *data, NSError *error) {
        [_downloadedFileData appendData:data];
    } completionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [timer invalidate];
            finishedFileCount++;
            if(finishedFileCount>=self.numberOfPhotos) {
                [self.downloadProgressAlert dismissViewControllerAnimated:YES completion:nil];
                self.downloadProgressAlert = nil;
                [_camera setCameraWorkMode:CameraWorkModeCapture withResult:nil];
                NSString* title = [NSString stringWithFormat:@"Download (%d/%d)", finishedFileCount, self.numberOfPhotos];
                [self displayAlertWithMessage:@"download finished" andTitle:title withActionOK:@"OK" withActionCancel:nil];
            }
            
            //store downloaded photo
            UIImage *downloadPhoto=[UIImage imageWithData:_downloadedFileData];
            
            //save to camera roll
            UIImageWriteToSavedPhotosAlbum(downloadPhoto, nil, nil, nil);
            
            //add to image Array
            [self.imageArray addObject:downloadPhoto];
        });
    }];
}

-(void)updateDownloadProgress{
    [self.downloadProgressAlert setMessage:[NSString stringWithFormat:@"FileName:%@ FileSize:%0.1fKB Downloaded:%0.1fKB", targetFileName, totalFileSize / 1024.0, _downloadedFileData.length / 1024.0]];
}

-(void) showDownloadProgressAlert {
    if (self.downloadProgressAlert == nil) {
        self.downloadProgressAlert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:self.downloadProgressAlert animated:YES completion:nil];
    }
}

//Upload image to AWS S3, execute lamda function
-(IBAction)onUploadButtonClicked:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    //upload image to S3 for processing
    [self.AWS uploadImageToS3:selectedImage withMissionCount:self.missionCount];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //wait 3 seconds, processing should be done?
    [self waitForNDVIProccessingToFinish];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)downloadNOW:(NSTimer *)t
{
    //download image from S3 and Display on screen
    [self.AWS downloadImageFromS3:self.AWS.superemeFileKey];
    
    [self waitForDownload];
  
}

//Display processed image that just finished downloading
-(void)displayNDVIProcessedImage:(NSTimer *)t
{
    //Display Processed NDVI Image
    self.ndviProcessedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.AWS.ndviImageURL]];
    
    //self.ndviProcessedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.ndviProcessedImageDisplay = [self imageWithImage:self.ndviProcessedImage scaledToSize:CGSizeMake(503, 503)];
    
    self.ndviProcessedImageView.image = self.ndviProcessedImageDisplay;
    
    NSLog(@"Displaying processed image....");
    
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)waitForNDVIProccessingToFinish
{
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(downloadNOW:) userInfo:nil repeats:NO];
}

-(void)waitForDownload
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayNDVIProcessedImage:) userInfo:nil repeats:NO];
}

//Display a UI Alert Controller with specified parameters
-(void)displayAlertWithMessage:(NSString*)message
                      andTitle:(NSString*)title
                  withActionOK:(NSString*)OK
              withActionCancel:(NSString*)Cancel
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if(OK != nil) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:okAction];
    }
    if(Cancel != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alert addAction:cancelAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

@end
