//
//  NPAssetsViewController.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//  Modified by Ezat Hashim 2018/05/08

#import <UIKit/UIKit.h>

#import "AbstractAsset.h"


@class QBImagePickerController;

@interface NPAssetsViewController : UICollectionViewController <AbstractAssetDelegate>

@property (nonatomic, weak) QBImagePickerController *imagePickerController;

@property (nonatomic, strong) NSMutableArray *abstractAssetsArray;

@property (nonatomic) NSString *navigationItemTitle;

@end
