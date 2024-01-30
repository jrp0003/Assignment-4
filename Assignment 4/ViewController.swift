//
//  ViewController.swift
//  Assignment 4
//
//  Created by Owner on 1/29/24.
//
import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var startButton: UIButton!

    var timer: Timer?
    var remainingTime: TimeInterval = 0
    var audioPlayer: AVAudioPlayer?
    var isMusicPlaying: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        updateClock()

        // Start a timer to update the clock periodically
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)

        Timer.scheduledTimer(timeInterval: 60 * 15, target: self, selector: #selector(updateBackgroundImage), userInfo: nil, repeats: true)

        // Customize date picker appearance
        datePicker.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        datePicker.setValue(UIColor.white, forKey: "textColor")

        // Set initial background image based on current time
        updateBackgroundImage()
        }

    @objc func updateClock() {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
           label1.text = dateFormatter.string(from: Date())

           // Change background image based on AM/PM
           updateBackgroundImage()
       }

    @objc func updateBackgroundImage() {
           let currentDateTime = Date()
           let isPM = Calendar.current.component(.hour, from: currentDateTime) >= 12
           backgroundImage.image = isPM ? UIImage(named: "Image") : UIImage(named: "Image 1")
       }

       @IBAction func startButtonTapped(_ sender: UIButton) {
           if timer == nil {
               if isMusicPlaying {
                   stopMusic()
                   startButton.setTitle("Start Timer", for: .normal)
               } else {
                   startTimer()
                   startButton.setTitle("Stop Timer", for: .normal)
               }
           } else {
               stopTimer()
           }
       }

       func startTimer() {
           let selectedTime = datePicker.countDownDuration
           remainingTime = selectedTime

           timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
       }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        startButton.setTitle("Start Timer", for: .normal)
    }


       @objc func updateTimer() {
           if remainingTime > 0 {
               remainingTime -= 1
               updateLabel2()
           } else {
               stopTimer()
               playMusic()
               startButton.setTitle("Stop Music", for: .normal)
           }
       }

       func updateLabel2() {
           let hours = Int(remainingTime) / 3600
           let minutes = (Int(remainingTime) % 3600) / 60
           let seconds = Int(remainingTime) % 60

           label2.text = "Time Remaining: " + String(format: "%02d:%02d:%02d", hours, minutes, seconds)
       }

       func playMusic() {
           guard let url = Bundle.main.url(forResource: "song", withExtension: "mp3") else {
               print("Error: Could not find the audio file.")
               return
           }

           do {
               audioPlayer = try AVAudioPlayer(contentsOf: url)
               audioPlayer?.delegate = self
               audioPlayer?.prepareToPlay()
               audioPlayer?.play()
               isMusicPlaying = true
           } catch {
               print("Error playing music: \(error.localizedDescription)")
           }
       }

       func stopMusic() {
           if let player = audioPlayer, player.isPlaying {
               player.stop()
               isMusicPlaying = false
           }
       }

       @IBAction func stopMusicButtonTapped(_ sender: UIButton) {
           stopMusic()
           startButton.setTitle("Start Timer", for: .normal)
       }

       // AVAudioPlayerDelegate method
       func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
           startButton.isEnabled = true  // Enable the button after the music finishes
       }
   }
