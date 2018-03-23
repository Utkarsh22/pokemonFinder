//
//  ViewController.swift
//  PokemonFinder
//
//  Created by Utkarsh Rastogi on 23/11/17.
//  Copyright © 2017 Utkarsh Rastogi. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    var resultString = ""
    var index=1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //pokeLBL.text = picker[row]
        index=row+1;
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pokePicker: UIPickerView!
    
    var picker=[String]()
        
    @IBAction func spotRandomPokemon(_ sender: Any) {
        
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let rand = index
        createSighting(ForLocation: loc, withPokemon: Int(rand))
        
    }
    func createSighting(ForLocation location:CLLocation, withPokemon pokeId:Int ){
        geoFire.setLocation(location, forKey: "\(pokeId)")
    }
    let locationManager = CLLocationManager()
    var mapHasCenterOnce = false
    var geoFire : GeoFire!
    var geoFireReference : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pokePicker.delegate=self
        self.pokePicker.dataSource=self
        picker=["bulbasaur",
                "ivysaur",
                "venusaur",
                "charmander",
                "charmeleon",
                "charizard",
                "squirtle",
                "wartortle",
                "blastoise",
                "caterpie",
                "metapod",
                "butterfree",
                "weedle",
                "kakuna",
                "beedri",
                "pidgey",
                "pidgeotto",
                "pidgeot",
                "rattata",
                "raticate",
                "spearow",
                "fearow",
                "ekans",
                "arbok",
                "pikachu",
                "raichu",
                "sandshrew",
                "sandslash",
                "nidoran-f",
                "nidorina",
                "nidoqueen",
                "nidoran-m",
                "nidorino",
                "nidoking",
                "clefairy",
                "clefable",
                "vulpix",
                "ninetales",
                "jigglypuff",
                "wigglytuff",
                "zubat",
                "golbat",
                "oddish",
                "gloom",
                "vileplume",
                "paras",
                "parasect",
                "venonat",
                "venomoth",
                "diglett",
                "dugtrio",
                "meowth",
                "persian",
                "psyduck",
                "golduck",
                "mankey",
                "primeape",
                "growlithe",
                "arcanine",
                "poliwag",
                "poliwhirl",
                "poliwrath",
                "abra",
                "kadabra",
                "alakazam",
                "machop",
                "machoke",
                "machamp",
                "bellsprout",
                "weepinbell",
                "victreebel",
                "tentacool",
                "tentacruel",
                "geodude",
                "graveler",
                "golem",
                "ponyta",
                "rapidash",
                "slowpoke",
                "slowbro",
                "magnemite",
                "magneton",
                "farfetchd",
                "doduo",
                "dodrio",
                "seel",
                "dewgong",
                "grimer",
                "muk",
                "shellder",
                "cloyster",
                "gastly",
                "haunter",
                "gengar",
                "onix",
                "drowzee",
                "hypno",
                "krabby",
                "kingler",
                "voltorb",
                "electrode",
                "exeggcute",
                "exeggutor",
                "cubone",
                "marowak",
                "hitmonlee",
                "hitmonchan",
                "lickitung",
                "koffing",
                "weezing",
                "rhyhorn",
                "rhydon",
                "chansey",
                "tangela",
                "kangaskhan",
                "horsea",
                "seadra",
                "goldeen",
                "seaking",
                "staryu",
                "starmie",
                "mr-mime",
                "scyther",
                "jynx",
                "electabuzz",
                "magmar",
                "pinsir",
                "tauros",
                "magikarp",
                "gyarados",
                "lapras",
                "ditto",
                "eevee",
                "vaporeon",
                "jolteon",
                "flareon",
                "porygon",
                "omanyte",
                "omastar",
                "kabuto",
                "kabutops",
                "aerodactyl",
                "snorlax",
                "articuno",
                "zapdos",
                "moltres",
                "dratini",
                "dragonair",
                "dragonite",
                "mewtwo",
                "mew"];
        
        
        mapView.delegate = self
        mapView.userTrackingMode=MKUserTrackingMode.follow
        geoFireReference=Database.database().reference()
        geoFire=GeoFire(firebaseRef: geoFireReference)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
        }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            mapView.showsUserLocation=true
        }
    }
    func centerMapOnLocation(loaction:CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(loaction.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location{
            if !mapHasCenterOnce{
                centerMapOnLocation(loaction: location)
                mapHasCenterOnce=true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView?
        let annoIdentifier = "Pokemon"
        if annotation.isKind(of: MKUserLocation.self){
            annotationView=MKAnnotationView(annotation: annotation, reuseIdentifier: "user")
            annotationView?.image=UIImage(named: "ash")
        }else if let deqAnno=mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier){
            annotationView = deqAnno
            annotationView?.annotation=annotation
        }else{
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView=av
        }
        
        if let annotationView = annotationView,let anno=annotation as?PokeAnnotation{
            annotationView.canShowCallout=true
            annotationView.image = UIImage(named: "\(anno.pokeId)")
            let btn=UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named:"map"), for: .normal)
            annotationView.rightCalloutAccessoryView=btn
        }
        return annotationView
        
    }
    
    func showSightingsOnMap(location:CLLocation) {
    let circleQuery = geoFire.query(at: location, withRadius: 2.5)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            if let key = key , let location = location{
                let Anno=PokeAnnotation(coordinate: location.coordinate, pokeId: Int(key)!)
                self.mapView.addAnnotation(Anno)
            }
            
        })
    }
    
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc=CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(location: loc)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? PokeAnnotation {
            
            var place: MKPlacemark!
            if #available(iOS 10.0, *) {
                place = MKPlacemark(coordinate: anno.coordinate)
            } else {
                place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            }
            let destination = MKMapItem(placemark: place)
            destination.name = "Pokemon Sighting"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey:  NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


