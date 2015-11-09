//
//  LocationVC.m
//  CurrentWeather
//
//  Created by Michael Billard on 11/7/15.
//  Copyright © 2015 Michael Billard. All rights reserved.
//

#import "LocationVC.h"
#import "WeatherResultsVC.h"

//TODO: Localizations
NSString* const STATUS_GETTING_LOCATION = @"Getting location...";
NSString* const STATUS_CHECKING_WEATHER = @"Checking the weather...";

NSString* const ERROR_OK = @"OK";
NSString* const ERROR_CANCEL = @"Cancel";
NSString* const ERROR_NEED_CITY_TITLE = @"Need name of city";
NSString* const ERROR_NEED_CITY = @"Please enter a city before checking the weather.";
NSString* const ERROR_LOCATION_MANAGER_FAILED_TITLE = @"OOPS!";
NSString* const ERROR_LOCATION_MANAGER_FAILED = @"Oops! location manager failed with error: %@";
NSString* const ERROR_GET_WEATHER_FAILED_TITLE = @"Get weather failed!";
NSString* const ERROR_GET_WEATHER_FAILED = @"Get weather failed with error: %@";

NSString* const ACCESS_KEY = @"7d1051d737b4fd2cd404d755562b7790";

@interface LocationVC () {
    WeatherInfo* weatherInfo;
}
@property (nonatomic, readwrite) CLLocationManager* locationManager;

- (void)startMonitoringLocation;
- (void)getWeatherForLocation:(CLLocation*)location;
- (void)getWeatherForCity:(NSString*)city;
@end

@implementation LocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // If we don't have locations services enabled then disable the button.
    self.useCurrentLocationButton.enabled = [CLLocationManager locationServicesEnabled];
    
    weatherInfo = [[WeatherInfo alloc] init];
    weatherInfo.accessKey = ACCESS_KEY;
    weatherInfo.delegate = self;
}

#pragma mark Actions
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self stopMonitoringLocation];
}

- (IBAction)getWeather:(id)sender {
    
    //Make sure that we have a city to check for
    if (self.cityField.text.length == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ERROR_NEED_CITY_TITLE
                                                                       message:ERROR_NEED_CITY
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:ERROR_OK
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:ERROR_CANCEL
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];

        return;
    }
    
    //Ok, we have a city to look for. Let's get the weather.
    [self getWeatherForCity:self.cityField.text];
}

- (IBAction)useCurrentLocation:(id)sender {
    [self startMonitoringLocation];
}

#pragma mark Delegates
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
    
    //Since we really only need to get this once, stop the monitoring to conserve power.
    [self stopMonitoringLocation];
    self.statusLabel.text = @"";
    
    //Now initiate the network request for the current latitude and longitude.
    [self getWeatherForLocation:location];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSString* errorMessage = [NSString stringWithFormat:ERROR_LOCATION_MANAGER_FAILED, [error localizedDescription]];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:ERROR_LOCATION_MANAGER_FAILED_TITLE
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:ERROR_OK
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:ERROR_CANCEL
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    NSLog(@"%@", errorMessage);
    
    self.statusLabel.text = @"";
}

- (void)didRetrieveWeather {
    self.useCurrentLocationButton.enabled = YES;
    self.getWeatherButton.enabled = YES;    
    self.statusLabel.text = @"";
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WeatherResultsVC *weatherResultsVC = [storyboard instantiateViewControllerWithIdentifier:@"WeatherView"];
    weatherResultsVC.weatherInfo = weatherInfo;
    
    [self.navigationController pushViewController:weatherResultsVC animated:YES];
}

- (void)didFailWithError:(NSError *)error {
    NSString* errorMessage = [NSString stringWithFormat:ERROR_GET_WEATHER_FAILED, [error localizedDescription]];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:ERROR_GET_WEATHER_FAILED_TITLE
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:ERROR_OK
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:ERROR_CANCEL
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    NSLog(@"%@", errorMessage);
    
    self.useCurrentLocationButton.enabled = YES;
    self.getWeatherButton.enabled = YES;
    self.statusLabel.text = @"";
}

#pragma mark Helpers
- (void)startMonitoringLocation {
    
    //Create the location manager if needed
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=kCLDistanceFilterNone;
    }
    
    //Start monitoring locations
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    
    self.statusLabel.text = STATUS_GETTING_LOCATION;
}

- (void)stopMonitoringLocation {
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager stopUpdatingLocation];
}

- (void)getWeatherForLocation:(CLLocation*)location {
    self.statusLabel.text = STATUS_CHECKING_WEATHER;
    
    //Disable buttons
    self.useCurrentLocationButton.enabled = NO;
    self.getWeatherButton.enabled = NO;
    
    //Make network request
    [weatherInfo getWeatherForLocation:location];
}

- (void)getWeatherForCity:(NSString*)city {
    self.statusLabel.text = STATUS_CHECKING_WEATHER;
    
    //Disable buttons
    self.useCurrentLocationButton.enabled = NO;
    self.getWeatherButton.enabled = NO;
    
    //Make network request
    [weatherInfo getWeatherForCity:city];
}
@end
