//
//  KVLoading.swift
//
//  Created by Vu Van Khac on 2/22/17.
//

import UIKit

public class KVLoading: UIView {
    
    class var shared: KVLoading {
        struct Static {
            static let shared = KVLoading()
        }
        
        return Static.shared
    }
    
    public private(set) var isShowing: Bool {
        get {
            guard let contentView = self.contentView else {
                return false
            }
            
            if contentView.alpha > 0 {
                return true
            } else {
                return false
            }
        }
        
        set {
            self.isShowing = newValue
        }
    }
    
    lazy var keyView: UIView = {
        if let view = UIApplication.shared.windows.last {
            return view
        }
        
        return UIView()
    }()
    
    var dimBackground: Bool = false
    lazy var backgroundView: UIView = {
        let backgroundView: UIView = UIView()
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.frame = self.keyView.bounds
        backgroundView.isUserInteractionEnabled = true
        backgroundView.backgroundColor = .black
        self.keyView.addSubview(backgroundView)
        
        return backgroundView
    }()
    
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didChangeStatusBarOrientation(notifitation: Notification) {
        guard let contentView = self.contentView else {
            return
        }
        
        contentView.center = keyView.center
    }
    
    public static func enableDimBackground() {
        self.shared.dimBackground = true
    }
    
    public static func disableDimBackgrounda() {
        self.shared.dimBackground = false
    }
    
    public static func show(_ customView: UIView? = nil, animated: Bool = true) {
        self.shared.show(customView, animated: animated)
    }
    
    func show(_ customView: UIView? = nil, animated: Bool = true) {
        if isShowing {
            return
        }
        
        if let customView = customView {
            customView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
            contentView = customView
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeStatusBarOrientation(notifitation:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
            contentView = KVLoadingView()
        }
        
        backgroundView.isHidden = false
        if dimBackground {
            backgroundView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.alpha = 0.2
            })
        } else {
            backgroundView.alpha = 0
        }
        
        guard let contentView = self.contentView else {
            return
        }
        
        contentView.alpha = 0
        contentView.center = keyView.center
        keyView.addSubview(contentView)
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                contentView.alpha = 1
            })
        } else {
            contentView.alpha = 1
        }
    }
    
    public static func hide(animated: Bool = true) {
        self.shared.hide(animated: animated)
    }
    
    func hide(animated: Bool = true) {
        if !isShowing {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
        })
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView?.alpha = 0
            }, completion: { (_) in
                self.backgroundView.isHidden = true
                self.contentView?.removeFromSuperview()
                self.contentView = nil
                NotificationCenter.default.removeObserver(self)
            })
        } else {
            backgroundView.isHidden = true
            contentView?.alpha = 0
            contentView?.removeFromSuperview()
            contentView = nil
            NotificationCenter.default.removeObserver(self)
        }
    }
    
}

class KVLoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.contentView())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contentView() -> UIView {
        let contentView: UIView = UIView()
        contentView.frame.size.width = 77
        contentView.frame.size.height = 77
        contentView.center = self.center
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        contentView.layer.cornerRadius = 5
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame.size.width = 37
        activityIndicator.frame.size.height = 37
        activityIndicator.center = CGPoint(x: contentView.frame.width / 2, y: contentView.frame.height / 2)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.startAnimating()
        contentView.addSubview(activityIndicator)
        
        return contentView
    }
    
}
