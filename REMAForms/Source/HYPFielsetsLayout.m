//
//  HYPFielsetsLayout.m

//
//  Created by Elvis Nunez on 06/10/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPFielsetsLayout.h"

#import "HYPFielsetsCollectionViewController.h"
#import "HYPFielsetBackgroundView.h"
#import "HYPBaseFormFieldCell.h"
#import "HYPFieldsetHeaderView.h"

#import "HYPFieldset.h"
#import "HYPFormField.h"

#import "UIScreen+HYPLiveBounds.h"

@interface HYPFielsetsLayout ()

@property (nonatomic) CGFloat previousHeight;
@property (nonatomic) CGFloat previousY;

@end

@implementation HYPFielsetsLayout

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.sectionInset = UIEdgeInsetsMake(HYPFieldsetMarginTop, HYPFieldsetMarginHorizontal, HYPFieldsetMarginBottom, HYPFieldsetMarginHorizontal);
    self.minimumLineSpacing = 0.0f;
    self.minimumInteritemSpacing = 0.0f;

    [self registerClass:[HYPFielsetBackgroundView class] forDecorationViewOfKind:HYPFieldsetBackgroundKind];

    return self;
}

#pragma mark - Private Methods

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (![elementKind isEqualToString:HYPFieldsetBackgroundKind]) {
        return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }

    NSArray *fieldsets = nil;

    if ([self.dataSource respondsToSelector:@selector(fieldsets)]) {
        fieldsets = [self.dataSource fieldsets];
    } else {
        abort();
    }

    NSArray *collapsedFieldsets = nil;

    if ([self.dataSource respondsToSelector:@selector(collapsedFieldsets)]) {
        collapsedFieldsets = [self.dataSource collapsedFieldsets];
    } else {
        collapsedFieldsets = [NSArray array];
    }

    HYPFieldset *fieldset = fieldsets[indexPath.section];
    NSArray *fields = nil;

    if ([collapsedFieldsets containsObject:@(indexPath.section)]) {
        fields = [NSArray array];
    } else {
        fields = fieldset.fields;
    }

    CGFloat bottomMargin = HYPFieldsetHeaderContentMargin;
    CGFloat height = HYPFieldsetMarginTop + HYPFieldsetMarginBottom;
    CGFloat size = 0.0f;

    for (HYPFormField *field in fields) {
        if (field.sectionSeparator) {
            height += HYPFieldCellItemSmallHeight;
        } else {
            size += [field.size floatValue];

            if (size >= 100.0f) {
                height += HYPFieldCellItemHeight;
                size = 0;
            }
        }
    }

    CGFloat y = self.previousHeight + self.previousY + HYPFieldsetHeaderHeight;

    self.previousHeight = height;
    self.previousY = y;

    if (fields.count == 0) y = 0.0f;

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind
                                                                                                               withIndexPath:indexPath];
    attributes.frame = CGRectMake(HYPFielsetBackgroundViewMargin, y, self.collectionViewContentSize.width - (HYPFielsetBackgroundViewMargin * 2), height - bottomMargin);
    attributes.zIndex = -1;

    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    self.previousHeight = 0.0f;
    self.previousY = 0.0f;

    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    for (UICollectionViewLayoutAttributes *element in attributes) {
        if ([element.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            CGRect bounds = [[UIScreen mainScreen] hyp_liveBounds];
            CGRect frame = element.frame;
            frame.origin.x = HYPFieldsetHeaderContentMargin;
            frame.size.width = CGRectGetWidth(bounds) - (2 * HYPFieldsetHeaderContentMargin);
            element.frame = frame;
        }
    }

    NSInteger sectionsCount = [self.collectionView numberOfSections];

    for (NSInteger section = 0; section < sectionsCount; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        [attributes addObject:[self layoutAttributesForDecorationViewOfKind:HYPFieldsetBackgroundKind
                                                                atIndexPath:indexPath]];
    }

    return attributes;
}

@end
