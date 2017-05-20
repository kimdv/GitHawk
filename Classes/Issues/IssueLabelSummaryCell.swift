//
//  IssueLabelSummaryCell.swift
//  Freetime
//
//  Created by Ryan Nystrom on 5/20/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

final class IssueLabelSummaryCell: UICollectionViewCell {

    let label = UILabel()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 15, height: 15)
        layout.minimumInteritemSpacing = Styles.Sizes.columnSpacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    let reuse = "cell"
    var colors = [UIColor]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = Styles.Fonts.secondary
        label.textColor = Styles.Colors.Gray.light
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(Styles.Sizes.gutter)
        }

        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(IssueLabelDotCell.self, forCellWithReuseIdentifier: reuse)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(Styles.Sizes.columnSpacing)
            make.top.bottom.right.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let height = contentView.bounds.height
        let size = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
        let inset = (height - size.height)/2
        collectionView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }

}

extension IssueLabelSummaryCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuse, for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }

}

extension IssueLabelSummaryCell: IGListBindable {

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? IssueLabelSummaryModel else { return }
        label.text = viewModel.title
        colors = viewModel.colors
        collectionView.reloadData()
        setNeedsLayout()
    }

}