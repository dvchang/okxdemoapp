//
//  OKXDataFetcher.m
//  OKXModellib
//
//  Created by David Chang on 12/18/23.
//

#import "OKXDataFetcher.h"

#import "AFNetworking/AFNetworking.h"

@implementation OKXDataItem

- (instancetype)initWithId:(NSInteger)itemId imageURL:(NSString *)imageURL videoURL:(NSString *)videoURL {
    self = [super init];
    if (self) {
        _itemId = itemId;
        _imageURL = [imageURL copy];
        _videoURL = [videoURL copy];
    }
    return self;
}

@end

@interface OKXDataFetcher()
@property(nonatomic, strong) AFURLSessionManager *manager;
@end

@implementation OKXDataFetcher

- (void)fetchData:(DataFetchCompletionBlock)completion {
    if (!self.manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    NSString *url = @"https://private-04a55-videoplayer1.apiary-mock.com/pictures";
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    [[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
        } else if (![responseObject isKindOfClass:[NSArray class]]) {
            completion(nil, [NSError errorWithDomain:@"OKXDataFetcher fetching" code:1 userInfo:nil]);
        } else {
            NSMutableArray<OKXDataItem *> *dataArray = [NSMutableArray array];
            NSArray *response = (NSArray *)responseObject;
            for (NSObject *object in response) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = (NSDictionary *)object;
                    NSNumber *itemId = dict[@"id"];
                    NSString *imageUrl = dict[@"imageUrl"];
                    NSString *videoUrl = dict[@"videoUrl"];
                    if (itemId != nil && imageUrl != nil && videoUrl != nil) {
                        OKXDataItem *item = [[OKXDataItem alloc] initWithId:itemId.integerValue imageURL:imageUrl videoURL:videoUrl];
                        [dataArray addObject:item];
                    }
                }
            }
            completion(dataArray, nil);            
        }
    }] resume];

}

@end
