//
//  DocumentPicker.swift
//  easyselling
//
//  Created by Corentin Laurencine on 22/12/2021.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker : UIViewControllerRepresentable {
    @Binding var data: PickedDocument?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {

        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentPicker>) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(data: $data)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate, PickedDocumentDelegate {
        @Binding var data: PickedDocument?

        init(data: Binding<PickedDocument?>) {
            self._data = data
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            self.data = formatData(urls: urls)
        }
    }
}
