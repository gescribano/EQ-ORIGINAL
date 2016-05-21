//
//  EQTablePopover.m
//  EQ
//
//  Created by Sebastian Borda on 4/21/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQTablePopover.h"
#define cellType @"Cell"
#define ROW_HEIGHT 44
#define ROW_WIDTH 250

@interface EQTablePopover ()

@property (nonatomic, weak) id<EQTablePopoverDelegate> delegate;
@property (nonatomic, strong) NSArray *data;

@end

@implementation EQTablePopover

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)initWithData:(NSArray *)data delegate:(id<EQTablePopoverDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.data = data;
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellType];
}

- (CGSize)popoverSize{
    if ([self.data count] > 0) {
        return CGSizeMake(ROW_WIDTH, ROW_HEIGHT * [self.data count]);
    }
    
    return CGSizeMake(ROW_WIDTH, ROW_HEIGHT);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count] > 0 ? [self.data count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellType];
    }
    if ([self.data count] > 0) {
        [cell.textLabel setText: [self.data objectAtIndex:indexPath.row]];
    } else {
        [cell.textLabel setText: @"No hay datos disponibles"];
    }
    
    [cell.textLabel setFont: [UIFont fontWithName:@"Helvetica" size:12.0]];
    cell.textLabel.numberOfLines = 2;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.data count] > 0) {
        NSString *selectedData = [self.data objectAtIndex:indexPath.row];
        if (selectedData) {
            [self.delegate tablePopover:self selectedRow:(int)indexPath.row selectedData:selectedData];
        }
    } else {
        [self.delegate tablePopover:self selectedRow:(int)indexPath.row selectedData:nil];
    }
}

@end
