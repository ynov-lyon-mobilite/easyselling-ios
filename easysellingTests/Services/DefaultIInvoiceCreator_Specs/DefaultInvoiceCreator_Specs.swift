//
//  DefaultInvoiceCreator_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 14/11/2021.
//

import XCTest
@testable import easyselling

class DefaultInvoiceCreator_Specs: XCTestCase {
    
//    func test_Login_user_succesfully() async {
//        let apiCaller = DefaultAPICaller(urlSession: FakeUrlSession(localFile: .userAuthenticatorResponse))
//        
//        givenInvoiceCreator(apiCaller: apiCaller)
//        await whenCreatingInvoice()
//        then()
//    }
//    
//    func test_Login_user_failed_because_needed_otp() async {
//        givenInvoiceCreator(apiCaller: FailingAPICaller(withError: 401))
//        await whenCreatingInvoice()
//        thenError(is: .unauthorized)
//    }
//    
//    private func givenInvoiceCreator(apiCaller: APICaller) {
//        invoiceCreator = DefaultInvoiceCreator(apiCaller: apiCaller)
//        informations = InvoiceDTO(vehicle: "VehicleID", file: "FileID")
//    }
//    
//    private func whenCreatingInvoice() async {
//        do {
//            try await invoiceCreator.createInvoice(invoice: informations)
//        } catch (let error) {
////            self.requestError = (error as! APICallerError)
//        }
//    }
//    
//    private func then() {
//        XCTAssertNil(requestError)
////        XCTAssertEqual(expectedRefreshToken, requestResult.refreshToken)
////        XCTAssertEqual(expectedAccessToken, requestResult.accessToken)
//    }
//    
//    private func thenError(is expectedError: APICallerError) {
////        XCTAssertNil(requestResult)
//        XCTAssertEqual(expectedError, requestError)
//    }
//    
//    private var invoiceCreator: DefaultInvoiceCreator!
////    private var requestResult: Token!
//    private var requestError: APICallerError!
//    private var informations: InvoiceDTO!
}
