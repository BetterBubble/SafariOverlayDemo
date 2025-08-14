
import UIKit

final class CustomFlowLayout: UICollectionViewFlowLayout {
    
    private let spacing: CGFloat = 16
    private let itemPerRow: CGFloat = 2
    private let itemHeight: CGFloat = 120
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        let totalItems = collectionView.numberOfItems(inSection: 0)
        let totalRows = calculateTotalRows(for: totalItems)
        let totalHeight = CGFloat(totalRows) * itemHeight + CGFloat(totalRows - 1) * spacing + spacing * 2
        
        return CGSize(width: collectionView.bounds.width, height: totalHeight)
    }
    
    private func calculateTotalRows(for totalItems: Int) -> Int {
        var rows = 0
        var currentItem = 0
        
        while currentItem < totalItems {
            if (currentItem + 1) % 3 == 0 {
                rows += 1
                currentItem += 1
            } else {
                rows += 1
                currentItem += Int(itemPerRow)
            }
        }
        
        return rows
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView else { return nil }
        
        var attributes: [UICollectionViewLayoutAttributes] = []
        let totalItems = collectionView.numberOfItems(inSection: 0)
        
        for item in 0..<totalItems {
            let indexPath = IndexPath(item: item, section: 0)
            if let attribute = layoutAttributesForItem(at: indexPath) {
                if rect.intersects(attribute.frame) {
                    attributes.append(attribute)
                }
            }
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let itemIndex = indexPath.item
        
        let (row, column) = calculatePosition(for: itemIndex)
        let isFullWidth = (itemIndex + 1) % 3 == 0
        
        let y = spacing + CGFloat(row) * (itemHeight + spacing)
        
        if isFullWidth {
            let fullWidth = collectionView.bounds.width - (spacing * 2)
            attributes.frame = CGRect(
                x: spacing,
                y: y,
                width: fullWidth,
                height: itemHeight
            )
        } else {
            let availableWidth = collectionView.bounds.width - (spacing * (itemPerRow + 1))
            let itemWidth = availableWidth / itemPerRow
            let x = spacing + (itemWidth + spacing) * CGFloat(column)
            
            attributes.frame = CGRect(
                x: x,
                y: y,
                width: itemWidth,
                height: itemHeight
            )
        }
        return attributes
    }
    
    private func calculatePosition(for itemIndex: Int) -> (row: Int, column: Int) {
        var currentItem = 0
        var row = 0
        
        while currentItem <= itemIndex {
            if (currentItem + 1) % 3 == 0 {
                if currentItem == itemIndex {
                    return (row, 0)
                }
                row += 1
                currentItem += 1
            } else {
                if currentItem == itemIndex {
                    return (row, 0)
                } else if currentItem + 1 == itemIndex {
                    return (row, 1)
                }
                row += 1
                currentItem += 2
            }
        }
        
        return (row, 0)
    }
}
