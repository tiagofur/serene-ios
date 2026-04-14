import Foundation
import UIKit
import PDFKit
import SwiftUI

// MARK: - PDF Export Service
// Pro feature per PRD Section 3.5: "Exportar historial en PDF (Pro)"

final class PDFExportService {
    static let shared = PDFExportService()
    private init() {}

    // MARK: - Public API

    /// Generate a PDF file containing all gratitudes in the date range.
    /// Returns a temporary file URL suitable for sharing via UIActivityViewController.
    func exportGratitudes(
        _ entries: [GratitudeEntry],
        userName: String,
        dateRange: ClosedRange<Date>?
    ) -> URL? {
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: {
            let format = UIGraphicsPDFRendererFormat()
            format.documentInfo = [
                kCGPDFContextCreator as String: "Serene",
                kCGPDFContextAuthor as String: userName,
                kCGPDFContextTitle as String: "Mi Diario de Gratitud",
            ]
            return format
        }())

        let fileName = "serene-gratitud-\(Int(Date().timeIntervalSince1970)).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try renderer.writePDF(to: tempURL) { ctx in
                renderCoverPage(
                    context: ctx,
                    pageRect: pageRect,
                    userName: userName,
                    totalEntries: entries.count,
                    dateRange: dateRange
                )

                // Group entries by date (newest first)
                let grouped = Dictionary(grouping: entries) { entry in
                    Calendar.current.startOfDay(for: entry.createdAt)
                }
                .sorted { $0.key > $1.key }

