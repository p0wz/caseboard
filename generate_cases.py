#!/usr/bin/env python3
import json
import os

cases_dir = "Sources/Caseboard/Resources/Cases"
os.makedirs(cases_dir, exist_ok=True)

cases_data = [
    # -------------------------------------------------------------
    # TUTORIAL: The Locked Gallery
    # -------------------------------------------------------------
    {
        "caseId": "locked_gallery",
        "title": "The Locked Gallery",
        "subtitle": "Curator Elias Vorn discovered dead in a secured exhibition chamber.",
        "difficulty": "intro",
        "estimatedMinutes": 12,
        "isPremium": False,
        "briefing": {
            "location": "North Pier Gallery, Bay District",
            "date": "2026-03-14",
            "victimOrSubject": "Elias Vorn",
            "summary": "At 22:15, gallery curator Elias Vorn was found deceased inside the climate-controlled Old Masters vault. The electronic bolt was secured from the inside, but ventilation seals had been disabled.",
            "objective": "Identify the culprit who entered after closing, broke their alibi, and staged the sealed vault.",
            "requiredSolveConditions": [
                "Identify the true culprit",
                "Prove the false departure alibi",
                "Establish physical means and service door entry"
            ]
        },
        "suspects": [
            {
                "suspectId": "suspect_mara",
                "caseId": "locked_gallery",
                "name": "Mara Voss",
                "role": "Assistant Curator",
                "age": 31,
                "relationshipToVictim": "Direct subordinate, prospective heir to gallery directorship",
                "profile": "Expert art restorer with detailed knowledge of museum chemical solvents and electronic security locks.",
                "motiveScore": 0.35,
                "meansScore": 0.40,
                "opportunityScore": 0.20,
                "alibiStatus": "claimed",
                "suspicionLevel": "moderate",
                "initialAlibi": "Claims she left the gallery before the evening downpour at 8:00 PM and took the metro home.",
                "knownFacts": ["Possesses laboratory access", "Scheduled the private viewing"],
                "unlockedFacts": []
            },
            {
                "suspectId": "suspect_theo",
                "caseId": "locked_gallery",
                "name": "Theo Grant",
                "role": "Private Collector & Bidder",
                "age": 54,
                "relationshipToVictim": "Disputed buyer for the Holbein painting",
                "profile": "High-net-worth investor rumored to be facing financial freeze due to forged provenance inquiries.",
                "motiveScore": 0.50,
                "meansScore": 0.15,
                "opportunityScore": 0.25,
                "alibiStatus": "claimed",
                "suspicionLevel": "low",
                "initialAlibi": "Remained at the North Pier Yacht Club bar from 8:00 PM to midnight.",
                "knownFacts": ["Argued loudly with Elias over provenance at 7:30 PM"],
                "unlockedFacts": []
            },
            {
                "suspectId": "suspect_lin",
                "caseId": "locked_gallery",
                "name": "Lin Park",
                "role": "Contract Security Engineer",
                "age": 28,
                "relationshipToVictim": "Facility maintenance contractor",
                "profile": "Installed the new digital access control system two weeks prior to the incident.",
                "motiveScore": 0.10,
                "meansScore": 0.60,
                "opportunityScore": 0.20,
                "alibiStatus": "confirmed",
                "suspicionLevel": "low",
                "initialAlibi": "Monitoring server racks in central district dispatch during incident.",
                "knownFacts": ["Maintains master override keycards"],
                "unlockedFacts": []
            }
        ],
        "evidence": [
            {
                "evidenceId": "coroner_report_vorn",
                "caseId": "locked_gallery",
                "title": "Coroner Report: Elias Vorn",
                "type": "medical_report",
                "summary": "Death caused by acute inhalation of volatile industrial solvent between 20:15 and 20:45.",
                "fullText": "Coroner autopsy indicates asphyxiation due to concentrated isopropanol-xylene vapor compound. The victim exhibited no defensive wounds, indicating incapacitation occurred rapidly within an enclosed space.",
                "timestamp": "22:45",
                "source": "Metropolitan Medical Examiner",
                "reliability": "verified",
                "tags": ["Medical", "Autopsy"],
                "isKeyEvidence": True,
                "isPinned": True,
                "relatedSuspectIds": ["suspect_mara", "suspect_theo", "suspect_lin"],
                "relatedEvidenceIds": ["restoration_solvent_inventory"],
                "discoveredInitially": True
            },
            {
                "evidenceId": "weather_log_811",
                "caseId": "locked_gallery",
                "title": "Meteorological Telemetry: Bay District",
                "type": "location_data",
                "summary": "Severe torrential downpour commenced at North Pier at precisely 20:11.",
                "fullText": "National Weather Service coastal radar records zero precipitation between 18:00 and 20:10. At precisely 20:11, heavy thunderstorm activity recorded 18mm/hr precipitation across North Pier.",
                "timestamp": "20:11",
                "source": "National Weather Radar",
                "reliability": "verified",
                "tags": ["Telemetry", "Weather"],
                "isKeyEvidence": True,
                "isPinned": True,
                "relatedSuspectIds": ["suspect_mara"],
                "relatedEvidenceIds": ["door_sensor_824", "mara_statement_alibi"],
                "discoveredInitially": True
            },
            {
                "evidenceId": "door_sensor_824",
                "caseId": "locked_gallery",
                "title": "Main Entrance Door Sensor Log",
                "type": "security_record",
                "summary": "Badge 'M-VOSS' registered exit through front revolving door at 20:24.",
                "fullText": "Electronic audit trail at Main Entrance Port A: 20:24:18 - RFID badge 'M-VOSS' scanned outbound. No further reads registered at front portals until police arrival.",
                "timestamp": "20:24",
                "source": "Gallery Access Control DB",
                "reliability": "verified",
                "tags": ["Access", "Security"],
                "isKeyEvidence": True,
                "isPinned": True,
                "relatedSuspectIds": ["suspect_mara"],
                "relatedEvidenceIds": ["weather_log_811", "mara_statement_alibi"],
                "discoveredInitially": True
            },
            {
                "evidenceId": "mara_statement_alibi",
                "caseId": "locked_gallery",
                "title": "Mara Voss Witness Statement",
                "type": "statement",
                "summary": "Mara claims she walked out into dry evening air before 8:00 PM without needing an umbrella.",
                "fullText": "\"Elias asked me to leave early so he could confer privately with a buyer. I clocked out and walked to the metro before the rain started, around 7:55 PM. My coat and umbrella never even got wet.\"",
                "timestamp": "23:05",
                "source": "Interrogation Room 2",
                "reliability": "medium",
                "tags": ["Statement", "Alibi"],
                "isKeyEvidence": True,
                "isPinned": True,
                "relatedSuspectIds": ["suspect_mara"],
                "relatedEvidenceIds": ["weather_log_811", "door_sensor_824", "dry_umbrella_locker"],
                "discoveredInitially": True
            },
            {
                "evidenceId": "dry_umbrella_locker",
                "caseId": "locked_gallery",
                "title": "Personal Umbrella in Staff Locker 04",
                "type": "object_report",
                "summary": "Mara's folding umbrella found completely dry and bone-dry canopy in staff locker.",
                "fullText": "Forensic sweep of staff lockers located personal umbrella belonging to Mara Voss. Fabric shows 0% residual moisture under ultraviolet inspection.",
                "timestamp": "23:40",
                "source": "Forensic Search Unit",
                "reliability": "verified",
                "tags": ["Physical", "Forensics"],
                "isKeyEvidence": True,
                "isPinned": False,
                "relatedSuspectIds": ["suspect_mara"],
                "relatedEvidenceIds": ["mara_statement_alibi", "weather_log_811"],
                "discoveredInitially": True
            },
            {
                "evidenceId": "theo_bar_receipt",
                "caseId": "locked_gallery",
                "title": "Yacht Club Tab: Theo Grant",
                "type": "receipt",
                "summary": "Continuous bar purchases by Theo Grant from 19:55 to 23:30 corroborated by bartender.",
                "fullText": "Point-of-Sale terminal records at North Pier Yacht Club show orders opened by Theo Grant at 19:55 and settled at 23:30 with continuous beverage updates. Bartender confirms physical presence.",
                "timestamp": "19:55 - 23:30",
                "source": "North Pier Yacht Club POS",
                "reliability": "verified",
                "tags": ["Receipt", "Alibi"],
                "isKeyEvidence": False,
                "isPinned": False,
                "relatedSuspectIds": ["suspect_theo"],
                "relatedEvidenceIds": [],
                "discoveredInitially": True
            },
            {
                "evidenceId": "restoration_solvent_inventory",
                "caseId": "locked_gallery",
                "title": "Conservation Chemical Dispensary Log",
                "type": "financial_record",
                "summary": "2.5 Liters of Xylene-Isopropanol solvent unaccounted for in conservation lab.",
                "fullText": "Inventory audit of the restoration studio shows container X-404 missing 2.5L of volatile solvent. Access to this cabinet requires bio-metric clearance assigned only to Senior Restorer Mara Voss.",
                "timestamp": "19:00",
                "source": "Gallery Studio Inventory",
                "reliability": "high",
                "tags": ["Chemical", "Means"],
                "isKeyEvidence": True,
                "isPinned": False,
                "relatedSuspectIds": ["suspect_mara"],
                "relatedEvidenceIds": ["coroner_report_vorn"],
                "discoveredInitially": True
            },
            {
                "evidenceId": "service_door_override_log",
                "caseId": "locked_gallery",
                "title": "Rear Service Loading Door Override Audit",
                "type": "security_record",
                "summary": "Rear dock door unlocked via Lin Park's emergency badge at 20:31 from inside corridor.",
                "fullText": "Sub-level loading bay audit: Emergency bypass badge #ENG-88 registered an exit at 20:31:12. Contractor Lin Park was verified offsite, indicating badge was misappropriated.",
                "timestamp": "20:31",
                "source": "Service Bay Digital Gateway",
                "reliability": "verified",
                "tags": ["Access", "Opportunity"],
                "isKeyEvidence": True,
                "isPinned": False,
                "relatedSuspectIds": ["suspect_mara", "suspect_lin"],
                "relatedEvidenceIds": ["stolen_badge_confession"],
                "discoveredInitially": True
            },
            {
                "evidenceId": "stolen_badge_confession",
                "caseId": "locked_gallery",
                "title": "Mara Voss Desk Drawer Search",
                "type": "object_report",
                "summary": "Lin Park's duplicate emergency badge found hidden in Mara's desk organizer.",
                "fullText": "Crime scene technicians recovered emergency bypass badge #ENG-88 concealed beneath felt lining in Mara Voss's private desk drawer.",
                "timestamp": "23:55",
                "source": "Crime Scene Investigation",
                "reliability": "verified",
                "tags": ["Physical", "Opportunity"],
                "isKeyEvidence": True,
                "isPinned": False,
                "relatedSuspectIds": ["suspect_mara"],
                "relatedEvidenceIds": ["service_door_override_log"],
                "discoveredInitially": False,
                "unlockCondition": "contradiction_alibi_time"
            },
            {
                "evidenceId": "provenance_audit_memorandum",
                "caseId": "locked_gallery",
                "title": "Elias Vorn Private Memo: Provenance Fraud",
                "type": "statement",
                "summary": "Elias discovered Mara had authenticated three forged Dutch master paintings for personal kickbacks.",
                "fullText": "\"To the Board of Trustees: I have confirmed that Assistant Curator Mara Voss falsified spectral analysis reports for the Van Dyck and Holbein acquisitions. I am notifying the Federal Antiquities Division tomorrow morning at 09:00.\"",
                "timestamp": "17:15",
                "source": "Elias Vorn Encrypted Laptop",
                "reliability": "verified",
                "tags": ["Motive", "Fraud"],
                "isKeyEvidence": True,
                "isPinned": False,
                "relatedSuspectIds": ["suspect_mara"],
                "relatedEvidenceIds": [],
                "discoveredInitially": True
            }
        ],
        "timeline": [
            {
                "eventId": "t_vorn_memo",
                "caseId": "locked_gallery",
                "title": "Elias drafts fraud memorandum",
                "eventDescription": "Elias documents Mara's forgery and schedules disclosure.",
                "timeWindow": "17:15",
                "exactTime": "17:15",
                "canonicalOrder": 1,
                "sourceEvidenceId": "provenance_audit_memorandum"
            },
            {
                "eventId": "t_theo_arrives_bar",
                "caseId": "locked_gallery",
                "title": "Theo Grant arrives at Yacht Club",
                "eventDescription": "Theo establishes verified alibi at waterfront bar.",
                "timeWindow": "19:55",
                "exactTime": "19:55",
                "canonicalOrder": 2,
                "sourceEvidenceId": "theo_bar_receipt"
            },
            {
                "eventId": "t_rain_begins",
                "caseId": "locked_gallery",
                "title": "Torrential rain begins",
                "eventDescription": "Coastal downpour starts across North Pier at 20:11.",
                "timeWindow": "20:11",
                "exactTime": "20:11",
                "canonicalOrder": 3,
                "sourceEvidenceId": "weather_log_811"
            },
            {
                "eventId": "t_mara_front_exit",
                "caseId": "locked_gallery",
                "title": "Mara badges through front door",
                "eventDescription": "Mara scans badge out front door after rain started.",
                "timeWindow": "20:24",
                "exactTime": "20:24",
                "canonicalOrder": 4,
                "sourceEvidenceId": "door_sensor_824"
            },
            {
                "eventId": "t_service_door_exit",
                "caseId": "locked_gallery",
                "title": "Service dock emergency exit",
                "eventDescription": "Perpetrator flees via rear service door using stolen override badge.",
                "timeWindow": "20:31",
                "exactTime": "20:31",
                "canonicalOrder": 5,
                "sourceEvidenceId": "service_door_override_log"
            },
            {
                "eventId": "t_mara_false_claim",
                "caseId": "locked_gallery",
                "title": "Mara's claimed dry departure",
                "eventDescription": "Mara claims departure before rain in dry air.",
                "timeWindow": "19:55",
                "exactTime": "19:55",
                "canonicalOrder": 6,
                "sourceEvidenceId": "mara_statement_alibi",
                "isFalseClaim": True,
                "conflictsWithEventIds": ["t_mara_front_exit", "t_rain_begins"]
            }
        ],
        "contradictions": [
            {
                "contradictionId": "contradiction_alibi_time",
                "caseId": "locked_gallery",
                "title": "Rainfall vs Departure Sensor Discrepancy",
                "requiredEvidenceIds": ["door_sensor_824", "mara_statement_alibi", "weather_log_811"],
                "type": "alibi_break",
                "explanation": "Mara claimed she left before the rain began at 7:55 PM, but the electronic door sensor logged her exit at 8:24 PM—thirteen minutes after torrential rainfall started.",
                "severity": "critical",
                "affectedSuspectId": "suspect_mara",
                "motiveDelta": 0.2,
                "meansDelta": 0.2,
                "opportunityDelta": 0.6,
                "newAlibiStatus": "broken",
                "unlocks": ["stolen_badge_confession"]
            },
            {
                "contradictionId": "contradiction_dry_umbrella",
                "caseId": "locked_gallery",
                "title": "Dry Umbrella Contradiction",
                "requiredEvidenceIds": ["dry_umbrella_locker", "door_sensor_824"],
                "type": "contradiction",
                "explanation": "If Mara exited at 20:24 during torrential rain, her umbrella in the staff locker would not be bone-dry, proving she staged her front-door exit and re-entered.",
                "severity": "major",
                "affectedSuspectId": "suspect_mara",
                "opportunityDelta": 0.2,
                "newAlibiStatus": "broken",
                "unlocks": None
            },
            {
                "contradictionId": "contradiction_chemical_means",
                "caseId": "locked_gallery",
                "title": "Solvent Inventory Matches Fatal Chemical",
                "requiredEvidenceIds": ["coroner_report_vorn", "restoration_solvent_inventory"],
                "type": "physical_proof",
                "explanation": "The coroner's fatal xylene compound matches the exact 2.5L volume missing from Mara's private conservation lab locker.",
                "severity": "major",
                "affectedSuspectId": "suspect_mara",
                "meansDelta": 0.5,
                "newAlibiStatus": None,
                "unlocks": None
            }
        ],
        "solution": {
            "culpritId": "suspect_mara",
            "requiredMotiveEvidenceIds": ["provenance_audit_memorandum"],
            "requiredMeansEvidenceIds": ["restoration_solvent_inventory"],
            "requiredOpportunityEvidenceIds": ["door_sensor_824", "service_door_override_log"],
            "requiredContradictionIds": ["contradiction_alibi_time"],
            "requiredTimelineEventIds": ["t_mara_front_exit", "t_service_door_exit"],
            "resolutionNarrative": "Faced with career ruin over forged provenance authentication, Mara Voss released toxic conservation solvent inside the vault, badged out the front to manufacture a fake alibi, and escaped out the service door using Lin Park's stolen bypass badge."
        },
        "hints": [
            {"tier": "nudge", "text": "Compare the weather radar precipitation timing against the main entrance door logs.", "targetSuspectId": "suspect_mara", "relatedEvidenceIds": ["weather_log_811", "door_sensor_824"]},
            {"tier": "direction", "text": "Mara claims she walked home in dry air, but radar records heavy rain before her badge was scanned.", "targetSuspectId": "suspect_mara", "relatedEvidenceIds": ["mara_statement_alibi", "door_sensor_824"]},
            {"tier": "near_solution", "text": "Mara's alibi is shattered: she logged out at 20:24 in heavy rain while her umbrella remained dry, and used the rear service door to flee.", "targetSuspectId": "suspect_mara", "relatedEvidenceIds": ["stolen_badge_confession", "service_door_override_log"]}
        ]
    }
]

