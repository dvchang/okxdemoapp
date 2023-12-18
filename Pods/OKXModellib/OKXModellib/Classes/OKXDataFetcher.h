//
//  OKXDataFetcher.h
//  OKXModellib
//
//  Created by David Chang on 12/18/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OKXDataItem : NSObject
@property(nonatomic, readonly) NSInteger itemId;
@property(nonatomic, strong, readonly) NSString* imageURL;
@property(nonatomic, strong, readonly) NSString* videoURL;

- (instancetype)initWithId:(NSInteger)itemId imageURL:(NSString *)imageURL videoURL:(NSString *)videoURL;

@end

typedef void (^DataFetchCompletionBlock)(NSArray<OKXDataItem *> * _Nullable dataArray, NSError * _Nullable error);

@interface OKXDataFetcher : NSObject

- (void)fetchData:(DataFetchCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
