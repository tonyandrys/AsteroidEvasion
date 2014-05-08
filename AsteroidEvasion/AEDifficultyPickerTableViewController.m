//
//  AEDifficultyPickerTableViewController.m
//  AsteroidEvasion
//
//  Created by Tony Andrys on 5/7/14.
//  Copyright (c) 2014 Tony Andrys, Ian Brauer, Patrick Walsh. All rights reserved.
//

#import "AEDifficultyPickerTableViewController.h"

@interface AEDifficultyPickerTableViewController ()

@end

@implementation AEDifficultyPickerTableViewController {
    
    // Holds list of difficulty to be displayed in the picker
    NSArray *difficultyList;
    NSArray *difficultySubtitleList;
    
    // Holds the user's selected index
    NSUInteger selectedIndex;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    difficultyList = @[@"Easy", @"Medium", @"Hard", @"Impossible"];
    difficultySubtitleList = @[@"1x points", @"2x points", @"3x points", @"4x points (but good luck)"];
    
    // The difficulty is stored as a signed integer from 0 to 3, where 0 represents Easy and 3 represents Impossible, so the selected difficulty maps to the selected row with no need to index the list options.
    selectedIndex = self.difficulty;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [difficultyList count];
}

// Method called to configure new cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DifficultyCell" forIndexPath:indexPath];
    
    // Set the title and subtitle of this cell
    cell.textLabel.text = difficultyList[indexPath.row];
    cell.detailTextLabel.text = difficultySubtitleList[indexPath.row];
    
    // If this cell matches with the user's selected difficulty, mark this cell with a checkbox.
    if (indexPath.row == self.difficulty) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

// Fired when a cell is selected by the user
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (selectedIndex != NSNotFound) {
        // Get an instance of the cell that was just deselected and remove its checkbox
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Mark the cell that was just selected with a checkbox and get a reference to the cell
    selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Send the new difficulty to the delegate to update the player's profile
    NSLog(@"Difficulty setting changed to %i", indexPath.row);
    [self.delegate difficultyPickerViewController:self didSelectDifficulty:indexPath.row];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
