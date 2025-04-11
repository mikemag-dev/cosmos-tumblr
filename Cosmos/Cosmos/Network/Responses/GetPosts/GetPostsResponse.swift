struct GetPostsResponse: Decodable {
    let meta: Meta
    let response: GetPostsResponseData
}



extension GetPostsResponse: PageableResponse {
    var data: GetPostsResponse {
        self
    }
    
    var total: Int {
        self.response.totalPosts
    }
}
