import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var srcImage: MyImageView!

    @IBOutlet weak var destImage: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //destImage.layer.borderColor = UIColor.greenColor().CGColor
        //destImage.layer.borderWidth = 5.0
        //self.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func chop(sender: AnyObject)
    {
        print("pre - dest:\(destImage)")
        
        srcImage.make(destImage.frame.size)
        
        destImage.image = srcImage.renderedImage
        //destImage.image = srcImage.image
        
        print("ren:\(srcImage.renderedImage)")
        print("src:\(srcImage.image)")
        print("dest:\(destImage)")
    }

    @IBAction func reset(sender: AnyObject)
    {
        destImage.image = nil
    }
}

