//
//  GSE_EtherScanProvider.m
//  wallet
//
//  Created by user on 29/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_EtherScanProvider.h"

@implementation GSE_EtherScanProvider

@end

@interface EtherscanProvider ()
- (NSURL*)urlForPath: (NSString*)path;
@end

@implementation EtherscanProvider (GSE)

- (ArrayPromise*)getTransactionsForAddress: (Address*)address page:(NSInteger)page count: (NSInteger)count {
    
    NSObject* (^processTransactions)(NSDictionary*) = ^NSObject*(NSDictionary *response) {
        NSMutableArray *result = [NSMutableArray array];
        
        NSArray *infos = (NSArray*)[response objectForKey:@"result"];
        if (![infos isKindOfClass:[NSArray class]]) {
            return [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:@{}];
        }
        
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"dd/MM/yy hh:mm:ss"];
        
        for (NSDictionary *info in infos) {
            if (![info isKindOfClass:[NSDictionary class]]) {
                continue;
                //return [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:@{}];
            }
            
            NSMutableDictionary *mutableInfo = [info mutableCopy];
            
            // Massage some values that have their key names differ from ours
            {
                NSObject *gasLimit = [info objectForKey:@"gas"];
                if (gasLimit) {
                    [mutableInfo setObject:gasLimit forKey:@"gasLimit"];
                }
                
                NSString *timestamp = [info objectForKey:@"timeStamp"];
                if (timestamp) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
                    [mutableInfo setObject:[_formatter stringFromDate:date] forKey:@"timestamp"];
                }
                
                NSObject *data = [info objectForKey:@"input"];
                if (data) {
                    [mutableInfo setObject:data forKey:@"data"];
                }
            }
            
            
            TransactionInfo *transactionInfo = [TransactionInfo transactionInfoFromDictionary:mutableInfo];
            if (!transactionInfo) {
                continue;
                //return [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:@{}];
            }
            
            [mutableInfo setObject:[Payment formatEther:transactionInfo.value] forKey:@"value"];
            
            [result addObject:mutableInfo];
        }
        
        return result;
    };
    
    NSString *path = [NSString stringWithFormat:@"/api?module=account&action=txlist&address=%@&sort=desc&page=%@&offset=%@",
                      address, @(page), @(count)];
    
    return [self promiseFetchJSON:[self urlForPath:path]
                             body:nil
                        fetchType:ApiProviderFetchTypeArray
                          process:processTransactions];
}

- (ArrayPromise*)getTransactionsForAddress: (Address*)address atContract:(Address *)contract page:(NSInteger)page count: (NSInteger)count{
    
    NSObject* (^processTransactions)(NSDictionary*) = ^NSObject*(NSDictionary *response) {
        NSMutableArray *result = [NSMutableArray array];
        
        NSArray *infos = (NSArray*)[response objectForKey:@"result"];
        //NSLog(@"%@",infos);
        if (![infos isKindOfClass:[NSArray class]]) {
            return [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:@{}];
        }
        
        for (NSDictionary *info in infos) {
            if (![info isKindOfClass:[NSDictionary class]]) {
                continue;
                //return [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:@{}];
            }
            
            NSMutableDictionary *mutableInfo = [info mutableCopy];
            
            // Massage some values that have their key names differ from ours
            {
                NSObject *gasLimit = [info objectForKey:@"gas"];
                if (gasLimit) {
                    [mutableInfo setObject:gasLimit forKey:@"gasLimit"];
                }
                
                NSObject *timestamp = [info objectForKey:@"timeStamp"];
                if (timestamp) {
                    [mutableInfo setObject:timestamp forKey:@"timestamp"];
                }
                
                NSObject *data = [info objectForKey:@"input"];
                if (data) {
                    [mutableInfo setObject:data forKey:@"data"];
                }
            }
            
            /*TransactionInfo *transactionInfo = [TransactionInfo transactionInfoFromDictionary:mutableInfo];
             if (!transactionInfo) {
             continue;
             //return [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:@{}];
             }*/
            
            [result addObject:mutableInfo];
        }
        
        return result;
    };
    
    NSString *path = [NSString stringWithFormat:@"/api?module=account&action=tokentx&address=%@&sort=desc&page=%@&offset=%@",
                      address, @(page), @(count)];
    NSLog(@"url: %@",[self urlForPath:path]);
    
    return [self promiseFetchJSON:[self urlForPath:path]
                             body:nil
                        fetchType:ApiProviderFetchTypeArray
                          process:processTransactions];
    
}

