//
//  RecordViewController.swift
//  AVFoundation_Audio
//
//  Created by Tsar on 10.04.2021.
//

import UIKit
import AVFoundation

final class RecordViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemFill
        configureRecording()
    }
    
    private func configureRecording() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            guard let saferecordingSession = recordingSession else { return }
            try saferecordingSession.setCategory(.playAndRecord, mode: .default)
            try saferecordingSession.setActive(true)
            saferecordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        recordButton.isHidden = false
                        playButton.isHidden = false
                    } else {
                        recordButton.isHidden = true
                        playButton.isHidden = true
                        
                        let alertVC = UIAlertController(title: "Запись голоса невозможна", message: "Пожалуйста, предоставьте доступ, чтобы вы смогли записать голос", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Понятно", style: .default)
                        alertVC.addAction(action)
                        present(alertVC, animated: true)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func setupPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getRecordURL())
            guard let safeAudioPlayer = audioPlayer else { return }
            safeAudioPlayer.delegate = self
            safeAudioPlayer.prepareToPlay()
            safeAudioPlayer.play()
        }
        catch {
            let errorAC = UIAlertController(title: "Ошибка воспроизведения", message: "Пока что забейте", preferredStyle: .alert)
            errorAC.addAction(UIAlertAction(title: "Понятно", style: .default))
            present(errorAC, animated: true)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getRecordURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("record.m4a")
    }
    
    private func startRecording() {
        let audioFilename = getRecordURL()
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        recordButton.setTitle("Остановить", for: .normal)
        playButton.isHidden = true

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                guard let safeAudioRecorder = audioRecorder else { return }
                safeAudioRecorder.delegate = self
                safeAudioRecorder.record()
            } catch {
                finishRecording(success: false)
            }
    }
    
    private func finishRecording(success: Bool) {
        view.backgroundColor = UIColor.systemFill
        audioRecorder?.stop()
        audioRecorder = nil

        if success {
            recordButton.setTitle("Перезаписать голос", for: .normal)
            playButton.isHidden = false
        } else {
            recordButton.setTitle("Записать голос", for: .normal)
            playButton.isHidden = false
            
            let errorAC = UIAlertController(title: "Ошибка записи", message: "Проблема с записью вашего голоса", preferredStyle: .alert)
            errorAC.addAction(UIAlertAction(title: "Понятно", style: .default))
            present(errorAC, animated: true)
        }
    }
    
    private func finishedPlay() {
        audioPlayer = nil
        
        recordButton.isHidden = false
        playButton.setTitle("Воспроизвести", for: .normal)
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
       
    }
    
   
    @IBAction func playButtonTapped(_ sender: Any) {
        if audioPlayer == nil {
            recordButton.isHidden = true
            playButton.setTitle("Остановить", for: .normal)
            setupPlayer()
        } else {
            finishedPlay()
        }
    }

}

extension RecordViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

extension RecordViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            finishedPlay()
        }
    }
}
