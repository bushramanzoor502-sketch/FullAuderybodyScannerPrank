# Full Audery Body Scanner Prank — product website

Marketing site (single page) plus a standalone privacy policy page, for the **Full Audery Body Scanner
Prank** Android app (`C:\github\FullAuderyBodyScannerXray-UtilEdge`, package
`utiledge.full.audery.cloth.remover.scanner.xray.simulator`).

No build step, no dependencies. Open `index.html` in a browser, or serve the folder:

```bash
python -m http.server 8080
# then open http://127.0.0.1:8080/
```

## Structure

`index.html` is the single-page site; `privacy.html` is a standalone page so the
Play Store has a dedicated policy URL. `index.html` sections:

| Anchor | Section |
|---|---|
| `#top` | Hero — headline, CTAs, stats, floating phone with scan line |
| `#features` | Nine feature cards, one per real app capability |
| `#screens` | The six anatomy systems, on the app's LightGrey anatomy panel |
| `#how` | Five-step Quick X-Ray walkthrough |
| `#ai` | Generate X-Ray with AI, with a keyboard-accessible before/after compare slider |
| `#disclaimer` | Entertainment / not-a-medical-device disclaimer |
| `#privacy` | Privacy-by-design band (the teaser) |
| `#support` | Quick guides + permission table (`#permissions`) |
| `#faq` | FAQ and troubleshooting |
| `#contact` | Contact us — support email, Copy email address + Open in Gmail |
| `#get` | Final download CTA |

The header nav is a scrollspy: the link for the section in view gets `aria-current="page"`.
A back-to-top button appears after 700px of scroll.

## Design system

Colours are copied verbatim from the app (`ui/theme/Color.kt`, `ui/theme/Theme.kt`). The app ships a
single `darkColorScheme`, so the site is dark as well.

| Token | Hex | App origin |
|---|---|---|
| `--near-black` | `#101010` | `NearBlack` — background |
| `--dark-grey` | `#1C1C1C` | `DarkGrey` — surface |
| `--border-grey` | `#303030` | `BorderGrey` — outline |
| `--medium-grey` | `#B8B8B8` | `MediumGrey` — onSurfaceVariant / secondary |
| `--light-grey` | `#D0D0D0` | `LightGrey` — tertiary / anatomyPanel |
| `--white` | `#FFFFFF` | `PureWhite` — primary / onBackground |
| `--teal` `--coral` `--amber` `--sky` `--violet` `--sage` `--crimson` `--tan` | `#3FA9A0` `#E8767A` `#E0A93E` `#5B9BD5` `#8B7BD8` `#6FAE7C` `#D64545` `#C98A54` | `IllustrationColors` — badges and art only |

Typography is Nunito (Google Fonts), the family the app bundles in `res/font/`.

## Assets

Everything in `assets/img/` is taken from the app itself — no stock art.

- `assets/img/icons/app_icon.png`, `launcher.png` — launcher icon from `mipmap-xxxhdpi/`
- `assets/img/icons/system_*.png` — anatomy system badges from `res/drawable/`
- `assets/img/art/xray_*.png`, `photo_full.png` — full-body female anatomy layers and photo
- `assets/img/art/onboarding2/3.png` — onboarding artwork; `og.jpg` is a 1200x630 crop of onboarding 3

## Before going live

1. ~~The app still uses the default Android Studio launcher icon.~~ Done — `assets/img/icons/app_icon.png`
   and `launcher_round.png` now use the real icon (`design/app_icon_source.png` in the app repo is the
   source; regenerate with `scripts/generate-round-icon.ps1` if the icon changes again).
2. The "Get the app" / "Download for Android" CTAs already point at
   `https://play.google.com/store/apps/details?id=utiledge.full.audery.cloth.remover.scanner.xray.simulator`
   — confirm that URL resolves once the app is actually published, and update it if the applicationId
   changes again before release.
3. Set `SettingsLinks.PRIVACY_POLICY_URL` in the app (currently empty) to this page's hosted URL once
   the site is deployed.
4. Confirm the "Last updated" date on the privacy policy, and revisit section 5 if the Gemini
   integration ships differently.
5. Make the `og:image` meta tags absolute once the domain is known (they are relative today).
