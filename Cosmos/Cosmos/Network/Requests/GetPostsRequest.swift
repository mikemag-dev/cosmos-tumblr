struct GetPostsRequest {
    enum PostType: String {
        case text
        case quote
        case link
        case answer
        case video
        case audio
        case photo
        case chat
    }
    
    let blogId: String
    let type: PostType
    let offset: Int
    let pageSize: Int
}
