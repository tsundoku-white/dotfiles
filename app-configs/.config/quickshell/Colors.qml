pragma Singleton
import QtQuick

QtObject {
  // ── Backgrounds ──────────────────────────────────────────────────────
  // Neutral ramp based on #141414, ~+6 lightness per level.
  readonly property color bg: "#141414"
  readonly property color bgElevated: "#1a1a1a"
  readonly property color bgSurface: "#212121"
  readonly property color bgHover: "#2b2b2b"

  // ── Text ─────────────────────────────────────────────────────────────
  readonly property color textPrimary: "#ececec"
  readonly property color textSecondary: "#a1a1a1"
  readonly property color textMuted: "#6e6e6e"
  readonly property color textDim: "#c6c6c6"
  readonly property color textBright: "#ffffff"
  readonly property color textPower: "#e2e2e2"

  // ── Dividers ─────────────────────────────────────────────────────────
  readonly property color divider: "#262626"
  readonly property color dividerStrong: "#363636"

  // ── Accents ──────────────────────────────────────────────────────────
  // Muted, slightly desaturated so they sit well on near-black.
  readonly property color accent: "#ffffff"
  readonly property color accentDefault: "#6b9fff"
  readonly property color accentBlue: "#6b9fff"
  readonly property color accentGreen: "#4ade80"
  readonly property color accentRed: "#f87171"
  readonly property color accentOrange: "#fb9f5a"
  readonly property color accentPurple: "#a78bfa"
  readonly property color accentTeal: "#2dd4bf"

  // ── Design tokens ────────────────────────────────────────────────────
  readonly property int radiusPanel: 5
  readonly property int radiusCard: 5
  readonly property int radiusButton: 5

  readonly property color shadowColor: "#a6000000"
  readonly property real shadowBlur: 0.8

  function tint(color, alpha) {
    return Qt.rgba(color.r, color.g, color.b, alpha);
  }
}
