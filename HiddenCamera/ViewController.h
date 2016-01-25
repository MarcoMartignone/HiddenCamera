//
//  ViewController.h
//  HiddenCamera
//
//  Created by Marco Martignone on 08/10/2015.
//  Copyright © 2015 Marco Martignone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController

@property bool isRecording;

@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession *session;

@end

