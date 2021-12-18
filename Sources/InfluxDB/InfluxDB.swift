import Vapor
import InfluxDBSwift

public struct InfluxDB {
    let application: Application

    final class Storage {
        let client: InfluxDBClient

        init(config: InfluxDBConfiguration) {
            let options = InfluxDBClient.InfluxDBOptions(
                bucket: config.bucketName,
                org: config.orgName
            )
            client = .init(
                url: config.url.absoluteString,
                token: config.token,
                options: options
            )
        }
    }

    public var client: InfluxDBClient {
        storage.client
    }

    struct Key: StorageKey {
        typealias Value = Storage
    }

    var storage: Storage {
        if self.application.storage[Key.self] == nil {
            self.initialize()
        }
        return self.application.storage[Key.self]!
    }

    struct Lifecycle: LifecycleHandler {
        func shutdown(_ application: Application) {
            application.influxDB.shutdown()
        }
    }

    func initialize() {
        guard let config = configuration else {
            fatalError("Missing influxDB configuration.")
        }
        self.application.storage[Key.self] = .init(config: config)
        self.application.lifecycle.use(Lifecycle())
    }

    public init(_ app: Application) {
        application = app
    }

    func shutdown() {
        self.storage.client.close()
    }
}

extension InfluxDB {
    struct ConfigurationKey: StorageKey {
        typealias Value = InfluxDBConfiguration
    }

    public var configuration: InfluxDBConfiguration? {
        get {
            application.storage[ConfigurationKey.self]
        }
        nonmutating set {
            application.storage[ConfigurationKey.self] = newValue
        }
    }
}

extension Application {
    public var influxDB: InfluxDB {
        .init(self)
    }
}

extension Request {
    public var influxDB: InfluxDB { .init(application) }
}