- (ArrayPromise*)crawlTransactionsForAddress:(Address*)address atContract:(Address *)contract page:(NSInteger)page{
    
    NSObject* (^processTransactions)(NSData*) = ^NSObject*(NSData *response) {
        
        NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        {
            NSString *match = @"[a-zA-Z0-9-=:\\s\'\"?_./,]*";
            
            NSString *regex = [NSString stringWithFormat:@"<a href=%@>",match];
            NSError *error;
            //NSLog(@"regex: %@, str: %@",regex,str);
            NSRegularExpression *regular =
            [NSRegularExpression
             regularExpressionWithPattern:regex
             options:NSRegularExpressionCaseInsensitive
             error:&error];
            
            str = [regular stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:@""];
            str = [str stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"&nbsp; IN &nbsp;" withString:@"IN"];
        }
        
        NSString *match = @"[a-zA-Z0-9-=:\\s\'\"?_./,&;]*";
        
        NSString *regex = [NSString stringWithFormat:@"<td><span%@>(%@)</span></td><td><span%@>(%@)</span></td><td><span class='address-tag'>(%@)</span></td><td><span%@>(%@)</span></td><td><span class='address-tag'>(%@)</span></td><td>(%@)</td>",match,match,match,match,match,match,match,match,match];
        
        NSLog(@"regex: %@,str:\n%@\n",regex,str);
        NSError *error;
        
        NSRegularExpression *regular =
        [NSRegularExpression
         regularExpressionWithPattern:regex
         options:NSRegularExpressionCaseInsensitive
         error:&error];
        
        NSArray *matches = [regular matchesInString:str
                                            options:0
                                              range:NSMakeRange(0, str.length)];
        
        NSLog(@"matches: %@, error: %@", matches, error);
        
        NSMutableArray *infos = [NSMutableArray array];
        
        for (NSTextCheckingResult *match in matches) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSInteger i = 0; i < match.numberOfRanges; i++){
                NSRange range = [match rangeAtIndex:i];
                NSString *mStr = [str substringWithRange:range];
                //NSLog(@"%@", mStr);
                if (i == 1) {
                    [dic setObject:mStr forKey:@"hash"];
                }else if (i == 2){
                    [dic setObject:mStr forKey:@"timestamp"];
                }else if (i == 3){
                    [dic setObject:mStr forKey:@"from"];
                }else if (i == 5){
                    [dic setObject:mStr forKey:@"to"];
                }else if (i == 6){
                    [dic setObject:mStr forKey:@"value"];
                }
            }
            [infos addObject:dic];
        }
        return infos;
    };
    
    NSString *path = [NSString stringWithFormat:@"https://etherscan.io/token/generic-tokentxns2?contractAddress=%@&a=%@&p=%@", contract, address, @(page)];
    NSLog(@"%@",path);
    return [self promiseFetch:[NSURL URLWithString:path]
                         body:nil
                  contentType:nil
                    fetchType:ApiProviderFetchTypeArray
                      process:processTransactions];
}

