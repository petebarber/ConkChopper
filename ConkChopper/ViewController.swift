import UIKit

class ViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var destImage: UIImageView!
    @IBOutlet weak var srcImageView: UIImageView!
    
    var bgQueue: dispatch_queue_t?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //destImage.layer.borderColor = UIColor.greenColor().CGColor
        //destImage.layer.borderWidth = 5.0
        //self.clipsToBounds = true
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = 0.1
        
        bgQueue = dispatch_queue_create("BackgroundImageCreation", DISPATCH_QUEUE_SERIAL)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func chop(sender: AnyObject)
    {
        drawTop(scrollView.contentOffset)
    }

    @IBAction func reset(sender: AnyObject)
    {
        destImage.image = nil
    }
    
    //
    // UIScrollViewDelegate
    //
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        //print("Num of SV:\(scrollView.subviews.count)")
        return srcImageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    {
    }

    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        dispatch_async(bgQueue!, { self.drawTop(scrollView.contentOffset) })
    }
    
    func drawTop(imageOffset: CGPoint)
    {
        let cgImage = srcImageView.image?.CGImage
        
        let topImage = CGImageCreateWithImageInRect(cgImage, CGRect(x: 0, y: 0, width: CGImageGetWidth(cgImage), height: Int(imageOffset.y)))
        
        let topLeftOfBottomPart = CGPoint(x: 0, y: imageOffset.y + scrollView.bounds.size.height)
        let sizeOfBottomPart = CGSize(width: CGImageGetWidth(cgImage), height: CGImageGetHeight(cgImage) - Int(topLeftOfBottomPart.y))
        
        let bottomImage = CGImageCreateWithImageInRect(cgImage, CGRect(origin: topLeftOfBottomPart, size: sizeOfBottomPart))
        
        let finalSize = CGSize(width: CGImageGetWidth(cgImage), height: CGImageGetHeight(topImage) + CGImageGetHeight(bottomImage))
        
        UIGraphicsBeginImageContext(finalSize)
        
        UIImage(CGImage: topImage!).drawAtPoint(CGPoint.zero)
        UIImage(CGImage: bottomImage!).drawAtPoint(CGPoint(x: 0, y: CGImageGetHeight(topImage!)))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        dispatch_async(dispatch_get_main_queue(), { self.destImage.image = finalImage })
    }
}

