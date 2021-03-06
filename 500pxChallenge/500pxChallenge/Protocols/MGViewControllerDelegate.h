//
//  MGViewControllerDelegate.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-24.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGViewControllerDelegate <NSObject>
@optional
- (void)viewControllerDidClose:(UIViewController *)viewController;
- (void)viewController:(UIViewController *)viewController didUpdateToIndexPath:(NSIndexPath *)indexPath;
@end
