//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func get() -> (Bool, Int) {
    return (true, 1)
}

func talk() {
    if let (b, i) = get() where b == true {
        print("haha")
    }
}