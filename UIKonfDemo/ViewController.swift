import UIKit
import Alloy

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var processor: ContrastProcessor!
    var texture: MTLTexture!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "kitten")!.cgImage!
        self.imageView.image = UIImage(cgImage: image)
        
        try! self.setup(with: image)
    }

    func setup(with image: CGImage) throws {
        self.processor = try .init(context: .init())
        self.texture = try self.processor
                               .context
                               .texture(from: image, srgb: false)
    }

    @IBAction func sliderDidChange(_ sender: UISlider) {
        let processedTexture = try! self.processor.process(texture: self.texture,
                                                           intensity: sender.value)
        
        self.imageView.image = try! processedTexture.image()
    }
}

