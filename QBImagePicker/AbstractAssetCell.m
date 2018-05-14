//
//  AbstractAssetCell.m
//  QBImagePicker
//
//  Created by Ezat Hashim on 2018-05-14.
//  Copyright © 2018 Katsuma Tanaka. All rights reserved.
//

#import "AbstractAssetCell.h"

#import "DAProgressOverlayView.h"


@interface AbstractAssetCell ()

@property DAProgressOverlayView *progressOverlayView;
@property UIActivityIndicatorView *activityIndicatorView;

@end


@implementation AbstractAssetCell


- (void)dealloc
{
    
    self.progressOverlayView.progress = 0.;
    self.progressOverlayView.hidden = YES;
    
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    
        // add transition animation
        // FIXME
        // I need to make it look nicer (like IKImageBrowserView animation
        // the old image scales out and fades out
        // the new one scales in and fades in
    
        //    self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        //
        //    self.layer.borderColor = [UIColor whiteColor].CGColor;
        //    self.layer.borderWidth = 4.0f;
        //    self.layer.shadowColor = [UIColor blackColor].CGColor;
        //    self.layer.shadowRadius = 3.0f;
        //    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        //    self.layer.shadowOpacity = 0.5f;
    
        // make sure we rasterize nicely for retina
        // should set this to YES if we start rotating the images
        // performance hit
        //self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        //self.layer.shouldRasterize = YES;
    
    //self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //self.imageView.clipsToBounds = YES;
    
    
        // add a progressView
    self.progressOverlayView = [[DAProgressOverlayView alloc] initWithFrame:self.imageView.bounds];
    [self.imageView addSubview:self.progressOverlayView];
    
    [self.progressOverlayView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
        // add constraints...
    
    [self.imageView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"H:|-0-[_progressOverlayView]-0-|"
                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                    metrics:nil
                                    views:NSDictionaryOfVariableBindings(_progressOverlayView)]];
    
    [self.imageView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-0-[_progressOverlayView]-0-|"
                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                    metrics:nil
                                    views:NSDictionaryOfVariableBindings(_progressOverlayView)]];
    
    
    
        // add a activityView
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.imageView.bounds];
    [self.imageView addSubview:self.activityIndicatorView];
    self.activityIndicatorView.hidesWhenStopped = YES;
    
    [self.activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
        // add constraints...
    
    [self.imageView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"H:|-0-[_activityIndicatorView]-0-|"
                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                    metrics:nil
                                    views:NSDictionaryOfVariableBindings(_activityIndicatorView)]];
    
    [self.imageView addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-0-[_activityIndicatorView]-0-|"
                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                    metrics:nil
                                    views:NSDictionaryOfVariableBindings(_activityIndicatorView)]];
    
    
}



- (void)prepareForReuse
{
    [super prepareForReuse];
    
        //self.imageView.image = nil;
    
    self.progressOverlayView.progress = 0.0;
    self.progressOverlayView.hidden = YES;
    
    [self.activityIndicatorView stopAnimating];
    
}



- (void)setIsDownloading:(BOOL)isDownloading
{
    _isDownloading = isDownloading;
    
    if (isDownloading) {
        
        [self.progressOverlayView displayOperationWillTriggerAnimation];
        
        double delayInSeconds = self.progressOverlayView.stateChangeAnimationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            
                // update the progress
            [self updateProgress];
            
        });
        
    } else {
        
        self.progressOverlayView.progress = 0.;
        self.progressOverlayView.hidden = YES;
        
    }
    
}



- (void)updateProgress
{
    
    CGFloat progress = 0.0;
    if (self.totalBytes > 0) {
        progress = ((float)self.transferredBytes/(float)self.totalBytes);
    }
    
    if (progress >= 1) {
        
        [self.progressOverlayView displayOperationDidFinishAnimation];
        double delayInSeconds = self.progressOverlayView.stateChangeAnimationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.progressOverlayView.progress = 0.;
            self.progressOverlayView.hidden = YES;
        });
        
    } else {
        
        self.progressOverlayView.progress = progress;
    }
}


- (void)setIsProcessing:(BOOL)isProcessing
{
    _isProcessing = isProcessing;
    
    if (isProcessing) {
        
        if (!self.activityIndicatorView.isAnimating) {
            [self.activityIndicatorView startAnimating];
        }
    } else {
        
        if (self.activityIndicatorView.isAnimating) {
            [self.activityIndicatorView stopAnimating];
        }
    }
    
}


- (void)setThumbnail:(UIImage *)thumbnail
{
    _thumbnail = thumbnail;
    
        // http://phildow.net/2012/05/31/flip-an-image-in-uiimageview-using-uiview-transitionwithview/
        // try animating the transition
        //self.imageView.image = thumbnail;
    [UIView transitionWithView: self
                      duration: 0.2f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^{
                        self.imageView.image = self->_thumbnail;
                    } completion:NULL];
    
}




@end
