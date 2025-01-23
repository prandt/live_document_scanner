package com.rprandt.live_document_scanner

enum class LiveDocumentScannerType(val value: String) {
    PDF("pdf"),
    IMAGES("images");

    companion object {
        fun fromValue(value: String): LiveDocumentScannerType {
            return values().firstOrNull { it.value == value }
                ?: throw IllegalArgumentException("Unknown value $value")
        }
    }
}

class LiveDocumentScannerProperties(var pageLimit: Int = 5, var galleryImportAllowed: Boolean = true, var type: LiveDocumentScannerType = LiveDocumentScannerType.PDF) {

    companion object {
        fun fromMap(map: Any): LiveDocumentScannerProperties {
            if (map !is Map<*, *>) {
                throw IllegalArgumentException("Expected map but got $map")
            }
            val pageLimit = map["pageLimit"] as? Int ?: 4
            val galleryImportAllowed = map["galleryImportAllowed"] as? Boolean ?: true
            val type = map["type"] as? String ?: LiveDocumentScannerType.PDF.value
            return LiveDocumentScannerProperties(pageLimit, galleryImportAllowed, LiveDocumentScannerType.fromValue(type))
        }
    }

}