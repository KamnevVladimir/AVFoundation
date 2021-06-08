//
//  ViewController.swift
//  AVFoundation_Audio
//
//  Created by Niki Pavlove on 18.02.2021.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var audioProgressView: UIProgressView!
    private var player = AVAudioPlayer()
    private var currentTrack = 0
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        player.delegate = self
        setupPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    private func setupPlayer() {
        do {
            let audio = AudioModel.audios[currentTrack]
            authorLabel.text = "Автор: " + audio.author
            trackLabel.text = "Трек: " + audio.name
            
            guard let path = Bundle.main.path(forResource: audio.bundleName, ofType: audio.format) else { return }
            let url = URL(fileURLWithPath: path)
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        }
        catch {
            authorLabel.text = error.localizedDescription
        }
    }
    
    private func setupProgressView() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            let audioTime = self.player.duration
            let currentAudioTIme = self.player.currentTime
            self.audioProgressView.progress = Float(currentAudioTIme / audioTime)
        }
        timer.fire()
    }
    
    private func stopMusic() {
        if player.isPlaying {
            player.stop()
        }
        player.currentTime = 0
        timer.invalidate()
        audioProgressView.progress = 0
    }
    
    private func playMusic() {
        player.play()
        setupProgressView()
    }
    
    private func nextAudio() {
        currentTrack = (currentTrack + 1) % AudioModel.audios.count
        setupPlayer()
        playMusic()
    }
    
    private func previousAudio() {
        currentTrack = (currentTrack - 1) % AudioModel.audios.count
        setupPlayer()
        playMusic()
    }
    
    @IBAction func PlayButton(_ sender: Any) {
        playMusic()
    }
    
    @IBAction func StopButton(_ sender: Any) {
        stopMusic()
    }
    @IBAction func pauseButtonTapped(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            timer.invalidate()
        } else {
            print("Already paused")
        }
        
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        nextAudio()
    }
    @IBAction func previousButtonTapped(_ sender: Any) {
        previousAudio()
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            nextAudio()
        } else {
            print("Error")
        }
    }
}
