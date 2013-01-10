//
//  ViewController.m
//  WZHReorderTableViewDemo_Non-ARC
//
//  Created by sadnessleaf on 13-1-4.
//  Copyright (c) 2013年 sadnessleaf. All rights reserved.
//

#import "ViewController.h"
#import "WZHReorderTableView.h"

@interface ViewController () <WZHReorderTableViewDelegate,WZHReorderTableViewDataSource> {
    NSMutableArray *arrayOfItems;
    
    WZHReorderTableView *_tableView;
}

@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Reordering";
	
	/*
     Populate array.
	 */
	if (!arrayOfItems) {
		NSUInteger numberOfItems = 20;
		arrayOfItems = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
		
		for (NSUInteger i = 0; i < numberOfItems; ++i)
			[arrayOfItems addObject:[NSString stringWithFormat:@"Item #%i", i + 1]];
	}
    
    _tableView = [[WZHReorderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView release];
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[_tableView flashScrollIndicators];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Table view data source
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
     Disable reordering if there's one or zero items.
     For this example, of course, this will always be YES.
	 */
	[_tableView setReorderingEnabled:(arrayOfItems.count > 1)];
	
	return arrayOfItems.count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
	
    return cell;
}
// should be identical to cell returned in -tableView:cellForRowAtIndexPath:
- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forReorderTableView:(WZHReorderTableView *)dragTableView {
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	cell.textLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
	
	return cell;
}
/*
 Description:
 Makes a cell appear draggable.
 Adds shadows,
 Bumps up the alpha of the selectedBackgroundView
 Parameters:
 cell -- Almost certainly will be self.draggedCell
 indexPath -- path of cell, provided for subclasses
 */
- (void)reorderTableView:(WZHReorderTableView *)tableView addDraggableIndicatorsToCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrayOfShadowViews = [_tableView addShadowViewsToCell:cell];
    
	for (UIView *shadowView in arrayOfShadowViews)
		shadowView.alpha = 1;
}
/*
 Description:
 Sets the draggable indicators to alpha = 0, effectively.
 Intented to be used in an animation block.
 
 cell.layer.shouldRasterize is expected to be NO before this method is called.
 Doesn't actually remove the draggable changes (that is, the shadow views). Thus, expectation is -removeDraggableIndicatorsFromCell: is called when animation is completed.
 
 If you don't want to animate, just use -removeDraggableIndicatorsFromCell: directly.
 */
- (void)reorderTableView:(WZHReorderTableView *)tableView hideDraggableIndicatorsOfCell:(UITableViewCell *)cell {
    UIView *aboveShadowView = [cell viewWithTag:TAG_FOR_ABOVE_SHADOW_VIEW_WHEN_DRAGGING];
	aboveShadowView.alpha = 0;
	
	UIView *belowShadowView = [cell viewWithTag:TAG_FOR_BELOW_SHADOW_VIEW_WHEN_DRAGGING];
	belowShadowView.alpha = 0;
}
/*
 Description:
 Removes all draggable indicators from the cell.
 Cell should be perfectly safe for reuse when this is complete.
 
 not meant to be animated. Use -hideDraggableIndicatorsOfCell: for that and call this in the animation's completion block.
 */
- (void)reorderTableView:(WZHReorderTableView *)tableView removeDraggableIndicatorsFromCell:(UITableViewCell *)cell {
    UIView *aboveShadowView = [cell viewWithTag:TAG_FOR_ABOVE_SHADOW_VIEW_WHEN_DRAGGING];
	[aboveShadowView removeFromSuperview];
	
	UIView *belowShadowView = [cell viewWithTag:TAG_FOR_BELOW_SHADOW_VIEW_WHEN_DRAGGING];
	[belowShadowView removeFromSuperview];
}
/*
 Required for drag tableview controller
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSString *itemToMove = [arrayOfItems objectAtIndex:fromIndexPath.row];
    [itemToMove retain];
	[arrayOfItems removeObjectAtIndex:fromIndexPath.row];
	[arrayOfItems insertObject:itemToMove atIndex:toIndexPath.row];
    [itemToMove release];
}
#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)reorderTableView:(WZHReorderTableView *)tableView didBeginDraggingAtRow:(NSIndexPath *)indexPath {
    
}
- (void)reorderTableView:(WZHReorderTableView *)tableView didEndDraggingToRow:(NSIndexPath *)indexPath {
    
}

@end