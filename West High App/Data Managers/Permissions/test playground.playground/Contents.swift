import UIKit

let tempdict = ["1": ["a", "b", "c"], "2": ["d, e, f"]]
for item in tempdict {
    if item.key == "1" {
        if item.value.contains("a") {
            print("yes")
        }
    }
}
