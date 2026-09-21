import Foundation

public struct DailyCaseGenerator: Sendable {
    public init() {}

    /// Linear Congruential Generator for deterministic pseudo-random sequence
    private struct DeterministicRNG {
        private var state: UInt64

        init(seed: UInt64) {
            self.state = seed != 0 ? seed : 0x123456789ABCDEF
        }

        mutating func next() -> UInt64 {
            state = state &* 6364136223846793005 &+ 1442695040888963407
            return state
        }

        mutating func nextInt(in range: Range<Int>) -> Int {
            let span = UInt64(range.upperBound - range.lowerBound)
            let raw = next() % span
            return range.lowerBound + Int(raw)
        }

        mutating func pickOne<T>(_ array: [T]) -> T {
            let idx = nextInt(in: 0..<array.count)
            return array[idx]
        }
    }

    /// Converts date (or date string YYYY-MM-DD) into a 64-bit integer seed
    public static func seed(from dateString: String) -> UInt64 {
        var hash: UInt64 = 5381
        for byte in dateString.utf8 {
            hash = ((hash << 5) &+ hash) &+ UInt64(byte)
        }
        return hash
    }

    public static func dateString(from date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }

    /// Generates a complete, playable CaseModel for the specified date
    public func generateDailyCase(for date: Date = Date()) -> CaseModel {
        let str = Self.dateString(from: date)
        return generateDailyCase(forDateString: str)
    }

