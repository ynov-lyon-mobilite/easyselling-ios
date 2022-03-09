//
//  InvoiceCreationViewModel.swift
//  easyselling
//
//  Created by Corentin Laurencine on 15/12/2021.
//

import Foundation
import Combine
import UniformTypeIdentifiers

class InvoiceCreationViewModel: ObservableObject {
    private var onFinish: () async -> Void
    private var invoiceCreator: InvoiceCreator
    private var fileUploader: FileUploader
    let allowedFileType: [UTType] = [.pdf]
    var vehicle: Vehicle

    @Published var fileConfirmationDialogIsPresented = false
    @Published var fileSelectionType: FileSelectionType?
    @Published var uploadedFile: UploadedFile?

    init(vehicle: Vehicle, fileUploader: FileUploader = DefaultFileUploader(), invoiceCreator: InvoiceCreator = DefaultInvoiceCreator(), onFinish: @escaping () async -> Void) {
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
                  return //TODO: Throw an Error
              }

        do {
            url.stopAccessingSecurityScopedResource()
            uploadedFile = try await fileUploader.upload(fileDTO)
        } catch(let error) {
            print(error) //TODO: Throw an Error
        }
    }

    @MainActor func createInvoice() async {
        guard let fileId = uploadedFile?.id else {
            return //TODO: Throw an Error
        }

        let informations = InvoiceDTO(file: fileId)

        do {
            try await invoiceCreator.createInvoice(vehicleId: vehicle.id, invoice: informations)
            await dismissModal()
        } catch (let error) {
            print(error) //TODO: Throw an Error
        }
    }

    func dismissModal() async {
        await self.onFinish()
    }

    enum FileSelectionType {
        case upload, scan
    }
}
