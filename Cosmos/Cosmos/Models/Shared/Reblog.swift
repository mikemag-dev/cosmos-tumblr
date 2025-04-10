import Foundation

struct Reblog: Decodable {
    let comment: String? // HTML content
    let treeHtml: String?

     enum CodingKeys: String, CodingKey {
         case comment
         case treeHtml = "tree_html"
     }
}
