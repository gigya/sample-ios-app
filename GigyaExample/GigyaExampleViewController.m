//
//  GigyaExampleViewController.m
//  GigyaExample
//
//  Created by Brian Fagan on 8/28/12.
//  Copyright (c) 2012 Brian Fagan. All rights reserved.
//

#import "GigyaExampleViewController.h"
#import "GSAPI.h"

@interface GigyaExampleViewController ()

@end

@implementation GigyaExampleViewController
@synthesize gsAPI;

//***Replace this with your API key, which can be located in the Gigya dashboard at http://platform.gigya.com
static NSString *apiKey = @"2_Y82PzwJ_chSFImHXaIDJClnLyJzmk-VFOavSsaNTzl6m901s_NNxRAS0xJ3bd3_N";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Load the Gigya API with a reference to your API key
    gsAPI = [[GSAPI alloc] initWithAPIKey:apiKey];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the keyboard when the view outside the text field is touched
    [textView resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)loginPushed:(id)sender
{
    //Check if the user is already logged in
    if ([[gsAPI getSession] IsValid]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You are already logged in." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        // Load the Gigya login UI component, passing this View Controller as a delegate.
        [gsAPI showLoginUI:nil ViewController:self delegate:self context:nil];
    }
}

- (IBAction)logoutPushed:(id)sender
{
    // Check if the user is already logged out
    if (![[gsAPI getSession] IsValid]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You are already logged out." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        // Log the user out
        [gsAPI logout];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You are now logged out." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (IBAction)sharePushed:(id)sender
{
    if (![[gsAPI getSession] IsValid]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You must be logged in to share." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        // Define a userAction to be published
        GSObject *userAction = [GSObject new];
        [userAction putStringValue:@"This is my title" forKey:@"title"];
        [userAction putStringValue:@"http://www.gigya.com" forKey:@"linkBack"];
        [userAction putStringValue:@"This is my description." forKey:@"description"];
        
        // Take the message from the textView
        [userAction putStringValue:[textView text] forKey:@"userMessage"];
    
        // Add an image to the userAction
        GSObject *image = [GSObject new];
        [image putStringValue:@"http://www.gigya.com/wp-content/themes/gigyatm/images/gigya-logo.gif" forKey:@"src"];
        [image putStringValue:@"http://www.gigya.com" forKey:@"href"];
        [image putStringValue:@"image" forKey:@"type"];
    
        // Create a media items array and add the image object to it
        NSArray *mediaItems = [NSArray arrayWithObject:image];
        
        // Add the media items to the user action object
        [userAction putNSArrayValue:mediaItems forKey:@"mediaItems"];
    
        GSObject *pParams = [GSObject new];
        
        // Add the user action object to the parameters for the API call
        [pParams putGSObjectValue:userAction forKey:@"userAction"];
    
        // Send the request, using this View Controller as the delegate
        [gsAPI sendRequest:@"socialize.publishUserAction" params:pParams delegate:self context:nil];
    }
}

-(void)updateProfile
{
    
}

// Fired when the login operation completes
- (void)  gsLoginUIDidLogin:(NSString*)provider user:(GSObject*)user context:(id)context;
{
    NSString *msg = @"Welcome ";
    msg = [msg stringByAppendingString:[user getString:@"nickname"]];
    msg = [msg stringByAppendingString:@", you are now logged in."];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    NSLog(@"gsLoginUIDidLogin: provider=%@ user=%@ context=%@",provider,[user stringValue],context);
}

// Fired when a Gigya API response is received
- (void) gsDidReceiveResponse:(NSString*)method response:(GSResponse*)response context:(id)context
{
    NSLog(@"Gigya response: %@", response.ResponseText);
    
    // Handle response here...
    if (response.errorCode == 0) {  // SUCCESS! response status = OK
        if (method == @"socialize.publishUserAction"){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Action published." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } else {
	NSLog(@"Gigya error: %@", response.errorMessage);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"API Call failed. Check the log for errors." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
