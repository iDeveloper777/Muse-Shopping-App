//
//  CatRecordData.h
//  Muse
//
//  Created by Mike Tran on 25/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_CatRecordData_h
#define Muse_CatRecordData_h

#import "JSONModel.h"

@protocol CatRecordData
@end

@interface CatRecordData : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* parent;
@property (strong, nonatomic) NSString* status;

@end

#endif