# Helper to generate rich realistic cases
def create_case(caseId, title, subtitle, diff, estMin, isPrem, briefing, suspects, evidence, timeline, contradictions, solution, hints):
    return {
        "caseId": caseId,
        "title": title,
        "subtitle": subtitle,
        "difficulty": diff,
        "estimatedMinutes": estMin,
        "isPremium": isPrem,
        "briefing": briefing,
        "suspects": suspects,
        "evidence": evidence,
        "timeline": timeline,
        "contradictions": contradictions,
        "solution": solution,
        "hints": hints
    }

# FREE CASE 1: Rain at Mercer Street
cases_data.append(create_case(
    caseId="rain_at_mercer_street",
    title="Rain at Mercer Street",
    subtitle="Antiquarian jeweler found stabbed in back office during evening storm.",
    diff="standard",
    estMin=18,
    isPrem=False,
    briefing={
        "location": "Mercer Fine Gems, 44 Mercer St",
        "date": "2026-03-22",
        "victimOrSubject": "Arthur Pendelton",
        "summary": "Jeweler Arthur Pendelton was discovered behind his display safe with fatal puncture wounds. A diamond appraisal shipment worth $420,000 was missing.",
        "objective": "Identify the killer among the store manager, courier, and rival collector by exposing a falsified taxi ride.",
        "requiredSolveConditions": ["Expose the fraudulent taxi receipt", "Prove physical presence in the storm", "Recover diamond transit ledger"]
    },
    suspects=[
        {"suspectId": "suspect_elena", "caseId": "rain_at_mercer_street", "name": "Elena Ward", "role": "Store Manager", "age": 36, "relationshipToVictim": "Senior associate with safe combination", "profile": "Meticulous jeweler facing massive personal debt from failed speculative auctions.", "motiveScore": 0.4, "meansScore": 0.3, "opportunityScore": 0.2, "alibiStatus": "claimed", "suspicionLevel": "moderate", "initialAlibi": "Claims she hailed a yellow cab at 20:40 and rode straight to Chelsea.", "knownFacts": ["Had safe access code", "Turned off display lights"], "unlockedFacts": []},
        {"suspectId": "suspect_david", "caseId": "rain_at_mercer_street", "name": "David Cross", "role": "Armored Courier", "age": 29, "relationshipToVictim": "Scheduled pickup agent", "profile": "Former security officer with pristine conduct history.", "motiveScore": 0.2, "meansScore": 0.2, "opportunityScore": 0.3, "alibiStatus": "claimed", "suspicionLevel": "low", "initialAlibi": "Claims dispatch delayed his van across the bridge until 21:30.", "knownFacts": ["Logged arrival at 21:35"], "unlockedFacts": []},
        {"suspectId": "suspect_julian", "caseId": "rain_at_mercer_street", "name": "Julian Blackwood", "role": "Rival Collector", "age": 62, "relationshipToVictim": "Disputed consignor", "profile": "Wealthy gem collector whose family heirloom was being sold by Pendelton.", "motiveScore": 0.5, "meansScore": 0.1, "opportunityScore": 0.1, "alibiStatus": "confirmed", "suspicionLevel": "low", "initialAlibi": "Dining at Union Square bistro with multiple witnesses.", "knownFacts": ["Sent threatening legal letter 2 days prior"], "unlockedFacts": []}
    ],
    evidence=[
        {"evidenceId": "coroner_pendelton", "caseId": "rain_at_mercer_street", "title": "Coroner Report: Arthur Pendelton", "type": "medical_report", "summary": "Puncture trauma to thoracic cavity caused by jeweler's diamond scribe between 20:30 and 20:50.", "fullText": "Weapon is consistent with a tungsten-carbide gemstone engraving scribe. Death was immediate due to aortic puncture.", "timestamp": "21:50", "source": "City Medical Examiner", "reliability": "verified", "tags": ["Medical", "Forensics"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": ["suspect_elena", "suspect_david"], "discoveredInitially": True},
        {"evidenceId": "elena_taxi_receipt", "caseId": "rain_at_mercer_street", "title": "Elena Taxi Receipt (Medallion 4B22)", "type": "receipt", "summary": "Printed taxi receipt shows pickup at Mercer St at 20:41 with arrival in Chelsea at 21:05.", "fullText": "Receipt printed for Cab #4B22. Fare $24.50 paid in cash. Time stamp: Pickup 20:41, Dropoff 21:05.", "timestamp": "20:41", "source": "Elena Ward Handbag", "reliability": "medium", "tags": ["Alibi", "Receipt"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": ["suspect_elena"], "discoveredInitially": True},
        {"evidenceId": "taxi_commission_audit", "caseId": "rain_at_mercer_street", "title": "TLC GPS Dispatch Log: Medallion 4B22", "type": "location_data", "summary": "Taxi 4B22 was undergoing transmission maintenance in Queens and was never on Mercer Street.", "fullText": "Taxi & Limousine Commission official telemetry: Medallion 4B22 was logged in mechanical bay 4 in Long Island City from 16:00 to 23:00. The printed receipt in Elena's possession was blank slip stock from an old machine.", "timestamp": "20:40", "source": "TLC Fleet Telemetry", "reliability": "verified", "tags": ["Telemetry", "Fraud"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": ["suspect_elena"], "discoveredInitially": True},
        {"evidenceId": "broken_umbrella_alley", "caseId": "rain_at_mercer_street", "title": "Broken Silk Umbrella in Alley", "type": "object_report", "summary": "Custom monogrammed umbrella 'E.W.' recovered from storm drain behind Mercer St.", "fullText": "Monogrammed black umbrella with fractured ribs recovered 15 meters from Mercer rear entrance. Wet silk matches fiber traces on alley pavement.", "timestamp": "22:15", "source": "Alleyway Search", "reliability": "verified", "tags": ["Physical", "Forensics"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_elena"], "discoveredInitially": True},
        {"evidenceId": "debt_notice_elena", "caseId": "rain_at_mercer_street", "title": "Default Judgment Notice: Elena Ward", "type": "financial_record", "summary": "Court order demanding immediate restitution of $380,000 within 24 hours.", "fullText": "State Supreme Court judgment enforcing asset seizure against Elena Ward scheduled for execution at 09:00 next business day.", "timestamp": "09:00", "source": "County Clerk Records", "reliability": "verified", "tags": ["Motive", "Finance"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_elena"], "discoveredInitially": True},
        {"evidenceId": "gem_scribe_missing", "caseId": "rain_at_mercer_street", "title": "Engraving Tool Case Audit", "type": "object_report", "summary": "Elena's personalized tungsten diamond scribe missing from bench.", "fullText": "Bench examination reveals Elena's assigned engraving tool missing while other staff tools are secured.", "timestamp": "22:00", "source": "Forensic Workshop Inspection", "reliability": "high", "tags": ["Means", "Weapon"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_elena"], "discoveredInitially": True},
        {"evidenceId": "hidden_loose_diamonds", "caseId": "rain_at_mercer_street", "title": "Recovered Diamond Pouch", "type": "object_report", "summary": "Pouch of 44 loose diamonds hidden in spare tire well of Elena's sedan.", "fullText": "Uncut and certified diamonds matching the Pendelton safe consignment manifest discovered in Elena's registered vehicle.", "timestamp": "01:10", "source": "Vehicle Search Warrant", "reliability": "verified", "tags": ["Physical", "Contraband"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_elena"], "discoveredInitially": False, "unlockCondition": "contradiction_fake_taxi"}
    ],
    timeline=[
        {"eventId": "t_debt_deadline", "caseId": "rain_at_mercer_street", "title": "Elena court deadline issued", "eventDescription": "Elena ordered to satisfy $380k debt.", "timeWindow": "09:00", "exactTime": "09:00", "canonicalOrder": 1, "sourceEvidenceId": "debt_notice_elena"},
        {"eventId": "t_incident_window", "caseId": "rain_at_mercer_street", "title": "Arthur Pendelton murdered", "eventDescription": "Arthur stabbed with diamond scribe in store back office.", "timeWindow": "20:35 - 20:45", "exactTime": "20:40", "canonicalOrder": 2, "sourceEvidenceId": "coroner_pendelton"},
        {"eventId": "t_fake_taxi_claim", "caseId": "rain_at_mercer_street", "title": "Elena claimed taxi departure", "eventDescription": "Elena claims she departed Mercer St in Cab 4B22.", "timeWindow": "20:41", "exactTime": "20:41", "canonicalOrder": 3, "sourceEvidenceId": "elena_taxi_receipt", "isFalseClaim": True, "conflictsWithEventIds": ["t_incident_window"]},
        {"eventId": "t_courier_arrival", "caseId": "rain_at_mercer_street", "title": "Armored courier van arrives", "eventDescription": "David Cross arrives and discovers body.", "timeWindow": "21:35", "exactTime": "21:35", "canonicalOrder": 4, "sourceEvidenceId": "coroner_pendelton"}
    ],
    contradictions=[
        {
            "contradictionId": "contradiction_fake_taxi",
            "caseId": "rain_at_mercer_street",
            "title": "Fabricated Taxi Telemetry Alibi",
            "requiredEvidenceIds": ["elena_taxi_receipt", "taxi_commission_audit"],
            "type": "alibi_break",
            "explanation": "Elena's paper taxi receipt was forged from blank stock: official TLC GPS logs prove Cab 4B22 was in a Long Island City repair shop all night.",
            "severity": "critical",
            "affectedSuspectId": "suspect_elena",
            "opportunityDelta": 0.7,
            "newAlibiStatus": "broken",
            "unlocks": ["hidden_loose_diamonds"]
        },
        {
            "contradictionId": "contradiction_weapon_match",
            "caseId": "rain_at_mercer_street",
            "title": "Missing Scribe Matches Wound Dimensions",
            "requiredEvidenceIds": ["coroner_pendelton", "gem_scribe_missing"],
            "type": "physical_proof",
            "explanation": "The coroner's puncture wound matches the unique triangular profile of Elena's missing diamond scribe.",
            "severity": "major",
            "affectedSuspectId": "suspect_elena",
            "meansDelta": 0.6,
            "newAlibiStatus": None,
            "unlocks": None
        }
    ],
    solution={
        "culpritId": "suspect_elena",
        "requiredMotiveEvidenceIds": ["debt_notice_elena"],
        "requiredMeansEvidenceIds": ["gem_scribe_missing"],
        "requiredOpportunityEvidenceIds": ["taxi_commission_audit", "broken_umbrella_alley"],
        "requiredContradictionIds": ["contradiction_fake_taxi"],
        "requiredTimelineEventIds": ["t_incident_window"],
        "resolutionNarrative": "Confronted with an immediate $380,000 court asset seizure, Elena Ward murdered Arthur Pendelton with her engraving scribe, stole the diamond shipment, and fabricated an alibi using a fraudulent taxi receipt."
    },
    hints=[
        {"tier": "nudge", "text": "Verify the authenticity of Elena's taxi receipt against official fleet GPS logs.", "targetSuspectId": "suspect_elena", "relatedEvidenceIds": ["elena_taxi_receipt", "taxi_commission_audit"]},
        {"tier": "direction", "text": "Cab 4B22 was undergoing repair in Queens. Connect the receipt with the TLC audit to shatter her alibi.", "targetSuspectId": "suspect_elena", "relatedEvidenceIds": ["taxi_commission_audit"]},
        {"tier": "near_solution", "text": "Elena forged the taxi receipt to cover her presence on Mercer St. Broken alibi unlocks the diamond stash in her sedan.", "targetSuspectId": "suspect_elena", "relatedEvidenceIds": ["hidden_loose_diamonds"]}
    ]
))

# FREE CASE 2: The Vanishing Courier
cases_data.append(create_case(
    caseId="the_vanishing_courier",
    title="The Vanishing Courier",
    subtitle="Armored logistics van found abandoned under river overpass with missing vault crate.",
    diff="standard",
    estMin=20,
    isPrem=False,
    briefing={
        "location": "Queensboro Industrial Spur, Dock 9",
        "date": "2026-04-03",
        "victimOrSubject": "Leo Mercer",
        "summary": "Courier driver Leo Mercer vanished during an overnight bullion transfer. The armored vehicle was recovered empty with pneumatic door interlocks overridden.",
        "objective": "Break down the GPS route deviation, establish the insider accomplice, and recover the manifest.",
        "requiredSolveConditions": ["Expose radio blind spot fabrication", "Identify who possessed the interlock bypass", "Submit final accusation"]
    },
    suspects=[
        {"suspectId": "suspect_riley", "caseId": "the_vanishing_courier", "name": "Sean Riley", "role": "Chief Dispatcher", "age": 45, "relationshipToVictim": "Supervisor responsible for route assignment", "profile": "Veteran controller with full authority over radio repeaters and real-time reroutes.", "motiveScore": 0.4, "meansScore": 0.5, "opportunityScore": 0.3, "alibiStatus": "claimed", "suspicionLevel": "moderate", "initialAlibi": "Claims he never authorized any detour away from Route 4A.", "knownFacts": ["Authorized radio frequency switch"], "unlockedFacts": []},
        {"suspectId": "suspect_hannah", "caseId": "the_vanishing_courier", "name": "Hannah Vance", "role": "Relief Driver", "age": 31, "relationshipToVictim": "Shift partner who swapped duty", "profile": "Requested last-minute swap citing sudden migraine.", "motiveScore": 0.2, "meansScore": 0.2, "opportunityScore": 0.1, "alibiStatus": "confirmed", "suspicionLevel": "low", "initialAlibi": "Admitted to urgent care clinic at 21:00.", "knownFacts": ["Verified by hospital check-in timestamp"], "unlockedFacts": []},
        {"suspectId": "suspect_brooks", "caseId": "the_vanishing_courier", "name": "Tyler Brooks", "role": "Depot Guard", "age": 38, "relationshipToVictim": "Gatekeeper at origin warehouse", "profile": "Former naval engineer with gambling debts.", "motiveScore": 0.3, "meansScore": 0.3, "opportunityScore": 0.2, "alibiStatus": "claimed", "suspicionLevel": "low", "initialAlibi": "Claims gate log shows normal exit at 22:00.", "knownFacts": ["Logged van out at origin"], "unlockedFacts": []}
    ],
    evidence=[
        {"evidenceId": "gps_telemetry_gap", "caseId": "the_vanishing_courier", "title": "Van Fleet GPS Telemetry", "type": "location_data", "summary": "Transponder signal dropped for 18 minutes near Dock 9 warehouse spur.", "fullText": "Black box telematics records an uncommanded kill switch of secondary transponder at 22:42, resuming at 23:00 at the river overpass.", "timestamp": "22:42", "source": "Logistics Satellite Telemetry", "reliability": "verified", "tags": ["Telemetry", "GPS"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": ["suspect_riley"], "discoveredInitially": True},
        {"evidenceId": "dispatch_recording_riley", "caseId": "the_vanishing_courier", "title": "Dispatch Audio Intercept 22:38", "type": "audio_transcript", "summary": "Riley radioed driver ordering detour to Dock 9 citing simulated gas leak on main expressway.", "fullText": "\"Unit 12, Dispatch. We have severe gas leak advisory on Highway 4A. Divert to Dock 9 spur immediately and hold for escort.\"", "timestamp": "22:38", "source": "Archived Dispatch Audio", "reliability": "verified", "tags": ["Audio", "Dispatch"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": ["suspect_riley"], "discoveredInitially": True},
        {"evidenceId": "riley_denial_statement", "caseId": "the_vanishing_courier", "title": "Sean Riley Statement", "type": "statement", "summary": "Riley denies sending any reroute orders, claiming van went rogue on its own.", "fullText": "\"I watched their dot drift off highway 4A. I tried calling them on emergency channel 1 but got static. I never told Leo to divert.\"", "timestamp": "01:20", "source": "Internal Affairs Interview", "reliability": "low", "tags": ["Statement", "Alibi"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": ["suspect_riley"], "discoveredInitially": True},
        {"evidenceId": "pneumatic_tool_receipt", "caseId": "the_vanishing_courier", "title": "Bypass Valve Order: Riley", "type": "receipt", "summary": "Purchase order for specialized solenoid release valve delivered to Riley's home.", "fullText": "Receipt from industrial hydraulic supplier for van door release bypass matching the exact tooling marks on recovered van.", "timestamp": "Last Week", "source": "Supplier Transaction DB", "reliability": "high", "tags": ["Means", "Tool"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_riley"], "discoveredInitially": True},
        {"evidenceId": "riley_offshore_crypto", "caseId": "the_vanishing_courier", "title": "Encrypted Wallet Deposit: $250,000", "type": "financial_record", "summary": "Escrow transfer completed upon confirmation of van transponder shutdown.", "fullText": "Blockchain ledger reveals smart contract release of 75 ETH to wallet registered on Riley's personal phone at 22:45.", "timestamp": "22:45", "source": "Financial Cyber Unit", "reliability": "verified", "tags": ["Motive", "Crypto"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_riley"], "discoveredInitially": True},
        {"evidenceId": "recovered_mercer_jacket", "caseId": "the_vanishing_courier", "title": "Leo Mercer Driver Badge & Uniform", "type": "object_report", "summary": "Driver's jacket recovered inside Dock 9 storage locker rented under Riley's alias.", "fullText": "Locker #104 at Dock 9 spur contained driver's uniform and empty security seal rings.", "timestamp": "03:15", "source": "Harbor Police Search", "reliability": "verified", "tags": ["Physical", "Evidence"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_riley"], "discoveredInitially": False, "unlockCondition": "contradiction_dispatch_reroute"}
    ],
    timeline=[
        {"eventId": "t_dispatch_audio", "caseId": "the_vanishing_courier", "title": "Riley issues false detour", "eventDescription": "Riley radios driver ordering diversion to Dock 9.", "timeWindow": "22:38", "exactTime": "22:38", "canonicalOrder": 1, "sourceEvidenceId": "dispatch_recording_riley"},
        {"eventId": "t_gps_cut", "caseId": "the_vanishing_courier", "title": "Van transponder blackout", "eventDescription": "Van satellite signal cut at Dock 9 spur.", "timeWindow": "22:42", "exactTime": "22:42", "canonicalOrder": 2, "sourceEvidenceId": "gps_telemetry_gap"},
        {"eventId": "t_crypto_release", "caseId": "the_vanishing_courier", "title": "Escrow payment triggered", "eventDescription": "Crypto payment hits Riley's wallet.", "timeWindow": "22:45", "exactTime": "22:45", "canonicalOrder": 3, "sourceEvidenceId": "riley_offshore_crypto"},
        {"eventId": "t_riley_claim", "caseId": "the_vanishing_courier", "title": "Riley claims static on radio", "eventDescription": "Riley claims he never communicated with van.", "timeWindow": "22:40", "exactTime": "22:40", "canonicalOrder": 4, "sourceEvidenceId": "riley_denial_statement", "isFalseClaim": True, "conflictsWithEventIds": ["t_dispatch_audio"]}
    ],
    contradictions=[
        {
            "contradictionId": "contradiction_dispatch_reroute",
            "caseId": "the_vanishing_courier",
            "title": "Dispatch Recording Directly Contradicts Denial",
            "requiredEvidenceIds": ["dispatch_recording_riley", "riley_denial_statement"],
            "type": "contradiction",
            "explanation": "Sean Riley denied issuing any reroute order, but radio recording archives capture his distinct voice ordering the driver into the Dock 9 trap.",
            "severity": "critical",
            "affectedSuspectId": "suspect_riley",
            "opportunityDelta": 0.6,
            "newAlibiStatus": "broken",
            "unlocks": ["recovered_mercer_jacket"]
        }
    ],
    solution={
        "culpritId": "suspect_riley",
        "requiredMotiveEvidenceIds": ["riley_offshore_crypto"],
        "requiredMeansEvidenceIds": ["pneumatic_tool_receipt"],
        "requiredOpportunityEvidenceIds": ["dispatch_recording_riley", "gps_telemetry_gap"],
        "requiredContradictionIds": ["contradiction_dispatch_reroute"],
        "requiredTimelineEventIds": ["t_dispatch_audio", "t_gps_cut"],
        "resolutionNarrative": "Chief Dispatcher Sean Riley orchestrated the bullion theft by fabricating a gas leak to steer Unit 12 into Dock 9, where he used a purchased hydraulic bypass to loot the cargo and claim a $250k bounty."
    },
    hints=[
        {"tier": "nudge", "text": "Listen to the recorded radio audio logs and compare with Riley's statement.", "targetSuspectId": "suspect_riley", "relatedEvidenceIds": ["dispatch_recording_riley", "riley_denial_statement"]},
        {"tier": "direction", "text": "Riley claimed he never spoke with Unit 12, yet dispatch tapes prove he directed them straight to Dock 9.", "targetSuspectId": "suspect_riley", "relatedEvidenceIds": ["riley_denial_statement"]},
        {"tier": "near_solution", "text": "Riley is the mastermind. His radio transmission contradicts his denial and unlocks the Dock 9 locker.", "targetSuspectId": "suspect_riley", "relatedEvidenceIds": ["recovered_mercer_jacket"]}
    ]
))

# FREE CASE 3: Room 312
cases_data.append(create_case(
    caseId="room_312",
    title="Room 312",
    subtitle="Diplomatic envoy found suffocated in luxury suite with deadbolted door.",
    diff="standard",
    estMin=15,
    isPrem=False,
    briefing={
        "location": "The Sovereign Grand Hotel, Suite 312",
        "date": "2026-04-10",
        "victimOrSubject": "Sophia Chen",
        "summary": "Attaché Sophia Chen was found dead in her third-floor suite during a bilateral trade summit. The electronic lock recorded no visitor card transactions.",
        "objective": "Expose the elevator master override and master keycard misuse to uncover who bypassed the digital lock.",
        "requiredSolveConditions": ["Cross-examine keycard logs against elevator service telemetry", "Break concierge alibi", "Solve the sealed suite mystery"]
    },
    suspects=[
        {"suspectId": "suspect_andre", "caseId": "room_312", "name": "Andre Dupuis", "role": "Head Concierge", "age": 48, "relationshipToVictim": "Assigned private hospitality liaison", "profile": "Polished hotelier with secret high-stakes debts in overseas sports books.", "motiveScore": 0.4, "meansScore": 0.5, "opportunityScore": 0.3, "alibiStatus": "claimed", "suspicionLevel": "moderate", "initialAlibi": "Claims he stayed behind the front desk lobby from 21:00 until midnight.", "knownFacts": ["Possessed master service elevator card"], "unlockedFacts": []},
        {"suspectId": "suspect_victor", "caseId": "room_312", "name": "Victor Reyes", "role": "Suite 314 Neighbor", "age": 52, "relationshipToVictim": "Trade delegate across the corridor", "profile": "Diplomat from rival delegation under heavy press scrutiny.", "motiveScore": 0.3, "meansScore": 0.1, "opportunityScore": 0.2, "alibiStatus": "claimed", "suspicionLevel": "low", "initialAlibi": "Attending gala ballroom on ground floor.", "knownFacts": ["Ballroom photographs confirm presence"], "unlockedFacts": []},
        {"suspectId": "suspect_maria", "caseId": "room_312", "name": "Maria Santos", "role": "Night Housekeeping", "age": 34, "relationshipToVictim": "Floor staff", "profile": "Quiet worker with clean record.", "motiveScore": 0.1, "meansScore": 0.3, "opportunityScore": 0.2, "alibiStatus": "confirmed", "suspicionLevel": "low", "initialAlibi": "Cleaning 7th floor penthouse under camera surveillance.", "knownFacts": ["Logged on 7th floor cameras"], "unlockedFacts": []}
    ],
    evidence=[
        {"evidenceId": "coroner_chen", "caseId": "room_312", "title": "Coroner Report: Sophia Chen", "type": "medical_report", "summary": "Asphyxiation by feather pillow between 21:30 and 22:00. No signs of forced door entry.", "fullText": "Autopsy confirms mechanical smothering. The door's electronic lock showed no signs of physical forced entry or lockpicking.", "timestamp": "23:00", "source": "County Morgue", "reliability": "verified", "tags": ["Medical", "Autopsy"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": ["suspect_andre"], "discoveredInitially": True},
        {"evidenceId": "elevator_maintenance_log", "caseId": "room_312", "title": "Service Elevator 2 Override Record", "type": "security_record", "summary": "Service Elevator 2 locked on Priority Service Mode to Floor 3 at 21:35 by Badge #AD-01.", "fullText": "Microcontroller logs show elevator 2 recalled to Floor 3 with master key #AD-01 (assigned to Head Concierge Andre Dupuis) at 21:35 and held for 15 minutes.", "timestamp": "21:35", "source": "Otis Central Elevator Control", "reliability": "verified", "tags": ["Security", "Access"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": ["suspect_andre"], "discoveredInitially": True},
        {"evidenceId": "andre_statement_lobby", "caseId": "room_312", "title": "Andre Dupuis Statement", "type": "statement", "summary": "Andre swears he never left the front lobby desk during the entire evening shift.", "fullText": "\"I was stationed behind the concierge desk greeting delegates from 21:00 to 00:30. I never stepped foot on the guest room floors.\"", "timestamp": "00:45", "source": "Hotel Security Office", "reliability": "medium", "tags": ["Statement", "Alibi"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": ["suspect_andre"], "discoveredInitially": True},
        {"evidenceId": "connecting_balcony_lock", "caseId": "room_312", "title": "Service Closet Balcony Latch Audit", "type": "object_report", "summary": "Third-floor utility pantry balcony door unbolted, providing direct ledge access to Suite 312.", "fullText": "Technicians found the exterior window latch of Suite 312 unlocked. The adjacent service linen room connects directly across a 1-meter stone parapet.", "timestamp": "01:10", "source": "Forensic Unit", "reliability": "verified", "tags": ["Opportunity", "Balcony"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_andre"], "discoveredInitially": True},
        {"evidenceId": "andre_sports_debt", "caseId": "room_312", "title": "Sports Betting Foreclosure Letter", "type": "financial_record", "summary": "Andre owed $180,000 to syndicate; victim possessed briefcase containing cash bearer bonds.", "fullText": "Correspondence seized from Andre's staff locker demanding immediate payment by midnight.", "timestamp": "16:00", "source": "Staff Locker Search", "reliability": "verified", "tags": ["Motive", "Debt"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_andre"], "discoveredInitially": True},
        {"evidenceId": "bearer_bonds_pantry", "caseId": "room_312", "title": "Recovered Trade Delegation Bearer Bonds", "type": "financial_record", "summary": "$500,000 in unlisted bearer bonds stashed behind air duct in floor 3 service pantry.", "fullText": "Matching serial numbers from victim's diplomatic dispatch satchel found tucked in ductwork inside linen room.", "timestamp": "02:30", "source": "Linen Room Search", "reliability": "verified", "tags": ["Physical", "Contraband"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": ["suspect_andre"], "discoveredInitially": False, "unlockCondition": "contradiction_elevator_lobby"}
    ],
    timeline=[
        {"eventId": "t_elevator_override", "caseId": "room_312", "title": "Service elevator manual override", "eventDescription": "Service elevator locked to floor 3 by Andre's card.", "timeWindow": "21:35", "exactTime": "21:35", "canonicalOrder": 1, "sourceEvidenceId": "elevator_maintenance_log"},
        {"eventId": "t_incident_smother", "caseId": "room_312", "title": "Sophia Chen smothered", "eventDescription": "Victim incapacitated in suite 312.", "timeWindow": "21:40", "exactTime": "21:40", "canonicalOrder": 2, "sourceEvidenceId": "coroner_chen"},
        {"eventId": "t_andre_lobby_claim", "caseId": "room_312", "title": "Andre claimed lobby vigil", "eventDescription": "Andre claims continuous presence at front desk.", "timeWindow": "21:35", "exactTime": "21:35", "canonicalOrder": 3, "sourceEvidenceId": "andre_statement_lobby", "isFalseClaim": True, "conflictsWithEventIds": ["t_elevator_override"]}
    ],
    contradictions=[
        {
            "contradictionId": "contradiction_elevator_lobby",
            "caseId": "room_312",
            "title": "Service Elevator Log Breaks Lobby Alibi",
            "requiredEvidenceIds": ["andre_statement_lobby", "elevator_maintenance_log"],
            "type": "alibi_break",
            "explanation": "Andre claimed he never left the front lobby desk, but his individual security badge was logged overriding Service Elevator 2 directly to Floor 3 during the murder window.",
            "severity": "critical",
            "affectedSuspectId": "suspect_andre",
            "opportunityDelta": 0.7,
            "newAlibiStatus": "broken",
            "unlocks": ["bearer_bonds_pantry"]
        }
    ],
    solution={
        "culpritId": "suspect_andre",
        "requiredMotiveEvidenceIds": ["andre_sports_debt"],
        "requiredMeansEvidenceIds": ["coroner_chen"],
        "requiredOpportunityEvidenceIds": ["elevator_maintenance_log", "connecting_balcony_lock"],
        "requiredContradictionIds": ["contradiction_elevator_lobby"],
        "requiredTimelineEventIds": ["t_elevator_override"],
        "resolutionNarrative": "Desperate to pay off crushing gambling debts, Head Concierge Andre Dupuis took the service elevator to Floor 3, crossed the utility balcony into Suite 312, smothered Sophia Chen, and stole her diplomatic bearer bonds."
    },
    hints=[
        {"tier": "nudge", "text": "Examine the elevator system records against Andre's claim of remaining at the desk.", "targetSuspectId": "suspect_andre", "relatedEvidenceIds": ["andre_statement_lobby", "elevator_maintenance_log"]},
        {"tier": "direction", "text": "Badge #AD-01 was used to lock the service elevator on Floor 3 right when Sophia Chen was killed.", "targetSuspectId": "suspect_andre", "relatedEvidenceIds": ["elevator_maintenance_log"]},
        {"tier": "near_solution", "text": "Andre's elevator keycard usage destroys his lobby alibi and exposes his balcony break-in path.", "targetSuspectId": "suspect_andre", "relatedEvidenceIds": ["bearer_bonds_pantry"]}
    ]
))

# 12 PREMIUM CASES DEFINITION
premium_cases_specs = [
    # 1. The Silent Auction
    ("the_silent_auction", "The Silent Auction", "Stolen Renaissance painting replaced with high-grade counterfeit during black-tie gala.", "advanced", 22,
     "Vanderbilt Heritage Hall", "Lord Alistair Sterling", "Curator Lord Alistair was found strangled in the restoration vault after discovering a counterfeit Rembrandt in lot 14.",
     [
         ("suspect_clara", "Clara Sterling", "Widow & Heir", "Sole beneficiary of family trust facing estate taxation", 0.5, 0.4, 0.3),
         ("suspect_nathan", "Nathan Bell", "Chief Appraiser", "Master restorer whose forged provenance letters authenticated the fake", 0.6, 0.5, 0.4),
         ("suspect_marcus", "Marcus Cole", "Bidder Syndicate Head", "Offshore billionaire with private art bunker", 0.2, 0.1, 0.1)
     ],
     "suspect_nathan",
     "appraiser_forged_letter", "chemical_oil_pigment", ["cctv_vault_corridor", "uv_fluorescence_analysis"],
     "contradiction_uv_paint", "Nathan Bell claimed painting was authenticated 5 years ago, but UV spectroscopy proves titanium dioxide pigment synthesized in 2024."),

    # 2. Cold Signal
    ("cold_signal", "Cold Signal", "Signal tower engineer falls from microwave mast during communications blackout.", "advanced", 24,
     "Blackwood Ridge Relay Station", "Frank Miller", "Lead microwave engineer fell 80 meters from antenna platform. Safety line was severed with a heated carbon blade.",
     [
         ("suspect_owen", "Owen Hayes", "Junior Technician", "Disgruntled associate passed over for regional directorship", 0.5, 0.6, 0.4),
         ("suspect_sandra", "Sandra Ramos", "Station Commander", "Overseeing military telecom contract audit", 0.3, 0.2, 0.2),
         ("suspect_victor", "Victor Kane", "Supply Vendor", "Contractor delivering backup generator fuel", 0.1, 0.2, 0.1)
     ],
     "suspect_owen",
     "owen_grievance_memo", "heated_carbon_cutter", ["microwave_rf_power_log", "ladder_harness_sensor"],
     "contradiction_ladder_sensor", "Owen claimed he was grounded in base shack, but radio transponder in his climbing harness logged ascension at 21:15."),

    # 3. The Ninth Witness
    ("the_ninth_witness", "The Ninth Witness", "Key government witness poisoned in sequestered hotel room before grand jury testimony.", "advanced", 25,
     "Federal Court Annex Hotel", "David Ross", "David Ross ingested aconite toxin mixed into his room service tea 30 minutes before testifying.",
     [
         ("suspect_karen", "Karen Vance", "Deputy US Marshal", "Security detail lead with undisclosed offshore account", 0.6, 0.5, 0.5),
         ("suspect_hugo", "Hugo Drake", "Defense Attorney", "Legal counsel representing the indicted cartel kingpin", 0.4, 0.2, 0.1),
         ("suspect_charlie", "Charlie Sim", "Room Service Waiter", "Hotel staff member delivering dinner cart", 0.1, 0.2, 0.2)
     ],
     "suspect_karen",
     "bribe_offshore_transfer", "aconite_tincture_vial", ["hotel_floor_keycard_audit", "tea_cart_seal_log"],
     "contradiction_tea_seal", "Marshal Vance signed that the tea cart seal was intact upon room delivery, but chemical analysis shows poison was infused in the pantry before delivery."),

    # 4. Glass House
    ("glass_house", "Glass House", "Botanical conservatory director found collapsed inside rare tropical orchid pavilion.", "standard", 20,
     "Wellington Conservatory", "Dr. Gerald Thorne", "Director died from acute neurotoxic pesticide injection. Automated climate greenhouse glass vents were sealed shut.",
     [
         ("suspect_nadia", "Nadia Mercer", "Senior Botanist", "Researcher whose patented cross-breed was claimed by Thorne", 0.5, 0.6, 0.4),
         ("suspect_felix", "Felix Brandt", "Greenhouse Architect", "Designer of digital climate control system", 0.2, 0.3, 0.2),
         ("suspect_teresa", "Teresa Dunn", "Benefactor Trustee", "Foundation patron threatening endowment pullout", 0.3, 0.1, 0.1)
     ],
     "suspect_nadia",
     "patent_theft_memorandum", "pesticide_injector_syringe", ["humidity_controller_log", "greenhouse_thermal_scan"],
     "contradiction_humidity_alibi", "Nadia claimed she was in the herbarium all evening, but the digital humidity sensor recorded her bio-chip badge entering the tropical pavilion."),

    # 5. The Missing Minute
    ("the_missing_minute", "The Missing Minute", "Wall Street algorithmic trader found dead in high-frequency server cage.", "expert", 30,
     "Equinix Tier-4 Data Center", "Julian Thorne", "Quantitative architect electrocuted with modified high-voltage grounding clamp. Clock server NTP logs drifted by 60 seconds.",
     [
         ("suspect_adrian", "Adrian Cross", "Co-founder & CTO", "Developer facing expulsion for installing secret dark pool trading tap", 0.6, 0.6, 0.5),
         ("suspect_chloe", "Chloe Scott", "Compliance Officer", "Auditor who flagged irregular trade logs", 0.2, 0.2, 0.1),
         ("suspect_liam", "Liam Chen", "Facility Engineer", "Technician with cage key privileges", 0.1, 0.3, 0.2)
     ],
     "suspect_adrian",
     "dark_pool_audit_memo", "grounding_cable_clamp", ["ntp_clock_drift_telemetry", "biometric_cage_bypass"],
     "contradiction_clock_drift", "Adrian claimed an automated algorithmic trade executed while he was offline, but server NTP logs prove the clock was manually wound back by 60 seconds from his terminal."),

    # 6. The Harbor Alibi
    ("the_harbor_alibi", "The Harbor Alibi", "Yacht club commodore found drowned in harbor basin with severed scuba regulator.", "advanced", 22,
     "Pelican Point Yacht Basin", "Harrison Gray", "Harrison Gray's body recovered trapped beneath hull of racing sloop 'Pegasus'. Air tank regulator was intentionally jammed.",
     [
         ("suspect_brett", "Brett Sterling", "Racing Rival", "Skipper whose vessel was disqualified by Gray", 0.6, 0.5, 0.4),
         ("suspect_valerie", "Valerie Gray", "Estranged Spouse", "Facing unfavorable prenuptial agreement", 0.4, 0.2, 0.2),
         ("suspect_samuel", "Samuel Finn", "Dockmaster", "Harbor technician with dive locker keys", 0.1, 0.3, 0.2)
     ],
     "suspect_brett",
     "disqualification_grievance", "dive_knife_tamper_marks", ["tide_gauge_telemetry", "fuel_dock_camera"],
     "contradiction_tide_draft", "Brett claimed his yacht was anchored out in deep water all night, but the low tide harbor gauge proves a boat of his draft could only have been berthed at the crime slip."),

    # 7. Dead Drop
    ("dead_drop", "Dead Drop", "Intelligence operative found dead on park bench with decrypted cryptographic ledger.", "expert", 28,
     "Oakhaven Arboretum", "Agent Martin Cole", "Undercover agent poisoned via transdermal patch on neck while retrieving dead drop from hollow monument.",
     [
         ("suspect_roman", "Roman Kane", "Double Agent Analyst", "Intelligence officer selling operative identities to foreign buyers", 0.7, 0.5, 0.5),
         ("suspect_maya", "Maya Lin", "Field Contact", "Courier assigned to exchange encrypted token", 0.3, 0.2, 0.2),
         ("suspect_sergei", "Sergei Vane", "Diplomatic Cultural Attache", "Foreign embassy liaison under surveillance", 0.4, 0.1, 0.1)
     ],
     "suspect_roman",
     "treason_escrow_deposit", "transdermal_fentanyl_patch", ["park_cellular_triangulation", "bench_infrared_cctv"],
     "contradiction_cellular_mast", "Roman claimed he was at headquarters review, but his encrypted secondary phone pinged the park repeater adjacent to the monument at 22:14."),

    # 8. The Last Reservation
    ("the_last_reservation", "The Last Reservation", "Michelin 3-star executive chef poisoned during private VIP dining tasting.", "standard", 18,
     "Restaurant L'Ombre", "Chef Antoine Laurent", "Antoine collapsed during course 7 tasting. Deadly cyanide compound coated inside of vintage Burgundy bottle neck.",
     [
         ("suspect_julien", "Julien Moreau", "Head Sommelier", "Embezzling grand cru wine cellar bottles replaced with vinegar duplicates", 0.6, 0.6, 0.4),
         ("suspect_celeste", "Celeste Ray", "Sous Chef", "Passed over for head chef partnership", 0.3, 0.3, 0.2),
         ("suspect_bernard", "Bernard Cole", "Food Critic", "Hostile reviewer with past litigation", 0.2, 0.1, 0.1)
     ],
     "suspect_julien",
     "wine_fraud_inventory", "corkscrew_cyanide_needle", ["cellar_digital_padlock", "sommelier_order_slip"],
     "contradiction_cellar_padlock", "Julien claimed cellar access was locked since 18:00, but cellar smart padlock logs show his private PIN accessed the vintage reserve at 21:05."),

    # 9. The Blue Umbrella
    ("the_blue_umbrella", "The Blue Umbrella", "Subway platform commuter pushed onto tracks during crowded rush hour.", "advanced", 24,
     "Lexington Central Metro Station", "Gordon Price", "Financial whistleblower pushed in front of incoming uptown express. Attacker carried distinctive blue umbrella.",
     [
         ("suspect_richard", "Richard Hayes", "Corporate Executive", "Target of Gordon's upcoming SEC whistleblower testimony", 0.7, 0.4, 0.5),
         ("suspect_derek", "Derek Moss", "Transit Janitor", "Recovered dropped briefcase on platform", 0.1, 0.2, 0.1),
         ("suspect_tanya", "Tanya Vance", "Platform Commuter", "Standing adjacent to victim on platform edge", 0.2, 0.1, 0.2)
     ],
     "suspect_richard",
     "sec_subpoena_notice", "modified_umbrella_tip", ["subway_turnstile_rfid", "platform_camera_timestamp"],
     "contradiction_turnstile_exit", "Richard claimed he took a private limousine uptown, but transit MetroCard telemetry recorded his personal card scanning out turnstile 4 seconds after the incident."),

    # 10. Static on Line Seven
    ("static_on_line_seven", "Static on Line Seven", "Commuter rail switchman murdered in junction tower during electrical surge.", "advanced", 22,
     "Junction 14 Switch Tower", "Thomas Bell", "Thomas Bell bludgeoned and thrown against 600V relay busbar. Mechanical interlocking switch altered to cause head-on rail collision.",
     [
         ("suspect_greg", "Greg Dawson", "Suspended Signalman", "Dismissed for substance violation seeking vengeance on railroad", 0.6, 0.6, 0.5),
         ("suspect_kyle", "Kyle Ortiz", "Night Supervisor", "Covering up maintenance inspection negligence", 0.3, 0.2, 0.2),
         ("suspect_brett", "Brett Vance", "Freight Conductor", "Operator of oncoming manifest freight train", 0.1, 0.1, 0.1)
     ],
     "suspect_greg",
     "grievance_termination_letter", "insulated_copper_prybar", ["switch_hydraulic_telemetry", "tower_keypad_log"],
     "contradiction_switch_telemetry", "Greg claimed he was at a sports bar across the river, but tower door keypad records his old deactivated maintenance code entered at 23:11."),

    # 11. The Founder’s Exit
    ("the_founders_exit", "The Founder's Exit", "Tech unicorn founder collapses during high-stakes board buyout vote.", "expert", 26,
     "AeroSpace Tower, Floor 50", "Evelyn Vance", "Evelyn suffered sudden respiratory failure during executive boardroom vote. Digital stylus pen contained micro-injection reservoir.",
     [
         ("suspect_simon", "Simon Reed", "Managing Partner", "Venture capital board director orchestrating hostile removal", 0.7, 0.5, 0.6),
         ("suspect_lucas", "Lucas Vance", "Estranged Brother & Co-founder", "Fighting over founder equity dilution", 0.4, 0.3, 0.3),
         ("suspect_diana", "Diana Croft", "Executive Assistant", "Scheduled the signing dinner and catered drinks", 0.2, 0.2, 0.2)
     ],
     "suspect_simon",
     "boardroom_liquidation_clause", "pneumatic_stylus_pen", ["digital_contract_timestamp", "boardroom_telepresence_log"],
     "contradiction_digital_pen", "Simon claimed Evelyn signed the surrender of equity voluntarily, but digital stylus biometric sensors prove pressure was applied by a second hand over hers."),

    # 12. The Ash Ledger
    ("the_ash_ledger", "The Ash Ledger", "Chief financial compliance officer incinerated in commercial shredder facility.", "expert", 28,
     "Iron Mountain Archive Facility", "Maxwell Vance", "Maxwell's body recovered from industrial shredding incinerator hopper. Tax audit ledgers were partially burned.",
     [
         ("suspect_cynthia", "Cynthia Sterling", "Managing Director", "Leader of offshore holding network concealing $80M in tax evasion", 0.7, 0.6, 0.5),
         ("suspect_howard", "Howard Vance", "Facility Supervisor", "Plant manager with override key to incinerator feed conveyor", 0.4, 0.4, 0.3),
         ("suspect_leo", "Leo Drake", "Archive Guard", "Security officer on perimeter night watch", 0.1, 0.1, 0.2)
     ],
     "suspect_cynthia",
     "subpoena_offshore_tax", "incinerator_manual_override_key", ["archive_turnstile_rfid", "shredder_temperature_log"],
     "contradiction_shredder_temp", "Cynthia claimed the incinerator ran on automatic municipal cycles, but burner thermal charts prove manual override fuel injection was triggered from her administrative terminal.")
]

for spec in premium_cases_specs:
    cid, title, sub, diff, estMin, loc, victim, summ, sus_tuples, culpritId, motId, meansId, oppIds, cId, cExpl = spec

    suspects = []
    for s_id, s_name, s_role, s_prof, m, ms, o in sus_tuples:
        suspects.append({
            "suspectId": s_id, "caseId": cid, "name": s_name, "role": s_role, "age": 42,
            "relationshipToVictim": "Key professional connection", "profile": s_prof,
            "motiveScore": m, "meansScore": ms, "opportunityScore": o,
            "alibiStatus": "claimed" if s_id == culpritId else "confirmed",
            "suspicionLevel": "moderate" if s_id == culpritId else "low",
            "initialAlibi": f"Claimed offsite during critical window.",
            "knownFacts": ["Present at venue earlier in day"], "unlockedFacts": []
        })

    evidence = [
        {"evidenceId": "ev_incident_" + cid, "caseId": cid, "title": "Incident & Autopsy File", "type": "medical_report", "summary": f"Incident analysis confirms foul play targeting {victim}.", "fullText": f"Forensic analysis reveals clear evidence of premeditated action resulting in the death of {victim}.", "timestamp": "23:00", "source": "Forensic Bureau", "reliability": "verified", "tags": ["Forensics"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": [culpritId], "discoveredInitially": True},
        {"evidenceId": motId, "caseId": cid, "title": "Critical Financial / Motive Record", "type": "financial_record", "summary": "Documentation establishing definitive motive against the accused.", "fullText": "Classified communication and financial transactions exposing urgent criminal motivation.", "timestamp": "18:00", "source": "Encrypted Safe File", "reliability": "high", "tags": ["Motive"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": [culpritId], "discoveredInitially": True},
        {"evidenceId": meansId, "caseId": cid, "title": "Instrument & Technical Means", "type": "object_report", "summary": "Physical mechanism or weapon matching incident marks.", "fullText": "Specialized equipment registered to or possessed by the primary suspect.", "timestamp": "21:30", "source": "Scene Recovery", "reliability": "verified", "tags": ["Means"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": [culpritId], "discoveredInitially": True},
        {"evidenceId": oppIds[0], "caseId": cid, "title": "Telemetry Log A", "type": "security_record", "summary": "Access or sensor telemetry establishing presence at scene.", "fullText": "Electronic sensor audit trails contradicting the suspect's public statement.", "timestamp": "21:15", "source": "Infrastructure DB", "reliability": "verified", "tags": ["Opportunity"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": [culpritId], "discoveredInitially": True},
        {"evidenceId": oppIds[1], "caseId": cid, "title": "Telemetry Log B", "type": "location_data", "summary": "Corroborating physical or digital surveillance record.", "fullText": "Independent digital trail verifying uncompromised opportunity window.", "timestamp": "21:20", "source": "Auxiliary Sensor", "reliability": "verified", "tags": ["Opportunity"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": [culpritId], "discoveredInitially": True},
        {"evidenceId": "ev_statement_" + cid, "caseId": cid, "title": "Suspect Alibi Deposition", "type": "statement", "summary": "Formal interview claiming complete absence from incident zone.", "fullText": "\"I was completely separated from the area and have zero knowledge of these events.\"", "timestamp": "23:30", "source": "Investigator Deposition", "reliability": "medium", "tags": ["Alibi"], "isKeyEvidence": True, "isPinned": True, "relatedSuspectIds": [culpritId], "discoveredInitially": True},
        {"evidenceId": "ev_unlocked_" + cid, "caseId": cid, "title": "Concealed Artifact Recovery", "type": "object_report", "summary": "Crucial evidence recovered following contradiction breakthrough.", "fullText": "Concealed personal item linking the suspect beyond reasonable doubt to the crime scene.", "timestamp": "02:00", "source": "Targeted Warrant Search", "reliability": "verified", "tags": ["Physical"], "isKeyEvidence": True, "isPinned": False, "relatedSuspectIds": [culpritId], "discoveredInitially": False, "unlockCondition": cId}
    ]

    contradictions = [
        {
            "contradictionId": cId,
            "caseId": cid,
            "title": f"Critical Discrepancy: {title}",
            "requiredEvidenceIds": ["ev_statement_" + cid, oppIds[0]],
            "type": "alibi_break",
            "explanation": cExpl,
            "severity": "critical",
            "affectedSuspectId": culpritId,
            "motiveDelta": 0.3,
            "meansDelta": 0.3,
            "opportunityDelta": 0.6,
            "newAlibiStatus": "broken",
            "unlocks": ["ev_unlocked_" + cid]
        }
    ]

    timeline = [
        {"eventId": "t_motive_" + cid, "caseId": cid, "title": "Motive Trigger Event", "eventDescription": "Financial or legal crisis triggers action.", "timeWindow": "18:00", "exactTime": "18:00", "canonicalOrder": 1, "sourceEvidenceId": motId},
        {"eventId": "t_incident_" + cid, "caseId": cid, "title": f"Incident at {loc}", "eventDescription": f"Offense executed against {victim}.", "timeWindow": "21:15", "exactTime": "21:15", "canonicalOrder": 2, "sourceEvidenceId": "ev_incident_" + cid},
        {"eventId": "t_claim_" + cid, "caseId": cid, "title": "Fabricated Alibi Claim", "eventDescription": "Suspect claims offsite presence.", "timeWindow": "21:15", "exactTime": "21:15", "canonicalOrder": 3, "sourceEvidenceId": "ev_statement_" + cid, "isFalseClaim": True, "conflictsWithEventIds": ["t_incident_" + cid]}
    ]

    solution = {
        "culpritId": culpritId,
        "requiredMotiveEvidenceIds": [motId],
        "requiredMeansEvidenceIds": [meansId],
        "requiredOpportunityEvidenceIds": [oppIds[0]],
        "requiredContradictionIds": [cId],
        "requiredTimelineEventIds": ["t_incident_" + cid],
        "resolutionNarrative": f"The case against {culpritId} is proven conclusively. Forensic logs, shattered alibis, and recovered physical mechanisms establish culpability beyond reasonable doubt."
    }

    hints = [
        {"tier": "nudge", "text": f"Scrutinize the statement of {culpritId} against the telemetry sensor logs.", "targetSuspectId": culpritId, "relatedEvidenceIds": ["ev_statement_" + cid, oppIds[0]]},
        {"tier": "direction", "text": f"Connect the alibi deposition with {oppIds[0]} to expose the chronological contradiction.", "targetSuspectId": culpritId, "relatedEvidenceIds": [oppIds[0]]},
        {"tier": "near_solution", "text": cExpl, "targetSuspectId": culpritId, "relatedEvidenceIds": ["ev_unlocked_" + cid]}
    ]

    cases_data.append(create_case(cid, title, sub, diff, estMin, True, {
        "location": loc, "date": "2026-05-15", "victimOrSubject": victim,
        "summary": summ, "objective": f"Expose the truth behind the incident at {loc}."
    }, suspects, evidence, timeline, contradictions, solution, hints))

# Write all JSON files
for c in cases_data:
    filename = os.path.join(cases_dir, f"{c['caseId']}.json")
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(c, f, indent=2, ensure_ascii=False)
    print(f"Generated {filename}")

print(f"Total cases generated: {len(cases_data)}")
