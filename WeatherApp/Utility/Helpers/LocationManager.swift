//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Роман Мельник on 14.06.2021.
//

import CoreLocation
import Foundation

protocol LocationUpdateProtocol {
    func locationDidUpdateToLocation()
    func hasProblem(error: String)
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    // MARK: - Properties
    
    private var locationManager:CLLocationManager?
    var lastLocation:CLLocation?
    var delegate: LocationUpdateProtocol?
    
    // MARK: - Init
    
    deinit {
        destroyLocationManager()
    }
    
    // MARK: - Confige
    
    func setupLocationManager() {
        locationManager = nil
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
    }
        
    func destroyLocationManager() {
        locationManager?.delegate = nil
        locationManager = nil
        lastLocation = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied: // Setting option: Never
            delegate?.hasProblem(error: "LocationManager didChangeAuthorization denied")
        case .notDetermined: // Setting option: Ask Next Time
            print("LocationManager didChangeAuthorization notDetermined")
        case .authorizedWhenInUse: // Setting option: While Using the App
            print("LocationManager didChangeAuthorization authorizedWhenInUse")
          
            // Stpe 6: Request a one-time location information
            locationManager?.requestLocation()
        case .authorizedAlways: // Setting option: Always
            print("LocationManager didChangeAuthorization authorizedAlways")
            // Stpe 6: Request a one-time location information
            locationManager?.requestLocation()
        case .restricted: // Restricted by parental control
            print("LocationManager didChangeAuthorization restricted")
        default:
            print("LocationManager didChangeAuthorization")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
        self.callReverseGeoCoder()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.hasProblem(error: "LocationManager didFailWithError \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
            
        // Location updates are not authorized.
        // To prevent forever looping of `didFailWithError` callback
        locationManager?.stopMonitoringSignificantLocationChanges()
        return
        }
    }
    
    // MARK: - Save location
    private func callReverseGeoCoder() {
        guard let lat = lastLocation?.coordinate.latitude, let lon = lastLocation?.coordinate.longitude else { return }
        UserDefaultsHelper.shared.saveUserLatitude(lat)
        UserDefaultsHelper.shared.saveUserLongitude(lon)
        let geoCoder = CLGeocoder()
        let userCurrentLocation = CLLocation(latitude: lat, longitude: lon)
        geoCoder.reverseGeocodeLocation(userCurrentLocation, completionHandler: { [weak self] placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                self?.delegate?.hasProblem(error: "Dont has coordinate")
                return
            }

            if let placeName = placemark.locality, let placeCountry =  placemark.country {
                print(placeName)
                UserDefaultsHelper.shared.saveUserPlacesname("\(placeName), \(placeCountry)")
            } else {
                print("Error in callReverseGeoCoder()")
            }
            self?.delegate?.locationDidUpdateToLocation()
        })
    }
}
