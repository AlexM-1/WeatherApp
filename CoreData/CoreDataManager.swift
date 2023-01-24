//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Alex M on 06.01.2023.
//

import CoreData
import UIKit


final class CoreDataManager {


    static let `default` = CoreDataManager()


    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
       // container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    

    lazy var contextMain: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()


    lazy var contextBackground: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()



    // MARK: - Core Data Saving support

    func saveMainContext () {
        if contextMain.hasChanges {
            do {
                try contextMain.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error in main context \(nserror), \(nserror.userInfo)")
            }
        }
    }


    func saveBackgroundContext () {
        if contextBackground.hasChanges {
            do {
                try contextBackground.save()

            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error in background context \(nserror), \(nserror.userInfo)")
            }
        }
    }
    


    func addLocation(location: LocationProtocol) {
        guard self.isUniqueLocation(newLocation: location) else {return}
        let newLocation = Location(context: self.contextMain)
        newLocation.city = location.city
        newLocation.administrativeArea = location.administrativeArea
        newLocation.country = location.country
        newLocation.latitude = location.latitude
        newLocation.longitude = location.longitude
        saveMainContext()
    }
    
    func deleteLocation(location: Location){
        contextMain.delete(location)
        saveMainContext()
    }

    func deleteForecasts(location: Location) {

        let request = Forecast.fetchRequest()
        request.predicate = NSPredicate(format: "location == %@", location)
        let forecasts = (try? contextBackground.fetch(request))

        if let forecasts = forecasts {
            for forecast in forecasts {
                contextBackground.delete(forecast)
            }
        }
        self.saveBackgroundContext()


    }



    private func isUniqueLocation(newLocation: LocationProtocol) -> Bool {

        let request = Location.fetchRequest()
        let locations = (try? contextMain.fetch(request)) ?? []

        var isUniqueLocation = true
        locations.forEach { location in
            if newLocation.city == location.city,
               newLocation.administrativeArea == location.administrativeArea,
               newLocation.country == location.country {
                isUniqueLocation = false
            }
        }
        return isUniqueLocation
    }
    
    
    
    func reloadDailyFact(in location: Location,
                         with weatherResponse: WeatherResponseCodable?,
                         completion: @escaping ()->Void)

    {
        contextBackground.perform {

            let newDailyFact = DailyFact(context: self.contextBackground)
           location.dailyFact = newDailyFact
            location.setValue(newDailyFact, forKey: "DailyFact")

            newDailyFact.condition = weatherResponse?.fact.condition
            newDailyFact.date = weatherResponse?.now_dt
            newDailyFact.humidity = Int16((weatherResponse?.fact.humidity)!)
            newDailyFact.precProb = Int16((weatherResponse?.fact.prec_prob)!)
            newDailyFact.sunrise = weatherResponse?.forecasts.first?.sunrise
            newDailyFact.sunset = weatherResponse?.forecasts.first?.sunset

            var icon = makeIconPath(icon: weatherResponse?.fact.icon, isDark: false)

            NetworkManager.downloadImage(from: icon) { response in
                if response.status
                {
                    newDailyFact.conditionIcon = response.pngdata
                    self.saveBackgroundContext()
                    completion()
                }
            }

            let day = weatherResponse?.forecasts.first?.parts.day
            let evening = weatherResponse?.forecasts.first?.parts.evening
            let morning = weatherResponse?.forecasts.first?.parts.morning
            let night = weatherResponse?.forecasts.first?.parts.night

            let temp = [day?.temp_max, evening?.temp_max, morning?.temp_max, night?.temp_max, day?.temp_min, evening?.temp_min, morning?.temp_min, night?.temp_min].compactMap { $0 }.sorted()

            newDailyFact.tempMin = Int16(temp.first!)
            newDailyFact.tempMax = Int16(temp.last!)
            newDailyFact.morningTemp = Int16(morning!.temp_avg)
            newDailyFact.dayTemp = Int16(day!.temp_avg)
            newDailyFact.eveningTemp = Int16(evening!.temp_avg)
            newDailyFact.nightTemp = Int16(night!.temp_avg)
            newDailyFact.tempNow = Int16((weatherResponse?.fact.temp)!)
            newDailyFact.uptime = weatherResponse?.fact.uptime
            newDailyFact.windSpeed = Int16((weatherResponse?.fact.wind_speed)!)


            icon = makeIconPath(icon: day?.icon)
            NetworkManager.downloadImage(from: icon) { response in
                if response.status
                {
                    newDailyFact.dayIcon = response.pngdata
                    self.saveBackgroundContext()
                    completion()
                }
            }

            icon = makeIconPath(icon: morning?.icon)
            NetworkManager.downloadImage(from: icon) { response in
                if response.status
                {
                    newDailyFact.morningIcon = response.pngdata
                    self.saveBackgroundContext()
                    completion()
                }
            }

            icon = makeIconPath(icon: evening?.icon)
            NetworkManager.downloadImage(from: icon) { response in
                if response.status
                {
                    newDailyFact.eveningIcon = response.pngdata
                    self.saveBackgroundContext()
                    completion()
                }
            }

            icon = makeIconPath(icon: night?.icon)
            NetworkManager.downloadImage(from: icon) { response in
                if response.status
                {
                    newDailyFact.nightIcon = response.pngdata
                    self.saveBackgroundContext()
                    completion()
                }
            }

            self.saveBackgroundContext()
            completion()

        }
    }



