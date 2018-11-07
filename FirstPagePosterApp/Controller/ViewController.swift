//
//  ViewController.swift
//  FirstPagePosterApp
//
//  Created by Igor on 06.08.2018.
//  Copyright © 2018 Gargolye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore

class ViewController: UIViewController {
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet weak var сalendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var databaseRefer: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    private func addingDataToDatabase() {
        //Create Record into Firebase

        let films = [
            "what men want" :
                [
                    "FilmName": "What Men Want",
                    "ageLimit": "18",
                    "country": "USA",
                    "description": "A woman is boxed out by the male sports agents in her profession, but gains an unexpected edge over them when she develops the ability to hear their thoughts.",
                    "duration": "140",
                    "genre": "comedy , fantasy , romance",
                    "movieURL": "BzQjM9bmOOg",
                    "releaseDate": "08/02/19",
                    "stars": "Taraji P. Henson, Wendi McLendon-Covey, Pete Davidson"
               ]
        ]
    
        databaseRefer = Database.database().reference()
        for (nameFilmKey, mainInfo) in films {
            self.databaseRefer.child("\(nameFilmKey.lowercased())").setValue([
                "FilmName" : "\(mainInfo["FilmName"]!)",
                "ageLimit": "\(mainInfo["ageLimit"]!)",
                "country": "\(mainInfo["country"]!)",
                "description": "\(mainInfo["description"]!)",
                "duration": "\(mainInfo["duration"]!)",
                "genre": "\(mainInfo["genre"]!)",
                "movieURL": "\(mainInfo["movieURL"]!)",
                "releaseDate": "\(mainInfo["releaseDate"]!)",
                "stars":  "\(mainInfo["stars"]!)"])
        }
        print("load data's is Ok")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Writing data to the database
        DispatchQueue.global(qos: .background).async {
            self.addingDataToDatabase()
        }
        
        сalendar.delegate = self
        сalendar.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: self.view.frame.size.width * 0.10, height: self.view.frame.size.height * 0.05)//0.045 - not bead
        
        flowLayout.minimumInteritemSpacing = 6//4 oldValue
        flowLayout.minimumLineSpacing = 0
        сalendar.collectionViewLayout = flowLayout
        
        currentMonth = Months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        monthLabel.textAlignment = .center

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        if weekday == 0 {
            weekday = 7
        }
        
        getStartDateOfDayPosition()
        
        if let customView = Bundle.main.loadNibNamed("SearchString", owner: self, options: nil)?.first as? SearchStringView {
            customView.delegate = self
            //customView.delegateAlertMessange = self
            view.addSubview(customView)
            setupLayout(customView: customView)
        }
        
