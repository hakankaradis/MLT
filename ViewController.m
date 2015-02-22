//
//  ViewController.m
//  IspeechTest
//
//  Created by hakan karadis on 9/16/13.
//  Copyright (c) 2013 hakan karadis. All rights reserved.
//

#import "ViewController.h"
#import "ECSlidingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "tesseract.h"

@interface ViewController ()
@end

@implementation ViewController
@synthesize textView,textView2,menuBtn;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [tesseract setImage:[UIImage imageNamed:@"deneme.jpg"]];
    [tesseract recognize];
    self.textView2.text = [tesseract recognizedText];
    
  //  NSLog(@"%@", [tesseract recognizedText]);
  
    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 25, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]){
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.view addSubview:menuBtn];
    
   
}
-(IBAction)revealMenu:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECRight];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    [self.textView2 resignFirstResponder];
}
- (IBAction)recognize:(id)sender {
    ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];
    NSError *err;
	
	[recognition setDelegate:self];

	if(![recognition listen:&err]) {
		NSLog(@"ERROR: %@", err);
	}

}
- (IBAction)speak:(id)sender {
    NSString *text;
    if(self.textView.text == nil){
        text = @"HELLO";
    }
    else
        text = self.textView.text;
    ISSpeechSynthesis *synthesis = [[ISSpeechSynthesis alloc] initWithText:text];
    
    NSError *err;
    
    if(![synthesis speak:&err]) {
        NSLog(@"ERROR: %@", err);
    }
}
- (IBAction)translate:(id)sender {
    NSString *URL = @"http://translate.google.com/translate_a/t?client=t&text=";
    URL = [[[URL stringByAppendingString:textView.text] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] ;
    URL = [URL stringByAppendingString:@"&sl=en&tl=tr"];
    NSLog(@"URL %@", URL);
    NSError *error = nil;
    NSString *translated = [NSString stringWithContentsOfURL:[NSURL URLWithString:URL] encoding:NSWindowsCP1254StringEncoding error:&error];
    NSArray *arrays = [translated componentsSeparatedByString:@","];
    self.textView2.text = [[arrays objectAtIndex:0] stringByReplacingOccurrencesOfString:@"[" withString:@""];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)recognition:(ISSpeechRecognition *)speechRecognition didGetRecognitionResult:(ISSpeechRecognitionResult *)result {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
	NSLog(@"Result: %@", result.text);
	
	//[label setText:result.text];
    [textView setText:result.text];
}

- (void)recognition:(ISSpeechRecognition *)speechRecognition didFailWithError:(NSError *)error {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
	NSLog(@"Error: %@", error);
}

- (void)recognitionCancelledByUser:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

- (void)recognitionDidBeginRecording:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

- (void)recognitionDidFinishRecording:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}
@end
