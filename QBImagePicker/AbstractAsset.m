//
//  AbstractAsset.m
//  QBImagePicker
//
//  Created by Ezat Hashim on 2018-05-10.
//  Copyright © 2018 Katsuma Tanaka. All rights reserved.
//

#import "AbstractAsset.h"

#import "QBAlbumsViewController.h"

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
        
        _image = [QBAlbumsViewController placeholderImageWithSize: _targetImageSize];
        
        
    }
    
    
    return self;
    
}


- (void)setTargetImageSize:(CGSize)targetImageSize
{
    _targetImageSize = targetImageSize;
    
    // subclasses can start generating a new cache based on this size
}


- (void)setImage:(UIImage *)image
{
    if (!image) {
        image = [QBAlbumsViewController placeholderImageWithSize: self.targetImageSize];
    }
    
    _image = image;
    
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
        // https://gist.github.com/tomasbasham/10533743
        // switch MIN to MAX for FILL instead of FIT
    
    BOOL scaleToFill = YES;
    
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = self.targetImageSize.width / newImage.size.width;
    CGFloat aspectHeight = self.targetImageSize.height / newImage.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    if (scaleToFill) {
        aspectRatio = MAX ( aspectWidth, aspectHeight );
    }
    
    scaledImageRect.size.width = newImage.size.width * aspectRatio;
    scaledImageRect.size.height = newImage.size.height * aspectRatio;
    scaledImageRect.origin.x = (self.targetImageSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (self.targetImageSize.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions( self.targetImageSize, NO, 0 );
    [newImage drawInRect:scaledImageRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = scaledImage;
    
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
