//
//  AWSInteraction.h
//  THOR
//

#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>

@interface AWSInteraction : NSObject

-(void)setUpIdentity;
-(void)downloadImageFromS3:(NSString *)downloadFileKey;
-(void)uploadImageToS3:(UIImage *)image withMissionCount:(int)missionCount;

@property (atomic) int fileCount;

@property (atomic) NSString *superemeFileKey;
@property (atomic) NSURL *ndviImageURL;

@end
