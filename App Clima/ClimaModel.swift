//
//  ClimaModel.swift
//  App Clima
//
//

import Foundation

struct ClimaModel {
    
    let idCondicion: Int
    let nameCity: String
    let description: String
    let temp: Double
    let tempMax: Double
    let tempMin: Double
    let wind: Double
    let humidity: Int
    
    // Crear propiedad computada
    var weatherCondicion: String {
        switch idCondicion {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
    
    // Formateamos el decimal del clima para devolver solo uno "26.8"
    var tempFormat: String {
        return String(format: "%.1f", self.temp)
    }
    
    var tempMaxFormat: String {
        return String(format: "%.1f", self.tempMax)
    }
    
    var tempMinFormat: String {
        return String(format: "%.1f", self.tempMin)
    }
}
