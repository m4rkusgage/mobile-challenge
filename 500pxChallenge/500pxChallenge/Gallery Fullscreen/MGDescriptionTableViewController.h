//
//  MGDescriptionTableViewController.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-22.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGViewControllerDelegate.h"
#import "MGPhoto.h"

@interface MGDescriptionTableViewController : UITableViewController
@property (weak, nonatomic) id<MGViewControllerDelegate> controllerDelegate;
@property (strong, nonatomic) MGPhoto *photo;
@end
