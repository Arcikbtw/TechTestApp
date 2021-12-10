//
//  AlbumTableViewCell.swift
//  TechTestApp
//
//  Created by Artur Dąbkowski on 09/12/2021.
//

import UIKit
import SDWebImage

struct AlbumTableViewCellModel {
    let imageUrl: String
    let title: String
    let year: String
}

final class AlbumTableViewCell: UITableViewCell {
    static let cellIdent: String = "AlbumTableViewCell"

    struct Values {
        static let margin: CGFloat = 16
        static let imageSize: CGFloat = 60
    }

    @ContainerView var coverImageView = UIImageView()
    @ContainerView var titleLabel = UILabel()
    @ContainerView var yearLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)

        coverImageView.backgroundColor = .secondarySystemBackground

        let heightConstraint = coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Values.margin),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Values.margin),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Values.margin),
            heightConstraint,
            coverImageView.widthAnchor.constraint(equalToConstant: Values.imageSize),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: Values.margin),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -Values.margin/2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Values.margin),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        yearLabel.font = .preferredFont(forTextStyle: .subheadline)
        yearLabel.textColor = .secondaryLabel
    }

    func updateContent(model: AlbumTableViewCellModel) {
        coverImageView.sd_setImage(with: URL(string: model.imageUrl))
        titleLabel.text = model.title
        yearLabel.text = model.year
    }

}
