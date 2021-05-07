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
        scrollView.backgroundColor = UIColor(hex: "#EEEEEE")

        let stackView = UIStackView(arrangedSubviews: [
            plainLogoView(),
            enhancedLogoView(),
            composedLogoView(),
            iconWithRoundedRectangle(name: "icon_calculator_grayscale"),
            iconWithBackground(name: "icon_calculator_grayscale", scheme: .grayscale),
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
                (UIColor(red: 243/255, green: 187/255, blue: 75/255, alpha: 1.0), .gray),
                (UIColor(red: 206/255, green: 72/255, blue:69/255, alpha: 1.0), .black),
            ], tolerance: 0.015)
        let labeledImage = LabeledImage(text: "Color Swapped", image: image!)
        return labeledImage
    }

    private func composedLogoView() -> UIView {
        let image = try? UIImage(color: UIColor(hex: "#77e7ff"), size: CGSize(width: 120.0, height: 120.0))
            .union(UIImage(color: .black, size: CGSize(width: 100, height:  100))
                .ovalImage()
            )
            .union(UIImage(color: .white, size: CGSize(width: 92, height:  92))
                .ovalImage()
            )
            .union(UIImage(named: "AppleLogo")!
                .aspectFit(size: CGSize(width: 60, height: 60))
            )
        let labeledImage = LabeledImage(text: "Composed", image: image!)
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

    private func iconWithRoundedRectangle(name: String) -> UIView {
        let icon = AFIcon.named(name, scheme: .grayscale, size: CGSize(width: 50, height: 50))
        let image = try? UIImage(color: .yellow, size: CGSize(width: 200, height: 92), radius: 50, isDashed: true)

        let newImage = try? image!.union(icon)
        return LabeledImage(text: "Icon with oval background", image: newImage!)
    }
}
