//
//  HTTPMessage.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

struct HTTPMessage {
    static var responseMessages = [
        200: "OK",
        403: "Access forbidden",
        404: "File not found",
        500: "Internal server error"
    ]
}
