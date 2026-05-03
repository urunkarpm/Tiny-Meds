// Hi-fi M3 screens — Part 1: Onboarding, Cabinet (home), Search, Detail
/* global T, Icon, FilledButton, OutlinedButton, TextButton, Chip, Card, MedTile, StatusPill, NavBar, AppBar, IconBtn, FAB, Phone, useMd, FONT, TYPE */

const MEDS = [
  { name: 'Amoxicillin',  strength: '500mg',  form: 'capsule', qty: 6,  unit: 'capsules', loc: 'Fridge',          status: 'soon',    statusLabel: 'Expires in 4 days', hue: 200, exp: 'May 7' },
  { name: 'Ibuprofen',    strength: '200mg',  form: 'tablet',  qty: 14, unit: 'tablets',  loc: 'Kitchen drawer',  status: 'active',  statusLabel: 'Active',             hue: 35,  exp: 'Aug 2027' },
  { name: 'Vitamin D3',   strength: '1000IU', form: 'tablet',  qty: 90, unit: 'softgels', loc: 'Bedside',         status: 'active',  statusLabel: 'Active',             hue: 65,  exp: 'Jan 2028' },
  { name: 'Cough Syrup',  strength: '120ml',  form: 'liquid',  qty: 2,  unit: 'doses',    loc: 'Bathroom',        status: 'low',     statusLabel: 'Low stock',          hue: 320, exp: 'Nov 2026' },
  { name: 'Loratadine',   strength: '10mg',   form: 'tablet',  qty: 22, unit: 'tablets',  loc: 'Kitchen drawer',  status: 'expired', statusLabel: 'Expired Mar 14',     hue: 280, exp: 'Mar 14' },
  { name: 'Hydrocortisone',strength: '1%',    form: 'cream',   qty: 1,  unit: 'tube',     loc: 'Bathroom',        status: 'active',  statusLabel: 'Active',             hue: 15,  exp: 'Sep 2027' },
];

// ─── 1. Onboarding ───────────────────────────────────────────────────
function OnboardingScreen() {
  const md = useMd();
  return (
    <Phone>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', padding: '24px 24px 0' }}>
        {/* Hero illustration */}
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: 280, position: 'relative' }}>
          <div style={{
            position: 'absolute', width: 240, height: 240, borderRadius: '50%',
            background: `radial-gradient(circle, ${md.primaryContainer} 0%, transparent 70%)`,
          }} />
          <div style={{ position: 'relative', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
            <div style={{ transform: 'rotate(-8deg) translateY(8px)' }}><MedTile form="capsule" hue={210} size={88} rounded={22} /></div>
            <div style={{ transform: 'rotate(6deg)' }}><MedTile form="tablet" hue={35} size={88} rounded={22} /></div>
            <div style={{ transform: 'rotate(4deg)' }}><MedTile form="liquid" hue={320} size={88} rounded={22} /></div>
            <div style={{ transform: 'rotate(-6deg) translateY(4px)' }}><MedTile form="cream" hue={140} size={88} rounded={22} /></div>
          </div>
        </div>

        {/* Page indicator */}
        <div style={{ display: 'flex', gap: 6, justifyContent: 'center', marginTop: 12, marginBottom: 24 }}>
          <span style={{ width: 24, height: 6, borderRadius: 3, background: md.primary }} />
          <span style={{ width: 6, height: 6, borderRadius: 3, background: md.outline }} />
          <span style={{ width: 6, height: 6, borderRadius: 3, background: md.outline }} />
        </div>

        {/* Title + body */}
        <T v="headlineLarge" style={{ color: md.onSurface, marginBottom: 12 }}>Your medicine cabinet, organized.</T>
        <T v="bodyLarge" style={{ color: md.onSurfaceVariant, marginBottom: 32 }}>
          Track every bottle, get a heads-up before things expire, never run out of essentials.
        </T>
      </div>

      {/* Sticky CTA */}
      <div style={{ padding: '16px 24px 24px', display: 'flex', flexDirection: 'column', gap: 12 }}>
        <FilledButton full height={48}>Get started</FilledButton>
        <TextButton style={{ alignSelf: 'center' }}>I already have a list to import</TextButton>
        <T v="bodySmall" style={{ color: md.onSurfaceVariant, textAlign: 'center', marginTop: 8 }}>
          Stays on your phone. No account needed.
        </T>
      </div>
    </Phone>
  );
}

