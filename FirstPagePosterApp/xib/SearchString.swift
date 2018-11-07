//
//  SearchStringView.swift
//  FirstPagePosterApp
//
//  Created by Igor on 10.08.2018.
//  Copyright © 2018 Gargolye. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

protocol SearchStringViewDelegate: class {
    func presentedCameraViewController()
    func updateCollectionView()
    func sendMessange(messange: String)
}

class SearchStringView: UIView {
    
    @IBOutlet weak var searchString: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    
    weak var delegate: SearchStringViewDelegate?
    
    @IBAction func tuppedCameraButton(_ sender: UIButton) {
        delegate?.presentedCameraViewController()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        searchString.delegate = self
    }
    
    func findFilmInLib() {
        FilmLibrary.searchResults.removeAll()
        
        if searchString.text != nil && (searchString.text?.count)! > 0 {
             if let findFilmName =  self.searchString.text?.lowercased(), FilmLibrary.data[findFilmName] != nil {
                FilmLibrary.searchResults.append(findFilmName)
             } else {
                for i in Array(FilmLibrary.data.keys) {
                    if let ganre = FilmLibrary.data[i]?["genre"] as? String, var findGanre = self.searchString.text?.lowercased() {
                        findGanre = findGanre.trimmingCharacters(in: .whitespaces)
                        if  findGanre.searchString(inLine: ganre, searchString: findGanre) {
                            FilmLibrary.searchResults.append(i)
                        }
                    }
                }
                if FilmLibrary.searchResults.count == 0 {
                    self.delegate?.sendMessange(messange: "Unfortunately in our database there is no suitable movie")
                }
            }
            self.delegate?.updateCollectionView()
        }
    }
}

extension SearchStringView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        findFilmInLib()
        return true;
    }
}
