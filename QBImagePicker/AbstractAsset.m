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
        
    }
    
    
    return self;
    
}



- (void)setAssetURL:(NSURL *)assetURL
{
    _assetURL = assetURL;
    
    if (!assetURL) {
            // set the image to default or nil
        self.image = nil;
        
        self.isImageFile = NO;
        self.isVideoFile = NO;
    
    } else {
        
        self.isImageFile = [[self class] isImageAsset: assetURL];
        self.isVideoFile = [[self class] isMovieAsset: assetURL];
        
        self.image = [UIImage imageWithContentsOfFile: assetURL.path];
        
        if (!self.image) {
            
                // default to system icon when cannot make image
            
            UIDocumentInteractionController *documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL: assetURL];
            NSArray *systemIconImages = documentInteractionController.icons;
            
            self.image = [systemIconImages firstObject];
        }
    }
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
