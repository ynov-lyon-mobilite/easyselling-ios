//
//  ButtonList.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 16/02/2022.
//

import SwiftUI

struct ButtonList: View {
    var title: String
    var icon: UIImage
    var color: Color
    var action: Action

    var body: some View {
        Button(action: self.action) {
            HStack {
                Image(uiImage: self.icon)
                    .padding(10)
                    .background(Circle().foregroundColor(self.color))
                    .padding(.leading, 10)
                Text(self.title)
                    .fontWeight(.bold)
                    .font(.title2)
                    .padding(.vertical, 20)
                    .padding(.leading, 10)
                Spacer()
            }
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.bottom, 15)
        }

    }
}
struct ButtonList_Previews: PreviewProvider {
    static var previews: some View {
        ButtonList(title: "Test", icon: Asset.Icons.settings.image, color: Color.blue, action: {})
    }
}
