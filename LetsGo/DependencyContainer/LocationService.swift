//
//  LocationService.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/3/22.
//

import Combine
import CoreLocation
import Foundation
import MapKit

protocol LocationServiceProtocol {
    var status: CurrentValueSubject<CLAuthorizationStatus, Never> { get }
    var location: CurrentValueSubject<CLLocation?, Never> { get }
    var latitude: CLLocationDegrees { get }
    var longitude: CLLocationDegrees { get }
    var permissionStatus: Bool { get }

    func start()
    func stop()
}

class LocationService: DependencyContainer.Component, LocationServiceProtocol {
    @Published var locationResults: [MKLocalSearchCompletion] = []
    var status = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    var location = CurrentValueSubject<CLLocation?, Never>(nil)

    private let locationManager = CLLocationManager()
    private let delegateObject: LocationServiceDelegateObject = LocationServiceDelegateObject()

    private var cancellables: Set<AnyCancellable> = []
    private var searchCompleter = MKLocalSearchCompleter()
    var currentPromise: ((Result<[MKLocalSearchCompletion], Error>) -> Void)?

    var latitude: CLLocationDegrees {
        location.value?.coordinate.latitude ?? 0
    }

    var longitude: CLLocationDegrees {
        location.value?.coordinate.longitude ?? 0
    }

    var permissionStatus: Bool {
        if status.value == .authorizedWhenInUse {
            return true
        } else {
            return false
        }
    }
    
    override init(entity: DependencyContainer) {
        super.init(entity: entity)
        delegateObject.owner = self
        status.value = locationManager.authorizationStatus
        locationManager.delegate = self.delegateObject
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
        searchCompleter.delegate = self.delegateObject
    }

    public func start() {
        if status.value == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else if status.value == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status.value == .denied {
            //AlertView location needed
        }
    }

    public func stop() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService {

    // CLLocationManagerDelegate must be a NSObject
    class LocationServiceDelegateObject: NSObject, ObservableObject, CLLocationManagerDelegate {
        weak var owner: LocationService?

        public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            self.owner?.status.value = manager.authorizationStatus
            if manager.authorizationStatus == .authorizedWhenInUse {
                manager.startUpdatingLocation()
            }
        }

        public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            self.owner?.location.value = location
        }

        public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            #if DEBUG
            print("Location manager failed with error", error.localizedDescription)
            #endif
        }
    }
}

extension LocationService.LocationServiceDelegateObject: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        owner?.currentPromise?(.success(completer.results))
    }
}
