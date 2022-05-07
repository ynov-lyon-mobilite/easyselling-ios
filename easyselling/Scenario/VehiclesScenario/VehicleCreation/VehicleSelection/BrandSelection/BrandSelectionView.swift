//
//  VehicleSelectionView.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 06/05/2022.
//

import SwiftUI

struct BrandSelectionView: View {
    @ObservedObject var viewModel: BrandSelectionViewModel

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
        }
        SearchBar(searchText: $viewModel.searchBrand)
        VStack(alignment: .leading) {
            List {
                ForEach(viewModel.searchBrandResults, id: \.self) { vehicleBrand in
                    Text(vehicleBrand.name.uppercased())
                        .onTapGesture(perform: {
                            viewModel.brandSelected = vehicleBrand
                            viewModel.dismissSelector()
                        })
                        .foregroundColor(.black)
                }
                Text(viewModel.searchBrand)
                    .onTapGesture(perform: {
                        viewModel.brandSelected = Brand(id: "", name: viewModel.searchBrand)
                        viewModel.dismissSelector()
                    })
                    .foregroundColor(.black)
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            Task {
                await viewModel.getVehicleBrand()
            }
        }
        .padding([.leading, .trailing, .bottom], 25)
        .padding(.top, 16)
        .background(Asset.Colors.whiteBackground.swiftUIColor)
    }
}

struct VehicleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        BrandSelectionView(viewModel: BrandSelectionViewModel(hasSelectedBrand: {_ in }))
    }
}
