//
//  WeatherResultsVC.m
//  CurrentWeather
//
//  Created by Michael Billard on 11/8/15.
//  Copyright © 2015 Michael Billard. All rights reserved.
//

#import "WeatherResultsVC.h"

@interface WeatherResultsVC ()

@end

@implementation WeatherResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableString* webPage = [[NSMutableString alloc] init];

    [webPage appendFormat:@"<span style=\"font-family: %@; font-size: %i\">",
     @"GothamRounded-Bold", 14];
    
    [webPage appendFormat:@"<h1>Current Weather for %@</h1>", self.weatherInfo.city];
    
    if (self.weatherInfo.humidity)
        [webPage appendFormat:@"<p>Humidity: %@%%</p>", [self.weatherInfo.humidity stringValue]];
    
    if (self.weatherInfo.pressure)
        [webPage appendFormat:@"<p>Pressure: %@ hPA</p>", [self.weatherInfo.pressure stringValue]];
    if (self.weatherInfo.seaLevelPressure)
        [webPage appendFormat:@"<p>Sea-level Pressure: %@ hPA</p>", [self.weatherInfo.seaLevelPressure stringValue]];
    
    if (self.weatherInfo.temperature)
        [webPage appendFormat:@"<p>Current Temperature: %@ F</p>", [self.weatherInfo.temperature stringValue]];

    if (self.weatherInfo.windSpeed)
        [webPage appendFormat:@"<p>Wind Speed: %@ miles per hour</p>", [self.weatherInfo.windSpeed stringValue]];
    
    if (self.weatherInfo.deg)
        [webPage appendFormat:@"<p>Wind Direction: %@ degrees</p>", [self.weatherInfo.deg stringValue]];

    if (self.weatherInfo.cloudiness)
        [webPage appendFormat:@"<p>Cloudiness: %@%%</p>", [self.weatherInfo.cloudiness stringValue]];
    
    if (self.weatherInfo.rain)
        [webPage appendFormat:@"<p>Rain: %@ millimeters</p>", [self.weatherInfo.rain stringValue]];

    if (self.weatherInfo.weatherDescription)
        [webPage appendFormat:@"<p>Description: %@</p>", self.weatherInfo.weatherDescription];
    
    [webPage appendString:@"</span>"];
    
    [self.webView loadHTMLString:webPage baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
