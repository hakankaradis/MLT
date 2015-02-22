//
//  ViewController.h
//  IspeechTest
//
//  Created by hakan karadis on 9/16/13.
//  Copyright (c) 2013 hakan karadis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iSpeechSDK.h"
@interface ViewController : UIViewController <ISSpeechRecognitionDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITextView *textView2;
@property (strong,nonatomic) UIButton *menuBtn;

@end
