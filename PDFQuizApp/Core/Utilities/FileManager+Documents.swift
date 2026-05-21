import Foundation

extension FileManager {
    var documentsDirectory: URL {
        urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    var importedPDFsDirectory: URL {
        let dir = documentsDirectory.appendingPathComponent(Constants.documentsSubdirectory)
        if !fileExists(atPath: dir.path) {
            try? createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    func uniquePDFURL(for filename: String) -> URL {
        let baseName = (filename as NSString).deletingPathExtension
        let ext = (filename as NSString).pathExtension
        var url = importedPDFsDirectory.appendingPathComponent(filename)
        var counter = 1
        while fileExists(atPath: url.path) {
            url = importedPDFsDirectory.appendingPathComponent("\(baseName)_\(counter).\(ext)")
            counter += 1
        }
        return url
    }

    func fileSize(at url: URL) -> Int64? {
        guard let attrs = try? attributesOfItem(atPath: url.path) else { return nil }
        return attrs[.size] as? Int64
    }

    func removeFile(at url: URL) throws {
        if fileExists(atPath: url.path) {
            try removeItem(at: url)
        }
    }
}
