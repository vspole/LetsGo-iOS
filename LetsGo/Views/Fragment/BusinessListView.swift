//
//  BusinessListView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import Foundation
import SwiftUI

struct BusinessListView: View {
    let configuration: BusinessModel
    let categories: [CategoryModel]
   
    var body: some View {
        HStack() {
            AsyncImage(
                url: configuration.imageURL,
                content: { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .frame(width: 75, height: 75)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.trailing, 10)

            VStack(alignment: .leading, spacing: 8) {
                Text(configuration.name)
                    .scaledFont(type: .quickSandBold, size: 17, color: .black)
                if let category = categories[0]
                {
                    Text(category.title)
                        .scaledFont(type: .quickSandRegular, size: 13, color: .black)
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text(String(format: "%.1f", configuration.rating))
                        .scaledFont(type: .openSansSemiBold, size: 15, color: Color.accentColor)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 5)
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 5)
                        .foregroundColor(Color.accentColor)

                    Text("(\(configuration.review_count))")
                        .scaledFont(type: .openSansRegular, size: 12, color: Color.accentColor)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 15)
                    Spacer()
                    Image(systemName: "heart")
                        .foregroundColor(Color.accentColor)
//                    Spacer()
//                    Image(systemName: "square.and.arrow.up")
//                        .foregroundColor(Color.accentColor)
                    Spacer()
                    Image(systemName: "eye.slash")
                        .foregroundColor(Color.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, SIZE_PADDING_NORMAL)
        .padding(.vertical, SIZE_PADDING_XXS)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}
