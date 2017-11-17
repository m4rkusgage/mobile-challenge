//
//  ViewController.m
//  500pxChallenge
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "ViewController.h"
#import "MGApiClient.h"

@interface ViewController ()
@property (strong, nonatomic) MGApiClient *apiClient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.apiClient getListPhotosForFeature:kMG500pxPhotoFeaturePopular
                         includedCategories:NULL
                         excludedCategories:@[kMG500pxPhotoCategoryNude]
                                       page:1
                                 completion:^(NSArray *result, NSError *error) {
        
                                     NSLog(@"PHOTOS: %@",result);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MGApiClient *)apiClient {
    if (!_apiClient) {
        _apiClient = [MGApiClient sharedInstance];
    }
    return _apiClient;
}

- (IBAction)getAuthorizeButtonPressed:(id)sender {
    [self.apiClient authorize];
}

@end
