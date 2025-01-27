import Flutter
import UIKit
import VisionKit
import PDFKit

@available(iOS 13.0, *)
public class LiveDocumentScannerPlugin: NSObject, FlutterPlugin, VNDocumentCameraViewControllerDelegate {
    
    enum FlutterDocScannerType: String {
        case pdf = "pdf"
        case images = "images"
        
        init(rawValue: String) {
            switch rawValue.lowercased() {
            case "pdf": self = .pdf
            case "images": self = .images
            default: self = .pdf
            }
        }
    }
    
    struct FlutterDocScannerProperties {
        let type: FlutterDocScannerType
        
        init(from map: [String: Any]) {
            let type = map["type"] as? String ?? "pdf"
            self.type = FlutterDocScannerType(rawValue: type)
        }
    }
    
    var resultChannel: FlutterResult?
    var presentingController: VNDocumentCameraViewController?
    var currentMethod: String?
    var properties: FlutterDocScannerProperties?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "live_document_scanner", binaryMessenger: registrar.messenger())
        let instance = LiveDocumentScannerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "scanDocument":
            if let args = call.arguments as? [String: Any] {
                self.properties = FlutterDocScannerProperties(from: args)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS",
                                    message: "Arguments must be a map.",
                                    details: nil))
            }
            startScan(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startScan(result: @escaping FlutterResult) {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else {
            result(FlutterError(
                code: "NO_ROOT_VIEW_CONTROLLER",
                message: "Unable to acccess the root view controller",
                details: nil))
            return
        }
        
        self.resultChannel = result
        
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        self.presentingController = documentCameraViewController
        
        rootViewController.present(documentCameraViewController, animated: true)
    }
    
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        switch properties?.type {
        case .pdf:
            saveScannedPdf(scan: scan)
        case .images:
            saveScannedImages(scan: scan)
        case nil:
            resultChannel?(FlutterError(code: "TYPE_NULL",
                                        message: "No type are defined",
                                        details: nil))
        }
        presentingController?.dismiss(animated: true)
    }
    
    
    private func saveScannedImages(scan: VNDocumentCameraScan) {
        let tempDirPath = getDocumentsDirectory()
        let formattedDate = getFormattedDate()
        var filenames: [String] = []
        for i in 0 ..< scan.pageCount {
            let page = scan.imageOfPage(at: i)
            let url = tempDirPath.appendingPathComponent(formattedDate + "-\(i).png")
            try? page.pngData()?.write(to: url)
            filenames.append(url.path)
        }
        resultChannel?(["images": filenames,
                        "pdf": nil,
                        "count": scan.pageCount,
                        "type": FlutterDocScannerType.images.rawValue])
    }
    
    private func saveScannedPdf(scan: VNDocumentCameraScan) {
        let tempDirPath = getDocumentsDirectory()
        let formattedDate = getFormattedDate()
        let pdfFilePath = tempDirPath.appendingPathComponent("\(formattedDate).pdf")
        
        let pdfDocument = PDFDocument()
        for i in 0 ..< scan.pageCount {
            let pageImage = scan.imageOfPage(at: i)
            if let pdfPage = PDFPage(image: pageImage) {
                pdfDocument.insert(pdfPage, at: pdfDocument.pageCount)
            }
        }
        pdfDocument.write(to: pdfFilePath)
        resultChannel?(["images": nil,
                        "pdf": pdfFilePath.path,
                        "count": scan.pageCount,
                        "type": FlutterDocScannerType.pdf.rawValue])
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getFormattedDate() -> String {
        let currentDateTime = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd-HHmmss"
        return df.string(from: currentDateTime)
    }
    
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        resultChannel?(nil)
        presentingController?.dismiss(animated: true)
    }
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        resultChannel?(FlutterError(code: "SCAN_ERROR", message: "Failed to scan documents", details: error.localizedDescription))
        presentingController?.dismiss(animated: true)
    }
    
}
