/*****************************************************************************
 文件名称 :
 版权声明 : Copyright (C), 2010-2013 Easier Digital Tech. Co., Ltd.
 文件描述 : 全局函数
 ******************************************************************************/

#import "sys/sysctl.h"
#import "GlobalFunction.h"

#import "zlib.h"

#import "AppDelegate.h"
#import "UIColor+Hex.h"

#import "UIView+Toast.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation GlobalFunction

+ (NSData*)compressData:(NSData*)uncompressedData {
    
    NSParameterAssert(uncompressedData);
    NSParameterAssert(uncompressedData.length);
    
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[uncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in  = (uInt)[uncompressedData length]; // Number of input bytes left to process
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK) {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        return nil;
    }
    // Create output memory buffer for compressed data. The zlib documentation states that
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *compressedData = [NSMutableData dataWithLength:[uncompressedData length] * 1.01 + 12];
    int deflateStatus;
    do {
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        zlibStreamStruct.avail_out = (uInt)([compressedData length] - zlibStreamStruct.total_out);
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
    } while (deflateStatus == Z_OK);
    
    // Check for zlib error and convert code to usable error message if appropriate
    if (deflateStatus != Z_STREAM_END) {
        NSString *errorMsg = nil;
        switch (deflateStatus)
        {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        // Free data structures that were dynamically created for the stream.
        deflateEnd(&zlibStreamStruct);
        return nil;
    }
    // Free data structures that were dynamically created for the stream.
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength: zlibStreamStruct.total_out];
    return compressedData;
}

+ (NSData *)decompressData:(NSData *)compressedData {
    z_stream zStream;
    zStream.zalloc = Z_NULL;
    zStream.zfree = Z_NULL;
    zStream.opaque = Z_NULL;
    zStream.avail_in = 0;
    zStream.next_in = 0;
    
    int status = inflateInit2(&zStream, (15+32));
    
    if (status != Z_OK) {
        return nil;
    }
    
    Bytef *bytes = (Bytef *)[compressedData bytes];
    NSUInteger length = [compressedData length];
    NSUInteger halfLength = length/2;
    
    NSMutableData *uncompressedData = [NSMutableData dataWithLength:length+halfLength];
    
    zStream.next_in = bytes;
    zStream.avail_in = (unsigned int)length;
    zStream.avail_out = 0;
    NSInteger bytesProcessedAlready = zStream.total_out;
    
    while (zStream.avail_in != 0) {
        if (zStream.total_out - bytesProcessedAlready >= [uncompressedData length]) {
            [uncompressedData increaseLengthBy:halfLength];
        }
        zStream.next_out = (Bytef*)[uncompressedData mutableBytes] + zStream.total_out-bytesProcessedAlready;
        zStream.avail_out = (unsigned int)([uncompressedData length] - (zStream.total_out-bytesProcessedAlready));
        status = inflate(&zStream, Z_NO_FLUSH);
        if (status == Z_STREAM_END) {
            break;
        }
        else if (status != Z_OK) {
            return nil;
        }
    }
    status = inflateEnd(&zStream);
    if (status != Z_OK) {
        return nil;
    }
    [uncompressedData setLength: zStream.total_out-bytesProcessedAlready];  // Set real length
    return uncompressedData;
}

+ (NSString *)generateUUID {
    CFUUIDRef puuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return [[result stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

+ (void)makeToast:(NSString *)message duration:(float)duration HeightScale:(float)scale {
    
    if(message.length>0){
        UIWindow *toastDisplaywindow = [AppDelegate sharedInstance].window;
        for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
            if (![[testWindow class] isEqual:[UIWindow class]]) {
                toastDisplaywindow = testWindow;
                break;
            }
        }
        [toastDisplaywindow makeToast:message duration:duration HeightScale:scale];
    }
}

+ (void)makeAttributedToast:(NSAttributedString *)message duration:(float)duration HeightScale:(float)scale {
    
    UIWindow *toastDisplaywindow = [AppDelegate sharedInstance].window;
    for (UIWindow *w in [[UIApplication sharedApplication] windows]) {
        if (![[w class] isEqual:[UIWindow class]]) {
            toastDisplaywindow = w;
            break;
        }
    }
    [toastDisplaywindow makeAttributedToast:message duration:duration HeightScale:scale];
}

+ (void)addLeftBarButtonItem:(UIViewController *)vc item:(UIBarButtonItem *)item {
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        negativeSpacer.width = -5;
    } else {
        // Load resources for iOS 7 or later
        negativeSpacer.width = -16;
    }
    
    vc.navigationItem.leftBarButtonItems = @[negativeSpacer, item];
    //    vc.navigationItem.backBarButtonItem = item;
}

+ (void)addRightBarButtonItem:(UIViewController *)vc item:(UIBarButtonItem *)item {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        negativeSpacer.width = -5;
    }
    else {
        // Load resources for iOS 7 or later
        negativeSpacer.width = -15;
    }
    vc.navigationItem.rightBarButtonItems = @[negativeSpacer, item];
}

+ (void)addRightBarButtonItem:(UIViewController *)vc items:(NSArray *)items {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        negativeSpacer.width = -5;
    }
    else {
        // Load resources for iOS 7 or later
        negativeSpacer.width = -16;
    }
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:negativeSpacer];
    for (UIBarButtonItem *item in items) {
        [array addObject:item];
    }
    vc.navigationItem.rightBarButtonItems = array;
}

+ (UILabel *)custNavigationTitle:(NSString *)title {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:18.0f];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = title;
    return lbl;
}

+ (UILabel *)custNavigationTitle:(NSString *)title andColor:(UIColor *)color{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = color;
    lbl.font = [UIFont systemFontOfSize:18.0f];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = title;
    return lbl;
}

+ (UILabel *)custNavigationAttributeTitle:(NSString *)title {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:16.0f];
    lbl.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x222222] range:NSMakeRange(0, 4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x999999] range:NSMakeRange(4, str.length-4)];
    lbl.attributedText = str;
    return lbl;
}

//自定义导航栏－标题
+ (UILabel *)custNavigationWithRect:(CGRect)rect title:(NSString *)title {
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:18.0f];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = title;
    return lbl;
}

//add by Ting
+ (UIImage *)imageTensile:(UIImage *)image withEdgeInset:(UIEdgeInsets )edgeInsets{
    image = [image resizableImageWithCapInsets:edgeInsets];
    return image;
}

//判断手机号 add by Ting
+ (BOOL)isPhoneId:(NSString *)string {
    NSString * regex = @"^(1)[0-9]{10}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
}

//画虚线
+ (void)drawDottedLine:(UIImageView *)img{
    UIGraphicsBeginImageContext(img.frame.size);   //开始画线
    [img.image drawInRect:CGRectMake(0, 0, img.frame.size.width, img.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[] = {3,3};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor grayColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 5.0);    //开始画线
    CGContextAddLineToPoint(line, 310.0, 5.0);
    CGContextStrokePath(line);
    img.image = UIGraphicsGetImageFromCurrentImageContext();
}

//view转image
+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque , view.window.screen.scale);
    /* iOS 7 */
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    else /* iOS 6 */
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return ret;
}

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day] == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}

+ (BOOL)isfloatString:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
    
}

+ (BOOL)isIntString:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+(BOOL) isMoneyWithStr:(NSString *)string {
    NSString * regex = @"^([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(.[0-9]{1,2})?$";
    //    NSString * regex = @"^[0-9]{1,6}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMoney = [pred evaluateWithObject:string];
    
    return isMoney;
}

@end
