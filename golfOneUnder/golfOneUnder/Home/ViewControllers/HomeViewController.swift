//
//  HomeViewController.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/6/22.
//

import UIKit
import GoogleMaps

class HomeViewController: BaseViewController, CLLocationManagerDelegate {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mapsViewContainer: UIView!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceNameContainer: UIView!
    @IBOutlet weak var deviceNotConnectedPromptView: UIStackView!
    @IBOutlet weak var connectDeviceButton: UIButton!
    
    private var locationManager = CLLocationManager()
    private var isDeviceConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapsViewContainer.backgroundColor = UIColor.white
        topBarView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        topBarView.layer.shadowOpacity = 0.5
        topBarView.layer.shadowRadius = 1
        topBarView.layer.shadowColor = UIColor.black.cgColor
        topBarView.layer.cornerRadius = 20
        topBarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        deviceNameContainer.layer.cornerRadius = 10.0
        deviceNameContainer.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        deviceNameContainer.layer.shadowOpacity = 0.8
        deviceNameContainer.layer.shadowRadius = 2
        deviceNameContainer.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    @IBAction func onConnectDeviceTap(_ sender: Any) {
        if !isDeviceConnected {
            connectToADevice()
        }
        else {
            let deviceDisconnectedController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: DeviceDisconnectedViewController.self)) as! DeviceDisconnectedViewController
            deviceDisconnectedController.modalPresentationStyle = .fullScreen
            deviceDisconnectedController.onTapConnectDevice = {
                self.connectToADevice()
            }
            deviceDisconnectedController.onTapBack = {
                self.mapsViewContainer.isHidden = true
                self.isDeviceConnected = false
                self.deviceNameContainer.isHidden = true
                self.deviceNotConnectedPromptView.isHidden = false
                self.connectDeviceButton.setTitle("Connect Device", for: .normal)
            }
            self.present(deviceDisconnectedController, animated: true)
        }
    }
    
    @IBAction func onTapNotificationButton(_ sender: Any) {
        let notificationViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: NotificationViewController.self)) as! NotificationViewController
        notificationViewController.modalPresentationStyle = .fullScreen
        notificationViewController.onTapViewLocation = { deviceInfo in
            self.viewDeviceLocation(deviceInfo: deviceInfo)
        }
        notificationViewController.onTapConnectDevice = {
            self.connectToADevice()
        }
        self.present(notificationViewController, animated: true)
    }
    
    @IBAction func onTapSettingsButton(_ sender: Any) {
        let settingsPresenterViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SettingsPresenterViewController.self)) as! SettingsPresenterViewController
        self.present(settingsPresenterViewController, animated: true)
    }
    
    private func connectToADevice() {
        let controller = storyboard?.instantiateViewController(withIdentifier: String(describing: DiscoverDeviceViewController.self)) as! DiscoverDeviceViewController
        controller.onDeviceConnted = {
            let deviceConnectedController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: DeviceConnectedViewController.self)) as! DeviceConnectedViewController
            deviceConnectedController.modalPresentationStyle = .fullScreen
            deviceConnectedController.didTapTrackLocation = {
                self.startLocationTracking()
            }
            self.present(deviceConnectedController, animated: true)
        }
        self.present(controller, animated: true)
    }
    
    func startLocationTracking() {
        mapsViewContainer.isHidden = false
        ProgressLoader.sharedInstance.showAlert(viewController: self, alertMessage: "Loading Location.")
        deviceName.text = RangeFinderDeviceService.sharedInstance.getConnectedDevice()?.localName
        deviceNameContainer.isHidden = false
        deviceNotConnectedPromptView.isHidden = true
        connectDeviceButton.setTitle("Disconnect Device", for: .normal)
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func viewDeviceLocation(deviceInfo: DeviceInfoDTO) {
        mapsViewContainer.isHidden = false
        deviceNotConnectedPromptView.isHidden = true
        
        let locationData = CLLocationCoordinate2D(latitude: deviceInfo.deviceLatitude, longitude: deviceInfo.deviceLongitude)
        self.setupMapView(latitude: locationData.latitude, longitude: locationData.longitude, deviceName: deviceInfo.deviceName)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        ProgressLoader.sharedInstance.dismissAlert(viewController: self) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            RangeFinderDeviceService.sharedInstance.setDeviceLocation(location: locValue)
            self.setupMapView(latitude: locValue.latitude, longitude: locValue.longitude, deviceName: RangeFinderDeviceService.sharedInstance.getConnectedDevice()?.localName ?? "")
        }
    }
    
    func setupMapView(latitude: CLLocationDegrees, longitude: CLLocationDegrees, deviceName: String) {
        isDeviceConnected = true
        GMSServices.setMetalRendererEnabled(true)
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 25.0)
        let mapView = GMSMapView.map(withFrame: self.mapsViewContainer.bounds, camera: camera)
        mapView.bounds = self.mapsViewContainer.bounds
        self.mapsViewContainer.addSubview(mapView)
                
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = deviceName
        marker.icon = UIImage(named: "icDeviceLocation")
        marker.map = mapView
        
        let circleCenter : CLLocationCoordinate2D  = CLLocationCoordinate2DMake(latitude, longitude);
        let circ = GMSCircle(position: circleCenter, radius: 10.0)
        circ.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
        circ.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
        circ.strokeWidth = 2.5;
        circ.map = mapView
    }

}
