//
//  FindLocations.swift
//  Hone
//
//  Created by Joey Donino on 6/9/15.
//  Copyright (c) 2015 Joey Donino. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

@available(iOS 8.0, *)
class FindLocations
{
    
  
    
    func searchSuggestions (text: String, sender: ViewController){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {

        let searchRequest=MKLocalSearchRequest()
        if let currentLocation=sender.locationValue{
        let region=MKCoordinateRegionMakeWithDistance(currentLocation, 1000, 1000)
             searchRequest.region=region
        }

        searchRequest.naturalLanguageQuery=text
       
        let search=MKLocalSearch (request: searchRequest)
        search.startWithCompletionHandler{(response: MKLocalSearchResponse?, error: NSError?) in
            if error == nil{
            print(response?.mapItems ?? "No response")
            for item in response!.mapItems {
                //println("1")
                if let result: MKMapItem? = item {
                          //println("2")
                    if let resultName=result!.name{
                             print("search sug \(resultName)")
                        
                       sender.searchResultList.append(resultName)
                        sender.mapItemsList.append(result!)
                        }
                    }
                }
                  sender.mapItemsList = sender.mapItemsList.sort(sender.sortByDistance)
                 dispatch_async(dispatch_get_main_queue()) {
                sender.updateSearchDisplay()
                }
            }
    
        }
  
    })
    }

/*
-(void)searchByCategory: (NSString *)text withVC: (EditProfileTableViewController *)vs{
MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
request.naturalLanguageQuery = text;


// Create and initialize a search object.
MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];


// Start the search and display the results as annotations on the map.
[search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
{
NSMutableArray *schools=[[NSMutableArray alloc]init];

for (MKMapItem *item in response.mapItems) {
NSArray *business=(NSArray *)[[item valueForKey:@"place"]valueForKey:@"business"];
for(NSDictionary* bus in business){
NSArray *bus2=(NSArray *)[bus valueForKey:@"localizedCategories"];
for(NSDictionary * local in bus2){
NSArray *localnames=(NSArray *)[local valueForKey:@"localizedNames"];
for(NSString *localname in localnames){
NSString* name=(NSString *)[localname valueForKey:@"name"];

if([name isEqualToString:@"Middle Schools & High Schools"]||[name isEqualToString:@"Private Schools"]||[name isEqualToString:@"Specialty School"]||[name isEqualToString:@"Education"]){
// NSLog(@" types: %@", name);
// NSLog(@"Name: %@", item.name);
if(item.name&&[item.placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressCityKey]&&[item.placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressStateKey]){
NSString* schoolForrmatted=[NSString stringWithFormat:@"%@ (%@, %@)",item.name,[item.placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressCityKey], [item.placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressStateKey]];
if(![schools containsObject:schoolForrmatted]){
[schools addObject:schoolForrmatted];
NSLog(@"Name: %@", schoolForrmatted);
}

}
}

}
[vs setCities:schools];
}

}
}



}];
}



-(void)searchSuggestions:(NSString *)text withVC: (EditProfileTableViewController *)vc{
    CLGeocoder *geocoder =[[CLGeocoder alloc]init];
    NSDictionary *address=[NSDictionary dictionaryWithObjectsAndKeys:text,kABPersonAddressCityKey,nil];
    [geocoder geocodeAddressDictionary:address completionHandler:^(NSArray *placemarks, NSError *error)
    {

    if([placemarks count]){
    NSMutableArray *pm=[[NSMutableArray alloc]init];
    for(CLPlacemark *placemark in placemarks)
    {
    if([placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressCityKey]&&[placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressStateKey]&&[placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressCountryKey]){
    NSString *cityformat=[NSString stringWithFormat:@"%@, %@, %@",[placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressCityKey],[placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressStateKey],[placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressCountryKey]];
    if(![pm containsObject:cityformat]){
    [pm addObject:cityformat];
    }
    NSLog(@"Placemark %@",[pm firstObject]);
    }
    }
    [vc setCities:pm];
    }
    
    }];



    */
    
}