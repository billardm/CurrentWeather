//
//  LocationVC.h
//  CurrentWeather
//
//  Created by Michael Billard on 11/7/15.
//  Copyright © 2015 Michael Billard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherInfo.h"

@interface LocationVC : UIViewController <CLLocationManagerDelegate, WeatherInfoDelegate>

@property (nonatomic, weak) IBOutlet UIButton* useCurrentLocationButton;
@property (nonatomic, weak) IBOutlet UIButton* getWeatherButton;
@property (nonatomic, weak) IBOutlet UILabel* statusLabel;
@property (nonatomic, weak) IBOutlet UITextField* cityField;

- (IBAction)useCurrentLocation:(id)sender;
- (IBAction)getWeather:(id)sender;
@end

