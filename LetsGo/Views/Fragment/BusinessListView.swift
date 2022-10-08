//
//  BusinessListView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import Foundation
import SwiftUI

struct BusinessListView: View {
    let configuration: Configuration
    
    var body: some View {
        HStack() {
            AsyncImage(
                url: configuration.business.imageURL,
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
                Text(configuration.business.name)
                    .scaledFont(type: .quickSandBold, size: 17, color: .black)
                if let category = configuration.categories[0]
                {
                    Text(category.title)
                        .scaledFont(type: .quickSandRegular, size: 13, color: .black)
                }
                
                HStack(alignment: .center, spacing: 0) {
                    HStack(spacing: 0) {
                        Text(String(format: "%.1f", configuration.business.rating))
                            .scaledFont(type: .openSansSemiBold, size: 15, color: Color.accentColor)
                            .multilineTextAlignment(.leading)
                            .padding(.trailing, 5)
                            .padding(.leading, 0)
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .padding(.trailing, 5)
                            .foregroundColor(Color.accentColor)
                        
                        Text("(\(configuration.business.review_count))")
                            .scaledFont(type: .openSansRegular, size: 12, color: Color.accentColor)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(width: 115, alignment: .leading)
                    Spacer()
                    HStack {
                        Button {
                            configuration.favoriteButtoncompletion(configuration.business)
                        } label: {
                            Image(systemName: configuration.isFavorited ? "heart.fill" : "heart")
                                .foregroundColor(Color.accentColor)
                        }
                        Spacer()
                        Image(systemName: "eye.slash")
                            .foregroundColor(Color.accentColor)
                    }
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

extension BusinessListView {
    struct Configuration {
        let business: BusinessModel
        let isFavorited: Bool
        let categories: [CategoryModel]
        let favoriteButtoncompletion: (BusinessModel) -> Void
        
        init(business: BusinessModel, isFavorited: Bool, categories: [CategoryModel], favoriteButtoncompletion: @escaping (BusinessModel) -> Void) {
            self.business = business
            self.isFavorited = isFavorited
            self.categories = categories
            self.favoriteButtoncompletion = favoriteButtoncompletion
        }
    }
}
