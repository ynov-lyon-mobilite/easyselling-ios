//
//  PickedDocumentDelegate.swift
//  easyselling
//
//  Created by Corentin Laurencine on 15/12/2021.
//

import Foundation

protocol PickedDocumentDelegate: AnyObject {}

extension PickedDocumentDelegate {
    func formatData(urls: [URL]) -> PickedDocument {
        guard let url = urls.first, url.startAccessingSecurityScopedResource() else {
            return PickedDocument(data: Data(), filename: "", path: "")
        }

        do {
            let filename = url.lastPathComponent
            let fileData = try Data(contentsOf: url)
            // let fileType = filename.split(separator: ".").last

            url.stopAccessingSecurityScopedResource()

            return PickedDocument(data: fileData, filename: filename, path: url.absoluteString)
        } catch(let error) {
            print(error)

            return PickedDocument(data: Data(), filename: "", path: "")
        }
    }
}
