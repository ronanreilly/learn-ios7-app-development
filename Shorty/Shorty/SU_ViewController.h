//
//  SU_ViewController.h
//  Shorty
//
//  Created by Ronan Sean Reilly on 14/06/2014.
//  Copyright (c) 2014 Ronan Sean Reilly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SU_ViewController : UIViewController

// Weak means property that will not hang on to object it is connected to.
// non atomic, makes property more accesible, for multitasking

@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
