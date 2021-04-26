//
//  ViewController.swift
//  Colors
//
//  Created by Edward Smith on 4/25/21.
//
import UIKit

extension UIImage {
    convenience init(safe: String) {
        if let _ = UIImage(named: safe) {
            self.init(named: safe)!
        }
        self.init(named: "cry.png")!
    }
}

// MARK: -

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let label1 = UILabel()
        label1.font = UIFont.boldSystemFont(ofSize: 20.0)
        label1.textColor = .black
        label1.text = "Plain"

        let imageView1 = UIImageView()
        imageView1.image =
            try? UIImage(named: "AppleLogo")!
                .aspectFit(size: CGSize(width: 120.0, height: 120.0))
        imageView1.layer.borderWidth = 0.5
        imageView1.layer.borderColor = UIColor.black.cgColor
        imageView1.layer.cornerRadius = 5.0

        let spacer = UIView()
        let heightConstraint = NSLayoutConstraint(
            item: spacer,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: 38
        )
        spacer.addConstraint(heightConstraint)

        let label2 = UILabel()
        label2.font = UIFont.boldSystemFont(ofSize: 20.0)
        label2.textColor = .black
        label2.text = "Enhanced"

        let imageView2 = UIImageView()
        imageView2.image =
            try? UIImage(named: "AppleLogo")!
                .aspectFit(size: CGSize(width: 120.0, height: 120.0))
        imageView2.layer.borderWidth = 0.5
        imageView2.layer.borderColor = UIColor.black.cgColor
        imageView2.layer.cornerRadius = 5.0

        let stackView = UIStackView(arrangedSubviews: [
            label1,
            imageView1,
            spacer,
            label2,
            imageView2,
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heightConstraint,
        ])
    }
}
