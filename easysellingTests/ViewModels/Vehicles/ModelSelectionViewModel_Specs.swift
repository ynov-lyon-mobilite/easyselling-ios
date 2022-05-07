//
//  ModelSelectionViewModel.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 07/05/2022.
//

import XCTest
@testable import easyselling

class ModelSelectionViewModel_Specs: XCTestCase {

    func test_Dissmis_selection_when_user_has_selected_brand_without_error() {
        givenViewModel()
        whenSelectingModel(is: "3008")
        whenModelHasSelected()
        thenSelectedModel()
    }

    func test_Filters_vehicle_model() {
        let models = [
            Model(id: "1", brand: "23", model: "MEGANE", type: .car),
            Model(id: "2", brand: "23", model: "MEGANE RS", type: .car),
            Model(id: "3", brand: "23", model: "LAGUNA", type: .car)
        ]

        let modelsExpected = [
            Model(id: "1", brand: "23", model: "MEGANE", type: .car),
            Model(id: "2", brand: "23", model: "MEGANE RS", type: .car)
        ]

        givenViewModel()
        whenGetVehicleModel(with: models)
        whenChossingModelName(with: "Meg")
        thenModelResultIsFiltered(is: modelsExpected)
    }

    private func givenViewModel(vehicleModelGetter: VehicleModelGetter = DefaultVehicleModelGetter()) {
        viewModel = ModelSelectionViewModel(vehicleModelGetter: vehicleModelGetter, brandSelected: Brand(id: "23", name: "Peugeot"), hasSelectedModel: { _ in
            self.hasSelectedModel = true
        })
    }

    private func whenGetVehicleModel(with modelResult: [Model]) {
        viewModel.vehicleModel = modelResult
    }

    private func whenChossingModelName(with model: String) {
        viewModel.searchModel = model
    }

    private func whenSelectingModel(is model: String) {
        modelSelected = model
    }

    private func whenModelHasSelected() {
        viewModel.dismissSelector()
    }

    private func thenSelectedModel() {
        XCTAssertTrue(hasSelectedModel)
    }

    private func thenModelResultIsFiltered(is expected: [Model]) {
        XCTAssertEqual(expected, viewModel.searchModelResults)
    }

    private var modelSelected: String!
    private var hasSelectedModel: Bool = false
    private var viewModel: ModelSelectionViewModel!
}
