//
//  ModelSelectionView.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 06/05/2022.
//

import SwiftUI

struct ModelSelectionView: View {
    @State private var keyboardHeight: CGFloat = 20
    @State private var isKeyboardOpen: Bool = false
    @ObservedObject var viewModel: ModelSelectionViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    viewModel.dismissSelector()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(Asset.Colors.primary.swiftUIColor)
                        .frame(width: 15, height: 15, alignment: .trailing)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            SearchBar(searchText: $viewModel.searchModel)
                VStack(alignment: .leading) {
                    List {
                        ForEach(viewModel.searchModelResults, id: \.self) { vehicleModel in
                            Text(vehicleModel.model.uppercased())
                                .onTapGesture(perform: {
                                    viewModel.model = vehicleModel.model
                                    viewModel.dismissSelector()
                                })
                                .foregroundColor(.black)
                        }
                        Text(viewModel.searchModel)
                            .onTapGesture(perform: {
                                viewModel.model = viewModel.searchModel
                                viewModel.dismissSelector()
                            })
                            .foregroundColor(.black)
                    }
                    .listStyle(PlainListStyle())
                }
        }
        .onAppear {
            Task {
                await viewModel.getVehicleModel()
            }
        }
        .padding([.leading, .trailing, .bottom], 25)
        .padding(.top, 16)
        .background(Asset.Colors.whiteBackground.swiftUIColor)
        /*.padding(.bottom, keyboardHeight)
        .onReceive(Publishers.keyboardHeight) { padding in
            withAnimation {
                self.keyboardHeight = padding
            }
        }*/
    }
}

struct ModelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ModelSelectionView(viewModel: ModelSelectionViewModel(brandSelected: Brand(id: "1", name: "Renault"), hasSelectedModel: { _ in }))
    }
}
