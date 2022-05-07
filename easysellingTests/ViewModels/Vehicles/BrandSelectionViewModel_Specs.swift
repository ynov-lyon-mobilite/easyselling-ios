//
//  BrandSelectionViewModel_Specs.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 06/05/2022.
//

import XCTest
@testable import easyselling

class BrandSelectionViewModel_Specs: XCTestCase {

    func test_Dissmis_selection_when_user_has_selected_brand_without_error() {
        givenViewModel()
        whenSelectingBrand(is: Brand(id: "1", name: "Peugeot"))
        whenBrandHasSelected()
        thenSelectedBrand()
    }

    func test_Filters_vehicle_brand() {
        let brands = [
            Brand(id: "1", name: "PEUGEOT"),
            Brand(id: "5", name: "RENAULT"),
            Brand(id: "23", name: "REWATTO")
        ]

        let brandsExpected = [
            Brand(id: "5", name: "RENAULT"),
            Brand(id: "23", name: "REWATTO")
        ]

        givenViewModel()
        whenGetVehicleBrand(with: brands)
        whenChossingBrandName(with: "Re")
        thenBerandResultIsFiltered(is: brandsExpected)
    }

    private func givenViewModel(vehicleBrandGetter: VehicleBrandGetter = DefaultVehicleBrandGetter()) {
        viewModel = BrandSelectionViewModel(vehicleBrandGetter: vehicleBrandGetter, hasSelectedBrand: { _ in
            self.hasSelectedBrand = true
        })
    }

    private func whenGetVehicleBrand(with brandResult: [Brand]) {
        viewModel.vehicleBrand = brandResult
    }

    private func whenChossingBrandName(with brand: String) {
        viewModel.searchBrand = brand
    }

    private func whenSelectingBrand(is brand: Brand) {
        brandSelected = brand
    }

    private func whenBrandHasSelected() {
        viewModel.dismissSelector()
    }

    private func thenSelectedBrand() {
        XCTAssertTrue(hasSelectedBrand)
    }

    private func thenBerandResultIsFiltered(is expected: [Brand]) {
        XCTAssertEqual(expected, viewModel.searchBrandResults)
    }

    private var brandSelected: Brand!
    private var hasSelectedBrand: Bool = false
    private var viewModel: BrandSelectionViewModel!
}
