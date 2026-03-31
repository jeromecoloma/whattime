# WhatTime

> A minimal macOS menubar-style time zone converter that understands natural language.

Just type a time — with as much or as little detail as you want — and instantly see it converted across your preset world locations. No dropdowns, no clicking through calendars.

## Requirements

- macOS 14 (Sonoma)+
- Xcode 15+

## Getting Started

```bash
git clone <your-repo-url>
cd WhatTime
./scripts/setup.sh   # installs deps, generates .xcodeproj, builds — no Xcode UI needed
```

Or if already set up:
```bash
make run             # build and launch
```

## Usage

Type a query in the search field and press **Return**. Click **×** to clear.

### Zone-only (current time in that location)

| Query | Interpreted as |
|-------|----------------|
| `guam` | Current time in Guam → all presets |
| `canada` | Current time in Canada (Ontario) → all presets |
| `australia` | Current time in Australia (Sydney) → all presets |
| `hong kong` | Current time in Hong Kong → all presets |
| `ph` | Current time in Manila → all presets |

### Time-only (uses your current timezone as source)

| Query | Interpreted as |
|-------|----------------|
| `now` | Current time, your timezone |
| `10` | 10:00 AM, your timezone |
| `10am` | 10:00 AM, your timezone |
| `11pm` | 11:00 PM, your timezone |
| `1130` | 11:30 AM, your timezone |
| `930` | 9:30 AM, your timezone |
| `1230p` | 12:30 PM, your timezone |
| `830a` | 8:30 AM, your timezone |

### With a source timezone

| Query | Interpreted as |
|-------|----------------|
| `10 guam` | 10:00 AM Guam → all presets |
| `11 ph` | 11:00 AM Manila → all presets |
| `8pm palau time` | 8:00 PM Palau → all presets |
| `8:30pm manila time` | 8:30 PM Manila → all presets |

### Point-to-point conversion

| Query | Interpreted as |
|-------|----------------|
| `10 guam to manila` | 10:00 AM Guam → Manila only |
| `8pm palau time to guam time` | 8:00 PM Palau → Guam only |
| `what is 8:30pm manila time to adelaide time` | Natural language prefix is ignored |

### Shorthand rules

- `a` or `am` — morning (e.g. `10a`, `10am`)
- `p` or `pm` — afternoon/evening (e.g. `10p`, `10pm`)
- No suffix — treated as AM (e.g. `10` = 10:00 AM)
- 3-digit compact — H:MM (e.g. `930` = 9:30 AM)
- 4-digit compact — HH:MM (e.g. `1130` = 11:30 AM)
- Zone abbreviations — `ph`, `hk`, `nz`, `kl`, `nyc`, `la`, and [many more](#supported-timezone-names)

## Default Preset Zones

Results are always shown for these four locations:

| | City | Timezone |
|---|------|----------|
| 🇦🇺 | Adelaide | Australia/Adelaide |
| 🇵🇭 | Manila | Asia/Manila |
| 🇵🇼 | Palau | Pacific/Palau |
| 🇬🇺 | Guam | Pacific/Guam |

## Supported Timezone Names

The parser recognises city names, country names, and short codes:

| Region | Accepted names |
|--------|---------------|
| **Philippines** | `manila`, `philippines`, `ph` |
| **Guam** | `guam` |
| **Palau** | `palau` |
| **Australia** | `adelaide`, `sydney`, `melbourne`, `brisbane`, `perth`, `darwin`, `hobart`, `canberra`, `australia` |
| **Japan** | `tokyo`, `japan` |
| **Singapore** | `singapore` |
| **Hong Kong** | `hong kong`, `hongkong`, `hk` |
| **Korea** | `seoul`, `korea` |
| **Malaysia** | `kuala lumpur`, `kl`, `malaysia` |
| **Thailand** | `bangkok`, `thailand` |
| **Indonesia** | `jakarta`, `indonesia` |
| **India** | `india`, `mumbai`, `delhi`, `kolkata` |
| **China** | `beijing`, `shanghai`, `china` |
| **UAE** | `dubai`, `uae` |
| **UK** | `london`, `uk` |
| **Europe** | `paris`, `berlin`, `amsterdam`, `rome`, `madrid`, `moscow` and country names |
| **USA** | `new york`, `nyc`, `eastern`, `los angeles`, `la`, `pacific`, `chicago`, `central`, `denver`, `mountain` |
| **Canada** | `toronto`, `canada`, `vancouver` |
| **New Zealand** | `auckland`, `new zealand`, `nz` |
| **Pacific** | `hawaii`, `honolulu`, `fiji`, `samoa`, `apia` |
| **Reference** | `utc`, `gmt` |

## Architecture

```
WhatTime/
├── App/           — @main entry point
├── Views/         — SwiftUI views (no business logic)
├── ViewModels/    — @MainActor ObservableObject state
├── Models/        — Codable data types
├── Services/      — NLP parser + time conversion logic
└── Helpers/       — TimeZoneData (preset list + name map)
```

**Data flow:** `TextField` → `ViewModel.processQuery()` → `NaturalLanguageParser` → `TimeConversionService` → `@Published results` → `List`

**Parser strategy:** patterns are tried most-specific first — strict (requires `time` keyword) → loose (zone only) → current-timezone (time only) → zone-only keyword → `now`. Each step validates the timezone name against a known map, so unrecognised input returns no results rather than a wrong answer.

## Building

```bash
make setup        # First-run: install deps, generate .xcodeproj, build
make build        # Debug build
make run          # Build and launch
make test         # Run unit tests
make lint         # SwiftLint
make format       # SwiftFormat
make archive      # Release archive
make clean        # Remove build artifacts
```

## License

MIT
