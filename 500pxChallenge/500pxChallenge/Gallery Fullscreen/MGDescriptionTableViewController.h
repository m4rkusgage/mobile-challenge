//
//  MGDescriptionTableViewController.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-22.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGPhoto.h"

@protocol MGDescriptionViewControllerDelegate <NSObject>
- (void)viewControllerDidClose:(UIViewController *)viewController;
@end

@interface MGDescriptionTableViewController : UITableViewController
@property (weak, nonatomic) id<MGDescriptionViewControllerDelegate> controllerDelegate;
@property (strong, nonatomic) MGPhoto *photo;
@end
