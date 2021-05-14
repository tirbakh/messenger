//
//  ViewController.swift
//  messenger
//
//  Created by Лада Тирбах on 14.05.2021.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate, KeyphaseDetectorDelegate {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "rus-RU"))!
    private var keyphaseDetector: KeyphaseDetector!
    private var isRecording = false
    
    func errorOccured() {
        let oldText = textLabel.text
        textLabel.text = "Something went wrong!"
        stopKeyphaseDetector()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.textLabel.text = oldText
        }
    }
    
    func timerExpied() {
        let oldText = textLabel.text
        textLabel.text = "Timer expired!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.textLabel.text = oldText
        }
        
    }
    
    func keyphaseDetected(keyphase: Keyphase, args: [String]?) {
        let oldText = textLabel.text
        textLabel.text = "Keyphase detected!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.textLabel.text = oldText
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Configure the SFSpeechRecognizer object already
        // stored in a local member variable.
        speechRecognizer.delegate = self
        
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in

            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                    
                default:
                    self.recordButton.isEnabled = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyphaseDetector = KeyphaseDetector(speechRecognizer: speechRecognizer)
        keyphaseDetector.delegate = self
    }
    
    private func stopKeyphaseDetector() {
        isRecording = false
        recordButton.setTitle("Start listening", for: UIControl.State.normal)
        keyphaseDetector?.stop()
    }
    
    @IBAction func recordButtonDidPressed(_ sender: Any) {
        if !isRecording {
            do {
                try keyphaseDetector.start()
                isRecording = true
                textLabel.text = "Say \"Jarvis, test\"!"
                recordButton.setTitle("Stop listening", for: UIControl.State.normal)
            } catch {
                recordButton.isEnabled = false
                textLabel.text = "Sorry, it didn't work :("
            }
        } else {
            stopKeyphaseDetector()
        }
    }

}

