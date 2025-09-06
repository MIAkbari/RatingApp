public struct StarRatingView: View {
    @Binding private var rating: Float
    @Binding private var width: CGFloat
    private let color: Color
    private let maxRating: Float
    @State private var dragOffset: CGFloat = 0
    @State private var initialDragX: CGFloat = 0
    @State private var starWidth: CGFloat = 0

    public init(rating: Binding<Float>, width: Binding<CGFloat>, color: Color = .orange, maxRating: Float = 5) {
        self._rating = rating
        self._width = width
        self.color = color
        self.maxRating = maxRating
    }

    public var body: some View {
        GeometryReader { geometry in
            let starSize = geometry.size.height
            let spacing: CGFloat = 5

            HStack(spacing: spacing) {
                ForEach(0..<Int(maxRating), id: \.self) { index in
                    star(for: Float(index + 1), starSize: starSize)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if dragOffset == 0 {
                            initialDragX = value.location.x
                        }
                        dragOffset = value.translation.width
                        updateRating()
                    }
                    .onEnded { _ in
                        dragOffset = 0
                    }
            )
            .animation(.easeInOut(duration: 0.2), value: rating)
        }
        .onAppear {
            calculateStarWidth()
        }
    }

    private func star(for value: Float, starSize: CGFloat) -> some View {
        let starFill: CGFloat
        if rating >= value {
            starFill = 1.0
        } else if rating + 1 > value {
            starFill = CGFloat(rating + 1 - value)
        } else {
            starFill = 0.0
        }

        return ZStack {
            emptyStar
            if starFill > 0 {
                fullStar
                    .mask(Rectangle().size(width: starSize * starFill, height: starSize))
            }
        }
        .frame(width: starSize, height: starSize)
    }

    private var fullStar: some View {
        Image(systemName: "star.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
    }

    private var emptyStar: some View {
        Image(systemName: "star")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
    }

    private func updateRating() {
        let absoluteLocation = initialDragX + dragOffset
        let newRating = Float(round(Double(absoluteLocation / starWidth) * 10) / 10)
        let clampedRating = min(max(0, newRating), maxRating)
        self.rating = clampedRating
    }

     private func calculateStarWidth() {
         let spacing: CGFloat = 5
         starWidth = (width - CGFloat(Int(maxRating) - 1) * spacing) / CGFloat(maxRating)
     }
}