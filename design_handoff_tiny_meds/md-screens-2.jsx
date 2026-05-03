// Hi-fi M3 screens — Part 2: Add med, Alerts, Set up alert, Settings
/* global T, Icon, FilledButton, OutlinedButton, TextButton, Chip, Card, MedTile, StatusPill, NavBar, AppBar, IconBtn, FAB, Phone, useMd, FONT */

// ─── 5. Add medicine flow (step 2 of 4) ──────────────────────────────
function AddMedScreen() {
  const md = useMd();
  return (
    <Phone>
      {/* Top */}
      <div style={{ height: 56, display: 'flex', alignItems: 'center', padding: '0 4px', flexShrink: 0, background: md.surface }}>
        <IconBtn name="close" />
        <T v="titleLarge" style={{ flex: 1, padding: '0 8px', color: md.onSurface }}>Add medicine</T>
        <TextButton>Save</TextButton>
      </div>

      {/* Stepper */}
      <div style={{ padding: '8px 20px 16px', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 12 }}>
          {[0,1,2,3].map(i => (
            <div key={i} style={{
              flex: 1, height: 4, borderRadius: 2,
              background: i <= 1 ? md.primary : md.outlineVariant,
            }} />
          ))}
        </div>
        <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5 }}>STEP 2 OF 4</T>
        <T v="titleLarge" style={{ color: md.onSurface, marginTop: 2 }}>The basics</T>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '0 20px 24px' }}>
        {/* Scan card */}
        <div style={{
          background: md.primaryContainer, color: md.onPrimaryContainer,
          borderRadius: 16, padding: 16, display: 'flex', alignItems: 'center', gap: 14, marginBottom: 24,
          cursor: 'pointer',
        }}>
          <div style={{ width: 48, height: 48, borderRadius: 14, background: md.primary, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
            <Icon name="camera" size={24} color={md.onPrimary} />
          </div>
          <div style={{ flex: 1 }}>
            <T v="titleMedium" style={{ color: md.onPrimaryContainer }}>Scan the box</T>
            <T v="bodySmall" style={{ color: md.onPrimaryContainer, opacity: 0.8 }}>We'll fill in name, strength, expiry</T>
          </div>
          <Icon name="chevron" size={22} color={md.onPrimaryContainer} />
        </div>

        {/* Or divider */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 20, color: md.onSurfaceVariant }}>
          <div style={{ flex: 1, height: 1, background: md.outlineVariant }} />
          <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5 }}>OR ENTER MANUALLY</T>
          <div style={{ flex: 1, height: 1, background: md.outlineVariant }} />
        </div>

        {/* Name field (filled, M3 style) */}
        <div style={{ marginBottom: 16 }}>
          <div style={{
            background: md.surfaceContainerLowest, borderRadius: 12,
            border: `1px solid ${md.primary}`, padding: '8px 16px 8px',
            position: 'relative',
          }}>
            <T v="bodySmall" style={{ color: md.primary, fontWeight: 600 }}>Name</T>
            <T v="bodyLarge" style={{ color: md.onSurface, marginTop: 2 }}>Amoxicillin</T>
          </div>
        </div>

        {/* Strength + unit row */}
        <div style={{ display: 'grid', gridTemplateColumns: '1.4fr 1fr', gap: 12, marginBottom: 24 }}>
          <div style={{ background: md.surfaceContainerLowest, borderRadius: 12, border: `1px solid ${md.outline}`, padding: '8px 16px' }}>
            <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>Strength</T>
            <T v="bodyLarge" style={{ color: md.onSurface, marginTop: 2 }}>500</T>
          </div>
          <div style={{ background: md.surfaceContainerLowest, borderRadius: 12, border: `1px solid ${md.outline}`, padding: '8px 16px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div>
              <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>Unit</T>
              <T v="bodyLarge" style={{ color: md.onSurface, marginTop: 2 }}>mg</T>
            </div>
            <Icon name="chevron_down" size={20} color={md.onSurfaceVariant} />
          </div>
        </div>

        {/* Form selector */}
        <T v="titleSmall" style={{ color: md.onSurface, marginBottom: 10 }}>Form</T>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 24 }}>
          {[
            { l: 'Tablet',  i: 'pill' },
            { l: 'Capsule', i: 'pill', sel: true },
            { l: 'Liquid',  i: 'droplet' },
            { l: 'Cream',   i: 'edit' },
            { l: 'Inhaler', i: 'spray' },
            { l: 'Other',   i: 'more' },
          ].map((f, i) => (
            <Chip key={i} leading={f.i} selected={f.sel}>{f.l}</Chip>
          ))}
        </div>

        {/* Quantity stepper */}
        <T v="titleSmall" style={{ color: md.onSurface, marginBottom: 10 }}>Quantity</T>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 8 }}>
          <button style={{
            width: 44, height: 44, borderRadius: 22, border: `1px solid ${md.outline}`,
            background: 'transparent', cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Icon name="minus" size={22} color={md.onSurface} />
          </button>
          <div style={{
            flex: 1, height: 56, borderRadius: 12, border: `1px solid ${md.outline}`,
            background: md.surfaceContainerLowest, display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <T v="headlineSmall" style={{ color: md.onSurface }}>20</T>
            <T v="bodyMedium" style={{ color: md.onSurfaceVariant, marginLeft: 8 }}>capsules</T>
          </div>
          <button style={{
            width: 44, height: 44, borderRadius: 22, border: 'none',
            background: md.primary, cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Icon name="plus" size={22} color={md.onPrimary} />
          </button>
        </div>
      </div>

      {/* Footer */}
      <div style={{ padding: '12px 20px 20px', background: md.surface, borderTop: `1px solid ${md.outlineVariant}`, display: 'flex', gap: 12 }}>
        <OutlinedButton style={{ flex: 1 }} height={48}>Back</OutlinedButton>
        <FilledButton style={{ flex: 1.4 }} height={48}>Next: Where</FilledButton>
      </div>
    </Phone>
  );
}

// ─── 6. Alerts list ──────────────────────────────────────────────────
function AlertsScreen() {
  const md = useMd();
  return (
    <Phone>
      <div style={{ background: md.surface, padding: '8px 4px 16px', flexShrink: 0 }}>
        <div style={{ height: 56, display: 'flex', alignItems: 'center', padding: '0 4px' }}>
          <div style={{ flex: 1 }} />
          <IconBtn name="search" />
          <IconBtn name="more" />
        </div>
        <div style={{ padding: '4px 20px 0' }}>
          <T v="headlineMedium" style={{ color: md.onSurface }}>Alerts</T>
          <T v="bodyMedium" style={{ color: md.onSurfaceVariant, marginTop: 4 }}>2 today · 3 coming up</T>
        </div>
      </div>

      <div style={{ display: 'flex', gap: 8, padding: '8px 20px 12px', flexShrink: 0, overflowX: 'auto' }}>
        <Chip selected>All</Chip>
        <Chip leading="clock">Expiry</Chip>
        <Chip leading="inventory">Low stock</Chip>
        <Chip leading="bell">Doses</Chip>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '0 16px 16px' }}>
        {/* Today section */}
        <T v="labelLarge" style={{ color: md.error, padding: '8px 4px 12px', letterSpacing: 1, fontWeight: 700 }}>TODAY</T>

        {/* Expired alert */}
        <div style={{
          background: md.surfaceContainerLowest, borderRadius: 16, padding: 16, marginBottom: 8,
          borderLeft: `4px solid ${md.error}`,
        }}>
          <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}>
            <div style={{ width: 40, height: 40, borderRadius: 12, background: md.errorContainer, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
              <Icon name="warning" size={22} color={md.error} filled />
            </div>
            <div style={{ flex: 1 }}>
              <T v="titleMedium" style={{ color: md.onSurface }}>Loratadine expired</T>
              <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginTop: 2 }}>Expired Mar 14 · Kitchen drawer</T>
            </div>
            <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>2h ago</T>
          </div>
          <div style={{ display: 'flex', gap: 8, marginTop: 12, marginLeft: 52 }}>
            <FilledButton bg={md.error} color="#fff" height={36} style={{ padding: '0 16px' }}>Toss & remove</FilledButton>
            <TextButton>Snooze</TextButton>
          </div>
        </div>

        {/* Low stock */}
        <div style={{
          background: md.surfaceContainerLowest, borderRadius: 16, padding: 16, marginBottom: 16,
          borderLeft: `4px solid ${md.expireSoon}`,
        }}>
          <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}>
            <div style={{ width: 40, height: 40, borderRadius: 12, background: 'rgba(255,152,0,0.15)', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
              <Icon name="inventory" size={22} color={md.expireSoon} />
            </div>
            <div style={{ flex: 1 }}>
              <T v="titleMedium" style={{ color: md.onSurface }}>Cough Syrup running low</T>
              <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginTop: 2 }}>About 2 doses left · Bathroom</T>
            </div>
            <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>5h ago</T>
          </div>
          <div style={{ display: 'flex', gap: 8, marginTop: 12, marginLeft: 52 }}>
            <FilledButton height={36} style={{ padding: '0 16px' }}>Add to shopping</FilledButton>
            <TextButton>Mark refilled</TextButton>
          </div>
        </div>

        {/* Upcoming */}
        <T v="labelLarge" style={{ color: md.onSurfaceVariant, padding: '8px 4px 12px', letterSpacing: 1, fontWeight: 700 }}>UPCOMING</T>

        {[
          { i: 'clock', t: 'Amoxicillin expires soon', s: 'In 4 days · May 7', when: 'Wed', kind: 'soon' },
          { i: 'bell',  t: 'Vitamin D3 · daily',        s: 'Every day at 9:00 AM',  when: '9:00', kind: 'active' },
          { i: 'clock', t: 'Ibuprofen expires',         s: 'In 3 weeks · May 24',   when: 'May 24', kind: 'month' },
        ].map((a, i) => (
          <div key={i} style={{
            background: md.surfaceContainerLowest, borderRadius: 16, padding: 14, marginBottom: 8,
            display: 'flex', gap: 12, alignItems: 'center',
          }}>
            <div style={{ width: 40, height: 40, borderRadius: 12, background: md.surfaceContainerHigh, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
              <Icon name={a.i} size={20} color={md.onSurfaceVariant} />
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <T v="bodyMedium" style={{ color: md.onSurface, fontWeight: 600 }}>{a.t}</T>
              <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginTop: 2 }}>{a.s}</T>
            </div>
            <T v="labelMedium" style={{ color: md.onSurfaceVariant }}>{a.when}</T>
          </div>
        ))}
      </div>

      <NavBar active={1} />
    </Phone>
  );
}

