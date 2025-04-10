protocol TumblrDataProvidable {
    func getPosts(blogId: String) async throws -> GetPostsResponse
}
