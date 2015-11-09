//
//  WeatherInfo.m
//  CurrentWeather
//
//  Created by Michael Billard on 11/8/15.
//  Copyright © 2015 Michael Billard. All rights reserved.
//

#import "WeatherInfo.h"

NSString* const REQUEST_WEATHER_BY_CITY = @"http://api.openweathermap.org/data/2.5/weather?q=%@&units=imperial&APPID=%@";
NSString* const REQUEST_WEATHER_BY_LOCATION = @"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&units=imperial&APPID=%@";

@interface WeatherInfo()
- (void)parseJSONResponse:(NSURLResponse*)response withData:(NSData*)data;
- (void)didFailWithError:(NSError*)error;
- (void)didRetrieveWeather;
@end

@implementation WeatherInfo
- (void)getWeatherForLocation:(CLLocation*)location {
    NSString* latitude = [[NSNumber numberWithDouble:location.coordinate.latitude] stringValue];
    NSString* longitude = [[NSNumber numberWithDouble:location.coordinate.longitude] stringValue];
    NSString* requestURL = [NSString stringWithFormat:REQUEST_WEATHER_BY_LOCATION, latitude, longitude, self.accessKey];
    
    __weak WeatherInfo* weakSelf = self;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:requestURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if (error == nil) {
                    [weakSelf parseJSONResponse:response withData:data];
                }
                
                else {
                    [weakSelf didFailWithError:error];
                }
                
            }] resume];
}

- (void)getWeatherForCity:(NSString*)city {
    NSString* encodedString = [city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString* requestURL = [NSString stringWithFormat:REQUEST_WEATHER_BY_CITY, encodedString, self.accessKey];
    
    __weak WeatherInfo* weakSelf = self;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:requestURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if (error == nil) {
                    [weakSelf parseJSONResponse:response withData:data];
                }
                
                else {
                    [self performSelectorOnMainThread:@selector(didFailWithError:)
                                           withObject:error
                                        waitUntilDone:NO];
                }
                
            }] resume];
}

- (void)parseJSONResponse:(NSURLResponse*)response withData:(NSData*)data {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    long statusCode = [httpResponse statusCode];
    NSError *jsonError = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
    if (jsonError == nil && statusCode == 200) {
        //Parse the JSON
        
        //Make sure we have a good response
        NSNumber* status = responseDict[@"cod"];
        if ([status intValue] != 200) {
            NSString* message = responseDict[@"message"];
            NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:message forKey:NSLocalizedDescriptionKey];
            
            NSError* responseError = [[NSError alloc] initWithDomain:NSURLErrorDomain
                                                                code:[status intValue]
                                                            userInfo:userInfo];
            [self performSelectorOnMainThread:@selector(didFailWithError:)
                                   withObject:responseError
                                waitUntilDone:NO];
            return;
        }
        
        NSDictionary* parameters = responseDict[@"main"];
        self.humidity = parameters[@"humidity"];
        self.minimumTemperature = parameters[@"temp_min"];
        self.maximumTemperature = parameters[@"temp_max"];
        self.temperature = parameters[@"temp"];
        self.pressure = parameters[@"pressure"];
        self.seaLevelPressure = parameters[@"sea_level"];
        
        parameters = responseDict[@"wind"];
        self.deg = parameters[@"deg"];
        self.windSpeed = parameters[@"speed"];
        
        NSArray* arrayParams = responseDict[@"weather"];
        parameters = arrayParams[0];
        self.weatherDescription = parameters[@"description"];
        
        parameters = responseDict[@"clouds"];
        self.cloudiness = parameters[@"all"];
        
        parameters = responseDict[@"rain"];
        self.rain = parameters[@"3h"];
        
        self.city = responseDict[@"name"];
        
        //Inform the delegate
        [self performSelectorOnMainThread:@selector(didRetrieveWeather) withObject:nil waitUntilDone:NO];
    }
    
    else {
        [self performSelectorOnMainThread:@selector(didFailWithError:)
                                   withObject:jsonError
                                waitUntilDone:NO];
    }
}

- (void)didRetrieveWeather {
    [self.delegate didRetrieveWeather];
}

- (void)didFailWithError:(NSError*)error {
    [self.delegate didFailWithError:error];
}
@end
