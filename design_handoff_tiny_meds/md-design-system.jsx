// Material 3 design tokens + atoms for Tiny Meds hi-fi
// Tokens lifted from the actual Flutter app_theme.dart

const MD = {
  // Light
  light: {
    primary:        '#0A84FF',
    onPrimary:      '#FFFFFF',
    primaryContainer: '#D6E7FF',
    onPrimaryContainer: '#001D36',

    surface:        '#F8F9FA',
    surfaceContainerLowest: '#FFFFFF',
    surfaceContainerLow:    '#F1F3F5',
    surfaceContainer:       '#ECEFF2',
    surfaceContainerHigh:   '#E5E8EB',
    surfaceContainerHighest:'#F1F3F5',

    onSurface:      '#1B1F24',
    onSurfaceVariant:'#5C6470',
    outline:        '#C0C6CD',
    outlineVariant: '#E2E5E9',

    // Expiry status (from getExpiryStatusColor)
    error:          '#BA1A1A',     // Expired
    errorContainer: '#FFDAD6',
    onErrorContainer:'#410002',
    expireToday:    '#D32F2F',
    expireSoon:     '#FF9800',     // Amber  — within 7d
    expireMonth:    '#FFA726',     // Light amber — within 30d
    success:        '#1B873B',
    successContainer:'#D8F0DD',

    scrim: 'rgba(0,0,0,0.4)',
  },
  dark: {
    primary:        '#A8C8FF',
    onPrimary:      '#003063',
    primaryContainer: '#00468C',
    onPrimaryContainer: '#D6E3FF',

    surface:        '#121212',
    surfaceContainerLowest: '#0B0B0B',
    surfaceContainerLow:    '#1A1A1A',
    surfaceContainer:       '#222222',
    surfaceContainerHigh:   '#2C2C2C',
    surfaceContainerHighest:'#2C2C2C',

    onSurface:      '#E6E1E5',
    onSurfaceVariant:'#9AA0A6',
    outline:        '#3C4147',
    outlineVariant: '#2A2D31',

    error:          '#FFB4AB',
    errorContainer: '#93000A',
    onErrorContainer:'#FFDAD6',
    expireToday:    '#FF6B6B',
    expireSoon:     '#FFB74D',
    expireMonth:    '#FFCC80',
    success:        '#7BD391',
    successContainer:'#1F4427',

    scrim: 'rgba(0,0,0,0.6)',
  }
};

// Type scale (M3)
const TYPE = {
  displayLarge:   { size: 57, weight: 400, lh: 1.12 },
  displayMedium:  { size: 45, weight: 400, lh: 1.16 },
  headlineLarge:  { size: 32, weight: 600, lh: 1.25 },
  headlineMedium: { size: 28, weight: 600, lh: 1.29 },
  headlineSmall:  { size: 24, weight: 600, lh: 1.33 },
  titleLarge:     { size: 22, weight: 600, lh: 1.27 },
  titleMedium:    { size: 16, weight: 600, lh: 1.5 },
  titleSmall:     { size: 14, weight: 600, lh: 1.43 },
  bodyLarge:      { size: 16, weight: 400, lh: 1.5 },
  bodyMedium:     { size: 14, weight: 400, lh: 1.43 },
  bodySmall:      { size: 12, weight: 400, lh: 1.33 },
  labelLarge:     { size: 14, weight: 600, lh: 1.43, ls: 0.1 },
  labelMedium:    { size: 12, weight: 600, lh: 1.33, ls: 0.5 },
  labelSmall:     { size: 11, weight: 600, lh: 1.45, ls: 0.5 },
};

// Hook for current theme
function useMd() {
  const [mode, setMode] = React.useState(
    () => document.documentElement.dataset.mode || 'light'
  );
  React.useEffect(() => {
    const el = document.documentElement;
    const mo = new MutationObserver(() => setMode(el.dataset.mode || 'light'));
    mo.observe(el, { attributes: true, attributeFilter: ['data-mode'] });
    return () => mo.disconnect();
  }, []);
  return MD[mode];
}

