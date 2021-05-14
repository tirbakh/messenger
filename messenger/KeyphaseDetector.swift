//
//  KeyphaseDetector.swift
//  messenger
//
//  Created by Лада Тирбах on 14.05.2021.
//

import Foundation
import Porcupine
import Speech

enum Keyphase {
    case test
}

protocol KeyphaseDetectorDelegate {
    func errorOccured()
    func timerExpied()
    func keyphaseDetected(keyphase: Keyphase, args: [String]?)
}

class KeyphaseDetector {
    private var porcupineManager: PorcupineManager!
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer!
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var isRecognitionStarted = false
    private let bus = 0
    
    var delegate: KeyphaseDetectorDelegate?
    
    init(speechRecognizer: SFSpeechRecognizer) {
        self.speechRecognizer = speechRecognizer
    }
    
    private func startEngine() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: bus)
        inputNode.installTap(onBus: bus, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }


        audioEngine.prepare()
        try audioEngine.start()
    }
    
    private func startRecognition() throws {
        guard !isRecognitionStarted else {
            return
        }
        
        isRecognitionStarted = true
        print("keyword detected!")
        recognitionRequest?.endAudio()
        
        recognitionTask?.cancel()
        self.recognitionTask = nil
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            guard self.isRecognitionStarted else {
                return
            }
            
            if let result = result {
                // Update the text view with the results.
                isFinal = result.isFinal
                let transcript = result.bestTranscription.formattedString
                print("Text \(transcript)")
                if transcript.lowercased().contains("тест") {
                    print("keyphase detected!")
                    self.stopRecognition()
                    DispatchQueue.main.async {
                        self.delegate?.keyphaseDetected(keyphase: .test, args: nil)
                    }
                }
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.stopRecognition()
                DispatchQueue.main.async {
                    self.delegate?.errorOccured()
                }
            }
        }
    }
    
    private func stopRecognition() {
        guard self.isRecognitionStarted else {
            return
        }
        
        recognitionRequest?.endAudio()
        isRecognitionStarted = false
    }
    
    private func keywordDetected(_ index: Int32) {
        do {
            try startRecognition()
        } catch {
            self.stopRecognition()
            delegate?.errorOccured()
        }
        //TODO: weak/strong self
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            guard self.isRecognitionStarted else {
                return
            }
            self.stopRecognition()
            self.delegate?.timerExpied()
        }
    }
    
    func start() throws {
        porcupineManager = try PorcupineManager(keyword: .jarvis, sensitivity: 1, onDetection: keywordDetected)
        try porcupineManager.start()
        try startEngine()
    }
    
    func stop() {
        stopRecognition()
        audioEngine.pause()
        audioEngine.inputNode.removeTap(onBus: bus)
        porcupineManager.stop()
    }
}
