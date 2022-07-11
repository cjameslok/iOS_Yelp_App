//
//  BusinessDetailsViewViewController.swift
//  YelpApp
//
//  Created by Bell on 2022-06-30.
//

import UIKit
import MapKit

class BusinessDetailsViewController: UIViewController, UINavigationControllerDelegate {
    
    var business: Business?
    var displayImages: [UIImage] = []
    var displayImageIndex: Int = 0
    weak var selectedImage: UIImage?
    var annotationView: MKAnnotationView?
    var annotation: BusinessMapAnnotation?
    var presenter: BusinessDetailsPresenter!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var address3Label: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    init(business: Business) {
        super.init(nibName: nil, bundle: nil)
        self.business = business
        let presenter = BusinessDetailsPresenter(view: self)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        resetLabels()
        setupInfo()
        setUpMap()
        retrieveExistingImages()
        
    }
    
    func setupNavBar() {
        navigationItem.title = business?.name
        
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Open camera roll", image: UIImage(systemName: "photo"))
                {(_) in self.onCameraButtonClick()},
                UIAction(title: "Take a picture", image: UIImage(systemName: "camera"))
                {(_) in self.onCameraButtonClick()}
            ]
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "plus"), primaryAction: nil, menu: UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems))
    }
    
    func setupInfo() {
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = 0.7
        infoView.layer.shadowOffset = .zero
        infoView.layer.shadowRadius = 10
        infoView.layer.cornerRadius = 10
        
        
        if let displayImageUrl = business!.image_url {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf: URL(string: displayImageUrl)!)
                {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.displayImages.append(image)
                            self.displayImages.append(UIImage(imageLiteralResourceName: "sample-food"))
                        }
                    }
                }
            }
        }
        
        
        
        
        let count: Int = business!.location!.display_address!.count
        if count > 0 {
            if let a1 = business!.location?.display_address?[0] {
                address1Label.text = a1
            } else {
                address1Label.text = ""
            }
            if count >= 2 {
                
                if let a2 = business!.location?.display_address?[1] {
                    address2Label.text = a2
                } else {
                    address2Label.text = ""
                }
                
                if count == 3 {
                    if business!.location?.display_address?.count == 3, let a3 = business!.location?.display_address?[2] {
                        address3Label.text = a3
                    } else {
                        address3Label.text = ""
                    }
                }
            }
        }
        
        if let p = business!.display_phone {
            phoneLabel.text = p
        } else {
            phoneLabel.text = ""
            return
        }
        
    }
    
    private func setUpMap() {
        mapView.delegate = self
        let annotation = BusinessMapAnnotation(business: self.business)
        let rect = centerToLocation(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
        mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 200.0, left: 0.0, bottom: 0.0, right: 0.0), animated: true)
        mapView.addAnnotation(annotation)
        self.annotation = annotation
        
    }
    
    private func resetLabels() {
        phoneLabel.text = ""
        address1Label.text = ""
        address2Label.text = ""
        address3Label.text = ""
    }
    
    private func retrieveExistingImages() {
        let images = presenter.retrieveAllImages(folderName: business!.alias)
        if !images.isEmpty{
            displayImages.append(contentsOf: images)
        }
        
    }
    
    @IBAction func onCarButtonClick(_ sender: Any) {
        guard let a = self.annotation else { return }
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
          ]
        a.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
    @IBAction func onPhoneButtonClick(_ sender: Any) {
    }
    
    private func onCameraButtonClick(){
        print("clicked")
        openPhotoLibraryButton()
        guard let image = selectedImage else {return}
        presenter.store(image: image, key: business!.alias, storageType: .fileSystem)

    }
    
}

extension BusinessDetailsViewController: UIImagePickerControllerDelegate {
    
    func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        self.selectedImage = image
        presenter.store(image: image, key: business!.alias, storageType: .fileSystem)
        displayImages.append(image)
        dismiss(animated:true, completion: nil)
    }
    
}

extension BusinessDetailsViewController: MKMapViewDelegate {
    
    func mapView( _ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? BusinessMapAnnotation else {
            return nil
        }
        
        let identifier = "business"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            
        }

        return view
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if !displayImages.isEmpty {
            //            view.detailCalloutAccessoryView = UIImageView(image: presenter.resizeImage(image: displayImages[displayImageIndex], targetSize: CGSize(width: 300, height: 200)))
//            view.rightCalloutAccessoryView = (UIButton(type: .detailDisclosure))
            view.detailCalloutAccessoryView = UIImageView(image: presenter.resizeImage(image: displayImages[displayImageIndex], targetSize: CGSize(width: 300, height: 200)))
            
            self.annotationView = view
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:_:)))
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:_:)))
            leftSwipe.direction = .left
            rightSwipe.direction = .right
            view.addGestureRecognizer(leftSwipe)
            view.addGestureRecognizer(rightSwipe)
            
//            mapView.centerToLocation(CLLocation(latitude: self.annotation!.coordinate.latitude, longitude: self.annotation!.coordinate.longitude))
//
//            let coordinate = self.annotation!.coordinate
//            let delta = CLLocationDegrees(0.003)
//            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
//            let region = MKCoordinateRegion(center: coordinate, span: span)
            let rect = centerToLocation(CLLocation(latitude: self.annotation!.coordinate.latitude, longitude: self.annotation!.coordinate.longitude))
            let insets = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
            mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
            setMapFreeze(true)
            
        }
    }
    
       // Convert CoordinateRegion to MapRect
      func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))

          let a = MKMapPoint(topLeft)
          let b = MKMapPoint(bottomRight)

        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
      }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        setMapFreeze(false)
    }
    
    
    
    @IBAction func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer, _ view: MKAnnotationView) {
        if gestureRecognizer.state == .ended {
            switch gestureRecognizer.direction {
            case .left:
                if displayImages.count == 1 {
                    return
                }
                else if displayImageIndex < displayImages.count-1 {
                    displayImageIndex += 1
                } else if displayImageIndex == displayImages.count-1 {
                    displayImageIndex = 0
                }
            case .right:
                if displayImages.count == 1 {
                    return
                }
                else if displayImageIndex == 0 {
                    displayImageIndex = displayImages.count-1
                }
                else if displayImageIndex <= displayImages.count-1 {
                    displayImageIndex -= 1
                }
            default:
                return
            }
            
            print("swipe")
            self.annotationView?.detailCalloutAccessoryView = UIImageView(image: presenter.resizeImage(image: displayImages[displayImageIndex], targetSize: CGSize(width: 300, height: 200)))
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        print("callout pressed")

        
        
    }
    
    func setMapFreeze(_ isFrozen: Bool){
        mapView.isZoomEnabled = !isFrozen
        mapView.isPitchEnabled = !isFrozen
        mapView.isRotateEnabled = !isFrozen
        mapView.isScrollEnabled = !isFrozen
    }
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) -> MKMapRect {
        
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
//        setRegion(coordinateRegion, animated: true)
        
        let topLeft = CLLocationCoordinate2D(latitude: coordinateRegion.center.latitude + (coordinateRegion.span.latitudeDelta/2), longitude: coordinateRegion.center.longitude - (coordinateRegion.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: coordinateRegion.center.latitude - (coordinateRegion.span.latitudeDelta/2), longitude: coordinateRegion.center.longitude + (coordinateRegion.span.longitudeDelta/2))

          let a = MKMapPoint(topLeft)
          let b = MKMapPoint(bottomRight)
        

        let rect = MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
        
        return rect
    
}


//private extension MKMapView{
//    
//    
//
//        
//    }
    
}

