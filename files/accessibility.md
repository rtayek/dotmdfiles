# Accessibility

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**, those words are used in the RFC sense.

## Font scaling

UI components MUST NOT use hard-coded font sizes or fixed pixel dimensions for text-bearing elements. All sizes MUST be derived from the system font metrics so they scale correctly when the OS font size is changed.

## Keyboard navigation

All UI functionality MUST be accessible via keyboard alone. No feature MUST require a mouse or pointer device.

## Tooltips and screen reader hints

All interactive controls MUST have a descriptive tooltip. All UI elements MUST have an accessible label or description suitable for screen readers.

## Color contrast

The UI MUST provide both a high-contrast and a low-contrast theme. Color MUST NOT be the sole means of conveying information.
