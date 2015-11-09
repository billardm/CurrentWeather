//
//  WeatherResultsVC.h
//  CurrentWeather
//
//  Created by Michael Billard on 11/8/15.
//  Copyright © 2015 Michael Billard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherInfo.h"

@interface WeatherResultsVC : UIViewController
@property (nonatomic, weak) IBOutlet UIWebView* webView;
@property (nonatomic, weak) WeatherInfo* weatherInfo;
@end
