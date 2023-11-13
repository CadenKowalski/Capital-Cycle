//
//  MailView.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/11/20.
//

import SwiftUI
import UIKit
import MessageUI

// MARK: MailView Struct

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    var recipient: String
    var subject: String
    var messageBody: String

    // Returns the coordinator which determines the presentation mode of the mail view controller
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation)
    }

    // Presents the mail view controller
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([recipient])
        vc.setSubject(subject)
        vc.setMessageBody(messageBody, isHTML: true)
        return vc
    }

    // Updates the maile view controller
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,context: UIViewControllerRepresentableContext<MailView>) {
    }
    
    // MARK: Coordinator Class
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        // Global variables
        @Binding var presentation: PresentationMode

        // Initializes the coordinator
        init(presentation: Binding<PresentationMode>) {
            _presentation = presentation
        }

        // Dismisses the mail view controller
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
