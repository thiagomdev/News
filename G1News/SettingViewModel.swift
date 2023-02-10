import Foundation

final class SettingViewModel {
    func openSignInLink() -> String {
        guard let url = URL(string: "https://login.globo.com/login/6906/connect-confirm?url=https%3A%2F%2Fid.globo.com%2Fauth%2Frealms%2Fglobo.com%2Flogin-actions%2Fauthenticate%3Fsession_code%3DVAKieyj7W5HsPEKtC5XEbMXhElOp-vt0JGXLMLm3Tq0%26execution%3Db5dd88dc-447e-468f-945e-e7c7de4883b7%26client_id%3Dapp-g1-ios%2540globoid-connect%26tab_id%3DMTtLirEPBFM%26request-context%3DvGgSp8&error=&request-context=vGgSp8&platform=ios-app") else { return "" }
        
        return "\(url)"
    }
}
