//
//  ContentView.swift
//  AquarioApp
//
//  Created by Joaquim P. Filho on 12/10/21.
//

import SwiftUI

public enum ValuePosition {
    case top
    case middle
    case botton
    case none
}

public enum ValuePrecision: Int {
    case zero = 0
    case one = 1
    case two = 2
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct CurveSliderView: View {
    @Binding
    public var value: Double
    public var minValue: Double = 0
    public var maxValue: Double = 100
    public var height: CGFloat = 30
    public var length: CGFloat = 90
    public var lineWidth: CGFloat = 10
    public var valuePosition: ValuePosition = .middle
    public var valuePrecision: ValuePrecision = .one
    
    public init(value: Binding<Double>,
                minValue: Double = 0,
                maxValue: Double = 100,
                height: CGFloat = 30,
                length: CGFloat = 90,
                lineWidth: CGFloat = 10,
                valuePosition: ValuePosition = .middle,
                valuePrecision: ValuePrecision = .one) {
        self._value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.height = height
        self.length = length
        self.lineWidth = lineWidth
        self.valuePosition = valuePosition
        self.valuePrecision = valuePrecision
    }
    
    private func convert(value: Double, width: Double, margin: Double) -> Double {
        return (value - minValue) * (width - margin) / (maxValue - minValue) + margin;
    }
    
    public var body: some View {
        VStack {
            let margin: CGFloat = length/2
            
            GeometryReader { geometry in
                ZStack {
                    let width = geometry.size.width - margin
                    let centerY = geometry.size.height/2.0
                    let heightY: CGFloat = centerY + height
                    
                    let valueConverted = convert(value: value, width: width, margin: margin)
                    
                    let startX: CGFloat = valueConverted - length/2
                    let endX: CGFloat = valueConverted + length/2
                    let midPoint: CGFloat = (startX + length/2 )
                    let apex1: CGFloat = (startX + midPoint) / 2
                    let apex2: CGFloat = midPoint + (endX - midPoint) / 2
                    
                    Path { path in
                        path.addLines([
                            CGPoint(x: 0, y: centerY + height),
                            CGPoint(x: startX, y: centerY + height),
                        ])
                        
                        path.move(to: CGPoint(x: startX, y: heightY))
                        
                        path.addCurve(
                            to:         CGPoint(x: midPoint,    y: centerY),
                            control1:   CGPoint(x: apex1,       y: heightY),
                            control2:   CGPoint(x: apex1,       y: centerY)
                        )
                        
                        path.addCurve(
                            to: CGPoint(x: endX, y: heightY),
                            control1: CGPoint(x: apex2, y: centerY),
                            control2: CGPoint(x: apex2, y: heightY)
                        )
                        
                        path.addLines([
                            CGPoint(x: endX, y: centerY + height),
                            CGPoint(x: geometry.size.width, y: centerY + height),
                        ])
                    }.stroke(LinearGradient(gradient: Gradient(colors: [.blue, .green, .red]), startPoint: .leading, endPoint: .trailing),
                             lineWidth: lineWidth)
                    
                    let format = "%.\(self.valuePrecision.rawValue)f %@"
                    let textYPosition = { () -> CGFloat? in
                        switch self.valuePosition {
                        case .top:
                            return centerY - (height >= 10 ? height*0.1 : 0) - (lineWidth >= 10 ? lineWidth*0.4 : 0)
                        case .botton:
                            return centerY + height + 10 + (lineWidth >= 10 ? lineWidth*0.8 : 10)
                        case .middle:
                            return centerY + height
                        case .none:
                            return nil
                        }
                    }
                    
                    if let yPosition = textYPosition() {
                        Text(String.localizedStringWithFormat(format, value, ""))
                            .font(.system(size: 12))
                            .frame(height: 1, alignment: .bottom)
                            .position(
                                x: valueConverted,
                                y: yPosition)
                    }
                }
            }
        }
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
struct CurveSliderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CurveSliderView(value: .constant(100.0))
        }
    }
}

