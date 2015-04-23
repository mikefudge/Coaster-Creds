//
//  CoasterTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 20/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "CoasterTableViewController.h"
#import "Coaster.h"
#import "CoreDataStack.h"
#import "Park.h"
#import "CoasterTableViewCell.h"
#import "HomeViewController.h"
#import "TranslucentNavigationController.h"
#import "PopupRatingViewController.h"

#import <CoreData/CoreData.h>

@interface CoasterTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkOpenedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkNumCoastersLabel;
@property (strong, nonatomic) NSArray *coasterImagesArray;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *headerDarkView;

@property (weak, nonatomic) IBOutlet UIView *parkLabelsDarkView;
@property (strong, nonatomic) PopupRatingViewController *popupRatingViewController;

@end

@implementation CoasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.fetchedResultsController performFetch:nil];
    [_headerImageView setImage:[self getParkImage]];
    // Disable scroll until animation is completed
    self.tableView.scrollEnabled = NO;
    [self setLabels];
    [self animateLabels];
    [(TranslucentNavigationController *)self.navigationController presentTranslucentNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {

}


- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {
    
  
    
    
}

- (UIImage *)getParkImage {
    if (self.park.hasImage == YES) {
        NSString *filename = [NSString stringWithFormat:@"header_%@.png", self.park.imagePath];
        UIImage *image = [UIImage imageNamed:filename];
        return image;
    } else {
        return [UIImage imageNamed:@"coaster1-header"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset <= -64.0) {
        // Expand header image on scroll up
        [self moveElement:_headerImageView toYValue:yOffset xValue:((yOffset + 64) / 2) width:(self.tableView.frame.size.width + (-yOffset-64)) height:150 + -yOffset];
        
    } else if (yOffset > 50 && yOffset < 73) {
        // Fade out labels, move park name down slightly
        _parkOpenedDateLabel.alpha = (3 - (yOffset / 25));
        _parkNumCoastersLabel.alpha = (3 - (yOffset / 25));
        [self moveElement:_parkNameLabel toYValue: ((25 * ((200 * yOffset) - 10037)) / 4074)];
        [self moveElement:_headerImageView toYValue:-64.0 xValue:0 width:self.tableView.frame.size.width height:214];
        
    } else if (yOffset >= 73) {
        // Remove opened and num coaster labels, set park name to center, scroll header & dark view
        _parkOpenedDateLabel.alpha = 0;
        _parkNumCoastersLabel.alpha = 0;
        [self moveElement:_headerImageView toYValue:yOffset-137 xValue:0 width:self.tableView.frame.size.width height:214];
        [self moveElement:_parkLabelsDarkView toYValue:yOffset];
        [self moveElement:_parkNameLabel toYValue:28];
        
    } else {
        // Reset elements to default positions & alphas
        _parkOpenedDateLabel.alpha = 1;
        _parkNumCoastersLabel.alpha = 1;
        [self moveElement:_parkNameLabel toYValue:0];
        [self moveElement:_parkLabelsDarkView toYValue:73.0];
        [self moveElement:_headerImageView toYValue:-64.0 xValue:0 width:self.tableView.frame.size.width height:214];
    }
}

- (void)moveElement:(UIView *)element toYValue:(float)value {
    CGRect temp = element.frame;
    temp.origin.y = value;
    element.frame = temp;
}

- (void)moveElement:(UIView *)element toYValue:(float)yValue xValue:(float)xValue width:(float)width height:(float)height {
    CGRect temp = element.frame;
    temp.origin.y = yValue;
    temp.origin.x = xValue;
    temp.size.height = height;
    temp.size.width = width;
    element.frame = temp;
}

- (void)setLabels {
    _parkNameLabel.text = self.park.name;
    [self updateNumCoastersLabel];
    if (self.park.year != 0) {
        _parkOpenedDateLabel.text = [NSString stringWithFormat:@"Opened in %hd", self.park.year];
    } else {
        _parkOpenedDateLabel.text = [NSString stringWithFormat:@"Opening year not known"];
    }
    [_parkNameLabel setAlpha:0];
    [_parkOpenedDateLabel setAlpha:0];
    [_parkNumCoastersLabel setAlpha:0];
}

- (void)updateNumCoastersLabel {
    int total = (int)[_park.coasters count];
    int rideCount = 0;
    NSString *grammar;
    for (Coaster *coaster in _park.coasters) {
        if (coaster.ridden) {
            rideCount++;
        }
    }
    if (total == 1) {
        grammar = @"coaster";
    } else {
        grammar = @"coasters";
    }
    if (total-rideCount == 0) {
        _parkNumCoastersLabel.text = @"All coasters ridden!";
    } else {
        _parkNumCoastersLabel.text = [NSString stringWithFormat:@"%d out of %d %@ remaining", total-rideCount, total, grammar];
    }
}

- (void)animateLabels {
    // Create origin frames and move labels offscreen
    CGRect parkNameFrame = [self prepareLabel:_parkNameLabel byMovingToX:200];
    CGRect parkOpenedFrame = [self prepareLabel:_parkOpenedDateLabel byMovingToX:200];
    CGRect parkNumCoastersFrame = [self prepareLabel:_parkNumCoastersLabel byMovingToX:200];
    // Move labels back into view
    
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.6 animations:^{
            _parkNameLabel.frame = parkNameFrame;
            [_parkNameLabel setAlpha:1];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.6 animations:^{
            _parkOpenedDateLabel.frame = parkOpenedFrame;
            [_parkOpenedDateLabel setAlpha:1];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.5 animations:^{
            _parkNumCoastersLabel.frame = parkNumCoastersFrame;
            [_parkNumCoastersLabel setAlpha:1];
        }];
    } completion: ^(BOOL finished) {
        self.tableView.scrollEnabled = YES;
    }];
}

- (CGRect)prepareLabel:(UILabel *)label byMovingToX:(CGFloat)value {
    CGRect initialFrame = label.frame;
    CGRect displacedFrame = initialFrame;
    displacedFrame.origin.x = value;
    label.frame = displacedFrame;
    return initialFrame;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        return self.fetchedResultsController.fetchedObjects.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        CoasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        CoasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        Coaster *coaster = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.coaster = coaster;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureCell];
        return cell;
    }
}

