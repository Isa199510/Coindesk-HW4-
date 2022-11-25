//
//  Link.swift
//  Coindesk(HW4)
//
//  Created by Иса on 24.11.2022.
//

enum Link: String {
    case urlCoindesk = "https://api.coindesk.com/v1/bpi/currentprice.json"
}

struct Coindesk: Codable {
    let time: Time
    let disclaimer: String?
    let chartName: String?
    let bpi: BPI
    
    var descriptionHeader: String {
        """
Time: \(time.description)
Disclaimer: \(disclaimer ?? "")
Chart name: \(chartName ?? "")
"""
    }
    
    init() {
        self.time = Time(updated: "", updatedISO: "", updateduk: "")
        self.disclaimer = ""
        self.chartName = ""
        self.bpi = BPI(USD: Currency(), GBP: Currency(), EUR: Currency())
    }
    
    init(time: Time?, disclaimer: String, chartName: String, bpi: BPI?) {
        self.time = time ?? Time(updated: "", updatedISO: "", updateduk: "")
        self.disclaimer = disclaimer
        self.chartName = chartName
        self.bpi = bpi ?? BPI(USD: Currency(), GBP: Currency(), EUR: Currency())
    }
    
    init (coindeskData: [String: Any]) {
        let timeUpdated = coindeskData["time"] as? [String: Any]
        let bpiThree = coindeskData["bpi"] as? [String: Any]
        let usd = bpiThree?["USD"] as? [String: Any]
        let gbp = bpiThree?["GBP"] as? [String: Any]
        let eur = bpiThree?["EUR"] as? [String: Any]
        
        self.time = Time(
            updated: timeUpdated?["updated"] as? String,
            updatedISO: timeUpdated?["updatedISO"] as? String,
            updateduk: timeUpdated?["updateduk"] as? String
        )
        self.disclaimer = coindeskData["disclaimer"] as? String
        self.chartName = coindeskData["chartName"] as? String
        self.bpi = BPI(
            USD: Currency(
                code: usd?["code"] as? String,
                symbol: usd?["symbol"] as? String,
                rate: usd?["rate"] as? String,
                description: usd?["description"] as? String,
                rate_float: usd?["rate_float"] as? Float
            ),
            GBP: Currency(
                code: gbp?["code"] as? String,
                symbol: gbp?["symbol"] as? String,
                rate: gbp?["rate"] as? String,
                description: gbp?["description"] as? String,
                rate_float: gbp?["rate_float"] as? Float
            ),
            EUR: Currency(
                code: eur?["code"] as? String,
                symbol: eur?["symbol"] as? String,
                rate: eur?["rate"] as? String,
                description: eur?["description"] as? String,
                rate_float: eur?["rate_float"] as? Float
            )
        )
    }
    
    static func getCoindesk(from value: Any) -> Coindesk {
        guard let coindeskData = value as? [String: Any] else { return Coindesk() }
        return Coindesk(coindeskData: coindeskData)
    }
}

struct Time: Codable, CustomStringConvertible {
    
    var updated: String
    var updatedISO: String
    var updateduk: String
    
    var description: String {
        """
\(updated)
\(updatedISO)
\(updateduk)
"""
    }
    init(updated: String, updatedISO: String, updateduk: String) {
        self.updated = updated
        self.updatedISO = updatedISO
        self.updateduk = updateduk
    }
    
    init(updated: String?, updatedISO: String?, updateduk: String?) {
        self.updated = updated ?? ""
        self.updatedISO = updatedISO ?? ""
        self.updateduk = updateduk ?? ""
    }
}

struct BPI: Codable {
    let USD: Currency
    let GBP: Currency
    let EUR: Currency
}

struct Currency: Codable {
    let code: String
    let symbol: String
    let rate: String
    let description: String
    let rate_float: Float
    
    var descriptionCurency: String {
        """
        Code: \(code)
        Symbol: \(symbol)
        Rate: \(rate)
        Description: \(description)
        Rate float: \(rate_float)
        """
    }
    
    init(code: String?, symbol: String?, rate: String?, description: String?, rate_float: Float?) {
        self.code = code ?? ""
        self.symbol = symbol ?? ""
        self.rate = rate ?? ""
        self.description = description ?? ""
        self.rate_float = rate_float ?? 0
    }
    init() {
        self.code = ""
        self.symbol = ""
        self.rate = ""
        self.description = ""
        self.rate_float = 0
    }
}
