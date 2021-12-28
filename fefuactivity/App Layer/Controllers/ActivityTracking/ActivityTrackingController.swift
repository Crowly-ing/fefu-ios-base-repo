import UIKit
import CoreLocation
import MapKit

class ActivityTrackingController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return manager
    }()
    
    fileprivate var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else {
                return
            }
            
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            
            mapView.setRegion(region, animated: true)
            
            userLocationsHistory.append(userLocation)
        }
    }
    
    private var previousRouteLine: MKPolyline?
    
    fileprivate var userLocationsHistory: [CLLocation] = [] {
        didSet {
            let coordinates = userLocationsHistory.map { $0.coordinate }
            
            if let previousRoute = previousRouteLine, !userLocationsHistory.isEmpty {
                mapView.removeOverlay(previousRoute as MKOverlay)
                previousRouteLine = nil
            }
            
            if userLocationsHistory.isEmpty {
                previousRouteLine = nil
            }
            
            let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            route.title = "Ваш маршрут"
            
            previousRouteLine = route
            
            mapView.addOverlay(route)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Новая активность"
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
}

extension ActivityTrackingController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let curLocation = locations.first else {
            return
        }
        
        userLocation = curLocation
    }
}

extension ActivityTrackingController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polyline)
            
            render.fillColor = UIColor(red: 0.294, green: 0.035, blue: 0.953, alpha: 1)
            render.strokeColor = UIColor(red: 0.294, green: 0.035, blue: 0.953, alpha: 1)
            render.lineWidth = 5
            
            return render
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: "user_icon")
            
            let view = dequedView ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "user_icon")
            
            view.image = UIImage(named: "MapPin")
            return view
        }
        return nil
    }
}
