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
        setUpView()
    }

    private func setUpView() {
        view.backgroundColor = .gray

        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(fromHex: "#EEEEEE")

        let stackView = UIStackView(arrangedSubviews: [
            plainLogoView(),
            enhancedLogoView(),
            iconInView(name: "icon_briefcase_grayscale", scheme: .grayscale),
            iconInView(name: "icon_briefcase_grayscale", scheme: .inverse),
            iconInView(name: "icon_briefcase_grayscale", scheme: .primary),
            iconInView(name: "icon_briefcase_grayscale", scheme: .destructive),
            iconInView(
                name: "icon_briefcase_grayscale",
                scheme: .custom(primary: .systemPink, light: .cyan, dark: .brown)
            )
        ])

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 30

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
    }

    private func plainLogoView() -> UIView {
        let image = try? UIImage(named: "AppleLogo")!
                .aspectFit(size: CGSize(width: 120.0, height: 120.0))
        let labeledImage = LabeledImage(text: "Plain", image: image!)

        return labeledImage
    }

    private func enhancedLogoView() -> UIView {
        let image = try? UIImage(named: "AppleLogo")!
            .aspectFit(size: CGSize(width: 120.0, height: 120.0))
            .replace(colors: [
                (UIColor(red: 243/255, green: 187/255, blue: 75/255, alpha: 1.0), .darkGray),
                (UIColor(red: 206/255, green: 72/255, blue:69/255, alpha: 1.0), .black),
            ], tolerance: 0.01)
        let labeledImage = LabeledImage(text: "Enhanced", image: image!)

        return labeledImage
    }

    private func iconInView(name: String, scheme: ColorScheme) -> UIView {
        let icon = AFIcon.named(name, scheme: scheme, size: CGSize(width: 100, height: 100))

        let labelImage = LabeledImage(
            text: "\(name) in \(scheme.string)",
            image: icon
        )

        return labelImage
    }
}
