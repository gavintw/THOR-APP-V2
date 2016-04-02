//
//  AWSInteraction.h
//  THOR
//

#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>

@interface AWSInteraction : NSObject

-(void)setUpIdentity;
-(void)downloadImageFromS3;
-(void)uploadImageToS3:(UIImage *)image;

@end
