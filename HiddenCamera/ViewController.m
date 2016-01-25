//
//  ViewController.m
//  HiddenCamera
//
//  Created by Marco Martignone on 08/10/2015.
//  Copyright © 2015 Marco Martignone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:YES];
    
    if (device.proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(proximityChanged:)
                                                     name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:device];
    }

    [self setupAVCapture];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.isRecording = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)proximityChanged:(NSNotification *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES && self.isRecording == NO) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [self performSelector:@selector(takePhoto)
                   withObject:self
                   afterDelay:2];
        
        self.isRecording = YES;
        
        NSLog(@"Proximity Sensor YES");
    } else {
        NSLog(@"Promimity Sensor NO");
    }
}

- (void)setupAVCapture
{
    NSError *error = nil;
  
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;

    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    [self.session addInput:self.videoInput];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
}

- (void)takePhoto
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection == nil) {
        return;
    }
    
    
    [self.stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
     }];
    
    self.isRecording = NO;
}

@end
