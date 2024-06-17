
import UIKit

// MARK: - HeaderView init & deinit
class HeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHeaderView()
    }
    
    override var intrinsicContentSize: CGSize {
        switch UIApplication.shared.preferredContentSizeCategory {
        case .accessibilityExtraExtraExtraLarge:
            return CGSize(width: UIView.noIntrinsicMetric, height: 170)
        case .accessibilityExtraExtraLarge:
            return CGSize(width: UIView.noIntrinsicMetric, height: 165)
        default:
            return CGSize(width: UIView.noIntrinsicMetric, height: 144)
        }
    }
}

// MARK: - Setup HeaderView
private extension HeaderView {
    func setupHeaderView() {
        let bundle = Bundle(for: HeaderView.self)
        bundle.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
