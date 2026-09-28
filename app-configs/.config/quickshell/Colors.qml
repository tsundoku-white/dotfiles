pragma Singleton
import QtQuick

QtObject {
  // ── Backgrounds ──────────────────────────────────────────────────────
  // Slightly cooler and deeper than a flat dark theme, with clear
  // separation between levels so elevated surfaces read as "elevated"
  // instead of everything sitting at nearly the same value.
  readonly property color bg: "#0a0b10"
  readonly property color bgElevated: "#15171f"
  readonly property color bgSurface: "#1d2028"
  readonly property color bgHover: "#262a35"

  // ── Text ─────────────────────────────────────────────────────────────
  readonly property color textPrimary: "#f5f6f8"
  readonly property color textSecondary: "#9a9eab"
  readonly property color textMuted: "#636773"
  readonly property color textDim: "#c2c5cf"
  readonly property color textBright: "#ffffff"
  readonly property color textPower: "#e7e9ee"

  // ── Dividers ─────────────────────────────────────────────────────────
  readonly property color divider: "#242732"
  readonly property color dividerStrong: "#2f3340"

  // ── Accents ──────────────────────────────────────────────────────────
  // One restrained primary accent used for focus states and selection.
  // Semantic colors are kept for meaning (power = red, volume = green)
  // but desaturated so they read as one family rather than a rainbow.
  readonly property color accent: "#5b93ff"
  readonly property color accentDefault: "#5b93ff"
  readonly property color accentBlue: "#5b93ff"
  readonly property color accentGreen: "#34d399"
  readonly property color accentRed: "#ff6b6b"
  readonly property color accentOrange: "#ffa958"
  readonly property color accentPurple: "#a78bfa"
  readonly property color accentTeal: "#2dd4bf"

  // ── Design tokens ────────────────────────────────────────────────────
  // Centralised so every panel/button shares the same rhythm instead of
  // each file inventing its own radius or shadow values.
  readonly property int radiusPanel: 10
  readonly property int radiusCard: 10
  readonly property int radiusButton: 10

  readonly property color shadowColor: "#8f000000"
  readonly property real shadowBlur: 0.55

  function tint(color, alpha) {
    return Qt.rgba(color.r, color.g, color.b, alpha);
  }
}
