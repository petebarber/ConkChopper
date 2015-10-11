import UIKit

class ViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var srcImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var destImage: UIImageView!

    private var bgQueue: dispatch_queue_t?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        bgQueue = dispatch_queue_create("BackgroundImageCreation", DISPATCH_QUEUE_SERIAL)
        
        scrollView.layer.borderColor = UIColor.blueColor().CGColor
        scrollView.layer.borderWidth = 5.0
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = 0.1
        
        destImage.layer.borderColor = UIColor.greenColor().CGColor
        destImage.layer.borderWidth = 5.0
    }
    
    func drawTop(var imageOffset: CGPoint)
    {
        guard let cgImage = srcImageView.image?.CGImage, finalImageWidth = srcImageView.image?.size.width else
        {
            return
        }
        
        imageOffset.x = max(0, imageOffset.x)
        imageOffset.y = max(0, imageOffset.y)
        
        let topImageHeight = imageOffset.y
        let topImage = CGImageCreateWithImageInRect(cgImage, CGRect(x: 0, y: 0, width: finalImageWidth, height: topImageHeight))
        
        let topLeftOfBottomPart = CGPoint(x: 0, y: imageOffset.y + scrollView.bounds.size.height)
        let bottomImageHeight = CGFloat(CGImageGetHeight(cgImage)) - topLeftOfBottomPart.y
        let sizeOfBottomPart = CGSize(width: finalImageWidth, height: bottomImageHeight)
        
        let bottomImage = CGImageCreateWithImageInRect(cgImage, CGRect(origin: topLeftOfBottomPart, size: sizeOfBottomPart))
        
        let finalSize = CGSize(width: finalImageWidth, height: topImageHeight + bottomImageHeight)
        
        UIGraphicsBeginImageContext(finalSize)
        
        if let topImage = topImage
        {
            UIImage(CGImage: topImage).drawAtPoint(CGPoint.zero)
        }
        
        if let bottomImage = bottomImage
        {
            UIImage(CGImage: bottomImage).drawAtPoint(CGPoint(x: 0, y: topImageHeight))
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        dispatch_async(dispatch_get_main_queue(), { self.destImage.image = finalImage })
    }
    
    //
    // UIScrollViewDelegate
    //
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return srcImageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    {
    }

    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        dispatch_async(bgQueue!, { self.drawTop(scrollView.contentOffset) })
    }
}