// ─── Atoms ───────────────────────────────────────────────────────────

const FONT = "'Inter', system-ui, -apple-system, 'Roboto', sans-serif";

function T({ v = 'bodyMedium', as: Tag = 'div', children, color, style, ...rest }) {
  const t = TYPE[v];
  return (
    <Tag style={{
      fontFamily: FONT,
      fontSize: t.size, fontWeight: t.weight, lineHeight: t.lh,
      letterSpacing: t.ls ? t.ls : 0,
      color: color || 'inherit',
      margin: 0,
      ...style
    }} {...rest}>{children}</Tag>
  );
}

// Icon: stroked SVG, M3 round style, 24×24 default
function Icon({ name, size = 24, color = 'currentColor', filled = false, style }) {
  const sw = filled ? 0 : 1.8;
  const paths = {
    pill: <g fill={filled ? color : 'none'} stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="9" width="18" height="6" rx="3" transform="rotate(-30 12 12)" />
      <line x1="9.4" y1="6.4" x2="14.6" y2="17.6" />
    </g>,
    bell: <g fill={filled ? color : 'none'} stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">
      <path d="M6 9a6 6 0 0 1 12 0v4l1.5 2.5h-15L6 13Z" />
      <path d="M10 18a2 2 0 0 0 4 0" />
    </g>,
    plus: <g fill="none" stroke={color} strokeWidth={2.2} strokeLinecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></g>,
    search: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round"><circle cx="11" cy="11" r="6.5"/><line x1="16" y1="16" x2="20.5" y2="20.5"/></g>,
    filter: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><path d="M4 6h16M7 12h10M10 18h4"/></g>,
    arrow_back: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><polyline points="14,6 8,12 14,18"/><line x1="8" y1="12" x2="20" y2="12"/></g>,
    close: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round"><line x1="6" y1="6" x2="18" y2="18"/><line x1="18" y1="6" x2="6" y2="18"/></g>,
    more: <g fill={color}><circle cx="6" cy="12" r="1.6"/><circle cx="12" cy="12" r="1.6"/><circle cx="18" cy="12" r="1.6"/></g>,
    edit: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><path d="M4 20h4l10-10-4-4L4 16v4Z"/><line x1="13" y1="7" x2="17" y2="11"/></g>,
    settings: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9c.2.6.7 1 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1Z"/></g>,
    home: <g fill={filled ? color : 'none'} stroke={color} strokeWidth={sw} strokeLinejoin="round"><path d="M4 11 12 4l8 7v8a1 1 0 0 1-1 1h-4v-6h-6v6H5a1 1 0 0 1-1-1Z"/></g>,
    calendar: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round"><rect x="4" y="5" width="16" height="15" rx="2"/><line x1="4" y1="10" x2="20" y2="10"/><line x1="9" y1="3" x2="9" y2="6"/><line x1="15" y1="3" x2="15" y2="6"/></g>,
    clock: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round"><circle cx="12" cy="12" r="8.5"/><polyline points="12,7 12,12 15.5,14"/></g>,
    warning: <g fill={filled ? color : 'none'} stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><path d="M12 3 2 20h20Z"/><line x1="12" y1="10" x2="12" y2="14"/><circle cx="12" cy="17" r="0.8" fill={color}/></g>,
    check: <g fill="none" stroke={color} strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round"><polyline points="5,12 10,17 19,7"/></g>,
    check_circle: <g fill={filled ? color : 'none'} stroke={color} strokeWidth={sw} strokeLinejoin="round"><circle cx="12" cy="12" r="9"/><polyline points="8,12 11,15 16,9" stroke={filled ? '#fff' : color}/></g>,
    inventory: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="6" width="18" height="14" rx="2"/><path d="M3 10h18M9 14h6"/></g>,
    camera: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><path d="M5 8h3l1.5-2h5L16 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1Z"/><circle cx="12" cy="13" r="3.5"/></g>,
    location: <g fill="none" stroke={color} strokeWidth={sw} strokeLinejoin="round"><path d="M12 21s7-6.5 7-12a7 7 0 1 0-14 0c0 5.5 7 12 7 12Z"/><circle cx="12" cy="9" r="2.5"/></g>,
    chevron: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><polyline points="9,6 15,12 9,18"/></g>,
    chevron_down: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><polyline points="6,9 12,15 18,9"/></g>,
    minus: <g fill="none" stroke={color} strokeWidth={2.2} strokeLinecap="round"><line x1="5" y1="12" x2="19" y2="12"/></g>,
    delete: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><polyline points="4,6 20,6"/><path d="M6 6v13a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V6"/><path d="M9 6V4h6v2"/></g>,
    download: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><path d="M12 4v12"/><polyline points="7,11 12,16 17,11"/><line x1="5" y1="20" x2="19" y2="20"/></g>,
    info: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round"><circle cx="12" cy="12" r="9"/><line x1="12" y1="11" x2="12" y2="16"/><circle cx="12" cy="8" r="0.8" fill={color}/></g>,
    droplet: <g fill={filled ? color : 'none'} stroke={color} strokeWidth={sw} strokeLinejoin="round"><path d="M12 3 6 12a6 6 0 0 0 12 0Z"/></g>,
    spray: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round"><rect x="9" y="9" width="6" height="11" rx="1"/><path d="M10 9V6h4v3"/><circle cx="6" cy="5" r="0.8" fill={color}/><circle cx="18" cy="5" r="0.8" fill={color}/><circle cx="5" cy="8" r="0.8" fill={color}/></g>,
    sun: <g fill="none" stroke={color} strokeWidth={sw} strokeLinecap="round"><circle cx="12" cy="12" r="4"/><line x1="12" y1="2" x2="12" y2="4"/><line x1="12" y1="20" x2="12" y2="22"/><line x1="2" y1="12" x2="4" y2="12"/><line x1="20" y1="12" x2="22" y2="12"/><line x1="5" y1="5" x2="6.5" y2="6.5"/><line x1="17.5" y1="17.5" x2="19" y2="19"/><line x1="5" y1="19" x2="6.5" y2="17.5"/><line x1="17.5" y1="6.5" x2="19" y2="5"/></g>,
  };
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" style={style}>
      {paths[name] || null}
    </svg>
  );
}

