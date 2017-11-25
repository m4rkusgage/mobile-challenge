//
//  MGDescriptionTableViewController.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-22.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGDescriptionTableViewController.h"
#import "MGHeaderCollectionReusableView.h"
#import "MGTitleTableViewCell.h"
#import "MGDescriptionTableViewCell.h"
#import "MGCreatedAtTableViewCell.h"
#import "NSString+MGUtilities.h"

@interface MGDescriptionTableViewController ()<MGReusableViewDelegate>
@end

@implementation MGDescriptionTableViewController

static NSString * const reuseTitleCellIdentifier = @"titleCell";
static NSString * const reuseDescriptionCellIdentifier = @"descriptionCell";
static NSString * const reuseCreatedCellIdentifier = @"createdCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MGTitleTableViewCell" bundle:nil] forCellReuseIdentifier:reuseTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MGDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:reuseDescriptionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MGCreatedAtTableViewCell" bundle:nil] forCellReuseIdentifier:reuseCreatedCellIdentifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *returnCell;
    switch (indexPath.item) {
        case 0: {
            MGTitleTableViewCell *titleCell = (MGTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseTitleCellIdentifier];
            [titleCell.titleLabel setText:self.photo.photoTitle];
            returnCell = titleCell;
            break;
        }
        case 1: {
            MGDescriptionTableViewCell *descriptionCell = (MGDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseDescriptionCellIdentifier];
            [descriptionCell.descriptionLabel setText:self.photo.photoDescription];
            returnCell = descriptionCell;
            break;
        }
        case 2: {
            MGCreatedAtTableViewCell *uploadedCell = (MGCreatedAtTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseCreatedCellIdentifier];
            [uploadedCell.uploadedOnLabel setText:[NSString stringByNormalizingDateString:self.photo.createdAt]];
            returnCell = uploadedCell;
            break;
        }
        default:
            break;
    }
    return returnCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MGHeaderCollectionReusableView *header =(MGHeaderCollectionReusableView *)[[[NSBundle mainBundle] loadNibNamed:@"MGHeaderCollectionReusableView" owner:nil options:nil] firstObject];
    [header setReusableViewDelegate:self];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

#pragma mark - MGReusableViewDelegate
- (void)reusableView:(UICollectionReusableView *)reusableView buttonPressed:(ReusableViewButton)buttonType {
    if (buttonType == ReusableViewButtonClose) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.controllerDelegate viewControllerDidClose:self];
        }];
    }
}

@end