// ─── 2. Cabinet (home) ───────────────────────────────────────────────
function CabinetScreen() {
  const md = useMd();
  return (
    <Phone>
      {/* Large top app bar */}
      <div style={{ background: md.surface, padding: '8px 4px 16px', flexShrink: 0 }}>
        <div style={{ height: 56, display: 'flex', alignItems: 'center', padding: '0 4px' }}>
          <div style={{ flex: 1 }} />
          <IconBtn name="search" />
          <IconBtn name="bell" badge="2" />
        </div>
        <div style={{ padding: '4px 20px 0' }}>
          <T v="headlineMedium" style={{ color: md.onSurface }}>Cabinet</T>
          <T v="bodyMedium" style={{ color: md.onSurfaceVariant, marginTop: 4 }}>22 medicines · 2 need attention</T>
        </div>
      </div>

      {/* Body */}
      <div style={{ flex: 1, overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
        {/* Filter chips */}
        <div style={{ display: 'flex', gap: 8, padding: '8px 20px 12px', overflowX: 'auto' }}>
          <Chip selected>All · 22</Chip>
          <Chip>Expiring</Chip>
          <Chip>Low stock</Chip>
          <Chip>Expired</Chip>
          <Chip>By location</Chip>
        </div>

        <div style={{ flex: 1, overflowY: 'auto', padding: '0 16px 16px' }}>
          {/* Attention card */}
          <div style={{
            background: md.errorContainer, color: md.onErrorContainer,
            borderRadius: 16, padding: 16, display: 'flex', gap: 14, alignItems: 'center', marginBottom: 16,
          }}>
            <div style={{
              width: 40, height: 40, borderRadius: '50%', background: md.error, color: '#fff',
              display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
            }}>
              <Icon name="warning" size={22} color="#fff" filled />
            </div>
            <div style={{ flex: 1 }}>
              <T v="titleMedium" style={{ color: md.onErrorContainer }}>2 things need a look</T>
              <T v="bodySmall" style={{ color: md.onErrorContainer, opacity: 0.8 }}>1 expired · 1 running low</T>
            </div>
            <Icon name="chevron" size={22} color={md.onErrorContainer} />
          </div>

          {/* Section header */}
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '4px 4px 8px' }}>
            <T v="titleMedium" style={{ color: md.onSurface }}>Recently added</T>
            <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5 }}>SORT: NAME</T>
          </div>

          {/* List */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {MEDS.map((m, i) => (
              <div key={i} style={{
                background: md.surfaceContainerLowest, borderRadius: 16, padding: 12,
                display: 'flex', alignItems: 'center', gap: 14,
              }}>
                <MedTile form={m.form} hue={m.hue} size={56} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <T v="titleMedium" style={{ color: md.onSurface }}>{m.name}</T>
                  <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginTop: 2 }}>
                    {m.strength} · {m.qty} {m.unit} · {m.loc}
                  </T>
                  <div style={{ marginTop: 8 }}>
                    <StatusPill kind={m.status}>{m.statusLabel}</StatusPill>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* FAB above NavBar */}
        <FAB extended label="Add medicine" style={{ bottom: 96 }} />
      </div>

      <NavBar active={0} />
    </Phone>
  );
}

