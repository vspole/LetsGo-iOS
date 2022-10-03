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
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 150, height: 150)
                },
                placeholder: {
                    ProgressView()
                }
            )
            VStack(alignment: .leading, spacing: 8) {
                Text(configuration.name)
                    .scaledFont(type: .openSansBold, size: 17, color: .orange)
                HStack() {
                    RatingStarView(rating: Float(configuration.rating))
                    Text("(\(configuration.review_count))")
                        .scaledFont(type: .openSansRegular, size: 14, color: .black)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            //.padding(.top, 10)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, SIZE_PADDING_NORMAL)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}