// ─── 7. Set up an alert ──────────────────────────────────────────────
function SetAlertScreen() {
  const md = useMd();
  return (
    <Phone>
      <div style={{ height: 56, display: 'flex', alignItems: 'center', padding: '0 4px', flexShrink: 0, background: md.surface }}>
        <IconBtn name="arrow_back" />
        <T v="titleLarge" style={{ flex: 1, padding: '0 8px', color: md.onSurface }}>New alert</T>
        <TextButton>Save</TextButton>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '4px 20px 24px' }}>
        {/* For which med */}
        <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5, marginBottom: 8 }}>FOR</T>
        <div style={{
          background: md.surfaceContainerLowest, borderRadius: 16, padding: 12,
          display: 'flex', alignItems: 'center', gap: 12, marginBottom: 24,
        }}>
          <MedTile form="capsule" hue={200} size={48} rounded={12} />
          <div style={{ flex: 1 }}>
            <T v="titleMedium" style={{ color: md.onSurface }}>Amoxicillin 500mg</T>
            <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginTop: 2 }}>Fridge · 6 capsules</T>
          </div>
          <Icon name="chevron_down" size={22} color={md.onSurfaceVariant} />
        </div>

        {/* Alert type segmented */}
        <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5, marginBottom: 8 }}>TYPE</T>
        <div style={{
          display: 'flex', borderRadius: 24, border: `1px solid ${md.outline}`, overflow: 'hidden', marginBottom: 24,
        }}>
          {['Expiry','Low stock','Dose'].map((l, i) => {
            const sel = i === 0;
            return (
              <button key={l} style={{
                flex: 1, height: 44, border: 'none',
                background: sel ? md.secondary || md.primaryContainer : 'transparent',
                color: sel ? md.onPrimaryContainer : md.onSurface,
                fontFamily: FONT, fontSize: 14, fontWeight: 600, cursor: 'pointer',
                display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 6,
              }}>
                {sel && <Icon name="check" size={16} color={md.onPrimaryContainer} />}
                {l}
              </button>
            );
          })}
        </div>

        {/* Lead time picker — visual */}
        <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5, marginBottom: 8 }}>HOW EARLY</T>
        <Card padding={20} style={{ background: md.surfaceContainerLowest, marginBottom: 24 }}>
          <div style={{ position: 'relative', height: 56 }}>
            <div style={{ position: 'absolute', top: 26, left: 0, right: 0, height: 4, borderRadius: 2, background: md.outlineVariant }} />
            <div style={{ position: 'absolute', top: 26, left: 0, width: '40%', height: 4, borderRadius: 2, background: md.primary }} />
            {[
              { lab: '30 days', x: 0,    sel: false },
              { lab: '7 days',  x: 0.4,  sel: true  },
              { lab: '1 day',   x: 0.75, sel: false },
              { lab: 'Today',   x: 1,    sel: false },
            ].map((p, i) => (
              <div key={i} style={{
                position: 'absolute', top: 16, left: `${p.x*100}%`, transform: 'translateX(-50%)',
                display: 'flex', flexDirection: 'column', alignItems: 'center',
              }}>
                <div style={{
                  width: p.sel ? 24 : 14, height: p.sel ? 24 : 14, borderRadius: '50%',
                  background: p.sel ? md.primary : md.surfaceContainerLowest,
                  border: p.sel ? 'none' : `2px solid ${md.outline}`,
                  boxShadow: p.sel ? `0 0 0 8px ${md.primary}1a` : 'none',
                }} />
                <T v="bodySmall" style={{
                  color: p.sel ? md.primary : md.onSurfaceVariant,
                  marginTop: p.sel ? 4 : 9, fontWeight: p.sel ? 600 : 400,
                }}>{p.lab}</T>
              </div>
            ))}
          </div>
        </Card>

        {/* Time */}
        <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5, marginBottom: 8 }}>TIME OF DAY</T>
        <div style={{
          background: md.surfaceContainerLowest, borderRadius: 12, padding: '14px 16px',
          display: 'flex', alignItems: 'center', gap: 12, marginBottom: 24,
        }}>
          <Icon name="clock" size={22} color={md.onSurfaceVariant} />
          <T v="bodyLarge" style={{ flex: 1, color: md.onSurface }}>9:00 AM</T>
          <Icon name="chevron" size={20} color={md.onSurfaceVariant} />
        </div>

        {/* Preview */}
        <T v="labelMedium" style={{ color: md.onSurfaceVariant, letterSpacing: 0.5, marginBottom: 8 }}>PREVIEW</T>
        <div style={{
          background: md.surfaceContainerHigh, borderRadius: 16, padding: 14,
          display: 'flex', gap: 12, alignItems: 'flex-start',
        }}>
          <div style={{ width: 36, height: 36, borderRadius: 10, background: md.primary, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
            <Icon name="bell" size={18} color={md.onPrimary} filled />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
              <T v="bodyMedium" style={{ color: md.onSurface, fontWeight: 600 }}>Tiny Meds</T>
              <T v="bodySmall" style={{ color: md.onSurfaceVariant }}>now</T>
            </div>
            <T v="bodyMedium" style={{ color: md.onSurface, marginTop: 2 }}>Amoxicillin expires in 7 days</T>
            <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginTop: 2 }}>Tap to view in cabinet</T>
          </div>
        </div>
      </div>

      <div style={{ padding: '12px 20px 20px', background: md.surface, borderTop: `1px solid ${md.outlineVariant}` }}>
        <FilledButton full height={48}>Save alert</FilledButton>
      </div>
    </Phone>
  );
}

