//
//  BookListenerViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/19/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import MediaPlayer

class BookListenerViewController: NBParentViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startFromLabel: UILabel!
    @IBOutlet weak var toEndLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var coverImageLink = ""
    var bookName = ""
    var link = ""
    
    var contentURL: URL?
    var readyToOpen = false
    var newAudioWillBeLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
        if newAudioWillBeLoaded {
            stopPlayer()
            audioPlayer = nil
            
            let urlString = coverImageLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            backgroundImage.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: #imageLiteral(resourceName: "notebook_place_holder"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            startupLogic()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    func startupLogic(){
        if !link.isEmpty{
            checkBookFileExists(withLink: link){ [weak self] downloadedURL in
                guard let self = self else{
                    return
                }
                self.readyToOpen = true
                self.contentURL = downloadedURL
                self.play(url: downloadedURL)
            }
        }else{
            showAlert(withTitle: "عفوا", andMessage: "حدث خطأ أثناء فتح الكتاب", completion: { action in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    

    func play(url: URL) {
        print("playing \(url)")
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            audioPlayer?.play()
            playButton.setImage(#imageLiteral(resourceName: "pause100Blue"), for: .normal)
            let percentage = (audioPlayer?.currentTime ?? 0)/(audioPlayer?.duration ?? 0)
            
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateAudioProgressBar), userInfo: nil, repeats: true)
                self.progressBar.setProgress(Float(percentage), animated: false)
            }
            
            setupCommandCenter(withDuration: percentage)
        
        } catch let error {
            audioPlayer = nil
            timer?.invalidate()
            playButton.setImage(#imageLiteral(resourceName: "playLight"), for: .normal)
            showAlert(withTitle: "خطأ", andMessage: error.localizedDescription)
        }
    }
    
    private func setupCommandCenter(withDuration duration: Double) {
        guard audioPlayer != nil else {return}
        
        var items = [String: Any]()
        items[MPMediaItemPropertyTitle] = "Notebook"
        items[MPMediaItemPropertyAlbumTitle] = bookName
        //items[MPMediaItemPropertyArtist] = "artist name."
        items[MPMediaItemPropertyPlaybackDuration] = audioPlayer?.duration ?? 0
        if let urlString = coverImageLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            items[MPMediaItemPropertyAssetURL] = urlString
        }
        
        let elapsedPlaybackTime = CMTimeGetSeconds(CMTime(seconds: audioPlayer!.currentTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        items[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedPlaybackTime
        items[MPNowPlayingInfoPropertyPlaybackRate] = 1
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = items
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            print("nextTrackCommand clicked")
            self?.handleNextLogic()
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            print("previousTrackCommand clicked")
            self?.handlePreviousLogic()
            return .success
        }
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.togglePlayPauseButton()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.togglePlayPauseButton()
            return .success
        }
        
        handleChangingInPlaybackPositionCommand(with: commandCenter)
    }
    
/*https://medium.com/@varundudeja/showing-media-player-system-controls-on-notification-screen-in-ios-swift-4e27fbf73575 */
    // Handle remote events
    func handleChangingInPlaybackPositionCommand(with commandCenter: MPRemoteCommandCenter ) {
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            print(event.timestamp)
            if let remoteEvent = event as? MPChangePlaybackPositionCommandEvent {
                print(remoteEvent.positionTime)
                
                if (self?.audioPlayer?.isPlaying ?? false) {
                    self?.audioPlayer?.stop()
                }
                    
                self?.audioPlayer?.currentTime = remoteEvent.positionTime
                self?.audioPlayer?.play()
                
                let percentage = (self?.audioPlayer?.currentTime ?? 0)/(self?.audioPlayer?.duration ?? 0)
                self?.progressBar.setProgress(Float(percentage), animated: false)
            }
            return .success
        }
    }
    
    
    @objc func updateAudioProgressBar()
    {
        if audioPlayer?.isPlaying ?? false {
            let percentage = (audioPlayer?.currentTime ?? 0)/(audioPlayer?.duration ?? 0)
            progressBar.setProgress(Float(percentage), animated: true)
            let startFromInteger = Int(audioPlayer?.currentTime ?? 0)
            let untilEndInteger = Int((audioPlayer?.duration ?? 0) - (audioPlayer?.currentTime ?? 0))
            let startTime = convertToTimeFormat(seconds: startFromInteger)
            let endTime = convertToTimeFormat(seconds: untilEndInteger)
            startFromLabel.text = "\(startTime.minutes):\(startTime.seconds)"
            toEndLabel.text = "\(endTime.minutes):\(endTime.seconds)"
        }
    }
    
    func convertToTimeFormat(seconds: Int) -> (minutes: Int, seconds: Int){
        var results = (0, seconds)
        while results.1 > 59 {
            results.0 = results.1 / 60
            results.1 = results.1 % 60
        }
        return results
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        togglePlayPauseButton()
    }
    
    private func togglePlayPauseButton(){
        if !(audioPlayer?.isPlaying ?? false){
            playButton.setImage(#imageLiteral(resourceName: "pause100Blue"), for: .normal)
            
            audioPlayer?.play()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressBar), userInfo: nil, repeats: true)
            updatePlaybackRate(with: 1)
        }else{
            playButton.setImage(#imageLiteral(resourceName: "playLight"), for: .normal)
            audioPlayer?.pause()
            timer?.invalidate()
            updatePlaybackRate(with: 0)
        }
    }
    
    private func updatePlaybackRate(with value: Int){
        setCurrentTimeToCommandCenter()
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = value
    }
    
    func setCurrentTimeToCommandCenter(){
        guard let currentTime = audioPlayer?.currentTime else {return}
        let scale = CMTimeScale(NSEC_PER_SEC)
        let cmTime = CMTime(seconds: currentTime, preferredTimescale: scale)
        let elapsedPlaybackTime = CMTimeGetSeconds(cmTime)
        let center = MPNowPlayingInfoCenter.default()
        center.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedPlaybackTime
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        handleNextLogic()
    }
    
    private func handleNextLogic(){
        var time: TimeInterval = audioPlayer?.currentTime ?? 0
        time += 5.0 // Go forward by 5 seconds
        if time > (audioPlayer?.duration ?? 0) {
            stopPlayer()
        }else{
            audioPlayer?.currentTime = time
            setCurrentTimeToCommandCenter()
        }
    }
    
    @IBAction func previouseButtonClicked(_ sender: UIButton) {
        handlePreviousLogic()
    }
    
    private func handlePreviousLogic(){
        var time: TimeInterval = audioPlayer?.currentTime ?? 0
        time -= 5.0 // Go back by 5 seconds
        if time < 0 {
            stopPlayer()
        }else {
            audioPlayer?.currentTime = time
            setCurrentTimeToCommandCenter()
        }
    }
    
    func stopPlayer(){
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        progressBar.progress = 0.0
        timer?.invalidate()
        timer = nil
        startFromLabel.text = "0:0"
        toEndLabel.text = "0:0"
        
        audioIsFinished()
    }
}

extension BookListenerViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioIsFinished()
    }
    
    func audioIsFinished(){
        playButton.setImage(#imageLiteral(resourceName: "playLight"), for: .normal)
        progressBar.setProgress(0, animated: true)
        
        // Finish the audio for the MPRemoteCommandCenter
        let scale = CMTimeScale(NSEC_PER_SEC)
        let cmTime = CMTime(seconds: 0, preferredTimescale: scale)
        let elapsedPlaybackTime = CMTimeGetSeconds(cmTime)
        let center = MPNowPlayingInfoCenter.default()
        center.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedPlaybackTime
    }
}