// ─── 3. Search & filter ──────────────────────────────────────────────
function SearchScreen() {
  const md = useMd();
  return (
    <Phone>
      {/* Search bar */}
      <div style={{ padding: '12px 16px', flexShrink: 0 }}>
        <div style={{
          height: 56, borderRadius: 28, background: md.surfaceContainer,
          display: 'flex', alignItems: 'center', padding: '0 8px 0 16px', gap: 12,
        }}>
          <Icon name="arrow_back" size={22} color={md.onSurfaceVariant} />
          <T v="bodyLarge" style={{ flex: 1, color: md.onSurface }}>ibu<span style={{ color: md.primary }}>|</span></T>
          <IconBtn name="close" size={20} />
        </div>
      </div>

      {/* Filter sheet (expanded) */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '8px 20px 24px' }}>
        <T v="labelLarge" style={{ color: md.onSurfaceVariant, padding: '8px 0 12px', letterSpacing: 1 }}>FILTERS</T>

        {/* Status filter */}
        <T v="titleSmall" style={{ color: md.onSurface, marginBottom: 10 }}>Status</T>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 24 }}>
          <Chip selected color={md.error}>Expired</Chip>
          <Chip selected color={md.expireSoon}>Expiring soon</Chip>
          <Chip>Low stock</Chip>
          <Chip>Active</Chip>
        </div>

        {/* Form filter */}
        <T v="titleSmall" style={{ color: md.onSurface, marginBottom: 10 }}>Form</T>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 24 }}>
          <Chip leading="pill">Tablet</Chip>
          <Chip leading="pill" selected>Capsule</Chip>
          <Chip leading="droplet">Liquid</Chip>
          <Chip>Cream</Chip>
          <Chip leading="spray">Inhaler</Chip>
        </div>

        {/* Location filter */}
        <T v="titleSmall" style={{ color: md.onSurface, marginBottom: 10 }}>Location</T>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 24 }}>
          <Chip leading="location">Kitchen drawer</Chip>
          <Chip leading="location" selected>Fridge</Chip>
          <Chip leading="location">Bathroom</Chip>
          <Chip leading="location">Bedside</Chip>
          <Chip leading="location">Travel kit</Chip>
        </div>

        {/* Expires within slider */}
        <T v="titleSmall" style={{ color: md.onSurface, marginBottom: 4 }}>Expires within</T>
        <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginBottom: 16 }}>~ 7 weeks</T>
        <div style={{ position: 'relative', height: 40, marginBottom: 8 }}>
          <div style={{ position: 'absolute', top: 18, left: 0, right: 0, height: 4, borderRadius: 2, background: md.outlineVariant }} />
          <div style={{ position: 'absolute', top: 18, left: 0, width: '35%', height: 4, borderRadius: 2, background: md.primary }} />
          <div style={{
            position: 'absolute', top: 8, left: '35%', transform: 'translateX(-50%)',
            width: 24, height: 24, borderRadius: '50%', background: md.primary,
            boxShadow: `0 0 0 8px ${md.primary}1a`,
          }} />
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 24 }}>
          <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>Today</T>
          <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>6 months</T>
        </div>
      </div>

      {/* Sticky footer */}
      <div style={{
        padding: '16px 20px 24px', background: md.surface,
        borderTop: `1px solid ${md.outlineVariant}`,
        display: 'flex', gap: 12, alignItems: 'center',
      }}>
        <TextButton>Clear</TextButton>
        <FilledButton style={{ flex: 1 }} height={48}>Show 3 results</FilledButton>
      </div>
    </Phone>
  );
}