// ─── 8. Settings ─────────────────────────────────────────────────────
function SettingsScreen() {
  const md = useMd();
  const Toggle = ({ on }) => (
    <div style={{
      width: 52, height: 32, borderRadius: 16, padding: 2,
      background: on ? md.primary : md.surfaceContainerHigh,
      border: on ? 'none' : `2px solid ${md.outline}`,
      display: 'flex', alignItems: 'center', justifyContent: on ? 'flex-end' : 'flex-start',
    }}>
      <div style={{
        width: on ? 24 : 16, height: on ? 24 : 16, borderRadius: '50%',
        background: on ? md.onPrimary : md.outline,
      }} />
    </div>
  );

  const Row = ({ icon, label, sub, value, toggle, danger, last }) => (
    <div style={{
      padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 14,
      borderBottom: last ? 'none' : `1px solid ${md.outlineVariant}`,
    }}>
      {icon && <Icon name={icon} size={22} color={danger ? md.error : md.onSurfaceVariant} />}
      <div style={{ flex: 1 }}>
        <T v="bodyLarge" style={{ color: danger ? md.error : md.onSurface }}>{label}</T>
        {sub && <T v="bodySmall" style={{ color: md.onSurfaceVariant, marginTop: 2 }}>{sub}</T>}
      </div>
      {value && <T v="bodyMedium" style={{ color: md.onSurfaceVariant }}>{value}</T>}
      {toggle != null && <Toggle on={toggle} />}
      {!toggle && value === undefined && !danger && <Icon name="chevron" size={20} color={md.onSurfaceVariant} />}
    </div>
  );

  return (
    <Phone>
      <div style={{ background: md.surface, padding: '8px 4px 16px', flexShrink: 0 }}>
        <div style={{ height: 56, display: 'flex', alignItems: 'center', padding: '0 4px' }}>
          <div style={{ flex: 1 }} />
        </div>
        <T v="headlineMedium" style={{ padding: '4px 20px 0', color: md.onSurface }}>Settings</T>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '0 16px 24px' }}>
        {/* You card */}
        <Card padding={16} style={{ background: md.primaryContainer, marginBottom: 24 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
            <div style={{
              width: 56, height: 56, borderRadius: '50%', background: md.primary,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <T v="titleLarge" style={{ color: md.onPrimary }}>P</T>
            </div>
            <div style={{ flex: 1 }}>
              <T v="titleMedium" style={{ color: md.onPrimaryContainer }}>Your cabinet</T>
              <T v="bodySmall" style={{ color: md.onPrimaryContainer, opacity: 0.8 }}>22 medicines · since April 2026</T>
            </div>
            <Icon name="chevron" size={22} color={md.onPrimaryContainer} />
          </div>
        </Card>

        <T v="titleSmall" style={{ color: md.onSurface, padding: '0 4px 8px' }}>Notifications</T>
        <Card padding={0} style={{ background: md.surfaceContainerLowest, marginBottom: 24, overflow: 'hidden' }}>
          <Row icon="warning" label="Expiry alerts" toggle={true} />
          <Row icon="inventory" label="Low stock alerts" toggle={true} />
          <Row icon="bell" label="Dose reminders" toggle={false} />
          <Row icon="clock" label="Quiet hours" sub="Mute between 10:00 PM and 7:00 AM" />
          <Row icon="sun" label="Notification sound" value="Soft chime" last />
        </Card>

        <T v="titleSmall" style={{ color: md.onSurface, padding: '0 4px 8px' }}>Defaults</T>
        <Card padding={0} style={{ background: md.surfaceContainerLowest, marginBottom: 24, overflow: 'hidden' }}>
          <Row icon="clock" label="Default lead time" value="7 days" />
          <Row icon="inventory" label="Low-stock threshold" value="3 doses" />
          <Row icon="location" label="Default location" value="Kitchen" last />
        </Card>

        <T v="titleSmall" style={{ color: md.onSurface, padding: '0 4px 8px' }}>Your data</T>
        <Card padding={0} style={{ background: md.surfaceContainerLowest, marginBottom: 24, overflow: 'hidden' }}>
          <Row icon="download" label="Export as CSV" sub="Download your medicine list" />
          <Row icon="info" label="Medical disclaimer" />
          <Row icon="delete" label="Reset cabinet" sub="Permanently delete all data" danger last />
        </Card>

        <T v="bodySmall" style={{ color: md.onSurfaceVariant, textAlign: 'center', padding: '16px 0' }}>
          Tiny Meds v0.1 · Everything stays on this phone
        </T>
      </div>

      <NavBar active={3} />
    </Phone>
  );
}

Object.assign(window, { AddMedScreen, AlertsScreen, SetAlertScreen, SettingsScreen });
