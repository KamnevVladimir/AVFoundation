//
//  VideoTableViewCell.swift
//  AVFoundation_Audio
//
//  Created by Tsar on 10.04.2021.
//

import UIKit

final class VideoTableViewCell: UITableViewCell {
    var video: Video? {
        didSet {
            guard let safeVideo = video else { return }
            videoNameLabel.text = safeVideo.name
        }
    }
    
    private lazy var youtubeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Youtube"
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var videoNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        contentView.addSubview(youtubeLabel)
        contentView.addSubview(videoNameLabel)
    }
    
    private func setupLayouts() {
        let constraints = [
            youtubeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            youtubeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            videoNameLabel.topAnchor.constraint(equalTo: youtubeLabel.bottomAnchor, constant: 5),
            videoNameLabel.leadingAnchor.constraint(equalTo: youtubeLabel.leadingAnchor),
            videoNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            videoNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
