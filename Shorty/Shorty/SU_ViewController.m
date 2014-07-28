//
//  SU_ViewController.m
//  Shorty
//
//  Created by Ronan Sean Reilly on 14/06/2014.
//  Copyright (c) 2014 Ronan Sean Reilly. All rights reserved.
//

#import "SU_ViewController.h"

@interface SU_ViewController ()
{
    // Private Vars
    NSURLConnection *shortenURLConnection;
    NSMutableData *shortURLData;
}

@end

#define kGoDaddyAccountKey @"4defc2bd9b604580a1dc1eb528bc9058"

@implementation SU_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)loadLocation:(id)sender
{
    NSString *urlText = self.urlField.text;
    
    if(![urlText hasPrefix:@"http:"] && ![urlText hasPrefix:@"https:"]){
        if(![urlText hasPrefix:@"//"])
            urlText = [@"//" stringByAppendingString:urlText];
            urlText = [@"http:" stringByAppendingString:urlText];
        
    }
    
    // Covert to URL
    NSURL *url = [NSURL URLWithString:urlText];
    
    // Display url in our web view
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    // Disable the shorten button until webpage has loaded.
    self.shortenButton.enabled = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    // Enable the shorten button as webpage has loaded.
    self.shortenButton.enabled = YES;
    // Once page has loaded chenge the value of our text field.
    self.urlField.text = webView.request.URL.absoluteString;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // Message for our error when page does not load.
    NSString *message = [NSString stringWithFormat:@"A problem occurred trying to load this page%@", error.localizedDescription];
    // Our laert view.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load URL" message:message delegate:nil cancelButtonTitle:@"That's Sad!" otherButtonTitles:nil, nil];
    
    // Show our alert.
    [alert show];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.shortLabel.title =@"failed";
    self.clipboardButton.enabled = NO;
    self.shortenButton.enabled = YES;
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Store data returned from GoDaddy
    [shortURLData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Turn ASCII bytes from connection didReceiveData into a string
    NSString *shortURLString = [[NSString alloc] initWithData:shortURLData encoding:NSUTF8StringEncoding];
    // reset url to shortened URL
    self.shortLabel.title = shortURLString;
    
    self.clipboardButton.enabled = YES;
}

-(IBAction)shortenUrl:(id)sender{
    
    // Get our current URL
    NSString *urlToShorten = self.webView.request.URL.absoluteString;
    
    //Construct our YRL for GoDaddy's Url Shortening service
    NSString *urlString = [NSString stringWithFormat:@"http://api.x.co/Squeeze.svc/text/%@?url=%@", kGoDaddyAccountKey, [urlToShorten stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // This will collect the data returned
    shortURLData = [NSMutableData new];
    
    // Our request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Our connection object
    shortenURLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    self.shortenButton.enabled = NO;
}

-(IBAction)clipboardURL:(id)sender
{
    // Gets URL from connectionDidFinishLoading
    NSString *shortURLString = self.shortLabel.title;
    
    // Turn URL into a URL object
    NSURL *shortURL = [NSURL URLWithString:shortURLString];
    
    // Returns teh system wide pasteboard, add the short url to our clipboard
    [[UIPasteboard generalPasteboard] setURL:shortURL];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
