//
//  ViewController.swift
//  NSBezierPath_Paint
//
//  Created by Saranjitharunesh Chockan on 2/24/18.
//  Copyright © 2018 Saranjitharunesh Chockan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController{

    var paint: Paint = Paint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: 480, height: 240)
        paint = Paint(frame: frame)
        view.addSubview(paint)

    }
    override func viewDidAppear() {
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    @IBAction func drawLine(_ sender: Any) {
        paint.drawLine()
    }
    
    @IBAction func drawRect(_ sender: Any) {
        paint.drawRect()
    }
    
    @IBAction func drawCircle(_ sender: Any) {
       paint.drawCircle()
    }
    
    @IBAction func drawOval(_ sender: Any) {
        paint.drawOval()
    }
    
    @IBAction func undo(_ sender: Any) {
        paint.undo()
    }
}


class Paint: NSView {
    
    var drag: Bool = false
    var SP = NSPoint()
    var arrayofPaths: [NSBezierPath] = []
    var index: Int = 0
    var firstLine:Int = 0
    var line: Bool = true
    var rect: Bool = false
    var circle: Bool = false
    var oval: Bool = false
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.red.set()
        __NSRectFill(dirtyRect)
        NSColor.black.set()
        
        for line in arrayofPaths{
            line.stroke()
        }
        
    }
    
    override func mouseDown(with event: NSEvent) {
        firstLine = 0
        drag = false
        let startPoint = event.locationInWindow
        SP = NSPoint()
        SP = self.convert(startPoint, from: nil)
    }
    
    
    override func mouseDragged(with event: NSEvent) {
        
        let endPoint = event.locationInWindow
        var EP = NSPoint()
        EP = self.convert(endPoint, from: nil)
        if line{
            let line = NSBezierPath()
            
            if firstLine != 0{
                arrayofPaths.removeLast()
            }
            
            firstLine = 1
            arrayofPaths.insert(line, at: index)
            arrayofPaths.last?.move(to: SP)
            arrayofPaths.last?.line(to: EP)
            
            drag = true
            needsDisplay = true
        }
        else if rect{
            let rectPaint = NSBezierPath()
            if firstLine != 0{
                arrayofPaths.removeLast()
            }
            firstLine = 1
            arrayofPaths.insert(rectPaint, at: index)
            let rect = NSRect(x: SP.x, y: SP.y, width: EP.x - SP.x, height: EP.y - SP.y)
            rectPaint.appendRect(rect)
            drag = true
            needsDisplay = true
        }
        
        else if circle{
            let circle = NSBezierPath()
            if firstLine != 0{
                arrayofPaths.removeLast()
            }
            firstLine = 1
            arrayofPaths.insert(circle, at: index)
            circle.appendArc(withCenter: SP, radius: EP.x - SP.x, startAngle: 0, endAngle: 360, clockwise: false)
            drag = true
            needsDisplay = true
        }
        
        else if oval{
            let oval = NSBezierPath()
            if firstLine != 0{
                arrayofPaths.removeLast()
            }
            firstLine = 1
            arrayofPaths.insert(oval, at: index)
            let rect = NSRect(x: SP.x, y: SP.y, width: EP.x - SP.x, height: EP.y - SP.y)
            oval.appendOval(in: rect)
            drag = true
            needsDisplay = true
        }

        
    }
    
    override func mouseUp(with event: NSEvent) {
        if drag==true{
            index+=1
        }
    }
    
    func drawLine(){
        line = true
        rect = false
        circle = false
        oval = false
    }
    
    func drawRect(){
        line = false
        rect = true
        circle = false
        oval = false
    }
    
    func drawCircle(){
        line = false
        rect = false
        circle = true
        oval = false
    }
    
    func drawOval(){
        line = false
        rect = false
        circle = false
        oval = true
    }
    
    func undo(){
        if arrayofPaths.isEmpty==false{
            arrayofPaths.removeLast()
            index = index-1
            needsDisplay = true
        }
    }
}

