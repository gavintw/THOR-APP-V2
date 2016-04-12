//
//  AWSInteraction.m
//  THOR
//

#import "AWSInteraction.h"

@implementation AWSInteraction

-(instancetype)init
{
    if(self == [super init]) {
        //To begin interaction with AWS S3, need transfer manager client, entry point into S3 API
        self.fileCount = 0;
        self.superemeFileKey = @"";
    }
    return self;
}

-(void)setUpIdentity
{
    //Initialize Amazon Cognito Credentials
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1 identityPoolId:@"us-east-1:56c9328e-beb3-459e-926e-0166cae5e497"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    
    //Retreieve unique id for current user
    NSString *cognitoId = credentialsProvider.identityId;
    
}

-(void)downloadImageFromS3:(NSString *)downloadFileKey
{
    //NSLog(@"Downloading...\n");
    //NSLog(@"%@", downloadFileKey);
    
    
    AWSS3TransferManager *transferManager2 = [AWSS3TransferManager defaultS3TransferManager];
    
    //download path
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:downloadFileKey];
    //location where it will be downloaded
    self.ndviImageURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    //download request
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    //set up download request with bucket name, image name, and location to download
    downloadRequest.bucket = @"graminorresized";
    downloadRequest.key = downloadFileKey;
    downloadRequest.downloadingFileURL = self.ndviImageURL;

    //Download file
    [[transferManager2 download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
        if(task.error) {
            if([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch(task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        break;
                    default:
                        NSLog(@"Error: %@", task.error);
                        break;
                }
            }
            else {
                //Unknown error
                NSLog(@"Error: %@", task.error);
            }
        }
        if(task.result) {
            AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
            //File download success
            NSLog(@"Success: %@", downloadOutput);
        }
        return nil;
    }];
}

-(void)uploadImageToS3:(UIImage *)image withMissionCount:(int)missionCount
{
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    
    //Create local image that can used to upload to S3
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"testImage.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    [imageData writeToFile:path atomically:YES];
    
    //image is saved, use path to create local file url
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //create upload request
    uploadRequest.bucket = @"graminor";
    NSString *fileKey = [NSString stringWithFormat:@"Image_%d.jpg",self.fileCount];
    self.superemeFileKey = fileKey;
    self.fileCount+=1;
    uploadRequest.key = fileKey;
    uploadRequest.body = url;
    
    //upload File using transferManager, and pass uploadRequest
    [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
        if(task.error) {
            if([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch(task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        break;
                        
                    default:
                        NSLog(@"Error: %@", task.error);
                        break;
                }
            }
            else {
                //Unknown error
                NSLog(@"Error: %@", task.error);
            }
        }
        
        if(task.result) {
            AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
            //File upload success
            NSLog(@"Success: %@", uploadOutput);
        }
        return nil;
    }];
}

@end