    public func generateDailyCase(forDateString dateString: String) -> CaseModel {
        let initialSeed = Self.seed(from: dateString)
        var rng = DeterministicRNG(seed: initialSeed)

        // Settings pool
        let settings = [
            (loc: "The Grand Meridian Hotel", v: "Arthur Vance", desc: "A venture capitalist found incapacitated in suite 702 during a buyout summit.", time: "23:45"),
            (loc: "North Pier Marina", v: "Capt. Ronald Sterling", desc: "A maritime surveyor found overboard near slip 14 with severed mooring lines.", time: "21:15"),
            (loc: "St. Jude Research Annex", v: "Dr. Elena Rostova", desc: "A molecular biologist poisoned in the cold storage laboratory before trial publication.", time: "22:30"),
            (loc: "Crown Auction Pavilion", v: "Julian Croft", desc: "An antique appraiser discovered behind the vault with a forged Renaissance provenance.", time: "20:45"),
            (loc: "Metropolitan Rail Relay Tower", v: "Marcus Vance", desc: "A signaling supervisor assaulted in the mechanical control cabin during signal blackout.", time: "22:10"),
            (loc: "Bellerose Private Clinic", v: "Dr. Alistair Finch", desc: "A chief pharmacist found in the narcotics dispensary with altered inventory records.", time: "01:20"),
            (loc: "Aegis Financial Tower", v: "Chloe Mercer", desc: "An auditor found locked inside the compliance archive with shredded tax filings.", time: "19:50")
        ]

        let setting = rng.pickOne(settings)
        let caseId = "daily_\(dateString)"
        let title = "Cold Case: \(setting.loc)"
        let subtitle = "Incident of \(dateString) involving \(setting.v)"

        // Suspect archetypes
        let suspectArchetypes = [
            (id: "s1", name: "Vincent Keller", role: "Business Partner", rel: "Co-investor with disputed equity share", prof: "Methodical financier facing urgent liquidity demands."),
            (id: "s2", name: "Claire Dupont", role: "Chief Assistant", rel: "Personal confidante with security key access", prof: "Quietly handles sensitive communications and travel logistics."),
            (id: "s3", name: "Garrison Fox", role: "Facility Contractor", rel: "Third-party maintenance specialist", prof: "Familiar with blind spots in CCTV surveillance and utility ducts.")
        ]

        // Pick culprit index (0, 1, or 2)
        let culpritIdx = rng.nextInt(in: 0..<3)
        let culprit = suspectArchetypes[culpritIdx]

        var suspects: [Suspect] = []
        for (i, arch) in suspectArchetypes.enumerated() {
            let isCulprit = (i == culpritIdx)
            suspects.append(Suspect(
                suspectId: arch.id,
                caseId: caseId,
                name: arch.name,
                role: arch.role,
                relationshipToVictim: arch.rel,
                profile: arch.prof,
                motiveScore: isCulprit ? 0.3 : 0.2,
                meansScore: isCulprit ? 0.4 : 0.1,
                opportunityScore: isCulprit ? 0.3 : 0.2,
                alibiStatus: .claimed,
                suspicionLevel: .moderate,
                initialAlibi: isCulprit ? "Claimed departure prior to incident window via main lobby." : "Verified on remote communication call during incident.",
                knownFacts: ["Present on premises during the evening shift."],
                unlockedFacts: []
            ))
        }

        // Evidence items
        let evIncident = EvidenceItem(
            evidenceId: "ev_incident_report",
            caseId: caseId,
            title: "Coroner Preliminary Report",
            type: .medicalReport,
            summary: "Victim discovered at \(setting.time). Trauma or toxicity initiated between 21:00 and 21:30.",
            fullText: "Physical evaluation of \(setting.v) indicates incident occurred within the primary chamber. Signs of rapid incapacitation.",
            timestamp: "\(setting.time)",
            source: "County Forensic Service",
            reliability: .verified,
            tags: ["Incident", "Medical"],
            isKeyEvidence: true,
            isPinned: true,
            relatedSuspectIds: suspects.map { $0.suspectId },
            discoveredInitially: true
        )

        let evAlibiClaim = EvidenceItem(
            evidenceId: "ev_culprit_statement",
            caseId: caseId,
            title: "\(culprit.name) Interview",
            type: .statement,
            summary: "\(culprit.name) states they exited the facility at 20:50, prior to the critical window.",
            fullText: "\"I took the east service stairwell at precisely 20:50 to catch my scheduled car. I did not return.\"",
            timestamp: "20:50 (Claimed)",
            source: "Field Detective Interview",
            reliability: .medium,
            tags: ["Statement", "Alibi"],
            isKeyEvidence: true,
            isPinned: true,
            relatedSuspectIds: [culprit.id],
            discoveredInitially: true
        )

        let evSensorLog = EvidenceItem(
            evidenceId: "ev_sensor_telemetry",
            caseId: caseId,
            title: "East Stairwell Motion Telemetry",
            type: .securityRecord,
            summary: "Electronic sensor records motion in east stairwell at 21:18, contradicting early departure.",
            fullText: "Sensor ST-4 (East Service) recorded infrared motion trigger at 21:18:04. Access badge corresponding to internal keyholder active.",
            timestamp: "21:18",
            source: "Automated Facility System",
            reliability: .verified,
            tags: ["Security", "Telemetry"],
            isKeyEvidence: true,
            isPinned: false,
            relatedSuspectIds: [culprit.id],
            discoveredInitially: true
        )

        let evMotiveRecord = EvidenceItem(
            evidenceId: "ev_financial_audit",
            caseId: caseId,
            title: "Offshore Ledger Discrepancy",
            type: .financialRecord,
            summary: "Audit reveals \(culprit.name) was facing immediate termination and litigation over siphoned capital.",
            fullText: "Confidential internal memorandum from \(setting.v) notifying legal counsel of unauthorized fund transfers initiated by \(culprit.name).",
            timestamp: "18:30",
            source: "Secured Office Safe",
            reliability: .high,
            tags: ["Motive", "Finance"],
            isKeyEvidence: true,
            isPinned: false,
            relatedSuspectIds: [culprit.id],
            discoveredInitially: true
        )

        let evMeansRecord = EvidenceItem(
            evidenceId: "ev_tool_requisition",
            caseId: caseId,
            title: "Equipment Sign-out Form",
            type: .receipt,
            summary: "Signed release form for specialized override tool assigned to \(culprit.name).",
            fullText: "Serial #TR-889 mechanical override tool checked out at 17:40 under signature matching \(culprit.name). Tool was found discarded near the perimeter.",
            timestamp: "17:40",
            source: "Facility Logistics Log",
            reliability: .high,
            tags: ["Means", "Logistics"],
            isKeyEvidence: true,
            isPinned: false,
            relatedSuspectIds: [culprit.id],
            discoveredInitially: true
        )

        let evPhoneLog = EvidenceItem(
            evidenceId: "ev_cell_tower_ping",
            caseId: caseId,
            title: "Cellular Tower Triangulation",
            type: .locationData,
            summary: "Cell handset of \(culprit.name) pinged local mast adjacent to site at 21:22.",
            fullText: "Telecom carrier log confirms device stayed connected to Sector 3 antenna until 21:35.",
            timestamp: "21:22",
            source: "Carrier Telemetry",
            reliability: .verified,
            tags: ["Location", "Opportunity"],
            isKeyEvidence: true,
            isPinned: false,
            relatedSuspectIds: [culprit.id],
            discoveredInitially: true
        )

        let evInnocentAlibi = EvidenceItem(
            evidenceId: "ev_innocent_timestamp",
            caseId: caseId,
            title: "Third-party Video Stream Record",
            type: .phoneLog,
            summary: "Confirmed live stream conference corroborates alibi of secondary suspects.",
            fullText: "Remote video conference server logs establish that other persons of interest were actively streaming video from outside the sector.",
            timestamp: "21:00 - 21:40",
            source: "Cloud Provider Metadata",
            reliability: .verified,
            tags: ["Alibi", "Corroboration"],
            isKeyEvidence: false,
            isPinned: false,
            relatedSuspectIds: suspects.filter { $0.suspectId != culprit.id }.map { $0.suspectId },
            discoveredInitially: true
        )

        let evHiddenUnlock = EvidenceItem(
            evidenceId: "ev_discarded_item",
            caseId: caseId,
            title: "Discarded Latex Gloves in Bin C",
            type: .objectReport,
            summary: "Disposable gloves bearing trace chemical residue matching victim sample.",
            fullText: "Recovered from trash chute 4. Chemical composition matches the toxic solvent identified in coroner report.",
            timestamp: "21:30",
            source: "Forensic Sweep",
            reliability: .verified,
            tags: ["Physical", "Forensics"],
            isKeyEvidence: true,
            isPinned: false,
            relatedSuspectIds: [culprit.id],
            discoveredInitially: false,
            unlockCondition: "contradiction_alibi_break"
        )

        let evidence = [
            evIncident,
            evAlibiClaim,
            evSensorLog,
            evMotiveRecord,
            evMeansRecord,
            evPhoneLog,
            evInnocentAlibi,
            evHiddenUnlock
        ]

        // Contradictions
        let contradictions = [
            Contradiction(
                contradictionId: "contradiction_alibi_break",
                caseId: caseId,
                title: "Broken Stairwell Alibi",
                requiredEvidenceIds: ["ev_culprit_statement", "ev_sensor_telemetry"],
                type: .alibiBreak,
                explanation: "\(culprit.name) claimed departure at 20:50, but stairwell telemetry proves activity inside at 21:18.",
                severity: .critical,
                affectedSuspectId: culprit.id,
                opportunityDelta: 0.6,
                newAlibiStatus: .broken,
                unlocks: ["ev_discarded_item"]
            ),
            Contradiction(
                contradictionId: "contradiction_location_carrier",
                caseId: caseId,
                title: "Transit Perimeter Ping",
                requiredEvidenceIds: ["ev_culprit_statement", "ev_cell_tower_ping"],
                type: .contradiction,
                explanation: "Device location proves suspect never departed the sector during claimed departure.",
                severity: .major,
                affectedSuspectId: culprit.id,
                opportunityDelta: 0.3,
                newAlibiStatus: .broken,
                unlocks: nil
            ),
            Contradiction(
                contradictionId: "contradiction_means_tool",
                caseId: caseId,
                title: "Instrument Correlation",
                requiredEvidenceIds: ["ev_tool_requisition", "ev_incident_report"],
                type: .physicalProof,
                explanation: "The signed override tool matches the force trauma pattern on the victim chamber.",
                severity: .major,
                affectedSuspectId: culprit.id,
                meansDelta: 0.5,
                newAlibiStatus: nil,
                unlocks: nil
            )
        ]

        // Timeline events
        let timeline = [
            TimelineEvent(
                eventId: "t_tool_checkout",
                caseId: caseId,
                title: "Override Tool Requisition",
                eventDescription: "Tool signed out by \(culprit.name).",
                timeWindow: "17:40",
                exactTime: "17:40",
                canonicalOrder: 1,
                sourceEvidenceId: "ev_tool_requisition"
            ),
            TimelineEvent(
                eventId: "t_claimed_departure",
                caseId: caseId,
                title: "\(culprit.name) Claimed Exit",
                eventDescription: "Claimed departure prior to incident.",
                timeWindow: "20:50",
                exactTime: "20:50",
                canonicalOrder: 2,
                sourceEvidenceId: "ev_culprit_statement",
                isFalseClaim: true,
                conflictsWithEventIds: ["t_sensor_trigger"]
            ),
            TimelineEvent(
                eventId: "t_sensor_trigger",
                caseId: caseId,
                title: "East Stairwell Motion",
                eventDescription: "Sensor triggers motion near victim chamber.",
                timeWindow: "21:18",
                exactTime: "21:18",
                canonicalOrder: 3,
                sourceEvidenceId: "ev_sensor_telemetry"
            ),
            TimelineEvent(
                eventId: "t_cell_ping",
                caseId: caseId,
                title: "Sector Mast Ping",
                eventDescription: "Handset transmits beacon near facility perimeter.",
                timeWindow: "21:22",
                exactTime: "21:22",
                canonicalOrder: 4,
                sourceEvidenceId: "ev_cell_tower_ping"
            )
        ]

        let solution = CaseSolution(
            culpritId: culprit.id,
            requiredMotiveEvidenceIds: ["ev_financial_audit"],
            requiredMeansEvidenceIds: ["ev_tool_requisition"],
            requiredOpportunityEvidenceIds: ["ev_sensor_telemetry", "ev_cell_tower_ping"],
            requiredContradictionIds: ["contradiction_alibi_break"],
            requiredTimelineEventIds: ["t_sensor_trigger"],
            resolutionNarrative: "Faced with financial ruin, \(culprit.name) staged a false departure at 20:50, entered via the east service stairs, and executed the offense before discarding evidence in bin C."
        )

        return CaseModel(
            caseId: caseId,
            title: title,
            subtitle: subtitle,
            difficulty: .standard,
            estimatedMinutes: 15,
            isPremium: false,
            briefing: Briefing(
                location: setting.loc,
                date: dateString,
                victimOrSubject: setting.v,
                summary: setting.desc,
                objective: "Expose the broken departure alibi and identify the perpetrator."
            ),
            suspects: suspects,
            evidence: evidence,
            timeline: timeline,
            contradictions: contradictions,
            solution: solution,
            hints: [
                CaseHint(tier: .nudge, text: "Examine the stairwell sensor telemetry against the departure claim."),
                CaseHint(tier: .direction, text: "Connect \(culprit.name)'s statement with the East Stairwell motion log."),
                CaseHint(tier: .nearSolution, text: "\(culprit.name) never departed at 20:50; motion logs place them inside at 21:18.")
            ]
        )
    }
}
