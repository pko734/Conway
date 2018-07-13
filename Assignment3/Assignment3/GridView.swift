//
//  GridView.swift
//  Assignment3
//
//  Created by Paul Oehler on 7/11/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    @IBInspectable var size: Int = 20 {
        didSet {
            grid = Grid(size, size)
        }
    }
    @IBInspectable var livingColor: UIColor = .cyan
    @IBInspectable var emptyColor: UIColor = .white
    @IBInspectable var bornColor: UIColor = .yellow
    @IBInspectable var diedColor: UIColor = .darkGray
    @IBInspectable var gridColor: UIColor = .black
    @IBInspectable var gridWidth: CGFloat = 0
    @IBInspectable var inset: CGFloat = 1.0
    
    var grid: Grid = Grid(0,0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let rect = CGRect(
            x: rect.origin.x + (gridWidth/2.0),
            y: rect.origin.y + (gridWidth/2.0),
            width: rect.size.width - gridWidth,
            height: rect.size.height - gridWidth
        )
        let verticalSpacing = rect.size.height / CGFloat(size)
        let horizontalSpacing = rect.size.width / CGFloat(size)
        let horizontalXStart = rect.origin.x
        let horizontalXEnd = rect.origin.x + rect.size.width
        let verticalYStart = rect.origin.y
        let verticalYEnd = rect.origin.y + rect.size.height
        
        // Horizontal lines
        (0 ... size).forEach { index in
            let y = (CGFloat(index) * verticalSpacing) + rect.origin.y
            let startPoint = CGPoint(x: horizontalXStart, y: y)
            let endPoint = CGPoint(x: horizontalXEnd, y: y)
            
            let horizontalPath = UIBezierPath()
            horizontalPath.lineWidth = gridWidth
            horizontalPath.move(to: startPoint)
            horizontalPath.addLine(to: endPoint)
            gridColor.setStroke()
            horizontalPath.stroke()
        }
        
        // Vertical lines
        (0 ... size).forEach { index in
            let x = (CGFloat(index) * horizontalSpacing) + rect.origin.x
            let startPoint = CGPoint(x: x, y: verticalYStart)
            let endPoint = CGPoint(x: x, y: verticalYEnd)
            
            let verticalPath = UIBezierPath()
            verticalPath.lineWidth = gridWidth
            verticalPath.move(to: startPoint)
            verticalPath.addLine(to: endPoint)
            gridColor.setStroke()
            verticalPath.stroke()
        }
        
        // Cells
        let positionArray = positionSequence(from: (0,0), to: (size,size))
        positionArray.forEach { (row, col) in
            let xOrigin = (CGFloat(col) * verticalSpacing) + rect.origin.x
            let yOrigin = (CGFloat(row) * horizontalSpacing) + rect.origin.y
            //let cellRect = CGRect( x: xOrigin, y: yOrigin, width: verticalSpacing, height: horizontalSpacing)
            
            let cellRect = CGRect(
                x: xOrigin + inset + (gridWidth / 2.0),
                y: yOrigin  + inset + (gridWidth / 2.0),
                width: verticalSpacing - ((2.0 * inset) + (gridWidth)),
                height: horizontalSpacing - ((2.0 * inset) + (gridWidth))
            )
            
            var color: UIColor = .clear
            switch grid[(row,col)] {
            case .alive:
                color = livingColor
            case .born:
                color = bornColor
            case .died:
                color = diedColor
            case .empty:
                color = emptyColor
            }
            
            let path = UIBezierPath(ovalIn: cellRect)
            color.setFill()
            path.fill()
        }
    }
    func convert(touch: UITouch) -> Position? {
        let touchY = touch.location(in: self).y - (gridWidth/2.0)
        let gridHeight = frame.size.height - gridWidth
        let row = touchY / gridHeight * CGFloat(size)
        
        let touchX = touch.location(in: self).x - (gridWidth/2.0)
        let gridWidth2 = frame.size.width - gridWidth
        let col = touchX / gridWidth2 * CGFloat(size)
        
        let pos = Position(row: Int(row), col: Int(col))
        guard pos.row >= 0 && pos.row < size && pos.col >= 0 && pos.col < size else { return nil }
        return pos
    }
    
    var lastPosition: Position?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else { return }
        let touch = touches.first!
        guard let pos = convert(touch: touch) else { return }
        let state = grid[pos]
        grid[pos] = grid[pos].toggle(value: state)
        lastPosition = pos
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else { return }
        let touch = touches.first!
        guard let pos = convert(touch: touch) else { return }
        guard pos.row != lastPosition?.row || pos.col != lastPosition?.col else { return }
        let state = grid[pos]
        grid[pos] = grid[pos].toggle(value: state)
        lastPosition = pos
        setNeedsDisplay()
    }
}
