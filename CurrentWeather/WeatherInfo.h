//
//  WeatherInfo.h
//  CurrentWeather
//
//  Created by Michael Billard on 11/8/15.
//  Copyright © 2015 Michael Billard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol WeatherInfoDelegate <NSObject>
- (void)didRetrieveWeather;
- (void)didFailWithError:(NSError*)error;
@end

@interface WeatherInfo : NSObject
@property (nonatomic, strong) NSNumber* humidity;
@property (nonatomic, strong) NSNumber* pressure;
@property (nonatomic, strong) NSNumber* seaLevelPressure;
@property (nonatomic, strong) NSNumber* temperature;
@property (nonatomic, strong) NSNumber* minimumTemperature;
@property (nonatomic, strong) NSNumber* maximumTemperature;
@property (nonatomic, strong) NSString* weatherDescription;
@property (nonatomic, strong) NSNumber* windSpeed;
@property (nonatomic, strong) NSNumber* deg;
@property (nonatomic, strong) NSNumber* rain;
@property (nonatomic, strong) NSNumber* cloudiness;
@property (nonatomic, strong) NSString* city;

@property (nonatomic, strong) NSString* accessKey;
@property (weak, nonatomic) NSObject<WeatherInfoDelegate> *delegate;

- (void)getWeatherForLocation:(CLLocation*)location;

- (void)getWeatherForCity:(NSString*)city;
@end
