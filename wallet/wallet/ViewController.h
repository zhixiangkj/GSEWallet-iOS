//
//  ViewController.h
//  wallet
//
//  Created by user on 21/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerNav : UINavigationController
@end

@interface ViewController : UIViewController
+ (id)shared;

- (void)reloadData;
- (void)reloadData:( void (^)(void) ) finish;
@end
