pragma Singleton
import QtQuick

QtObject {
  // ── Raw palette (from colors.lua) ────────────────────────────────────
  readonly property color orange: "#ff7a00"
  readonly property color amber: "#ffb000"
  readonly property color pink: "#ff2a6d"
  readonly property color cyan: "#05d9e8"
  readonly property color purple: "#b967ff"
  readonly property color yellow: "#f9f002"
  readonly property color fg: "#f3e9dc"
  readonly property color comment: "#7a6a8a"
  readonly property color popup: "#1a1024"
  readonly property color sel: "#3a1f4d"
  readonly property color line: "#2a1838"

  // ── Backgrounds ──────────────────────────────────────────────────────
  readonly property color bg: "#0c0c0c"          // popup
  readonly property color bgElevated: "#0c0c0c"  // line
  readonly property color bgSurface: "#3a1f4d"   // sel
  readonly property color bgHover: "#4a2a60"     // derived: one step above sel

  // ── Text ─────────────────────────────────────────────────────────────
  readonly property color textPrimary: "#f3e9dc"    // fg
  readonly property color textSecondary: "#ffd1a0"  // @property / @variable.parameter
  readonly property color textMuted: "#7a6a8a"      // comment
  readonly property color textDim: "#cfc4b8"        // derived: between fg and comment
  readonly property color textBright: "#ffffff"
  readonly property color textPower: "#ffe9cc"      // derived: warm bright

  // ── Dividers ─────────────────────────────────────────────────────────
  readonly property color divider: "#3a1f4d"        // sel
  readonly property color dividerStrong: "#ff7a00"  // orange (WinSeparator / FloatBorder)

  // ── Accents ──────────────────────────────────────────────────────────
  readonly property color accent: "#ff7a00"
  readonly property color accentDefault: "#ff7a00"
  readonly property color accentBlue: "#05d9e8"    // cyan (no blue in palette)
  readonly property color accentGreen: "#f9f002"   // yellow (no green in palette)
  readonly property color accentRed: "#ff2a6d"     // pink
  readonly property color accentOrange: "#ff7a00"
  readonly property color accentPurple: "#b967ff"
  readonly property color accentTeal: "#05d9e8"    // cyan
  readonly property color accentAmber: "#ffb000"
  readonly property color accentYellow: "#f9f002"
  readonly property color accentPink: "#ff2a6d"

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
