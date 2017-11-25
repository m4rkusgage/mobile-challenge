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

@interface MGDescriptionTableViewController ()<MGReusableViewDelegate>
@property (strong, nonatomic) NSMutableArray *photoInfo;
@end

@implementation MGDescriptionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoInfo = [[NSMutableArray alloc] init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MGTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MGDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"descriptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MGCreatedAtTableViewCell" bundle:nil] forCellReuseIdentifier:@"uploadedCell"];
   
}

#pragma mark - Table view data source

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
            MGTitleTableViewCell *titleCell = (MGTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            [titleCell.titleLabel setText:self.photo.photoTitle];
            returnCell = titleCell;
            break;
        }
        case 1: {
            MGDescriptionTableViewCell *descriptionCell = (MGDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
            [descriptionCell.descriptionLabel setText:self.photo.photoDescription];
            returnCell = descriptionCell;
            break;
        }
        case 2: {
            MGCreatedAtTableViewCell *uploadedCell = (MGCreatedAtTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"uploadedCell"];
            [uploadedCell.uploadedOnLabel setText:[self normalizeDateFormat:self.photo.createdAt]];
            returnCell = uploadedCell;
            break;
        }
        default:
            break;
    }
    
    return returnCell;
}

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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)reusableView:(UICollectionReusableView *)reusableView buttonPressed:(ReusableViewButton)buttonType {
    if (buttonType == ReusableViewButtonClose) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.controllerDelegate viewControllerDidClose:self];
        }];
    }
}

- (NSString *)normalizeDateFormat:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *dates = [dateFormatter dateFromString:date];
    
    [dateFormatter setDateFormat:@"MMM d, yyyy"];
    NSString *newDate = [dateFormatter stringFromDate:dates];
    return newDate;
}
@end
