//
//  LearnMoreViewController.swift
//  FirstPagePosterApp
//
//  Created by Igor on 9/24/18.
//  Copyright © 2018 Gargolye. All rights reserved.
//

import UIKit

class LearnMoreViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var premiereLabel: UILabel!
    @IBOutlet weak var trailerForFilmWebView: UIWebView!
    @IBOutlet weak var filmDiscriptionTexView: UITextView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var ageLimitLabel: UILabel!
    @IBOutlet weak var activityIndekaator: UIActivityIndicatorView!
    
    //takes the name of the movie from the cell of the result of the movie search,
    //on which they clicked the button to learn more
    var names = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUP.direction = .right
        self.view.addGestureRecognizer(swipeUP)
        
        trailerForFilmWebView.delegate = self
        
        filmNameLabel.text = names
        filmNameLabel.sizeToFit()
        posterImageView.image = UIImage(named: "c\(names)")
        
        if let dataPremiereDay = FilmLibrary.data["\(names.lowercased())"]?["releaseDate"] {
            premiereLabel.text = "Premiere: \(dataPremiereDay)"
        }
        if let  age = FilmLibrary.data["\(names.lowercased())"]?["ageLimit"] {
            let normalNameString = NSMutableAttributedString.init(string: "")
            
            let attachment = NSTextAttachment()
            attachment.image = pgImage(textValue: "\(age)+")
            attachment.bounds = CGRect(x: 0, y: 0, width: (attachment.image?.size.width)!, height: (attachment.image?.size.height)!)
            normalNameString.append(NSAttributedString(attachment: attachment))
            
            ageLimitLabel.attributedText = normalNameString
        }
        if let duration = FilmLibrary.data["\(names.lowercased())"]?["duration"] {
            durationLabel.text = "Duration: \(duration)min"
        }
        if let duscription = FilmLibrary.data["\(names.lowercased())"]?["description"] {
            filmDiscriptionTexView.text = "\(duscription)"
        }
        if let url = FilmLibrary.data["\(names.lowercased())"]?["movieURL"] {
            getVideo(videoCode: "\(url)")
        }
        createShape()
    }
    
    @objc
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            let transition: CATransition = CATransition()
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromBottom
            self.view.window!.layer.add(transition, forKey: nil)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func pgImage(textValue :String) -> UIImage {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.lineBreakMode = .byClipping
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 2
        label.text = textValue
        label.sizeToFit()
        label.bounds = CGRect(x: 0, y: 0, width: label.bounds.size.width + 35, height: label.bounds.size.height + 35)
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, UIScreen.main.scale)
        label.layer.allowsEdgeAntialiasing = true
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    private func getVideo(videoCode: String) {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        trailerForFilmWebView.loadRequest(URLRequest(url: url!))
    }
    
    private func createShape() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.posterImageView.frame.size.width, y: 0))
        path.addLine(to: CGPoint(x: self.posterImageView.frame.size.height, y: self.posterImageView.frame.size.width))
        path.addLine(to: CGPoint(x: 0, y: self.posterImageView.frame.size.width - 100 ))
        path.close()
        
        let mask = CAShapeLayer();
        mask.frame = self.posterImageView.bounds;
        mask.path = path.cgPath;
        self.posterImageView.layer.mask = mask;
    }
}

extension LearnMoreViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndekaator.isHidden = false
        activityIndekaator.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndekaator.isHidden = true
        activityIndekaator.stopAnimating()
    }
}
