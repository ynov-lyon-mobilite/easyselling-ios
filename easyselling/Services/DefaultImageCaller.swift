//
//  DefaultImageCaller.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 11/12/2021.
//

import Foundation
import UIKit

protocol ImageCaller {
    func callImage(_ urlRequest: URLRequest) async throws -> UIImage
}

class DefaultImageCaller: ImageCaller {

    private var successStatusCodes = Set<Int>(200...209)
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    // No test for this because this was just a solution in wait of a document presenter in the app
    func callImage(_ urlRequest: URLRequest) async throws -> UIImage {
        var uiImage: UIImage = UIImage()
        if let url = urlRequest.url, let data = try? Data(contentsOf: url) {

            if let document = CGPDFDocument(url as CFURL),
                  let page = document.page(at: 1) {

                let pageRect = page.getBoxRect(.mediaBox)
                let renderer = UIGraphicsImageRenderer(size: pageRect.size)
                let img = renderer.image { ctx in
                    UIColor.white.set()
                    ctx.fill(pageRect)

                    ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                    ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

                    ctx.cgContext.drawPDFPage(page)
                }

                return img
            }

            if let image = UIImage(data: data) {
                uiImage = image
            }
        } else {
            throw APICallerError.internalServerError
        }
        return uiImage
    }

    func callImageWithNoNetwork(_ data: Data) -> UIImage {
        var uiImage: UIImage = UIImage()

        if let data = UIImage(data: data) {
            uiImage = data
        }

        return uiImage
    }
}
