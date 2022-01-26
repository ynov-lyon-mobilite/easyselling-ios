//
//  TaskSequencer.swift
//  easyselling
//
//  Created by Valentin Mont School on 26/01/2022.
//

import Foundation

protocol TaskAPI {

}

class TaskSequencer {
    static let shared = TaskSequencer()

    var tasks: [TaskAPI] = []

    func proccess() {
        tasks.forEach({ taskAPI in
            print(taskAPI)
        })
    }
}
