import SwiftUI

/// Grows and offsets its content based on scroll position, producing a soft parallax
/// "hero image" effect for milestone cards on the timeline.
struct ParallaxImageView: View {
    let item: MediaItem
    var height: CGFloat = 260

    var body: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            MediaThumbnailView(item: item)
                .frame(width: geo.size.width, height: height + max(0, minY))
                .clipped()
                .offset(y: minY > 0 ? -minY : 0)
        }
        .frame(height: height)
    }
}
