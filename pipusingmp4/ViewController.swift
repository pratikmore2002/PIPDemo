import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var pipButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    
    var playerViewController: AVPlayerViewController?
    var player: AVPlayer?
    var isInPipMode = false
    var isVideoPaused = false
    var floatingPlayerView: UIView?
    
    let mp4VideoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")! // Hard-coded MP4 link
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
        
        // Set up PiP button action
        pipButton.addTarget(self, action: #selector(togglePiPMode), for: .touchUpInside)
        
        // Set up Play/Pause button action
        playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        
        closeButton.addTarget(self, action: #selector(closeVideoView), for: .touchUpInside)
    }
    
    func setupVideoPlayer() {
        // Set up AVPlayer with hardcoded MP4 URL
        player = AVPlayer(url: mp4VideoURL)
        
        // Set up AVPlayerViewController
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 250)
        self.view.addSubview(playerViewController!.view)
    }
    
    @objc func togglePiPMode() {
        if isInPipMode {
            exitPiPMode()
        } else {
            enterPiPMode()
        }
    }
    
    func enterPiPMode() {
        // Create a smaller, floating version of playerViewController's view if not already created
        if floatingPlayerView == nil {
            floatingPlayerView = UIView(frame: CGRect(x: 20, y: 150, width: 350, height: 200))
            floatingPlayerView?.backgroundColor = .black
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            floatingPlayerView?.addGestureRecognizer(panGesture)
        }
        
        if let floatingPlayerView = floatingPlayerView {
            // Remove the original player view from the main view
            playerViewController?.view.removeFromSuperview()
            
            // Add player view to the floating view
            floatingPlayerView.addSubview(playerViewController!.view)
            playerViewController?.view.frame = floatingPlayerView.bounds
            playerViewController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Add the floating view to the main view
            view.addSubview(floatingPlayerView)
            
            // Play video if it was paused
            if isVideoPaused {
                player?.play() // Resume video
            }
        }
        
        isInPipMode = true
    }
    
    func exitPiPMode() {
        // Restore playerViewController's view to its original position
        if let floatingPlayerView = floatingPlayerView {
            playerViewController?.view.removeFromSuperview()
            view.addSubview(playerViewController!.view)
            playerViewController?.view.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 250)
            floatingPlayerView.removeFromSuperview()
            self.floatingPlayerView = nil
        }
        
        isInPipMode = false
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        guard let floatingPlayerView = floatingPlayerView else { return }
        let translation = gesture.translation(in: view)
        floatingPlayerView.center = CGPoint(x: floatingPlayerView.center.x + translation.x, y: floatingPlayerView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }
    
    @objc func togglePlayPause() {
        if isVideoPaused {
            player?.play()
        } else {
            player?.pause()
        }
        
        isVideoPaused.toggle()
        updatePlayPauseButton()
    }
    
    func updatePlayPauseButton() {
        if isVideoPaused {
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    @objc func closeVideoView() {
           // Stop the video and exit PiP mode
           player?.pause()
           isVideoPaused = true
           exitPiPMode()
           
           // Dismiss the current view controller
           self.dismiss(animated: true, completion: nil)
        
       }
}
//changes do