- (DictionaryPromise *)getGasPrice_Etherscan{
    
    NSObject* (^processResult)(NSData*) = ^NSObject*(NSData *response) {
        //NSLog(@"%@",response);
        
        NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        {
            NSString *regex = [NSString stringWithFormat:@"<span id=\"ContentPlaceHolder1_ltGasPrice\">"];
            NSError *error;
            //NSLog(@"regex: %@, str: %@",regex,str);
            NSRegularExpression *regular =
            [NSRegularExpression
             regularExpressionWithPattern:regex
             options:NSRegularExpressionCaseInsensitive
             error:&error];
            
            str = [regular stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:@""];
            str = [str stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        }
        
        NSString *regex = [NSString stringWithFormat:@"<span class=\"counter\">([a-zA-Z0-9-=:\\s\'\"?_./,&;]*)"];
        
        //NSLog(@"regex: %@, str: %@",regex,str);
        NSError *error;
        
        NSRegularExpression *regular =
        [NSRegularExpression
         regularExpressionWithPattern:regex
         options:NSRegularExpressionCaseInsensitive
         error:&error];
        
        NSArray *matches = [regular matchesInString:str
                                            options:0
                                              range:NSMakeRange(0, str.length)];
        
        //NSLog(@"matches: %@, error: %@", matches, error);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        if (matches.count != 3) {
            return nil;
        }
        for (NSInteger i = 0; i < 3; i++) {
            NSTextCheckingResult *match = matches[i];
            if (match.numberOfRanges <= 1) {
                continue;
            }
            NSRange range = [match rangeAtIndex:1];
            NSString *mStr = [str substringWithRange:range];
            mStr = [mStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (i == 0) {
                [dic setObject:mStr?:@"" forKey:@"block"];
            }else if (i == 1){
                [dic setObject:mStr?:@"" forKey:@"safe"];
            }else{
                [dic setObject:mStr?:@"" forKey:@"propose"];
            }
        }
        return [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:nil];
    };
    
    NSString *path = @"https://etherscan.io/gasTracker";
    
    return [self promiseFetch:[NSURL URLWithString:path]
                         body:nil
                  contentType:nil
                    fetchType:ApiProviderFetchTypeJSONDictionary
                      process:processResult];
}

- (DictionaryPromise *)crawlTokensForAddress:(Address *)address page:(NSInteger)page withParams:(NSDictionary *)params{
    
    if (![params isKindOfClass:[NSDictionary class]]) {
        params = @{@"pUsd24hrs":@"",@"pUsd":@"",@"pBtc24hrs":@""};
    }
    NSObject* (^processTransactions)(NSData*) = ^NSObject*(NSData *response) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        if (!result ||
            ![result isKindOfClass:[NSDictionary class]] ||
            !result[@"totaleth"] ||
            !result[@"totalusd"] ||
            !result[@"usdpercentagechange"] ||
            !result[@"layout"]
            ) {
            NSLog(@"%s,%@",__FUNCTION__,@"lack of params");
            return nil;
        }
        
        NSString *totaleth = result[@"totaleth"];
        if (![totaleth isKindOfClass:[NSString class]]) {
            NSLog(@"%s,%@",__FUNCTION__,@"lack of response : totaleth");
            return nil;
        }
        NSString *totalusd = result[@"totalusd"];
        if (![totalusd isKindOfClass:[NSString class]]) {
            NSLog(@"%s,%@",__FUNCTION__,@"lack of response : totalusd");
            return nil;
        }
        if ([totalusd isEqualToString:@"-"]) {
            totalusd = @"$ 0.00";
        }
        NSString *usdpercentagechange = result[@"usdpercentagechange"];
        if (![usdpercentagechange isKindOfClass:[NSString class]]) {
            NSLog(@"%s,%@",__FUNCTION__,@"lack of response : usdpercentagechange");
            return nil;
        }
        
        NSString *str = result[@"layout"];
        if (![str isKindOfClass:[NSString class]]) {
            NSLog(@"%s,%@",__FUNCTION__,@"lack of response : layout");
            return nil;
        }
        
        NSMutableArray *tokens = [NSMutableArray array];
        
        NSMutableDictionary *eth = @{@"name" : @"Ethereum (ETH)",@"symbol" : @"ETH"}.mutableCopy;
        
        [tokens addObject:eth];
        
        NSDictionary *emptyResult = @{@"totaleth":totaleth,
                                      @"totalusd":totalusd,
                                      @"usdpercentagechange":usdpercentagechange,
                                      @"tokens":tokens};
        
        NSMutableDictionary *fullResult = [NSMutableDictionary dictionaryWithDictionary:emptyResult];
        
        NSString *regex1 = [NSString stringWithFormat:@"<a href='/token/([0-9a-zA-Z]*)'>(<span title='[0-9a-zA-Z.\\s-()]*|[0-9a-zA-Z()\\s]+)"];
        //NSLog(@"regex: %@, str: %@",regex1,str);
        
        NSError *error;
        
        NSRegularExpression *regular1 = [NSRegularExpression regularExpressionWithPattern:regex1 options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *matches1 = [regular1 matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        NSLog(@"matches1: %@, error: %@", @(matches1.count), error);
        if (!matches1.count) {
            return nil;
        }
        
        NSString *regex2 = [NSString stringWithFormat:@"position:relative; border-left:none;border-right:none'>([0-9a-zA-Z.,\\s]*)</td>"];
        
        NSRegularExpression *regular2 = [NSRegularExpression regularExpressionWithPattern:regex2 options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *matches2 = [regular2 matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        NSLog(@"matches2: %@, error: %@", @(matches2.count), error);
        if (!matches2.count) {
            return nil;
        }
        
        NSString *regex3 = [NSString stringWithFormat:@"<span style='margin-left:-4px'>([$0-9.,]+)"];
        
        NSRegularExpression *regular3 = [NSRegularExpression regularExpressionWithPattern:regex3 options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *matches3 = [regular3 matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        NSLog(@"matches3: %@, error: %@", @(matches3.count), error);
        
        
        NSMutableArray *tokensInfo = [NSMutableArray array];
        for (NSInteger i = 0; i < matches1.count; i++) {
            NSTextCheckingResult *match1 = matches1[i];
            //NSLog(@"match1.numberOfRanges: %@",@(match1.numberOfRanges));
            if (match1.numberOfRanges == 3) {
                
                NSRange range1 = [match1 rangeAtIndex:1];
                NSString *token_address = [str substringWithRange:range1];
                //NSLog(@"%@",token_address);
                
                NSRange range2 = [match1 rangeAtIndex:2];
                NSString *token_name = [str substringWithRange:range2];
                token_name = [token_name stringByReplacingOccurrencesOfString:@"<span title='" withString:@""];
                //NSLog(@"%@",token_name);
                
                [tokensInfo addObject:@{@"contractAddress":token_address,@"name":token_name}.mutableCopy];
            }
        }
        
        if (tokensInfo.count != matches1.count) {
            return nil;
        }
        
        for (NSInteger i = 0; i < matches2.count; i++) {
            NSTextCheckingResult *match2 = matches2[i];
            if (match2.numberOfRanges == 2) {
                NSRange range = [match2 rangeAtIndex:1];
                NSString *mStr = [str substringWithRange:range];
                //NSLog(@"%@",mStr);
                NSArray *mStrComponents = [mStr componentsSeparatedByString:@" "];
                if (mStrComponents.count != 2) {
                    continue;
                }
                if ([mStrComponents.lastObject isEqualToString:@"ETH"]) {
                    [eth setObject:mStrComponents.firstObject forKey:@"value"];
                    continue;
                }
                if (matches1.count == matches2.count - 1) {
                    if (i > 0) {
                        NSMutableDictionary *dic = tokensInfo[i-1];
                        [dic setObject:mStrComponents.firstObject forKey:@"value"];
                        [dic setObject:mStrComponents.lastObject forKey:@"symbol"];
                    }
                }else if (matches1.count == matches2.count){
                    NSMutableDictionary *dic = tokensInfo[i];
                    [dic setObject:mStrComponents.firstObject forKey:@"value"];
                    [dic setObject:mStrComponents.lastObject forKey:@"symbol"];
                }
            }
        }
        
        if (  matches3.count >= 2 ) {
            if (matches1.count == matches2.count - 1) {
                {
                    NSTextCheckingResult *match3 = matches3[0];
                    if (match3.numberOfRanges == 2) {
                        NSRange range = [match3 rangeAtIndex:1];
                        NSString *mStr = [str substringWithRange:range];
                        [eth setObject:mStr forKey:@"valueInETH"];
                    }
                }
                {
                    NSTextCheckingResult *match3 = matches3[1];
                    if (match3.numberOfRanges == 2) {
                        NSRange range = [match3 rangeAtIndex:1];
                        NSString *mStr = [str substringWithRange:range];
                        [eth setObject:mStr forKey:@"valueInUSD"];
                    }
                }
                if (matches3.count / 2 - 1 <= tokensInfo.count) {
                    for (NSInteger i = 1; i < matches3.count / 2; i++) {
                        NSMutableDictionary *dic = tokensInfo[i-1];
                        {
                            NSTextCheckingResult *match3 = matches3[i*2];
                            if (match3.numberOfRanges == 2) {
                                NSRange range = [match3 rangeAtIndex:1];
                                NSString *mStr = [str substringWithRange:range];
                                [dic setObject:mStr forKey:@"valueInETH"];
                            }
                        }
                        {
                            NSTextCheckingResult *match3 = matches3[i*2 + 1];
                            if (match3.numberOfRanges == 2) {
                                NSRange range = [match3 rangeAtIndex:1];
                                NSString *mStr = [str substringWithRange:range];
                                [dic setObject:mStr forKey:@"valueInUSD"];
                            }
                        }
                    }
                }
                
            }else{
                if (matches3.count / 2 <= tokensInfo.count) {
                    for (NSInteger i = 0; i < matches3.count / 2; i++) {
                        NSMutableDictionary *dic = tokensInfo[i];
                        {
                            NSTextCheckingResult *match3 = matches3[i*2];
                            if (match3.numberOfRanges == 2) {
                                NSRange range = [match3 rangeAtIndex:1];
                                NSString *mStr = [str substringWithRange:range];
                                [dic setObject:mStr forKey:@"valueInETH"];
                            }
                        }
                        {
                            NSTextCheckingResult *match3 = matches3[i*2 + 1];
                            if (match3.numberOfRanges == 2) {
                                NSRange range = [match3 rangeAtIndex:1];
                                NSString *mStr = [str substringWithRange:range];
                                [dic setObject:mStr forKey:@"valueInUSD"];
                            }
                        }
                    }
                }
            }
        }
        
        if (matches1.count == matches2.count - 1) {
            [tokensInfo insertObject:eth atIndex:0];
        }
        
        [fullResult setObject:tokensInfo forKey:@"tokens"];
        
        return [NSJSONSerialization dataWithJSONObject:fullResult options:kNilOptions error:nil];
    };
    
    NSString *path = [NSString stringWithFormat:@"https://etherscan.io/tokenholdingsHandler.ashx?&a=%@&q=&p=%@&f=0&h=0&sort=total_price_usd&order=desc&%@&fav=", address.checksumAddress.lowercaseString ? :@"",@(page), [params buildHttpQuery] ];
    NSLog(@"%@",path);
    return [self promiseFetch:[NSURL URLWithString:path]
                         body:nil
                  contentType:nil
                    fetchType:ApiProviderFetchTypeJSONDictionary
                      process:processTransactions];
    
}

- (DictionaryPromise *)crawlPricesForAddress:(Address *)address{
    if (!address || ![address isKindOfClass:[Address class]]) {
        return nil;
    }
    
    NSObject* (^processResult)(NSData*) = ^NSObject*(NSData *response) {
        //NSLog(@"%@",response);
        
        NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        NSString *regex = [NSString stringWithFormat:@"var p([0-9a-zA-Z.]*) = ([0-9.,]*);"];
        //NSLog(@"regex: %@, str: %@",regex1,str);
        
        NSError *error;
        
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *matches = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        NSLog(@"matches1: %@, error: %@", @(matches.count), error);
        if (!matches.count) {
            return nil;
        }
        
        NSMutableDictionary *infos = [NSMutableDictionary dictionary];
        
        for (NSTextCheckingResult *match in matches) {
            if (match.numberOfRanges == 3) {
                NSRange range1 = [match rangeAtIndex:1];
                NSString *key = [str substringWithRange:range1];
                
                NSRange range2 = [match rangeAtIndex:2];
                NSString *value = [str substringWithRange:range2];
                if (key.length && value.length) {
                    [infos setObject:value forKey:[NSString stringWithFormat:@"p%@",key]];
                }
            }
        }
        NSLog(@"get price infos: %@",infos);
        
        return [NSJSONSerialization dataWithJSONObject:infos options:kNilOptions error:nil];
    };
    
    NSString *path = [NSString stringWithFormat:@"https://etherscan.io/tokenholdings?a=%@",address.checksumAddress?:@""];
    
    NSString *addressString = address.checksumAddress.lowercaseString ? : @"";
    return [self promiseFetch:[NSURL URLWithString:path]
                         body:[NSJSONSerialization dataWithJSONObject:@{@"address":addressString} options:kNilOptions error:nil]
                  contentType:@"application/json"
                    fetchType:ApiProviderFetchTypeJSONDictionary
                      process:processResult];
}

- (ArrayPromise*)crawlTransactionsForAddress:(Address *)address page:(NSInteger)page{
    
    NSObject* (^processTransactions)(NSData*) = ^NSObject*(NSData *response) {
        
        NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        {
            NSString *match = @"[a-zA-Z0-9-=:\\s\'\"?_./,]*";
            
            NSString *regex = [NSString stringWithFormat:@"<a href=%@>",match];
            NSError *error;
            //NSLog(@"regex: %@, str: %@",regex,str);
            NSRegularExpression *regular =
            [NSRegularExpression
             regularExpressionWithPattern:regex
             options:NSRegularExpressionCaseInsensitive
             error:&error];
            
            str = [regular stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:@""];
            str = [str stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"&nbsp; IN &nbsp;" withString:@"IN"];
        }
        
        NSString *match = @"[a-zA-Z0-9-=:\\s\'\"?_./,&;]*";
        
        NSString *regex = [NSString stringWithFormat:@"<td><span%@>(%@)</span></td><td><span%@>(%@)</span></td><td><span class='address-tag'>(%@)</span></td><td><span%@>(%@)</span></td><td><span class='address-tag'>(%@)</span></td><td>(%@)</td>",match,match,match,match,match,match,match,match,match];
        
        NSLog(@"regex: %@,str:\n%@\n",regex,str);
        NSError *error;
        
        NSRegularExpression *regular =
        [NSRegularExpression
         regularExpressionWithPattern:regex
         options:NSRegularExpressionCaseInsensitive
         error:&error];
        
        NSArray *matches = [regular matchesInString:str
                                            options:0
                                              range:NSMakeRange(0, str.length)];
        
        NSLog(@"matches: %@, error: %@", matches, error);
        
        NSMutableArray *infos = [NSMutableArray array];
        
        for (NSTextCheckingResult *match in matches) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSInteger i = 0; i < match.numberOfRanges; i++){
                NSRange range = [match rangeAtIndex:i];
                NSString *mStr = [str substringWithRange:range];
                //NSLog(@"%@", mStr);
                if (i == 1) {
                    [dic setObject:mStr forKey:@"hash"];
                }else if (i == 2){
                    [dic setObject:mStr forKey:@"timestamp"];
                }else if (i == 3){
                    [dic setObject:mStr forKey:@"from"];
                }else if (i == 5){
                    [dic setObject:mStr forKey:@"to"];
                }else if (i == 6){
                    [dic setObject:mStr forKey:@"value"];
                }
            }
            [infos addObject:dic];
        }
        return infos;
    };
    
    NSString *path = [NSString stringWithFormat:@"https://etherscan.io/txs?a=%@&p=%@",address.checksumAddress.lowercaseString?:@"",@(page)];
    NSLog(@"%@",path);
    return [self promiseFetch:[NSURL URLWithString:path]
                         body:nil
                  contentType:nil
                    fetchType:ApiProviderFetchTypeArray
                      process:processTransactions];
}

@end
