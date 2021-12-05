//
//  DefaultAPICaller.swift
//  easyselling
//
//  Created by Maxence on 06/10/2021.
//

import Foundation
import Combine
import UIKit

protocol APICaller {
    func call<T: Decodable>(_ urlRequest: URLRequest, decodeType: T.Type) async throws -> T
    func call(_ urlRequest: URLRequest) async throws
    func callImage(_ urlRequest: URLRequest) async throws -> UIImage
}

final class DefaultAPICaller: APICaller {

    private var jsonDecoder = JSONDecoder()
    private var successStatusCodes = Set<Int>(200...209)
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func call<T: Decodable>(
        _ urlRequest: URLRequest,
        decodeType: T.Type) async throws -> T {
            let result: (Data, URLResponse)? = try? await urlSession.data(for: urlRequest, delegate: nil)

            guard let (data, response) = result,
                  let strongResponse = response as? HTTPURLResponse else {
                      throw APICallerError.internalServerError
                  }

            if !successStatusCodes.contains(strongResponse.statusCode) {
                throw APICallerError.from(statusCode: strongResponse.statusCode)
            }

            do {
                print(data)
                let decodedResult = try jsonDecoder.decode(APIResponse<T>.self, from: data)
                return decodedResult.data
            } catch (let error) {
                print(error)
                throw APICallerError.decodeError
            }
        }

    func call(_ urlRequest: URLRequest) async throws {
        let result: (Data, URLResponse)? = try? await urlSession.data(for: urlRequest, delegate: nil)

        guard let (_, response) = result,
              let strongResponse = response as? HTTPURLResponse else {
                  throw APICallerError.internalServerError
              }

        if !successStatusCodes.contains(strongResponse.statusCode) {
            throw APICallerError.from(statusCode: strongResponse.statusCode)
        }
    }

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
        }
        return uiImage
    }
}
