//
//  InvoiceCreationViewModel.swift
//  easyselling
//
//  Created by Corentin Laurencine on 15/12/2021.
//

import Foundation
import Combine
import UniformTypeIdentifiers
import SwiftUI

class InvoiceCreationViewModel: ObservableObject {
    private var onFinish: () async -> Void
    private var invoiceCreator: InvoiceCreator
    private var fileUploader: FileUploader
    let allowedFileType: [UTType] = [.pdf]
    var vehicle: Vehicle

    @Published var fileConfirmationDialogIsPresented = false
    @Published var fileSelectionType: FileSelectionType?
    @Published var uploadedFile: UploadedFile?
    @Published var alertError: Error?
    @Published var alertIsPresented = false
    @Published var invoiceLabel: String = ""
    @Published var invoiceDate: Date = Date()
    @Published var invoiceMileage: Int?
    var isReadyToAdd: Bool { withAnimation {
        invoiceMileage != nil
    } }

    init(vehicle: Vehicle, fileUploader: FileUploader = DefaultFileUploader(),
         invoiceCreator: InvoiceCreator = DefaultInvoiceCreator(context: mainContext),
         onFinish: @escaping () async -> Void) {
        self.vehicle = vehicle
        self.fileUploader = fileUploader
        self.invoiceCreator = invoiceCreator
        self.onFinish = onFinish
    }

    func openFileConfirmationDialog() {
        fileConfirmationDialogIsPresented = true
    }

    func openFileSectionSheet(_ type: FileSelectionType) {
        fileSelectionType = type
    }

    @MainActor func importFile(result: Result<URL, Error>) async {
        guard case .success(let url) = result,
              url.startAccessingSecurityScopedResource(),
              let mimeType = url.mimeType,
              let data = try? Data(contentsOf: url),
              let fileDTO = FileDTO(name: url.lastPathComponent, type: mimeType, data: data) else {
            alertError = APICallerError.unknownError
            fileSelectionType = nil
            alertIsPresented = true

            return
        }

        do {
            url.stopAccessingSecurityScopedResource()
            uploadedFile = try await fileUploader.upload(fileDTO)
        } catch(let error) {
            alertError = error
            fileSelectionType = nil
            alertIsPresented = true
        }
    }

    @MainActor func createInvoice() async {
        guard let fileId = uploadedFile?.id else {
            alertError = APICallerError.unknownError
            fileSelectionType = nil
            alertIsPresented = true

            return
        }

        guard let invoiceMileage = invoiceMileage else {
            return
        }

        let informations = InvoiceDTO(file: fileId, label: invoiceLabel, mileage: invoiceMileage, date: invoiceDate)

        do {
            try await invoiceCreator.createInvoice(vehicleId: vehicle.id, invoice: informations)
            await dismissModal()
        } catch (let error) {
            alertError = error
            fileSelectionType = nil
            alertIsPresented = true
        }
    }

    func dismissModal() async {
        await onFinish()
    }

    enum FileSelectionType {
        case upload, scan
    }
}
