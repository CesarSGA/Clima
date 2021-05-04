//
//  ClimaManager.swift
//  App Clima
//
//

import Foundation

protocol ClimaManagerDelegate {
    
    func updateWeather(weather: ClimaModel)
    
    func ifError(error: Error)
}

struct ClimaManager {
    
    var delegate: ClimaManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4235256c472d4ca247d440d4529b315a&units=metric&lang=es"
    
    // Consultar con nombre de la ciudad
    func fechtClima(nameCity: String) {
        let urlString = "\(weatherURL)&q=\(nameCity)"
        
        realizarSolicitud(urlString: urlString)
    }
    
    // Consultar con la ubicacion
    func fechtClima(lat: Double, lon: Double) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String) {
        // 1.- Crear una url
        if let url = URL(string: urlString) {
            
            // 2.- Crear el objeto URLSession
            let session = URLSession(configuration: .default)
            
            // 3.- Asignar una tarea a la sesion
            let task = session.dataTask(with: url) { (data, request, error) in
                if error != nil {
                    delegate?.ifError(error: error!)
                    print(error!)
                    return
                }
                
                if let dataSure = data {
                    // Decodificar el objeto JSON de la API
                    if let weather = self.parseJSON(weatherData: dataSure) {
                        
                        // Quien sea el delegado cualquier class o structur que implemente el metodo updateWeather
                        delegate?.updateWeather(weather: weather)
                    }
                }
            }
            
            // 4.- Empezar la tarea
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> ClimaModel? {
        
        let decoder = JSONDecoder()
        do {
            let dataDecoder = try decoder.decode(ClimaData.self, from: weatherData)
            let id = dataDecoder.weather[0].id
            let nameCity = dataDecoder.name
            let description = dataDecoder.weather[0].description
            let temp = dataDecoder.main.temp
            let tempMax = dataDecoder.main.temp_max
            let tempMin = dataDecoder.main.temp_min
            let wind = dataDecoder.wind.speed
            let humidity = dataDecoder.main.humidity
            
            // Crear un Objeto de tipo ClimaModelo
            let weatherObj = ClimaModel(idCondicion: id, nameCity: nameCity, description: description, temp: temp, tempMax: tempMax, tempMin: tempMin, wind: wind, humidity: humidity )
            
            return weatherObj
        } catch {
            print(error)
            delegate?.ifError(error: error)
            return nil
        }
    }
}
