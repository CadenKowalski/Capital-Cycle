//
//  ViewFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/31/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

class ViewFunctions: UIViewController {

    // MARK: View Fucntions
    
    // Generates haptic feedback
    func giveHapticFeedback(error: Bool, prefers: Bool) {
        if prefers {
            if error {
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.prepare()
                feedbackGenerator.notificationOccurred(.error)
            } else {
                let feedbackGenerator = UISelectionFeedbackGenerator()
                feedbackGenerator.selectionChanged()
            }
        }
    }
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style, view: UIViewController) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        view.present(Alert, animated: true, completion: nil)
        giveHapticFeedback(error: true, prefers: true)
    }
    
    // Formats the progress wheel
    func formatProgressWheel(progressWheel: UIActivityIndicatorView, button: UIButton?, toShow: Bool, hapticFeedback: Bool) {
        if toShow {
            button?.alpha = 0.25
            progressWheel.isHidden = false
            progressWheel.startAnimating()
            if hapticFeedback {
                giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
            }
        } else {
            button?.alpha = 1.0
            progressWheel.stopAnimating()
        }
    }
    
    // Waits a given amount of time and then performs actions in the completion block
    func wait(time: Double, completion: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
            completion()
        })
    }
    
    // Performs the completion block on the main thread
    func main(completion: @escaping() -> Void) {
        DispatchQueue.main.async() {
            completion()
        }
    }
}
