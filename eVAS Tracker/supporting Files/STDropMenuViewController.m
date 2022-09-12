//
//  STDropMenuViewController.m
//  operamobile
//
//  Created by SamsoDeveloper on 6/12/18.
//  Copyright © 2018 samsotech. All rights reserved.
//

// utilities
#import "Constants.h"
#import "StoryboardIdentifiers.h"
//#import "eRegCard-Swift.h"
//#import "eVAS-Tracker-Swift.h"
// view controllers
#import "STDropMenuViewController.h"

// objects
#import "STDropMenuDataSource.h"

@interface STDropMenuViewController () <UITableViewDelegate>
{
    STDropMenuDataSource *mDataSource;
    NSMutableArray <NSLayoutConstraint*> *_tableViewConstraints;
    CGFloat mCellHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation STDropMenuViewController
#pragma mark - Constants
NSInteger  const DROPMENU_VIEW_SPACE    = 2;
NSInteger  const DROPMENU_SCREEN_MARGIN = 30;
NSUInteger const DROPMENU_MAX_HEIGHT    = 300;
NSUInteger const DROPMENU_MIN_WIDTH     = 100;
float const HEIGH_MULTIPLIER = 1.0f;

#pragma mark - Init
+ (id)storyboardInstance
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:STORYBOARD_UTILITIES bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    mDataSource = [[STDropMenuDataSource alloc] init];
    
    [self.tableView setDataSource:mDataSource];
    [self.tableView setDelegate:self];
    
    [self loadStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private
- (void)loadStyle
{
//    STAppStyleManager   *appStyleManager = [STAppStyleManager sharedManager];
//    STAppStyleModel     *appStyle        = [appStyleManager style];
//    STColorPaletteModel *colorPalette    = [appStyle colorPalette];
//
//    UIColor *colorBG   = [UIColor colorWithHexString:[colorPalette light1]];
    UIColor *colorLine = [UIColor grayColor];

    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView.layer setBorderWidth:1];
    [self.tableView.layer setBorderColor:colorLine.CGColor];
    [self.tableView.layer setCornerRadius:5.0];
    [self.tableView.layer setMasksToBounds:YES];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView setSeparatorColor:colorLine];
}

#pragma mark - Public
- (void)hide
{
    if(_tableViewConstraints != nil)
    {
        [NSLayoutConstraint deactivateConstraints:_tableViewConstraints];
        [_tableViewConstraints removeAllObjects];
    }
    
    //[_tableView setHidden:YES];
    [self.view setHidden:YES];
}

- (void)attachToView:(UIView*)view withData:(NSArray*)data
{
    CGRect frame = [self.view frame];
    CGSize frameSize = frame.size;
    
    CGRect  viewRect   = [view.superview convertRect:view.frame toView:nil];
    CGSize  viewSize   = viewRect.size;
    CGPoint viewOrigin = viewRect.origin;
    
    mCellHeight = viewSize.height * HEIGH_MULTIPLIER;
    
    float width  = MAX(viewSize.width, DROPMENU_MIN_WIDTH);
    float height = MIN(mCellHeight * [data count], DROPMENU_MAX_HEIGHT);
    
    float dropMenuBottom = viewOrigin.y + viewSize.height + height;
    float frameBottom = frameSize.height - DROPMENU_SCREEN_MARGIN;
    
    float dropMenuRight = viewOrigin.x + width;
    float frameRight = frameSize.width - DROPMENU_SCREEN_MARGIN;
    
    BOOL willExceedBottomScreen = dropMenuBottom >= frameBottom;
    BOOL willExceedRightScreen  = dropMenuRight  >= frameRight;
    
    [self reloadWithData:data];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView removeConstraints:self.tableView.constraints];
    _tableViewConstraints = [NSMutableArray new];
    
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem: self.tableView
                                                               attribute: NSLayoutAttributeWidth
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: nil
                                                               attribute: NSLayoutAttributeNotAnAttribute
                                                              multiplier: 1
                                                                constant: width]];
    
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem: self.tableView
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: nil
                                                               attribute: NSLayoutAttributeNotAnAttribute
                                                              multiplier: 1
                                                                constant: height]];
    
    if(willExceedRightScreen)
    {
        [_tableViewConstraints addObject:[self.tableView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor]];
    }
    else
    {
        [_tableViewConstraints addObject:[self.tableView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor]];
    }
    
    if(willExceedBottomScreen)
    {
        [_tableViewConstraints addObject:[self.tableView.bottomAnchor constraintEqualToAnchor:view.topAnchor]];
    }
    else
    {
        [_tableViewConstraints addObject:[self.tableView.topAnchor constraintEqualToAnchor:view.bottomAnchor]];
    }
    
    [NSLayoutConstraint activateConstraints:_tableViewConstraints];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView setScrollEnabled:(height >= DROPMENU_MAX_HEIGHT)];
    [self.tableView setHidden:NO];
}

