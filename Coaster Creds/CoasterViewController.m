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
#import <MapKit/MapKit.h>

#define NUMBER_OF_FOOTER_IMAGES 4
#define NUMBER_OF_HEADER_IMAGES 13
#define HEADER_IMAGE_HEIGHT 240
#define DARK_VIEW_DEFAULT_ALPHA 0.5

@interface CoasterViewController () <NSFetchedResultsControllerDelegate, UIActionSheetDelegate>

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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) NSString *currentSort;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;

@end

@implementation CoasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Tableview row height
    self.tableView.estimatedRowHeight = 98.0;
    // Get coasters
     [self.fetchedResultsController performFetch:nil];
    // Set header and footer images, and labels
    UIImage *headerImage = [self getParkImage];
    [_headerImageView setImage:headerImage];
    [_blurImageView setImage:headerImage];
    [_footerImageView setImage:[self getFooterImage]];
    [self setLabels];
    // Set navigation bar to be transparent
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    // Set footerview as background of tableview
    _tableView.backgroundView = _footerImageView;
    // Eliminate "extra" seperators
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Default to sorting coasters by name
    _currentSort = @"name";
    [_sortButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"AvenirNext-Medium" size:18.0], NSFontAttributeName,
                                            nil] forState:UIControlStateNormal];
    [_doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"AvenirNext-Medium" size:18.0], NSFontAttributeName,
                                         nil] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
    blurView.frame = _blurImageView.frame;
    [_blurImageView addSubview:blurView];
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
        int r = arc4random_uniform(NUMBER_OF_HEADER_IMAGES);
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
    // Scroll up, expand header views
    if (yOffset <= 0) {
        // Expand header views on scroll up
        [self moveElement:_headerImageView toYValue:yOffset xValue:(yOffset / 1.5) width:(self.tableView.frame.size.width + ((-yOffset) * 1.5)) height:HEADER_IMAGE_HEIGHT + -yOffset];
        // Expand header dark view
        [self moveElement:_headerDarkView toYValue:yOffset xValue:(yOffset / 1.5) width:(self.tableView.frame.size.width + ((-yOffset) * 1.5)) height:HEADER_IMAGE_HEIGHT + -yOffset];
        // Pin navigation bar
        [self moveElement:_navigationBar toYValue:22 + (yOffset)];
        // Fade out labels & dark view
        _parkNameLabel.alpha = (1 + (yOffset / 100));
        _parkNumCoastersLabel.alpha = (1 + (yOffset / 100));
        _parkButtonsView.alpha = (1 + (yOffset / 100));
        _navigationBar.alpha = (1 + (yOffset / 100));
        _headerDarkView.alpha = (DARK_VIEW_DEFAULT_ALPHA + (yOffset / 100));
    }
    // Fade in blur view, fade in navigation bar title
    else if (yOffset >= 135 && yOffset < _headerImageView.frame.size.height - _navigationBar.frame.size.height - 22) {
        _blurImageView.alpha = ((0.0263 * yOffset) - 3.5526);
        [self moveElement:_headerImageView toYValue:0 xValue:0 width:self.tableView.frame.size.width height:HEADER_IMAGE_HEIGHT];
        [self moveElement:_headerDarkView toYValue:0 xValue:0 width:self.tableView.frame.size.width height:HEADER_IMAGE_HEIGHT];
        [self moveElement:_blurImageView toYValue:0 xValue:0 width:self.tableView.frame.size.width height:HEADER_IMAGE_HEIGHT];
        // Reset labels & dark view alphas
        _headerDarkView.alpha = DARK_VIEW_DEFAULT_ALPHA;
        _navigationBar.alpha = 1;
        _parkNameLabel.alpha = (1 - (yOffset / 100));
        _parkNumCoastersLabel.alpha = (1 - (yOffset / 100));
        _parkButtonsView.alpha = (1 - (yOffset / 100));
        [self moveElement:_navigationBar toYValue:22];
    }
    // Pin blur, header, nav to top
    else if (yOffset >= _headerImageView.frame.size.height - _navigationBar.frame.size.height - 22) {
        [self moveElement:_headerImageView toYValue:yOffset - (_headerImageView.frame.size.height - _navigationBar.frame.size.height - 22) xValue:0 width:self.tableView.frame.size.width height:_headerImageView.frame.size.height];
        [self moveElement:_headerDarkView toYValue:yOffset - (_headerDarkView.frame.size.height - _navigationBar.frame.size.height - 22) xValue:0 width:self.tableView.frame.size.width height:_headerDarkView.frame.size.height];
        [self moveElement:_blurImageView toYValue:yOffset - (_blurImageView.frame.size.height - _navigationBar.frame.size.height - 22) xValue:0 width:self.tableView.frame.size.width height:_blurImageView.frame.size.height];
        _headerDarkView.alpha = DARK_VIEW_DEFAULT_ALPHA;
        [self moveElement:_navigationBar toYValue:22];
        _blurImageView.alpha = 1;
    }
    // y > 0, y < 135
    else {
        // Reset header views
        [self moveElement:_headerImageView toYValue:0 xValue:0 width:self.tableView.frame.size.width height:HEADER_IMAGE_HEIGHT];
        [self moveElement:_headerDarkView toYValue:0 xValue:0 width:self.tableView.frame.size.width height:HEADER_IMAGE_HEIGHT];
        [self moveElement:_blurImageView toYValue:0 xValue:0 width:self.tableView.frame.size.width height:HEADER_IMAGE_HEIGHT];
        // Reset labels & dark view alphas
        _headerDarkView.alpha = DARK_VIEW_DEFAULT_ALPHA;
        _navigationBar.alpha = 1;
        _blurImageView.alpha = 0;
        _parkNameLabel.alpha = (1 - (yOffset / 100));
        _parkNumCoastersLabel.alpha = (1 - (yOffset / 100));
        _parkButtonsView.alpha = (1 - (yOffset / 100));
        [self moveElement:_navigationBar toYValue:22];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (IBAction)sortWasPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sort coasters by.." message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *name = [UIAlertAction actionWithTitle:@"Name" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // If controller is already sorted by name, reverse the order
        if ([_currentSort isEqual:@"name"]) {
            _currentSort = @"nameDescending";
            NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]];
            [[_fetchedResultsController fetchRequest] setSortDescriptors:sortDescriptors];
        } else {
            _currentSort = @"name";
            NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
            [[_fetchedResultsController fetchRequest] setSortDescriptors:sortDescriptors];
        }
        NSError *error;
        if (![[self fetchedResultsController] performFetch:&error]) {
        }
        [_tableView reloadData];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *year = [UIAlertAction actionWithTitle:@"Year Opened" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([_currentSort isEqual:@"year"]) {
            _currentSort = @"yearAscending";
            NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES]];
            [[_fetchedResultsController fetchRequest] setSortDescriptors:sortDescriptors];
        } else {
            _currentSort = @"year";
            NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO]];
            [[_fetchedResultsController fetchRequest] setSortDescriptors:sortDescriptors];
        }
        NSError *error;
        if (![[self fetchedResultsController] performFetch:&error]) {
        }
        [_tableView reloadData];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *rating = [UIAlertAction actionWithTitle:@"Rating" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([_currentSort isEqual:@"rating"]) {
            _currentSort = @"ratingAscending";
            NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:YES]];
            [[_fetchedResultsController fetchRequest] setSortDescriptors:sortDescriptors];
        } else {
            _currentSort = @"rating";
            NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO]];
            [[_fetchedResultsController fetchRequest] setSortDescriptors:sortDescriptors];
        }
        NSError *error;
        if (![[self fetchedResultsController] performFetch:&error]) {
        }
        [_tableView reloadData];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:name];
    [alertController addAction:year];
    [alertController addAction:rating];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)websiteButtonWasPressed:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:_park.website];
    // Check to see if website can be opened
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Go to park's website?" message:@"This will open the park's website in your browser." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alertController addAction:cancel];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    // If website can't be opened, open google and search for "park name, park state"
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No website data for park." message:@"Search for park in Google?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *nameAndLocation = [NSString stringWithFormat:@"%@, %@", _park.name, _park.state];
            NSString *urlString = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", nameAndLocation];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }];
        [alertController addAction:cancel];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)locationButtonWasPressed:(id)sender {
    if (_park.latitude) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Go to Apple Maps?" message:@"This will show the park's location in Apple Maps." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(_park.latitude, _park.longitude) addressDictionary:nil];
            MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
            item.name = _park.name;
            [item openInMapsWithLaunchOptions:nil];
        }];
        [alertController addAction:cancel];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
