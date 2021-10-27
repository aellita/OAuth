struct DiskResponse : Codable {
    let items : [DiskFile]?
}

struct DiskFile : Codable {
    let name : String?
    let preview : String?
    let size : Int64?
}