#pragma mark - Core Data

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self coasterFetchRequest];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (NSFetchRequest *)coasterFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Coaster"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"park.name like %@ && park.state like %@ && park.country like %@", self.park.name, self.park.state, self.park.country];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return fetchRequest;
}

#pragma mark - IBActions

- (IBAction)rideButtonWasPressed:(id)sender {
    CoasterTableViewCell *cell = [self getCellForSender:sender];
    NSDate *date = [NSDate date];
    cell.coaster.dateLastRidden = date;
    [cell.coaster toggleRidden];
    if (cell.coaster.ridden) {
        [cell configureCell];
        [self showRatingViewForCell:cell];
    } else {
        cell.coaster.rating = 0;
        [cell configureCell];
    }
    [self updateNumCoastersLabel];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (IBAction)ratingViewWasPressed:(id)sender {
    CoasterTableViewCell *cell = [self getCellForSender:sender];
    if (cell.coaster.ridden) {
        [self showRatingViewForCell:cell];
    }
}

- (CoasterTableViewCell *)getCellForSender:(id)sender {
    CGPoint senderPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:senderPosition];
    CoasterTableViewCell *cell = (CoasterTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}


- (void)showRatingViewForCell:(CoasterTableViewCell *)cell {
    _popupRatingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PopupRatingViewController"];
    _popupRatingViewController.cell = cell;
    [_popupRatingViewController showInView:self.view.superview animated:YES];
}

- (IBAction)backWasPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
