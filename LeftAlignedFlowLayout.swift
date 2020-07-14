//
//  Created by Artur.
//  Copyright © 2019 All rights reserved.
//

import Foundation

class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Init
    override init() {
        super.init()
        setAutomaticItemSize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setAutomaticItemSize()
    }
    
    private func setAutomaticItemSize() {
        estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
    }
    
    // MARK: - Layout Attributes Elements Calculation
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesForElements = super.layoutAttributesForElements(in: rect) else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        return attributesForElements.map(layoutAttributesForCellCategory(_:))
    }
    
    private func layoutAttributesForCellCategory(_ attribute: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard attribute.representedElementCategory == .cell else { return attribute }
        let attributeIndexPath = attribute.indexPath
        return layoutAttributesForItem(at: attributeIndexPath) ?? attribute
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributesForItem = super.layoutAttributesForItem(at:indexPath) else {
            return super.layoutAttributesForItem(at:indexPath)
        }
        
        let isFirstItem = indexPath.item == 0
        let isClosestToLeft = attributesForItem.frame.origin.x - 1 <= self.sectionInset.left
        
        guard !isFirstItem, !isClosestToLeft else {
                var frame = attributesForItem.frame
                frame.origin.x = sectionInset.left
                attributesForItem.frame = frame
                return attributesForItem
            }
        
        let previousItemIndexPath = IndexPath(item:indexPath.row-1, section:indexPath.section)
        guard let previousItemFrame = self.layoutAttributesForItem(at:previousItemIndexPath)?.frame else { return attributesForItem }
        
        let nextItemStartPosition = previousItemFrame.origin.x + previousItemFrame.size.width + self.minimumInteritemSpacing
        let layout = attributesForItem.copy() as? UICollectionViewLayoutAttributes
        layout?.frame.origin.x = nextItemStartPosition
        
        return layout ?? attributesForItem
    }
}