    func reloadForecasts (in location: Location,
                          forecastsCodable: [ForecastsCodable],
                          completion: @escaping ()->Void)  {

        contextBackground.perform {

            for forecast in forecastsCodable {

                let day = forecast.parts.day
                let evening = forecast.parts.evening
                let morning = forecast.parts.morning
                let night = forecast.parts.night

                let parts = [morning, day, evening, night]


                let temp = [morning.temp_max, morning.temp_min,
                            day.temp_max, day.temp_min,
                            evening.temp_max, evening.temp_min,
                            night.temp_max, night.temp_min
                ].compactMap { $0 }.sorted()

                for (index, part) in parts.enumerated() {

                    let newForecast = Forecast(context: self.contextBackground)
                    location.addToForecasts(newForecast)

                    newForecast.tempFeelsLike = Int16(part.feels_like)
                    newForecast.humidity = Int16(part.humidity)
                    newForecast.condition = part.condition
                    newForecast.date = forecast.date
                    newForecast.tempMin = Int16(temp.first!)
                    newForecast.tempMax = Int16(temp.last!)
                    newForecast.precProb = Int16(part.prec_prob)
                    newForecast.windDir = part.wind_dir
                    newForecast.windSpeed = part.wind_speed
                    newForecast.tempAvg = Int16(part.temp_avg)
                    newForecast.precProb = Int16(part.prec_prob)
                    newForecast.precValue = part.prec_mm
                    newForecast.pressureValue = Int16(part.pressure_mm)
                    newForecast.precType = Int16(part.prec_type)
                    newForecast.precStrength = part.prec_strength
                    newForecast.cloudness = part.cloudness


                    switch index {
                    case 0:
                        newForecast.partName = "morning"
                    case 1:
                        newForecast.partName = "day"
                    case 2:
                        newForecast.partName = "evening"
                    case 3:
                        newForecast.partName = "night"
                    default:
                        newForecast.partName = ""
                    }

                    var iconStr = "https://yastatic.net/weather/i/icons/funky/dark/"
                    iconStr += part.icon + ".svg"

                    NetworkManager.downloadImage(from: iconStr) { response in
                        if response.status
                        {
                            newForecast.conditionIcon = response.pngdata
                            self.saveBackgroundContext()
                            completion()
                        }
                    }

                    self.saveBackgroundContext()
                    completion()
                }

            }

        }
 

    }

}