- (void)attachToViewTop:(UIView*)view withData:(NSArray*)data
{
    CGRect  frame = [self.view frame];
    CGSize  frameSize = frame.size;
    CGPoint frameOrigin = frame.origin;
    
    CGRect  viewRect   = [view.superview convertRect:view.frame toView:nil];
    CGSize  viewSize   = viewRect.size;
    CGPoint viewOrigin = viewRect.origin;
    
    mCellHeight = viewSize.height * HEIGH_MULTIPLIER;
    
    float width  = MAX(viewSize.width, DROPMENU_MIN_WIDTH);
    float height = MIN(mCellHeight * [data count], DROPMENU_MAX_HEIGHT);
    
    float dropMenuTop = viewOrigin.y - height;
    float frameTop = frameOrigin.y + DROPMENU_SCREEN_MARGIN;
    
    float dropMenuRight = viewOrigin.x + width;
    float frameRight = frameSize.width - DROPMENU_SCREEN_MARGIN;
    
    BOOL willExceedTopScreen   = dropMenuTop   <= frameTop;
    BOOL willExceedRightScreen = dropMenuRight >= frameRight;
    
    [self reloadWithData:data];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView removeConstraints:self.tableView.constraints];
    _tableViewConstraints = [NSMutableArray new];
    
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem: self.tableView
                                                               attribute: NSLayoutAttributeWidth
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: nil
                                                               attribute: NSLayoutAttributeNotAnAttribute
                                                              multiplier: 1
                                                                constant: width]];
    
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem: self.tableView
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy: NSLayoutRelationEqual
                                                                  toItem: nil
                                                               attribute: NSLayoutAttributeNotAnAttribute
                                                              multiplier: 1
                                                                constant: height]];
    
    if(willExceedRightScreen)
    {
        [_tableViewConstraints addObject:[self.tableView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor]];
    }
    else
    {
        [_tableViewConstraints addObject:[self.tableView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor]];
    }
    
    if(willExceedTopScreen)
    {
        [_tableViewConstraints addObject:[self.tableView.topAnchor constraintEqualToAnchor:view.bottomAnchor]];
    }
    else
    {
        [_tableViewConstraints addObject:[self.tableView.bottomAnchor constraintEqualToAnchor:view.topAnchor]];
    }
    
    [NSLayoutConstraint activateConstraints:_tableViewConstraints];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView setScrollEnabled:(height >= DROPMENU_MAX_HEIGHT)];
    [self.tableView setHidden:NO];
}

- (void)reloadWithData:(NSArray*)data
{
    [mDataSource reloadWithData:data];
    [_tableView reloadData];
}

#pragma mark - UI Actions

- (IBAction)closeDropDown:(id)sender
{
    [self hide];
    if (_delegate && [_delegate respondsToSelector:@selector(onCloseSTDropMenu)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate onCloseSTDropMenu];
        });
    }
    
    [self.tableView setHidden:true];
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return mCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(onSTDropMenuSelectWithIndex:andValue:)])
    {
        [_delegate onSTDropMenuSelectWithIndex:indexPath.row andValue:[mDataSource getValueAtIndex:indexPath.row]];
    }
    
    if(_onSelectFontFamily)
    {
        NSString *fontFamily = [mDataSource getValueAtIndex:indexPath.row];
        _onSelectFontFamily(fontFamily);
    }
    
    [self closeDropDown:nil];
}

@end
