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
                    .scaledFont(type: .openSansBold, size: 17, color: .black)
                HStack(alignment: .center, spacing: 0) {
                    Text(String(format: "%.1f", configuration.rating))
                        .scaledFont(type: .openSansSemiBold, size: 15, color: .green)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 5)
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 5)
                        .foregroundColor(.green)

                    Text("(\(configuration.review_count))")
                        .scaledFont(type: .openSansRegular, size: 12, color: .green)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 15)
                    Spacer()
                    Image(systemName: "heart")
                        .foregroundColor(.green)
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.green)
                    Spacer()
                    Image(systemName: "eye.slash")
                        .foregroundColor(.green)
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
