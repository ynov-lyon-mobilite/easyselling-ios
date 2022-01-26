//
//  TaskSequencer.swift
//  easyselling
//
//  Created by Valentin Mont School on 26/01/2022.
//

import Foundation
import CoreData

protocol TaskAPI {
    func generateRequest() async -> URLRequest?
    func parseJSONToCoreDataObject() async
}

class TaskSequencer {
    static let shared = TaskSequencer()

    var tasks: [TaskAPI] = []

    func proccess() async {
        for taskAPI in tasks {
            do {
                await taskAPI.parseJSONToCoreDataObject()
            } catch (let error) {
                print(error)
            }
        }
    }
}
