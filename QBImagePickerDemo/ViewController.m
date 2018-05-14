//
//  ViewController.m
//  QBImagePickerDemo
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "ViewController.h"
#import <QBImagePicker/QBImagePicker.h>

@interface ViewController () <QBImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeAny;
    imagePickerController.allowsMultipleSelection = (indexPath.section == 1);
    imagePickerController.showsNumberOfSelectedAssets = YES;
    
    
        // load image files at URL
    NSMutableArray *array = [NSMutableArray array];
    NSURL *image1 = [[NSBundle mainBundle] URLForResource:@"image1" withExtension:@"jpg"];
    AbstractAsset *asset1 = [[AbstractAsset alloc] init];
    asset1.assetURL = image1;
    
    NSURL *image2 = [[NSBundle mainBundle] URLForResource:@"image2" withExtension:@"jpg"];
    AbstractAsset *asset2 = [[AbstractAsset alloc] init];
    asset2.assetURL = image2;
    
    NSURL *image3 = [[NSBundle mainBundle] URLForResource:@"image3" withExtension:@"jpg"];
    AbstractAsset *asset3 = [[AbstractAsset alloc] init];
    asset3.assetURL = image3;
    
    [array addObject: asset1];
    [array addObject: asset2];
    [array addObject: asset3];
    imagePickerController.abstractAssetArray = array;

    
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1:
                imagePickerController.minimumNumberOfSelection = 3;
                break;
                
            case 2:
                imagePickerController.maximumNumberOfSelection = 6;
                break;
                
            case 3:
                imagePickerController.minimumNumberOfSelection = 3;
                imagePickerController.maximumNumberOfSelection = 6;
                break;

            case 4:
                imagePickerController.maximumNumberOfSelection = 2;
                [imagePickerController.selectedAssets addObject:[PHAsset fetchAssetsWithOptions:nil].lastObject];
                break;
                
            default:
                break;
        }
    }
    
    [self presentViewController: imagePickerController
                       animated: YES
                     completion: NULL];
}


#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"Selected assets:");
    NSLog(@"%@", assets);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
