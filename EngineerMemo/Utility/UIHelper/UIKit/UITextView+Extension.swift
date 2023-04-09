import UIKit

extension UITextView {
    var numberOfLines: Int {
        var computingLineIndex = 0
        var computingGlyphIndex = 0

        while computingGlyphIndex < layoutManager.numberOfGlyphs {
            var lineRange = NSRange()
            layoutManager.lineFragmentRect(
                forGlyphAt: computingGlyphIndex,
                effectiveRange: &lineRange
            )
            computingGlyphIndex = NSMaxRange(lineRange)
            computingLineIndex += 1
        }

        if textContainer.maximumNumberOfLines > 0 {
            return min(
                textContainer.maximumNumberOfLines,
                computingLineIndex
            )
        } else {
            return computingLineIndex
        }
    }
}
