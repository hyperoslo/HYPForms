//
//  HYPDateFormFieldCell.m

//
//  Created by Elvis Nunez on 08/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPDateFormFieldCell.h"

#import "HYPTimeViewController.h"

static NSString * const HYPDateFieldFormat = @"yyyy-MM-dd";

static const CGSize HYPDatePopoverSize = { 320.0f, 216.0f };

@interface HYPDateFormFieldCell () <HYPTextFormFieldDelegate, HYPTimeViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) HYPTextFormField *textField;

@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) HYPTimeViewController *timeViewController;

@end

@implementation HYPDateFormFieldCell

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame contentViewController:self.timeViewController
                 andContentSize:HYPDatePopoverSize];
    if (!self) return nil;

    return self;
}

#pragma mark - Getters

- (HYPTimeViewController *)timeViewController
{
    if (_timeViewController) return _timeViewController;

    _timeViewController = [[HYPTimeViewController alloc] initWithDate:[NSDate date]];
    _timeViewController.delegate = self;
    _timeViewController.birthdayPicker = YES;

    return _timeViewController;
}

#pragma mark - Private headers

- (void)updateWithField:(HYPFormField *)field
{
    [super updateWithField:field];

    if (field.fieldValue) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = HYPDateFieldFormat;
        self.textField.rawText = [formatter stringFromDate:field.fieldValue];
    }
}

- (void)validate
{
    NSLog(@"validation in progress");
}

- (void)updateContentViewController:(UIViewController *)contentViewController withField:(HYPFormField *)field
{
    if (self.field.fieldValue) {
        self.timeViewController.currentDate = self.field.fieldValue;
    }
}

#pragma mark - HYPTimeViewControllerDelegate

- (void)timeController:(HYPTimeViewController *)timeController didChangedDate:(NSDate *)date
{
    self.field.fieldValue = date;

    [self updateWithField:self.field];

    [self.popoverController dismissPopoverAnimated:YES];
}

@end
