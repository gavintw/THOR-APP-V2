//
//  AWSInteraction.h
//  THOR
//

#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>

@interface AWSInteraction : NSObject

@property(nonatomic, strong) AWSS3TransferManager *transferManager;

-(void)setUpIdentity;
-(void)downloadImageFromS3;
-(void)uploadImageToS3;

@end
