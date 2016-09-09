//
//  ViewController.swift
//  Puzzler
//
//  Created by Curtis Wang on 9/9/16.
//  Copyright © 2016 Curtis Wang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet var tiles: [UIButton]!
    var backgroundColors = [UIColor.blueColor(), UIColor.redColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.purpleColor(), UIColor.blueColor(), UIColor.blackColor(), UIColor.whiteColor(), UIColor.orangeColor()]
    var currentImage = "grumpy"
    var audioPlayer = AVAudioPlayer()
    
    var board = [["","",""],
                 ["","",""],
                 ["","",""]
                ]
    var emptyTile = [2,2]
    
    let images = ["grumpy": ["grumpy1", "grumpy2", "grumpy3", "grumpy4", "grumpy5", "grumpy6", "grumpy7", "grumpy8", "grumpy9"], "splashing": ["splashing1", "splashing2", "splashing3", "splashing4", "splashing5", "splashing6", "splashing7", "splashing8", "splashing9"], "office": ["office1", "office2", "office3", "office4", "office5", "office6", "office7", "office8", "office9"]]
    
    let buttonTagsToArrayIndexes = [1: [0,0], 2: [0,1], 3: [0,2], 4: [1,0], 5: [1,1], 6: [1,2], 7: [2,0], 8: [2,1], 9: [2,2]]
    let arrayIndexesToButtonTags = [[0,0]: 1, [0,1]: 2, [0,2]: 3, [1,0]: 4, [1,1]: 5, [1,2]: 6, [2,0]: 7, [2,1]: 8, [2,2]: 9]
    
    
    @IBAction func tilePressed(sender: UIButton) {
        print(sender.tag)
        let row = buttonTagsToArrayIndexes[sender.tag]![0]
        let column = buttonTagsToArrayIndexes[sender.tag]![1]
        
        if (row - emptyTile[0] == 0 && abs(column - emptyTile[1]) == 1) || (column - emptyTile[1] == 0 && abs(row - emptyTile[0]) == 1) {
            print("********")
            print(tiles)
            for tile in tiles {
                if tile.tag == arrayIndexesToButtonTags[emptyTile] {
                    print("yes")
                    tiles[arrayIndexesToButtonTags[emptyTile]!-1].setBackgroundImage(UIImage(named: board[buttonTagsToArrayIndexes[sender.tag]![0]][buttonTagsToArrayIndexes[sender.tag]![1]]), forState: UIControlState.Normal)
                    print("sdasd")
                    board[emptyTile[0]][emptyTile[1]] = board[buttonTagsToArrayIndexes[sender.tag]![0]][buttonTagsToArrayIndexes[sender.tag]![1]]
                    board[buttonTagsToArrayIndexes[sender.tag]![0]][buttonTagsToArrayIndexes[sender.tag]![1]] = ""
                    
                    
                }
            }
            print(board)
            tiles[sender.tag-1].setBackgroundImage(nil, forState: UIControlState.Normal)
            print(emptyTile)
            emptyTile = buttonTagsToArrayIndexes[sender.tag]!
            print(emptyTile)
            if checkCompletion() {
                if let asset = NSDataAsset(name:"YouDidIt") {
                    
                    
                    do {
                        try audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                        audioPlayer.play()
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                }
            }
        } else {
            print("NO")
        }
    }
    
    @IBAction func shuffleButtonPressed(sender: UIButton) {
        shuffle()
    }
    func shuffle() {
        var randomimages = [0,1,2,3,4,5,6,7]
        emptyTile = [2,2]
        for i in 0...7 {
            var rand = arc4random_uniform(UInt32(randomimages.count))
            tiles[i].setBackgroundImage(UIImage(named: images[currentImage]![randomimages[Int(rand)]]), forState: UIControlState.Normal)
            board[buttonTagsToArrayIndexes[i+1]![0]][buttonTagsToArrayIndexes[i+1]![1]] = images[currentImage]![randomimages[Int(rand)]]
            randomimages.removeAtIndex(Int(rand))
        }
        tiles[8].setBackgroundImage(nil, forState: UIControlState.Normal)
        board[2][2] = ""
        
    }
    
    func checkCompletion() -> Bool {
        var complete = true
        var count = 1
        for row in board {
            for tile in row{
                if tile != currentImage + String(count) && count < 9 {
                    complete = false
                }
                count += 1
            }
        }
        return complete
    }
    
    @IBAction func randomImagePressed(sender: UIButton) {
        let randImg = ["grumpy", "splashing", "office"]
        var rand = arc4random_uniform(3)
        currentImage = randImg[Int(rand)]
        shuffle()
        if rand == 0{
            if let asset = NSDataAsset(name:"mortalkombat") {
                do {
                    try audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                    audioPlayer.play()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        } else if rand == 1{
            if let asset = NSDataAsset(name:"whatislove") {
                do {
                    try audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                    audioPlayer.play()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
        } else if rand == 2 {
            if let asset = NSDataAsset(name:"caramel") {
                do {
                    try audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                    audioPlayer.play()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for i in 0...7 {
            tiles[i].setBackgroundImage(UIImage(named: images[currentImage]![i]), forState: UIControlState.Normal)
            board[buttonTagsToArrayIndexes[i+1]![0]][buttonTagsToArrayIndexes[i+1]![1]] = images[currentImage]![i]
        }
        if let asset = NSDataAsset(name:"mortalkombat") {
            do {
                try audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                audioPlayer.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("changeBackground"), userInfo: nil, repeats: true)

        print(board)
    }
    
    func changeBackground() {
        var randColor = backgroundColors[Int(arc4random_uniform(UInt32(backgroundColors.count)))]
        self.view.backgroundColor = randColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

