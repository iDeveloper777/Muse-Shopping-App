//
//  CategoryData.h
//  Muse
//
//  Created by Mike Tran on 25/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_CategoryData_h
#define Muse_CategoryData_h

#import "JSONModel.h"
#import "CatRecordData.h"

@protocol CategoryData
@end

@interface CategoryData : JSONModel

@property (strong, nonatomic) NSArray<CatRecordData>* records;

@end
#endif