                for (date, dayEntries) in grouped {
                    renderDayPage(
                        context: ctx,
                        pageRect: pageRect,
                        date: date,
                        entries: dayEntries.sorted { $0.createdAt < $1.createdAt }
                    )
                }
            }
            return tempURL
        } catch {
            print("PDF export failed: \(error)")
            return nil
        }
    }

    // MARK: - Pages

    private func renderCoverPage(
        context: UIGraphicsPDFRendererContext,
        pageRect: CGRect,
        userName: String,
        totalEntries: Int,
        dateRange: ClosedRange<Date>?
    ) {
        context.beginPage()
        let cgContext = context.cgContext

        // Background
        cgContext.setFillColor(UIColor(Color(hex: "FDFAF6")).cgColor)
        cgContext.fill(pageRect)

        // Title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Georgia", size: 40) ?? UIFont.systemFont(ofSize: 40, weight: .regular),
            .foregroundColor: UIColor(Color(hex: "2D2420")),
        ]
        let title = "Mi diario de gratitud"
        title.draw(at: CGPoint(x: 60, y: 200), withAttributes: titleAttributes)

        // User name
        let nameAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor(Color(hex: "7C6E5A")),
        ]
        userName.draw(at: CGPoint(x: 60, y: 265), withAttributes: nameAttrs)

        // Metadata box
        let meta: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor(Color(hex: "9E8A78")),
        ]

        var y: CGFloat = 360
        "\(totalEntries) gratitudes registradas".draw(at: CGPoint(x: 60, y: y), withAttributes: meta)
        y += 20

        if let range = dateRange {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es")
            formatter.dateStyle = .long
            let periodText = "Del \(formatter.string(from: range.lowerBound)) al \(formatter.string(from: range.upperBound))"
            periodText.draw(at: CGPoint(x: 60, y: y), withAttributes: meta)
            y += 20
        }

        // Footer
        let footer: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10, weight: .regular),
            .foregroundColor: UIColor(Color(hex: "9E8A78")),
        ]
        "Exportado desde Serene · \(Date().formatted(date: .abbreviated, time: .omitted))".draw(
            at: CGPoint(x: 60, y: pageRect.height - 50),
            withAttributes: footer
        )

        // Accent line
        cgContext.setStrokeColor(UIColor(Color(hex: "5A7A6B")).cgColor)
        cgContext.setLineWidth(2)
        cgContext.move(to: CGPoint(x: 60, y: 320))
        cgContext.addLine(to: CGPoint(x: 140, y: 320))
        cgContext.strokePath()
    }

    private func renderDayPage(
        context: UIGraphicsPDFRendererContext,
        pageRect: CGRect,
        date: Date,
        entries: [GratitudeEntry]
    ) {
        context.beginPage()
        let cgContext = context.cgContext

        // Background
        cgContext.setFillColor(UIColor(Color(hex: "FDFAF6")).cgColor)
        cgContext.fill(pageRect)

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es")
        formatter.dateFormat = "EEEE, d 'de' MMMM 'de' yyyy"

        let dateAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Georgia", size: 22) ?? UIFont.systemFont(ofSize: 22),
            .foregroundColor: UIColor(Color(hex: "2D2420")),
        ]
        formatter.string(from: date).capitalized.draw(
            at: CGPoint(x: 60, y: 60),
            withAttributes: dateAttrs
        )

        // Accent line
        cgContext.setStrokeColor(UIColor(Color(hex: "5A7A6B")).cgColor)
        cgContext.setLineWidth(1)
        cgContext.move(to: CGPoint(x: 60, y: 100))
        cgContext.addLine(to: CGPoint(x: pageRect.width - 60, y: 100))
        cgContext.strokePath()

        var y: CGFloat = 120
        let contentWidth = pageRect.width - 120

        for (index, entry) in entries.enumerated() {
            // Page break guard
            if y > pageRect.height - 140 {
                context.beginPage()
                cgContext.setFillColor(UIColor(Color(hex: "FDFAF6")).cgColor)
                cgContext.fill(pageRect)
                y = 60
            }

            // Index + emoji
            let headerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11, weight: .medium),
                .foregroundColor: UIColor(Color(hex: "9E8A78")),
            ]
            let tag = entry.isExtra ? "EXTRA" : "GRATITUD \(index + 1)"
            "\(tag)  \(entry.emoji)".draw(
                at: CGPoint(x: 60, y: y),
                withAttributes: headerAttrs
            )
            y += 20

            // Text
            let bodyAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: UIColor(Color(hex: "2D2420")),
            ]
            let textRect = CGRect(x: 60, y: y, width: contentWidth, height: 500)
            let textSize = entry.text.boundingRect(
                with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: bodyAttrs,
                context: nil
            )
            entry.text.draw(in: textRect, withAttributes: bodyAttrs)
            y += textSize.height + 8

            // Coach response
            if let response = entry.aiResponse, !response.isEmpty {
                let coachAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.italicSystemFont(ofSize: 12),
                    .foregroundColor: UIColor(Color(hex: "7C6E5A")),
                ]
                let coachRect = CGRect(x: 80, y: y, width: contentWidth - 20, height: 500)
                let coachSize = response.boundingRect(
                    with: CGSize(width: contentWidth - 20, height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: coachAttrs,
                    context: nil
                )

                // Left accent bar
                cgContext.setFillColor(UIColor(Color(hex: "5A7A6B")).cgColor)
                cgContext.fill(CGRect(x: 66, y: y, width: 2, height: coachSize.height))

                response.draw(in: coachRect, withAttributes: coachAttrs)
                y += coachSize.height + 18
            } else {
                y += 10
            }

            // Entry separator
            if index < entries.count - 1 {
                cgContext.setStrokeColor(UIColor(Color(hex: "D4C5B0")).cgColor)
                cgContext.setLineWidth(0.5)
                cgContext.move(to: CGPoint(x: 60, y: y))
                cgContext.addLine(to: CGPoint(x: pageRect.width - 60, y: y))
                cgContext.strokePath()
                y += 18
            }
        }

        // Page footer
        let footer: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: UIColor(Color(hex: "9E8A78")),
        ]
        "Serene".draw(
            at: CGPoint(x: pageRect.width - 100, y: pageRect.height - 40),
            withAttributes: footer
        )
    }
}
