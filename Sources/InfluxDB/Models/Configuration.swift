import Vapor

public struct InfluxDBConfiguration {
    public let url: URL
    public let token: String
    public let bucketName: String
    public let orgName: String

    public init(url: URL, token: String, bucketName: String, orgName: String) {
        self.url = url
        self.token = token
        self.bucketName = bucketName
        self.orgName = orgName
    }

    public static var environment: InfluxDBConfiguration {
        guard
            let urlString = Environment.get("INFLUX_DB_URL"),
            let url = URL(string: urlString),
            let token = Environment.get("INFLUX_DB_TOKEN"),
            let bucketName = Environment.get("INFLUX_DB_BUCKET_NAME"),
            let orgName = Environment.get("INFLUX_DB_ORG_NAME")
        else {
            fatalError("InfluxDB environment variables not set")
        }
        return .init(url: url, token: token, bucketName: bucketName, orgName: orgName)
    }
}
