//
//  ProgramAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
//

import UIKit

final class ProgramAssembly {
    static func build(
        for program: GroupOfProgramsModel.ProgramModel,
        by university: UniversityModel
    ) -> UIViewController {
        ProgramViewController(
            for: program,
            by: university
        )
    }
}
