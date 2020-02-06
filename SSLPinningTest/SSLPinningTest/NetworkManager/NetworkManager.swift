//
//  NetworkManager.swift
//  SSLPinningTest
//
//  Created by Abhishek Chaudhari on 06/02/20.
//  Copyright © 2020 Abhishek Chaudhari. All rights reserved.
//


// download cert
//openssl s_client -connect www.facebook.com:443 -servername www.facebook.com </dev/null | openssl x509 -outform DER > fb.cer
import Foundation
import Alamofire

class NetworkManager {
    static let networkManager = NetworkManager()
    var manager: Session!
    
    fileprivate init() { }
    
    
    func publicKeyPinningTest() {
        let keys = getPublicKeys()
        let evaluators = ["www.facebook.com" : PublicKeysTrustEvaluator(keys: keys, performDefaultValidation: true, validateHost: true)]
        manager = Session(configuration: .default,
                                serverTrustManager: ServerTrustManager(evaluators: evaluators))
        manager.request("https://www.facebook.com").response { (response) in
            if response.error == nil {
                print("public key pinning valid")
                print(response.response?.statusCode ?? "empty")
            } else {
                print("cert expired: \(String(describing: response.error?.localizedDescription))")
            }
        }
    }
    
    func certificatePinningTest() {
        let certs = getCertificates()
        let evaluators = ["www.facebook.com" : PinnedCertificatesTrustEvaluator(certificates: certs, acceptSelfSignedCertificates: false, performDefaultValidation: true, validateHost: true)]
        manager = Session(configuration: .default,
                                serverTrustManager: ServerTrustManager(evaluators: evaluators))
        
        manager.request("https://www.facebook.com").response { (response) in
            if response.error == nil {
                print("cert valid")
                print(response.response?.statusCode ?? "empty")
            } else {
                print("cert expired: \(String(describing: response.error?.localizedDescription))")
            }
        }
    }
    
    
    private func getCertificates() -> [SecCertificate] {
        let url = Bundle.main.url(forResource: "fb", withExtension: "cer")!
        let localCertificate = try! Data(contentsOf: url) as CFData
        
        guard let certificate = SecCertificateCreateWithData(nil, localCertificate)
            else {
                return []
        }
        return [certificate]
    }
    private func getPublicKeys() -> [SecKey] {
        let url = Bundle.main.url(forResource: "fb", withExtension: "cer")!
        let localCertificate = try! Data(contentsOf: url) as CFData
        
        guard let certificate = SecCertificateCreateWithData(nil, localCertificate)
            else {
                return []
        }
        guard let key = certificate.af.publicKey else {
            return []
        }
        return [key]
    }

}
