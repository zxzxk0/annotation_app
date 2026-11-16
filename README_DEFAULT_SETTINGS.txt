Requested default settings from Eugene Douglass

1. Data selection
   - Explicit default slide: PreSCCT1_HE.ome
   - Dropdown is selected before slide loading starts
   - Falls back to the first available slide only if that ID is absent

2. SYNC
   - syncEnabled starts as true
   - Header button initially displays "Sync: ON"
   - Status initially displays "Following H&E movement only"
   - Existing one-way H&E -> right-panel delta synchronization behavior is unchanged

Debug console:
  [Init] default slide: PreSCCT1_HE.ome
  [Init] sync default: ON
