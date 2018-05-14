//
//  AbstractAssetCell.h
//  QBImagePicker
//
//  Created by Ezat Hashim on 2018-05-14.
//  Copyright © 2018 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetCell.h"

@interface AbstractAssetCell : QBAssetCell


@property (nonatomic) UIImage *thumbnail;

    // will show download progress
@property (nonatomic) BOOL isDownloading;
@property CGFloat transferredBytes;
@property CGFloat totalBytes;


    // will show activity indicator
@property (nonatomic) BOOL isProcessing;


@end
