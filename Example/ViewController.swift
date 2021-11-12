//
//  ViewController.swift
//  Example
//
//  Created by Dawid Płatek on 30/10/2019.
//  Copyright © 2019 Inspace Labs. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func playSampleVideoButtonTapped(_ sender: Any) {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "mp4") else { return }
        
        showPlayerViewController(for: url)
    }
    
    @IBAction func addWatermarkButtonTapped(_ sender: Any) {
        guard let inputURL = Bundle.main.url(forResource: "sample", withExtension: "mp4") else { return }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("output-\(Int(Date().timeIntervalSince1970)).mp4")
        
        let processor = VideoOverlayProcessor(inputURL: inputURL, outputURL: outputURL)
        
        let videoSize = processor.videoSize
        let videoDuration = processor.videoDuration

        guard let image = UIImage(named: "overlay") else { return }
        let margin: CGFloat = 100
        let imageOverlay = ImageOverlay(image: image, frame: CGRect(x: videoSize.width-image.size.width-margin, y: videoSize.height-image.size.height/2-margin, width: image.size.width/2, height: image.size.height/2), delay: 0.0, duration: videoDuration)
        processor.addOverlay(imageOverlay)
        
        processor.process { [weak self] (exportSession) in
            guard let exportSession = exportSession else { return }
            
            if (exportSession.status == .completed) {
                DispatchQueue.main.async { [weak self] in
                    self?.showPlayerViewController(for: outputURL)
                }
            }
        }
    }
    
    var listText = ["BA/BS Degree in Computer Science or equivalent practical experiences;",
                    "3+ years programming experience in iOS, and less experienced candidates will be considered for junior roles;",
            "Proficient with debugging runtime issues and performance optimisations;",
            "Proficient with writing unit tests using XCTest framework;",
            "Experience with Git version control system;",
            "Familiar with continuous integration & deployment system (CI/CD).",
            "Deep understanding in various design patterns and architectures;",
            "Knowledge of 3D graphics in OpenGL or Metal;",
            "Know how to optimize code using various techniques;",
            "Familiar with the latest Apple technologies such as ARKit.",
            "Full stack skills (also know backend and web etc.);",
            "Know computer vision, data science, machine learning and natural language processing;",
            "Have personal projects at GitHub with 100+ stars;",
            "Experienced in coaching junior developers;",
            "Experienced in open source projects"]
    
    @IBAction func addSubtitlesButtonTapped(_ sender: Any) {
        guard let inputURL = Bundle.main.url(forResource: "sample", withExtension: "mp4") else { return }
        
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output-\(Int(Date().timeIntervalSince1970)).mp4")
        
        let processor = VideoOverlayProcessor(inputURL: inputURL, outputURL: outputURL)
        
        let videoSize = processor.videoSize
        let videoDuration = processor.videoDuration

        var startTime: Double = 0.0
        let durationTime: Double = videoDuration / Double(listText.count)
        let font = UIFont(name: "Pattaya-Regular", size: 30)
        
        for index in 0..<listText.count {
            let textOverlay = TextOverlay(text: listText[index], frame: CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height / 12), delay: startTime, duration: durationTime, backgroundColor: UIColor.black.withAlphaComponent(0.9), textColor: UIColor.white, font: font!)
            processor.addOverlay(textOverlay)
            
            startTime += durationTime
        }
        
        processor.process { [weak self] (exportSession) in
            guard let exportSession = exportSession else { return }
            
            if (exportSession.status == .completed) {
                DispatchQueue.main.async { [weak self] in
                    self?.showPlayerViewController(for: outputURL)
                    UISaveVideoAtPathToSavedPhotosAlbum(outputURL.path, self, nil, nil)
                }
            }
        }
    }
    
    private func showPlayerViewController(for url: URL) {
        let videoPlayer = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = videoPlayer
        
        present(playerViewController, animated: true) {
            if let player = playerViewController.player {
                player.play()
            }
        }
    }
}

