//
//  UIImageView+EXT.swift
//  GourmetGuide
//
//  Created by Min Kim on 10/24/23.
//

import UIKit

extension UIImageView {
    
    /// Function to make UIImageView a circle
    func makeRounded() {
        
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
    
    
    /// UIImageView extension to download an image from a passed in url
    /// - Parameter urlString: the url for the image
    func downloadImage(from urlString: String){
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
