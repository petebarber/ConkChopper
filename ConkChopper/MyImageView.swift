import Foundation
import UIKit

@IBDesignable
class MyImageView : UIView
{
    @IBInspectable var image: UIImage?
    var rect = CGRect.zero
    
    internal(set) var renderedImage: UIImage?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 5.0
        //self.clipsToBounds = true
    }
    
    override func drawRect(rect: CGRect)
    {
        self.rect = rect
        guard let image = image else
        {
            return
        }
        
        image.drawInRect(rect)
    }
    
    func make(size: CGSize)
    {
        UIGraphicsBeginImageContext(size)
        
        image?.drawAtPoint(CGPoint.zero)
        
        renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
}