// ─── 4. Medicine detail ──────────────────────────────────────────────
function DetailScreen() {
  const md = useMd();
  const m = MEDS[0]; // Amoxicillin
  return (
    <Phone>
      {/* Top bar */}
      <div style={{ height: 56, display: 'flex', alignItems: 'center', padding: '0 4px', flexShrink: 0, background: md.surface }}>
        <IconBtn name="arrow_back" />
        <div style={{ flex: 1 }} />
        <IconBtn name="edit" />
        <IconBtn name="more" />
      </div>

      <div style={{ flex: 1, overflowY: 'auto' }}>
        {/* Hero */}
        <div style={{ padding: '8px 20px 24px' }}>
          <div style={{ display: 'flex', alignItems: 'flex-start', gap: 16, marginBottom: 16 }}>
            <MedTile form={m.form} hue={m.hue} size={88} rounded={22} />
            <div style={{ flex: 1, paddingTop: 4 }}>
              <T v="headlineSmall" style={{ color: md.onSurface }}>{m.name}</T>
              <T v="bodyMedium" style={{ color: md.onSurfaceVariant, marginTop: 4 }}>
                {m.strength} · Capsule
              </T>
              <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginTop: 2 }}>by Generic Pharma</T>
              <div style={{ marginTop: 12 }}><StatusPill kind={m.status}>{m.statusLabel}</StatusPill></div>
            </div>
          </div>

          {/* Stat row */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            <Card padding={16} style={{ background: md.surfaceContainerLowest }}>
              <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5 }}>QUANTITY</T>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginTop: 8 }}>
                <T v="headlineMedium" style={{ color: md.onSurface }}>6</T>
                <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>capsules</T>
              </div>
              <div style={{ height: 4, background: md.outlineVariant, borderRadius: 2, marginTop: 12 }}>
                <div style={{ width: '30%', height: '100%', background: md.expireSoon, borderRadius: 2 }} />
              </div>
            </Card>
            <Card padding={16} style={{ background: md.surfaceContainerLowest }}>
              <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5 }}>EXPIRES</T>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginTop: 8 }}>
                <T v="headlineMedium" style={{ color: md.expireSoon }}>4</T>
                <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>days · May 7</T>
              </div>
              <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginTop: 12 }}>Opened Apr 22</T>
            </Card>
          </div>
        </div>

        {/* Details list */}
        <div style={{ padding: '0 20px 16px' }}>
          <T v="titleSmall" style={{ color: md.onSurface, marginBottom: 8 }}>Details</T>
          <Card padding={0} style={{ background: md.surfaceContainerLowest, overflow: 'hidden' }}>
            {[
              ['location', 'Where', 'Fridge'],
              ['calendar', 'Opened', 'Apr 22, 2026'],
              ['info',     'Prescribed by', 'Dr. Singh'],
              ['edit',     'Notes', 'Take with food'],
            ].map(([ic, l, v], i, arr) => (
              <div key={i} style={{
                padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 14,
                borderBottom: i < arr.length - 1 ? `1px solid ${md.outlineVariant}` : 'none',
              }}>
                <Icon name={ic} size={20} color={md.onSurfaceVariant} />
                <T v="bodyMedium" style={{ flex: 1, color: md.onSurface }}>{l}</T>
                <T v="bodyMedium" style={{ color: md.onSurfaceVariant }}>{v}</T>
              </div>
            ))}
          </Card>
        </div>

        {/* Alerts attached */}
        <div style={{ padding: '8px 20px 24px' }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
            <T v="titleSmall" style={{ color: md.onSurface }}>Alerts</T>
            <TextButton>+ Add alert</TextButton>
          </div>
          <Card padding={0} style={{ background: md.surfaceContainerLowest, overflow: 'hidden' }}>
            <div style={{ padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 14, borderBottom: `1px solid ${md.outlineVariant}` }}>
              <div style={{ width: 36, height: 36, borderRadius: '50%', background: md.primaryContainer, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <Icon name="bell" size={18} color={md.onPrimaryContainer} filled />
              </div>
              <div style={{ flex: 1 }}>
                <T v="bodyMedium" style={{ color: md.onSurface, fontWeight: 600 }}>7 days before expiry</T>
                <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>One-time · 9:00 AM</T>
              </div>
              <Icon name="chevron" size={20} color={md.onSurfaceVariant} />
            </div>
            <div style={{ padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 14 }}>
              <div style={{ width: 36, height: 36, borderRadius: '50%', background: md.surfaceContainerHigh, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <Icon name="inventory" size={18} color={md.onSurfaceVariant} />
              </div>
              <div style={{ flex: 1 }}>
                <T v="bodyMedium" style={{ color: md.onSurface, fontWeight: 600 }}>When 3 capsules left</T>
                <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>Low stock</T>
              </div>
              <Icon name="chevron" size={20} color={md.onSurfaceVariant} />
            </div>
          </Card>
        </div>
      </div>

      {/* Sticky actions */}
      <div style={{ padding: '12px 20px 20px', background: md.surface, borderTop: `1px solid ${md.outlineVariant}`, display: 'flex', gap: 12 }}>
        <OutlinedButton style={{ flex: 1 }} height={48} leading="minus">Take dose</OutlinedButton>
        <FilledButton style={{ flex: 1 }} height={48}>Refill</FilledButton>
      </div>
    </Phone>
  );
}

Object.assign(window, { OnboardingScreen, CabinetScreen, SearchScreen, DetailScreen });
