//
//  main.swift
//  SpaceWarShips
//
//  Created by Thomas Bibby on 09/04/2017.
//  Copyright © 2017 Till Now Limited. All rights reserved.
//

import Foundation
import Dispatch

//struct to hold each relevant info about starship
struct starship {
    var name: String = ""
    var consumablesString = ""
    var hoursOfConsumables: Double = 0.0
    var mglt = 0
}

// we don't actually need to wrap this in a class, the only reason to do so is that we can reorder the functions to a more natural order. An instance of this class is instantiated at the end of this file
class starshipRetriever {
    
    //we're just using the default URLSession config here for our network requests
    let defaultSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    
    //our arrray of structs representing each starship
    var starshipStructsArray = [starship]()
    
    
    //starting up by loading starship data from API, when we have finished retrieving we will call interact() below
    func start() {
        print("Loading starship data...")
        retrieveStarshipJson(urlToStartFrom:"http://swapi.co/api/starships")
    }
    
    //function to read input after we have retrieved data
    func interact() {
        print("Please enter the number of mega lights or any other key to quit: ")
        let response = readLine()
        //unwrap the response, and if we have an integer, run our calculations and print them
        if let r = response, let numMegaLights = Int(r) {
            //print out and call this function again
            printResults(for: numMegaLights)
            interact()
        }
        else {
            exit(0)
        }
    }
    //network code
    func retrieveStarshipJson(urlToStartFrom: String) {
        //there's a lot of optional unwrappping here - guard let is used
        //to do an early return which reduces indentation
        guard let url = URL(string: urlToStartFrom) else {
            print("Could not convert string to url")
            return
        }
        let dataTask = defaultSession.dataTask(with: url) {
            data, response, error in
            //we're in a closure here, with 3 optional values above. 
            //This closure gets called when we get a response
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // Parse the JSON
            do {
                //We use Swift's JSONSerialization class here
                //working with JSON in Swift is a bit of a pain as we have lots
                //of unwrapping to do...
                
                //get main json object
                guard let starships = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                //get results
                guard let starshipArray = starships["results"] as? [[String:Any]] else {
                    print("error getting starships")
                    return
                }
                
                //loop over results
                for starshipJSON in starshipArray {
                    //unwrap the json we need
                    if let name = starshipJSON["name"] as? String, let consumables = starshipJSON["consumables"] as? String, let mglt = starshipJSON["MGLT"] as? String {
                        var mgltAsInt = 0
                        //mglt can be unknown. It's a string in the JSON so we have to convert. Default it to zero
                        if(mglt != "unknown"), let mgltInt = Int(mglt) {
                            mgltAsInt = mgltInt
                        }
                        //create a new starship struct and add it to the array
                        let newStarship = starship(name: name, consumablesString: consumables, hoursOfConsumables: self.hoursFromIntervalDescription(from: consumables), mglt: mgltAsInt)
                        self.starshipStructsArray.append(newStarship)
                    }
                    
                }
                
                //our API is paginated, so check if we have any more to get, if so go off and do that by calling this function again
                if let nextUrlString = starships["next"] as? String  {
                    self.retrieveStarshipJson(urlToStartFrom: nextUrlString)
                //else we've got everything so we can start accepting input
                }
                else {
                    
                    self.interact()
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        //urlsessiontasks are suspended by default, have to call resume on them to actually run
        dataTask.resume()
    }
    
    //helper function to convert a time interval string in hours, days, weeks, months or years to hours
    //plural and singular form is OK too - so 1 year works
    func hoursFromIntervalDescription(from intervalString: String) -> Double {
        //some consts here
        let daysInYear = 365.25
        let hoursInDay = 24.0
        let daysInWeek = 7.0
        let monthsInYear = 12.0
        
        var numberToCompare = 0
        var hoursToReturn = 0.0
        
        //Small regular expression to extract integer
        //+ is greedy so will extract all numbers
        let numberRegex = "[0-9]+"
        //get range of this regex and get an Int from teh string
        if let rangeOfNumber = intervalString.range(of: numberRegex, options: .regularExpression), let number = Int(intervalString.substring(with: rangeOfNumber)) {
            numberToCompare = number
        }
        
        //convert the number to hours. Should have probably used a switch here
        if(intervalString.contains("week")) {
            hoursToReturn = Double(numberToCompare) * daysInWeek * hoursInDay
        }
        else if(intervalString.contains("year"))
        {
            hoursToReturn = Double(numberToCompare) * daysInYear * hoursInDay
        }
        else if(intervalString.contains("month")) {
            hoursToReturn = Double(numberToCompare) * daysInYear * hoursInDay / monthsInYear
        }
        else if(intervalString.contains("hour")) {
            hoursToReturn = Double(numberToCompare)
        }
        else if(intervalString.contains("day")) {
            hoursToReturn = Double(numberToCompare) * hoursInDay
        }
        //we're returning 0 if nothing matches
        return hoursToReturn
    }
    
    //our function to print results
    func printResults(for megalights: Int) {
        for starship in starshipStructsArray {
            //let's just print 0 for unknown consumables
            var stops = 0.0
            //avoid divide by zero errors
            if(starship.hoursOfConsumables > 0.0 && starship.mglt > 0) {
                stops = Double(megalights) / (starship.hoursOfConsumables * Double(starship.mglt))
            }
            //now if we have 2.3 stops, we only have to make 2 stops before we get to our destination So let's round down and convert to an Int
            let roundedStops = Int(stops.rounded(.down))
            print ("\(starship.name): \(roundedStops)")
        }
    }
}

let retriever = starshipRetriever()
retriever.start()
//unfortunately this line is necessary to keep the program running for long enough for the async network request to return. This does not work on the IBM Swift Sandbox or similar as it times out
dispatchMain()
