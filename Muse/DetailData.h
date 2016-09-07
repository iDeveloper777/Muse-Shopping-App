//
//  DetailData.h
//  Muse
//
//  Created by Mike Tran on 22/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_DetailData_h
#define Muse_DetailData_h

#import <Foundation/Foundation.h>
#import "ItemsModel.h"
#import "CategoryModel.h"

@interface DetailData : NSObject

@property (nonatomic, strong) NSString *productid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *brandid;
@property (nonatomic, strong) NSString *brandname;
@property (nonatomic, strong) NSString *brandcreated;
@property (nonatomic, assign) NSArray<CategoryModel> *category;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSString *seqNum;
@property (nonatomic, assign) NSArray<ItemsModel>* items;
@property (nonatomic, assign) NSString *created;
@property (nonatomic, assign) NSString *updated;

- (instancetype)initWithName:(NSString *)productid
                        name:(NSString *)name
                     brandid:(NSString *)brandid
                   brandname:(NSString *)brandname
                brandcreated:(NSString *)brandcreated
                    category:(NSArray<CategoryModel>*) category
                        desc:(NSString *)desc
                      seqNum:(NSString *)seqNum
                       items:(NSArray<ItemsModel> *) items
                     created:(NSString *)created
                     updated:(NSString *)updated;

@end

#endif