// Material ripple-feeling button
function FilledButton({ children, leading, color, bg, full, style, height = 40, ...p }) {
  const md = useMd();
  return (
    <button {...p} style={{
      height, padding: '0 24px', borderRadius: height / 2,
      background: bg || md.primary, color: color || md.onPrimary,
      border: 'none', fontFamily: FONT, fontSize: 14, fontWeight: 600, letterSpacing: 0.1,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      cursor: 'pointer', width: full ? '100%' : 'auto', ...style
    }}>
      {leading && <Icon name={leading} size={18} color={color || md.onPrimary} />}
      {children}
    </button>
  );
}

function OutlinedButton({ children, leading, full, style, height = 40, ...p }) {
  const md = useMd();
  return (
    <button {...p} style={{
      height, padding: '0 24px', borderRadius: height / 2,
      background: 'transparent', color: md.primary,
      border: `1px solid ${md.outline}`, fontFamily: FONT, fontSize: 14, fontWeight: 600, letterSpacing: 0.1,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      cursor: 'pointer', width: full ? '100%' : 'auto', ...style
    }}>
      {leading && <Icon name={leading} size={18} color={md.primary} />}
      {children}
    </button>
  );
}

function TextButton({ children, color, style, ...p }) {
  const md = useMd();
  return (
    <button {...p} style={{
      height: 36, padding: '0 12px', borderRadius: 18,
      background: 'transparent', color: color || md.primary,
      border: 'none', fontFamily: FONT, fontSize: 14, fontWeight: 600, letterSpacing: 0.1,
      cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 6, ...style
    }}>{children}</button>
  );
}

