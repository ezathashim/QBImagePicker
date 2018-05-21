//
//  AbstractAsset.h
//  QBImagePicker
//
//  Created by Ezat Hashim on 2018-05-10.
//  Copyright © 2018 Katsuma Tanaka. All rights reserved.
//


@import Foundation;
@import UIKit;



@class AbstractAsset;

@protocol AbstractAssetDelegate <NSObject>

@optional

- (void)assetDidUpdate: (AbstractAsset *)sender;

@required

@end


@interface AbstractAsset : NSObject

@property (weak) id<AbstractAssetDelegate> delegate;

@property (readwrite) long long totalBytes;
@property (readwrite) long long transferredBytes;
@property (readwrite) BOOL isIndeterminate;
@property (readwrite) BOOL isDownloading;

@property (readwrite) BOOL isProcessing;


    // used to identify the asset before downloading is complete
@property (readwrite) NSString *identifier;

@property (readwrite) NSURL *assetURL;
@property (nonatomic) CGSize targetImageSize;
@property (nonatomic, readwrite) UIImage *image;


@property (readwrite) BOOL isImageFile;
@property (readwrite) BOOL isVideoFile;


+ (BOOL)isImageAsset: (NSURL *)inAssetURL;
+ (BOOL)isMovieAsset: (NSURL *)inAssetURL;

- (void)updateImageCache;


@end