        Database.database().reference().observe(.value) { [weak self] (snapshot) in
            guard let value = snapshot.value, snapshot.exists()  else {
                print("Error with geting data")
                return
            }
            FilmLibrary.data = value as! [String : [String : Any]]
            self?.сalendar.reloadData()
        }
    }

    
    @objc
    private func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        let mySensitiveArea = CGRect(x: 0, y: 60, width: 315, height: 231.5)
        let p = gesture.location(in: self.view)
        if mySensitiveArea.contains(p) {
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                previousMonth()
            case UISwipeGestureRecognizerDirection.left:
                nextMonth()
            default:
                print("Other swipe")
            }
        }
    }
    
    private func nextMonth() {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            direction = 1
            
            if (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) {
                DaysInMonths[1] = 29
            } else {
                DaysInMonths[1] = 28
            }
            
            getStartDateOfDayPosition()
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            сalendar.reloadData()
            monthLabel.sizeToFit()
            collectionView.reloadData()
        default:
            direction = 1
            getStartDateOfDayPosition()
            month += 1
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            сalendar.reloadData()
            monthLabel.sizeToFit()
            collectionView.reloadData()
        }
    }
   
    private func previousMonth() {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            direction = -1
            
            if (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) {
                DaysInMonths[1] = 29
            } else {
                DaysInMonths[1] = 28
            }
            
            getStartDateOfDayPosition()
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            monthLabel.sizeToFit()
            сalendar.reloadData()
        default:
            month -= 1
            direction = -1
            getStartDateOfDayPosition()
            currentMonth = Months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            monthLabel.sizeToFit()
            сalendar.reloadData()
        }
    }
   
    @IBAction func Next(_ sender: UIButton) {
        nextMonth()
    }

    @IBAction func Back(_ sender: UIButton) {
        previousMonth()
    }

    @IBAction func Tupped(_ sender: UIButton) {
        let nameMonths = ["January": "01", "February": "02", "March": "03", "April": "04", "May": "05", "June": "06", "July": "07","August": "08", "September": "09", "October": "10", "November": "11", "December":"12"]
        
        FilmLibrary.searchResults.removeAll()
        
        let day = Array("\(monthLabel.text!)")
        let monh = String(day[0...day.count - 6])
        let year = String(day[day.count - 2...day.count - 1])
        
        var days = sender.currentTitle!
        //if the number in the calendar is less than ten then add a zero before the number
        if let d = Int(days), d < 10 {
            days = "0\(days)"
        }
        
        if let monhts = nameMonths[monh] {
            let pressday = "\(days)" + "/" + "\(monhts)" + "/" + "\(year)"
            for value in FilmLibrary.data.keys {
                if pressday == FilmLibrary.data[value]?["releaseDate"] as? String {
                    FilmLibrary.searchResults.append(value)
                } else {
                    messageLabel.text = "There are no premieres on this day =("
                }
            }
            collectionView.reloadData()
        }
    }
    
    // this functions gives us the number of empty boxes
    private func getStartDateOfDayPosition() {
        switch direction {
        case 0:                         //if we are at the current month
            numerOfEmptyBox = weekday
            dayCounter = day
            
            while dayCounter > 0 {
                numerOfEmptyBox -= 1
                dayCounter -= 1
                if numerOfEmptyBox == 0 {
                    numerOfEmptyBox = 7
                }
            }
            if numerOfEmptyBox == 7 {
                numerOfEmptyBox = 0
            }
            positionINdex = numerOfEmptyBox
        case 1...:                      //if we are at a future  month
            nextNumerOfEmptyBox = (positionINdex + DaysInMonths[month]) % 7
            positionINdex = nextNumerOfEmptyBox
        case -1:                        // if we are at  a past month
            previousNumberOfEmptyBox = (7 - (DaysInMonths[month] - positionINdex) % 7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionINdex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    private func allPremieresData() -> [String] {
        //This method is needed to convert data from 10/08/19 format -> 01January 2018
        var nameMonths = ["01": "January", "02": "February", "03": "March", "04": "April", "05": "May", "06": "June","07": "July","08": "August","09": "September","10": "October","11": "November","12": "December"]
        
        let allKeyNameFilm = FilmLibrary.data.keys
        var arrayDateRelease = [String]()
        for i in allKeyNameFilm {
            if let allRelizData = FilmLibrary.data[i]?["releaseDate"] as? String {
                var relizData = Array(allRelizData)
                let monthReleseDay = "\(relizData[3])" + "\(relizData[4])"
                for j in nameMonths.keys {
                    if monthReleseDay == j {
                        let firstTwoNumber = Int((String(relizData[0]) + String(relizData[1])))
                        if let number = firstTwoNumber, number > 9 {
                            arrayDateRelease.append(String(relizData[0]) + String(relizData[1]) + nameMonths[j]! + " 20" + String(relizData[6]) + String(relizData[7]))
                        } else {
                            arrayDateRelease.append(String(String(relizData[1]) + nameMonths[j]! + " 20" + String(relizData[6]) + String(relizData[7])))
                        }
                    }
                }
            }
        }
        return arrayDateRelease
    }
   
    private func setupLayout(customView: SearchStringView) {
        customView.searchString.placeholder = "Enter film name or gander"
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addConstraint(NSLayoutConstraint(item: customView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 30))
    }
    
    public func showAlertButtonTapped(string: String) {
        // create the alert
        let alert = UIAlertController(title: "Error", message: string, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int ) -> Int {
        if collectionView == self.сalendar {
            switch direction {          //it return the number of days in the minth + the number of "empty boxes" based on the drection we are going
            case 0:
                return DaysInMonths[month] + numerOfEmptyBox
            case 1...:
                return DaysInMonths[month] + nextNumerOfEmptyBox
            case -1:
                return DaysInMonths[month] + previousNumberOfEmptyBox
            default:
                fatalError()
            }
        } else {
            if FilmLibrary.searchResults.count != 0 {
                messageLabel.alpha = 0
            } else {
                messageLabel.alpha = 1
            }
            return FilmLibrary.searchResults.count
        }
    
    }
    
    //создаем ячейку где указываем все ее характеристики, значение ячейки береться из этого метода.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.сalendar {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! DateCollectionViewCell
            if cell.isHidden {
                cell.isHidden = false
            }
            
            switch direction {          //it return the number of days in the minth + the number of "empty boxes" based on the drection we are going
            case 0:
                cell.DateLabel.setTitle("\(indexPath.row + 1 - numerOfEmptyBox)", for: .normal)
            case 1...:
                cell.DateLabel.setTitle("\(indexPath.row + 1 - nextNumerOfEmptyBox)", for: .normal)
            case -1:
                cell.DateLabel.setTitle("\(indexPath.row + 1 - previousNumberOfEmptyBox)", for: .normal)
            default:
                fatalError()
            }
            if Int((cell.DateLabel.currentTitle)!)! < 1 { // hids every cell that is smaller then 1
                cell.isHidden = true
            }
            cell.DateLabel.setBackgroundImage(nil, for: .normal)
            let allPremieres = allPremieresData()
            for value in allPremieres {
                let tempData = "\(cell.DateLabel.currentTitle!)" + "\(monthLabel.text!)"
                if value == tempData {
                    let image = UIImage(named: "playButton")
                    cell.DateLabel.setBackgroundImage(image, for: .normal)
                }
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CellSearchResults
            if let custom = Bundle.main.loadNibNamed("FilmCollectionViewCell", owner: self, options: nil)?.first as? FilmCollectionViewCell {
                
                custom.delegat = self // Set the Delagate to go to learnMore button
                
                for i in 0..<collectionView.numberOfSections {
                    for _ in 0..<collectionView.numberOfItems(inSection: i) {
                        custom.filmNameLabel.text = ("\(indexPath.row)")
                        let row = FilmLibrary.searchResults[indexPath.row]
                        custom.filmNameLabel.text = (FilmLibrary.data[row]?["FilmName"] as! String)
                        custom.filmNameLabel.sizeToFit()
                        custom.releaseDateLabell.text = (FilmLibrary.data[row]?["releaseDate"] as! String)
                        if let imageName = FilmLibrary.data[row]?["FilmName"] as? String {
                            custom.posterImageViwe.image = UIImage(named: "c\(imageName.lowercased())")
                        }
                    }
                }
                cell.addSubview(custom)
                return cell
            }
            return cell
        }
    }
}

extension ViewController: SearchStringViewDelegate {
    func presentedCameraViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "CameraViewControllerID") as? CameraViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    func sendMessange(messange: String) {
        // create the alert
        let alert = UIAlertController(title: "Bad new's", message: messange, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    func updateCollectionView() {
        self.collectionView.reloadData()
    }
}

extension ViewController: MyCellDelegate {
    func cellWasPressed(film: String?, image: UIImage?, premiere: String? ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "LearnMoreViewControllerID") as? LearnMoreViewController {
            if film != nil, premiere != nil {
                vc.names = film!.lowercased()
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
