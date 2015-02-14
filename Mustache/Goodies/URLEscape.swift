// The MIT License
//
// Copyright (c) 2015 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Foundation

class URLEscape : MustacheBoxable {
    
    var mustacheBox: MustacheBox {
        return Box(
            value: self,
            filter: Filter(filter),
            willRender: willRender)
    }
    
    private func filter(rendering: Rendering, error: NSErrorPointer) -> Rendering? {
        return Rendering(URLEscape.escapeURL(rendering.string), rendering.contentType)
    }
    
    private func willRender(tag: Tag, box: MustacheBox) -> MustacheBox {
        switch tag.type {
        case .Variable:
            // We don't know if the box contains a String, so let's escape its
            // rendering.
            return Box({ (info: RenderingInfo, error: NSErrorPointer) -> Rendering? in
                if let rendering = box.render(info: info, error: error) {
                    return self.filter(rendering, error: error)
                } else {
                    return nil
                }
            })
        case .Section:
            return box
        }
    }
    
    private class func escapeURL(string: String) -> String {
        var s = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as NSMutableCharacterSet
        s.removeCharactersInString("?&=")
        return string.stringByAddingPercentEncodingWithAllowedCharacters(s) ?? ""
    }
}
