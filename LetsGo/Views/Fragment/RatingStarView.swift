//
//  RatingStarView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/3/22.
//

import Foundation
import SwiftUI

struct RatingStarView: View {
  private static let MAX_RATING: Float = 5 // Defines upper limit of the rating
  private static let COLOR = Color.orange // The color of the stars

  let rating: Float
  private let fullCount: Int
  private let emptyCount: Int
  private let halfFullCount: Int

  init(rating: Float) {
    self.rating = rating
    fullCount = Int(rating)
      emptyCount = Int(RatingStarView.MAX_RATING - rating)
    halfFullCount = (Float(fullCount + emptyCount) < RatingStarView.MAX_RATING) ? 1 : 0
  }

  var body: some View {
    HStack {
      ForEach(0..<fullCount) { _ in
          self.fullStar
       }
       ForEach(0..<halfFullCount) { _ in
         self.halfFullStar
       }
       ForEach(0..<emptyCount) { _ in
         self.emptyStar
       }
     }
  }

  private var fullStar: some View {
    Image(systemName: "star.fill")
          .resizable()
          .foregroundColor(RatingStarView.COLOR)
          .frame(width: 10, height: 10)
  }

  private var halfFullStar: some View {
      Image(systemName: "star.lefthalf.fill")
          .resizable()
          .foregroundColor(RatingStarView.COLOR)
          .frame(width: 10, height: 10)
  }

  private var emptyStar: some View {
    Image(systemName: "star")
          .resizable()
          .foregroundColor(RatingStarView.COLOR)
          .frame(width: 10, height: 10)
  }
}
