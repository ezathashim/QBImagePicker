//
//  AbstractAsset.m
//  QBImagePicker
//
//  Created by Ezat Hashim on 2018-05-10.
//  Copyright © 2018 Katsuma Tanaka. All rights reserved.
//

#import "AbstractAsset.h"

@import MobileCoreServices;


@implementation AbstractAsset


- (void)dealloc
{
    self.delegate = nil;
    
}


- (id)init
{
    self = [super init];
    
    if (self) {
        
        _totalBytes = 0;
        _transferredBytes = 0;
        _isIndeterminate = YES;
        _isDownloading = NO;
        
        _isProcessing = NO;
        
        _isImageFile = NO;
        _isVideoFile = NO;
        
        _targetImageSize = CGSizeMake(100, 100);
        
    }
    
    
    return self;
    
}


- (void)setTargetImageSize:(CGSize)targetImageSize
{
    _targetImageSize = targetImageSize;
    
    // subclasses can start generating a new cache based on this size
}



- (void)updateImageCache
{
    if (!self.assetURL) {
        self.image = nil;
        return;
    }
    
    UIImage *newImage = [UIImage imageWithContentsOfFile: self.assetURL.path];
    
    if (!newImage) {
        
            // default to system icon when cannot make image
        
        UIDocumentInteractionController *documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL: self.assetURL];
        NSArray *systemIconImages = documentInteractionController.icons;
        
        newImage = [systemIconImages firstObject];
    }
    
    // scale it
    
        //UIGraphicsBeginImageContext(newSize);
        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(self.targetImageSize, NO, 0.0);
    [newImage drawInRect:CGRectMake(
                                    0,
                                    0,
                                    self.targetImageSize.width,
                                    self.targetImageSize.height)
     ];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = newImage;
    
}


+ (BOOL)isImageAsset: (NSURL *)inAssetURL
{
    if (!inAssetURL.pathExtension) {
        return NO;
    }
    
    NSString *UTI = (__bridge NSString *)(UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                                (__bridge CFStringRef _Nonnull)(inAssetURL.pathExtension),
                                                                                NULL));
    
        // find if video
    if (UTTypeConformsTo((__bridge CFStringRef _Nonnull)(UTI), kUTTypeImage)) {
            // is image type
        return YES;
    }
    
    return NO;
    
}


+ (BOOL)isMovieAsset: (NSURL *)inAssetURL
{
    if (!inAssetURL.pathExtension) {
        return NO;
    }
    
    NSString *UTI = (__bridge NSString *)(UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                                (__bridge CFStringRef _Nonnull)(inAssetURL.pathExtension),
                                                                                NULL));
    
        // find if video
    if (UTTypeConformsTo((__bridge CFStringRef _Nonnull)(UTI), kUTTypeMovie)) {
            // is movie type
        return YES;
    }
    
    return NO;
    
}




@end
