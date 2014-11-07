//
//  FileManager.m
//  Addressbook-iOS
//
//  Created by allenlin on 11/7/14.
//  Copyright (c) 2014 g0v. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

- (NSString *)filePathWithKey:(NSString *)filePathKey
{
    if (!filePathKey) {
        return nil;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filePathKey];
    return filePath;
}

- (NSArray *)readPeople
{
    NSArray *people = nil;
    
    NSError *error;
    NSArray *peopleFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self filePathWithKey:kPeopleFilePathKey] error:&error];
    if (peopleFileNames.count == 0) {
        NSLog(@"peopleFileNames.count == 0");
        return nil;
    }
    else{
//        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
//        {
//            NSData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
//            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
//                                             initForReadingWithData:data];
//            MyObject *obj = [unarchiver decodeObjectForKey:@"MY_OBJ"];
//            [unarchiver finishDecoding];
//            NSLog(@"name %@ age %d color %@", obj.name, obj.age,
//                  obj.color);
//        }
    }
    NSLog(@"%@",peopleFileNames);
    return people;
}

- (NSArray *)readOrganizations
{
    NSArray *organizations = nil;
    NSString *path = [self filePathWithKey:kOrganizationFilePathKey];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        organizations = [[NSArray alloc] initWithContentsOfFile:kOrganizationFilePathKey];
    }
    
    return organizations;
}

- (void)writePerson:(PopoloPerson *)person
{
    NSString *filePath = [[self filePathWithKey:kPeopleFilePathKey] stringByAppendingPathComponent:[person valueForKey:@"id"]];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:person forKey:kKeyForEncodePopoloPerson];
    [archiver finishEncoding];
    BOOL didWrite = [data writeToFile:filePath atomically:YES];
    if (didWrite) {
        NSLog(@"did writePerson");
    }
    else{
        NSLog(@"did not writePerson");
    }
}

- (void)writeOrganization:(PopoloOrganization *)organization
{
    NSString *filePath = [[self filePathWithKey:kOrganizationFilePathKey] stringByAppendingPathComponent:organization.id];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:organization forKey:kKeyForEncodePopoloOrganization];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

+ (id)sharedInstance {
    static FileManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end