function Chip({ selected, leading, children, onClick, color }) {
  const md = useMd();
  return (
    <button onClick={onClick} style={{
      height: 32, padding: leading ? '0 14px 0 10px' : '0 14px',
      borderRadius: 8,
      background: selected ? (color ? color : md.surfaceContainerHigh) : 'transparent',
      color: selected ? (color ? '#fff' : md.onSurface) : md.onSurfaceVariant,
      border: selected ? 'none' : `1px solid ${md.outline}`,
      fontFamily: FONT, fontSize: 14, fontWeight: 500, letterSpacing: 0.1,
      display: 'inline-flex', alignItems: 'center', gap: 6, cursor: 'pointer',
      whiteSpace: 'nowrap',
    }}>
      {selected && !leading && <Icon name="check" size={16} color={color ? '#fff' : md.onSurface} />}
      {leading && <Icon name={leading} size={16} color={selected ? (color ? '#fff' : md.onSurface) : md.onSurfaceVariant} />}
      {children}
    </button>
  );
}

function Card({ children, style, padding = 16, elevated = false }) {
  const md = useMd();
  return (
    <div style={{
      background: elevated ? md.surfaceContainerLowest : md.surfaceContainer,
      borderRadius: 16, padding,
      boxShadow: elevated ? '0 1px 3px rgba(0,0,0,0.08), 0 1px 2px rgba(0,0,0,0.04)' : 'none',
      ...style
    }}>{children}</div>
  );
}

// Medicine illustration: a colored capsule/tablet/etc tile
function MedTile({ form = 'tablet', hue = 210, size = 56, rounded = 14 }) {
  const c1 = `oklch(0.85 0.08 ${hue})`;
  const c2 = `oklch(0.72 0.12 ${hue})`;
  const c3 = `oklch(0.55 0.14 ${hue})`;
  const half = size / 2;
  return (
    <div style={{
      width: size, height: size, borderRadius: rounded,
      background: `linear-gradient(135deg, ${c1}, ${c2})`,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      flexShrink: 0,
    }}>
      <svg width={size*0.6} height={size*0.6} viewBox="0 0 40 40">
        {form === 'tablet' && (
          <g>
            <circle cx="20" cy="20" r="14" fill="white" opacity="0.9"/>
            <line x1="6" y1="20" x2="34" y2="20" stroke={c3} strokeWidth="1.6" strokeLinecap="round"/>
          </g>
        )}
        {form === 'capsule' && (
          <g transform="rotate(-30 20 20)">
            <rect x="4" y="14" width="32" height="12" rx="6" fill="white" opacity="0.95"/>
            <rect x="4" y="14" width="16" height="12" rx="6" fill={c3} opacity="0.85"/>
          </g>
        )}
        {form === 'liquid' && (
          <g>
            <path d="M14 8 h12 v4 l2 2 v18 a2 2 0 0 1-2 2 h-12 a2 2 0 0 1-2-2 v-18 l2-2 z" fill="white" opacity="0.95"/>
            <rect x="14" y="22" width="12" height="10" fill={c3} opacity="0.8"/>
          </g>
        )}
        {form === 'cream' && (
          <g>
            <rect x="10" y="12" width="20" height="22" rx="3" fill="white" opacity="0.95"/>
            <rect x="14" y="6" width="12" height="6" rx="1.5" fill={c3} opacity="0.85"/>
            <rect x="13" y="18" width="14" height="3" rx="1" fill={c3} opacity="0.4"/>
          </g>
        )}
        {form === 'inhaler' && (
          <g>
            <rect x="12" y="6" width="16" height="22" rx="3" fill="white" opacity="0.95"/>
            <rect x="12" y="28" width="16" height="6" rx="2" fill={c3} opacity="0.85"/>
            <circle cx="20" cy="14" r="3" fill={c3} opacity="0.5"/>
          </g>
        )}
        {form === 'other' && (
          <g><circle cx="20" cy="20" r="10" fill="white" opacity="0.9"/><circle cx="20" cy="20" r="4" fill={c3}/></g>
        )}
      </svg>
    </div>
  );
}

