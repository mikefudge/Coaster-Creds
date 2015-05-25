//
//  CoasterViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 20/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "CoasterViewController.h"
#import "Coaster.h"
#import "CoreDataStack.h"
#import "Park.h"
#import "CoasterTableViewCell.h"
#import "HomeViewController.h"
#import "TranslucentNavigationController.h"
#import "PopupRatingViewController.h"

#import <CoreData/CoreData.h>

#define NUMBER_OF_FOOTER_IMAGES 4
#define NUMBER_OF_HEADER_IMAGES 14
#define HEADER_IMAGE_HEIGHT 240
#define DARK_VIEW_DEFAULT_ALPHA 0.5

@interface CoasterViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkNumCoastersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *headerDarkView;
@property (strong, nonatomic) PopupRatingViewController *popupRatingViewController;
@property (weak, nonatomic) IBOutlet UIImageView *footerImageView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *parkButtonsView;

@end

@implementation CoasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Automatic table row height
    self.tableView.estimatedRowHeight = 98.0;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Get coasters
     [self.fetchedResultsController performFetch:nil];
    // Set header and footer images, and labels
    [_headerImageView setImage:[self getParkImage]];
    [_footerImageView setImage:[self getFooterImage]];
    [self setLabels];
    // Set navigation bar to be transparent
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    _tableView.backgroundView = _footerImageView;
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
    [self.tableView reloadData];
}

// Returns image associated with park. If there is no image, will return a random image from a selection of default images
- (UIImage *)getParkImage {
    if (self.park.hasImage == YES) {
        NSString *filename = [[NSString stringWithFormat:@"header_%@.png", self.park.imagePath] lowercaseString];
        UIImage *image = [UIImage imageNamed:filename];
        return image;
    } else {
        NSMutableArray *defaultHeaderImages = [[NSMutableArray alloc] init];
        for (int i = 1; i <= NUMBER_OF_HEADER_IMAGES; i++) {
            NSString *imageName = [[NSString alloc] initWithFormat:@"header_default%d.png", i];
            UIImage *image = [UIImage imageNamed:imageName];
            [defaultHeaderImages addObject:image];
        }
        int r = arc4random_uniform(NUMBER_OF_HEADER_IMAGES-1);
        return [defaultHeaderImages objectAtIndex:r];
    }
}

// Returns a random footer image
- (UIImage *)getFooterImage {
    
    NSMutableArray *footerImagesArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= NUMBER_OF_FOOTER_IMAGES; i++) {
        NSString *imageName = [[NSString alloc] initWithFormat:@"footer_coaster%d.png", i];
        UIImage *image = [UIImage imageNamed:imageName];
        [footerImagesArray addObject:image];
    }
    int r = arc4random_uniform(NUMBER_OF_FOOTER_IMAGES-1);
    return [footerImagesArray objectAtIndex:r];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if (yOffset <= 0) {
        // Expand header views on scroll up
        [self moveElement:_headerImageView toYValue:yOffset xValue:(yOffset / 2) width:(self.tableView.frame.size.width + (-yOffset)) height:HEADER_IMAGE_HEIGHT + -yOffset];
        // Expand header dark view
        [self moveElement:_headerDarkView toYValue:yOffset xValue:(yOffset / 2) width:(self.tableView.frame.size.width + (-yOffset)) height:HEADER_IMAGE_HEIGHT + -yOffset];
        // Pin navigation bar
        [self moveElement:_navigationBar toYValue:22 + (yOffset)];
        // Fade out labels & dark view
        _parkNameLabel.alpha = (1 + (yOffset / 100));
        _parkNumCoastersLabel.alpha = (1 + (yOffset / 100));
        _parkButtonsView.alpha = (1 + (yOffset / 100));
        _navigationBar.alpha = (1 + (yOffset / 100));
        _headerDarkView.alpha = (DARK_VIEW_DEFAULT_ALPHA + (yOffset / 100));
    } else if (yOffset >= _headerImageView.frame.size.height - _navigationBar.frame.size.height - 22) {
        [self moveElement:_headerImageView toYValue:yOffset - (_headerImageView.frame.size.height - _navigationBar.frame.size.height - 22) xValue:0 width:self.tableView.frame.size.width height:_headerImageView.frame.size.height];
        [self moveElement:_headerDarkView toYValue:yOffset - (_headerDarkView.frame.size.height - _navigationBar.frame.size.height - 22) xValue:0 width:self.tableView.frame.size.width height:_headerDarkView.frame.size.height];
        _headerDarkView.alpha = DARK_VIEW_DEFAULT_ALPHA;
     
    } else {
        // Reset header views
        [self moveElement:_headerImageView toYValue:0 xValue:0 width:self.tableView.frame.size.width height:HEADER_IMAGE_HEIGHT];
        [self moveElement:_headerDarkView toYValue:0 xValue:0 width:self.tableView.frame.size.width height:HEADER_IMAGE_HEIGHT];
        // Reset labels & dark view alphas
        _headerDarkView.alpha = DARK_VIEW_DEFAULT_ALPHA;
        _navigationBar.alpha = 1;
        _parkNameLabel.alpha = (1 - (yOffset / 100));
        _parkNumCoastersLabel.alpha = (1 - (yOffset / 100));
        _parkButtonsView.alpha = (1 - (yOffset / 100));
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
}

- (void)updateNumCoastersLabel {
    int total = 0;
    int count = 0;
    for (Coaster *coaster in _park.coasters) {
        if (coaster.status == 1) {
            total++;
            if (coaster.ridden == YES) {
                count++;
            }
        }
    }
    _parkNumCoastersLabel.text = [NSString stringWithFormat:@"%d/%d", count, total];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_fetchedResultsController.fetchedObjects.count > 0) {
        /*
        id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
         */
        return _fetchedResultsController.fetchedObjects.count;
        
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_fetchedResultsController.fetchedObjects.count == 0) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fetchedResultsController.fetchedObjects.count == 0) {
        return 118;
    } else {
        return 118;
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY self.park == %@", _park];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
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
        //[self showRatingViewForCell:cell];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
