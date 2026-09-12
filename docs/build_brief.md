# Cattle Finder — Build Brief

Handoff document for starting the real build in Claude Code. Everything below reflects
decisions already locked in during planning — Claude Code shouldn't need to re-ask most
of these, just implement them.

## What it is

A mobile app (iOS + Android) for Australian farmers to search cattle for sale across
multiple sale sources and get alerted when new matching lots appear. Version 1 is
cattle-only, search/alert only (no in-app marketplace yet, but data structures should
allow adding one later without a rewrite).

## Confirmed technical stack

- **Flutter** — single codebase for iOS + Android
- **Supabase** — Postgres database, auth, saved searches, favourites, server-side functions
- **Firebase Cloud Messaging** — push notifications
- Email alerts alongside push (farmer chooses either/both)
- Alert check frequency: hourly

## Product decisions (locked in)

- **Pricing**: free at launch, no subscription/paywall/billing in v1
- **Accounts**: guest mode by default; account (email/Apple/Google) optional, needed only
  to save searches, sync across devices, or receive ongoing alerts
- **Coverage area**: Australia-wide from day one; farmer sets their own location and
  search radius (sensible default, e.g. 300–700km)
- **Cattle categories**: Steers, Heifers, Cows, Bulls, PTIC Heifers, Cows & Calves,
  Weaners, Feeders, Breeders, Mixed Mob
- **Breed filtering**: farmer picks one or more breeds, plus a Purebred / Crossbred / Both
  switch per search
- **Weight filtering**: min + max, plus an "include mixed-weight mobs that partly fall
  outside this range" toggle (mixed mobs get flagged in results, not excluded outright)
- **Price filtering**: filter by $/head, c/kg liveweight, c/kg dressed weight, min/max,
  plus an "include POA / no price listed" toggle
- **Location/freight**: search radius (should upgrade from straight-line to actual road
  distance), app gives a default freight estimate but farmer can override with their own
  rate; results show both purchase price and estimated landed cost per head
- **Head count filtering**: min + max, plus an "include mobs the seller is willing to
  split" toggle for mobs above the max
- **Listing display**: hybrid link-out — show enough detail to compare in-app, but send
  the farmer to the original source (AuctionsPlus/agent/saleyard/etc.) for the full
  listing and to transact
- **Listing sources**: existing online auction/classified sites, saleyard catalogues,
  livestock agency sale notices, **plus** farmers/agents can submit a listing link
  directly into the app
- **Submission moderation**: hybrid — trusted sources/agents publish automatically,
  anything unrecognised goes into an admin review queue

## ⚠️ Unresolved before connecting any live source

Before wiring up AuctionsPlus, TopX, Nutrien, Ray White Rural, GDL or similar, confirm
each source's actual terms for a farmer-facing app:

- AuctionsPlus's terms explicitly prohibit automated scraping tools
- A prior attempt used the Brave Search API as a workaround, but Brave's standard terms
  restrict persistent storage and redistribution of search results — not suitable for a
  live multi-user app without separately confirming rights
- Treat every source as **inactive** until one of these is confirmed: an official API/data
  partnership, a permitted feed/alert mechanism (e.g. saved-search email alerts forwarded
  in), or manual/farmer-submitted links

This isn't a blocker for building the app itself — build against mock data first (see
prototype below), and bring sources online one at a time as access is confirmed.

## First development milestone

A phone-search prototype using sample cattle data, demonstrating:
- Simple search and Advanced search screens
- Breed selection (with purebred/crossbred/both)
- Full category selection
- Min/max weight with mixed-mob toggle
- Results list + listing detail view
- Test case: does a 280–380kg mob correctly appear (flagged mixed-weight) when searching
  Speckle Park + cross, 320kg+? Does a 250–300kg mob correctly get excluded?

A working reference for all of this already exists — see attached
`cattle_finder_prototype.jsx`, a React/web prototype built to validate the screens and
filter logic (including the weight-overlap logic, split-mob logic, and freight/landed-cost
calculation). Porting this logic to Flutter/Dart is a reasonable starting point rather than
re-deriving the filter rules from scratch. The mock listing dataset in that file is also a
reasonable seed for Flutter development before live sources are connected.

## Roadmap after the prototype

1. Farmer feedback on the prototype (screens, filters actually used)
2. Confirm data-source access (see above) — parallel track, not blocking
3. Flutter + Supabase technical foundation
4. Accounts (guest mode + optional sign-in) and saved searches/favourites
5. Connect first live source — AuctionsPlus is the best first candidate once access is
   confirmed, since its listings already expose breed, sex and liveweight
6. Push (FCM) + email alerts on an hourly cycle
7. App Store / Play Store submission

## Working name

**Cattle Finder**
