//  This file is part of the PhotoEditor Software Development Kit.
//  Copyright (C) 2016 9elements GmbH <contact@9elements.com>
//  All rights reserved.
//  Redistribution and use in source and binary forms, without
//  modification, are permitted provided that the following license agreement
//  is approved and a legal/financial contract was signed by the user.
//  The license agreement can be found under the following link:
//  https://www.photoeditorsdk.com/LICENSE.txt

import UIKit
import imglyKit

private enum Selection: Int {
    case camera = 0
    case editor = 1
    case embeddedEditor = 2
}

class ViewController: UITableViewController {

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case Selection.camera.rawValue:
            presentCameraViewController()
        case Selection.editor.rawValue:
            presentPhotoEditViewController()
        case Selection.embeddedEditor.rawValue:
            pushPhotoEditViewController()
        default:
            break
        }
    }

    // MARK: - Configuration

    private func buildConfiguration() -> Configuration {
        let configuration = Configuration() { builder in
            // Configure camera
            builder.configureCameraViewController() { options in
                // Just enable Photos
                options.allowedRecordingModes = [.photo]
            }

            // Get a reference to the sticker data source
            builder.configureStickerToolController() { options in
                options.stickerCategoryDataSourceConfigurationClosure = { dataSource in
                    // Duplicate the first sticker category for demonstration purposes
                    if let stickerCategory = dataSource.stickerCategories?.first {
                        dataSource.stickerCategories = [stickerCategory, stickerCategory]
                    }
                }
            }
        }

        return configuration
    }

    // MARK: - Presentation

    private func presentCameraViewController() {
        let configuration = buildConfiguration()
        let cameraViewController = CameraViewController(configuration: configuration)
        cameraViewController.completionBlock = { [unowned cameraViewController] image, videoURL in
            if let image = image {
                cameraViewController.present(self.createPhotoEditViewController(with: image), animated: true, completion: nil)
            }
        }

        present(cameraViewController, animated: true, completion: nil)
    }

    private func createPhotoEditViewController(with photo: UIImage) -> ToolbarController {
        let configuration = buildConfiguration()
        var menuItems = MenuItem.defaultItems(with: configuration)
        menuItems.removeLast() // Remove last menu item ('Magic')

        // Create a photo edit view controller
        let photoEditViewController = PhotoEditViewController(photo: photo, menuItems: menuItems, configuration: configuration)
        photoEditViewController.delegate = self

        // A PhotoEditViewController works in conjunction with a `ToolbarController`, so in almost
        // all cases it should be embedded in one and presented together.
        let toolbarController = ToolbarController()
        toolbarController.push(photoEditViewController, animated: false)

        return toolbarController
    }

    private func presentPhotoEditViewController() {
        guard let photo = UIImage(named: "LA.jpg") else {
            return
        }

        present(createPhotoEditViewController(with: photo), animated: true, completion: nil)
    }

    private func pushPhotoEditViewController() {
        guard let photo = UIImage(named: "LA.jpg") else {
            return
        }

        navigationController?.pushViewController(createPhotoEditViewController(with: photo), animated: true)
    }

}

extension ViewController: PhotoEditViewControllerDelegate {
    func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        dismiss(animated: true, completion: nil)
    }

    func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }

    func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }
}