function StatusPill({ kind, children }) {
  const md = useMd();
  const map = {
    expired:  { bg: md.errorContainer, fg: md.onErrorContainer, dot: md.error },
    today:    { bg: md.errorContainer, fg: md.onErrorContainer, dot: md.expireToday },
    soon:     { bg: 'rgba(255,152,0,0.15)', fg: md.expireSoon, dot: md.expireSoon },
    month:    { bg: 'rgba(255,167,38,0.12)', fg: md.expireMonth, dot: md.expireMonth },
    active:   { bg: md.successContainer, fg: md.success, dot: md.success },
    low:      { bg: 'rgba(255,152,0,0.15)', fg: md.expireSoon, dot: md.expireSoon },
  }[kind] || { bg: md.surfaceContainerHigh, fg: md.onSurfaceVariant, dot: md.onSurfaceVariant };
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 6,
      padding: '4px 10px', borderRadius: 8,
      background: map.bg, color: map.fg,
      fontFamily: FONT, fontSize: 12, fontWeight: 600, letterSpacing: 0.2,
      whiteSpace: 'nowrap',
    }}>
      <span style={{ width: 6, height: 6, borderRadius: '50%', background: map.dot }} />
      {children}
    </span>
  );
}

// Bottom nav (M3 NavigationBar)
function NavBar({ active = 0 }) {
  const md = useMd();
  const items = [
    { icon: 'home', label: 'Cabinet' },
    { icon: 'bell', label: 'Alerts' },
    { icon: 'calendar', label: 'Calendar' },
    { icon: 'settings', label: 'Settings' },
  ];
  return (
    <div style={{
      height: 80, display: 'flex',
      background: md.surfaceContainer,
      borderTop: `1px solid ${md.outlineVariant}`,
    }}>
      {items.map((it, i) => {
        const sel = i === active;
        return (
          <button key={i} style={{
            flex: 1, background: 'transparent', border: 'none', cursor: 'pointer',
            display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 4,
            padding: '12px 0',
          }}>
            <div style={{
              width: 64, height: 32, borderRadius: 16,
              background: sel ? md.primaryContainer : 'transparent',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Icon name={it.icon} size={24} color={sel ? md.onPrimaryContainer : md.onSurfaceVariant} filled={sel} />
            </div>
            <span style={{
              fontFamily: FONT, fontSize: 12, fontWeight: sel ? 600 : 500,
              color: sel ? md.onSurface : md.onSurfaceVariant, letterSpacing: 0.5,
            }}>{it.label}</span>
          </button>
        );
      })}
    </div>
  );
}

// Top app bar
function AppBar({ title, leading, trailing, large = false }) {
  const md = useMd();
  if (large) {
    return (
      <div style={{ background: md.surface, padding: '8px 4px 16px' }}>
        <div style={{ height: 56, display: 'flex', alignItems: 'center', padding: '0 4px' }}>
          {leading}
          <div style={{ flex: 1 }} />
          {trailing}
        </div>
        <T v="headlineMedium" style={{ padding: '8px 20px 0', color: md.onSurface }}>{title}</T>
      </div>
    );
  }
  return (
    <div style={{
      height: 64, display: 'flex', alignItems: 'center', padding: '0 4px',
      background: md.surface,
    }}>
      {leading}
      <T v="titleLarge" style={{ flex: 1, padding: '0 12px', color: md.onSurface }}>{title}</T>
      {trailing}
    </div>
  );
}

function IconBtn({ name, onClick, color, size = 24, badge }) {
  const md = useMd();
  return (
    <button onClick={onClick} style={{
      width: 48, height: 48, borderRadius: '50%', border: 'none', background: 'transparent',
      cursor: 'pointer', display: 'inline-flex', alignItems: 'center', justifyContent: 'center', position: 'relative',
    }}>
      <Icon name={name} size={size} color={color || md.onSurface} />
      {badge && (
        <span style={{
          position: 'absolute', top: 10, right: 10, minWidth: 16, height: 16,
          padding: '0 4px', borderRadius: 8, background: md.error, color: '#fff',
          fontFamily: FONT, fontSize: 10, fontWeight: 700,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>{badge}</span>
      )}
    </button>
  );
}

// FAB
function FAB({ icon = 'plus', extended, label, style }) {
  const md = useMd();
  return (
    <button style={{
      position: 'absolute', right: 16, bottom: 96,
      height: 56, minWidth: 56, padding: extended ? '0 16px 0 16px' : 0,
      borderRadius: 16, background: md.primary, color: md.onPrimary,
      border: 'none', cursor: 'pointer',
      display: 'inline-flex', alignItems: 'center', gap: 8, justifyContent: 'center',
      boxShadow: '0 1px 2px rgba(0,0,0,0.08), 0 4px 12px rgba(10,132,255,0.30)',
      fontFamily: FONT, fontSize: 14, fontWeight: 600, letterSpacing: 0.1,
      ...style
    }}>
      <Icon name={icon} size={24} color={md.onPrimary} />
      {extended && <span>{label}</span>}
    </button>
  );
}

// Phone shell — Pixel-style
function Phone({ children, mode = 'light', width = 380, height = 800, scale = 1 }) {
  const md = MD[mode];
  return (
    <div data-phone-mode={mode} style={{
      width, height, borderRadius: 44, padding: 8,
      background: mode === 'dark' ? '#0a0a0a' : '#1d1d1f',
      boxShadow: '0 30px 60px -20px rgba(0,0,0,0.35), 0 8px 24px -12px rgba(0,0,0,0.25)',
      transform: `scale(${scale})`, transformOrigin: 'top left',
      flexShrink: 0,
    }}>
      <div style={{
        position: 'relative', width: '100%', height: '100%', borderRadius: 36,
        background: md.surface, overflow: 'hidden',
        display: 'flex', flexDirection: 'column',
      }}>
        {/* Status bar */}
        <div style={{
          height: 32, padding: '0 24px',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          color: md.onSurface, fontFamily: FONT, fontSize: 13, fontWeight: 600,
          flexShrink: 0,
        }}>
          <span>9:41</span>
          <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
            <span style={{ fontSize: 11 }}>5G</span>
            <svg width="16" height="12"><rect x="0" y="0" width="14" height="10" rx="2" fill="none" stroke={md.onSurface} strokeWidth="1"/><rect x="2" y="2" width="9" height="6" rx="1" fill={md.onSurface}/></svg>
          </div>
        </div>
        {/* Punch hole */}
        <div style={{
          position: 'absolute', top: 8, left: '50%', transform: 'translateX(-50%)',
          width: 12, height: 12, borderRadius: '50%', background: '#000',
        }} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
          {children}
        </div>
        {/* Gesture bar */}
        <div style={{
          height: 24, display: 'flex', alignItems: 'center', justifyContent: 'center',
          flexShrink: 0,
        }}>
          <div style={{ width: 120, height: 4, borderRadius: 2, background: md.onSurface, opacity: 0.5 }} />
        </div>
      </div>
    </div>
  );
}

Object.assign(window, {
  MD, TYPE, FONT, useMd, T, Icon, FilledButton, OutlinedButton, TextButton,
  Chip, Card, MedTile, StatusPill, NavBar, AppBar, IconBtn, FAB, Phone,
});
