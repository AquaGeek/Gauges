//
//  LoginViewController.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/12/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "LoginViewController.h"

#import "User.h"

@interface LoginViewController()

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

- (IBAction)signInTapped:(id)sender;

@end


#pragma mark -

@implementation LoginViewController

@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;

#pragma mark Object Lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    // Clear the text fields
    self.emailTextField.text = nil;
    self.passwordTextField.text = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
    {
        [textField resignFirstResponder];
        [self signInTapped:nil];
    }
    
    return NO;
}


#pragma mark -

- (IBAction)signInTapped:(id)sender
{
    // TODO: Validate the user's credentials
    [User authenticateWithEmail:self.emailTextField.text
                       password:self.passwordTextField.text
                        handler:^(NSError *error)
     {
         if (error == nil)
         {
             [self performSegueWithIdentifier:@"ListViewSegue" sender:self];
         }
         else
         {
             // TODO: Check the error
         }
     }];
}

@end
