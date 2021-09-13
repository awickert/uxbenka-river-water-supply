from matplotlib import pyplot as plt
import pandas as pd

plt.ion()

df = pd.read_csv('drainage_results.tsv', delimiter='\t')
df = df[df['Runoff rate [mm/yr]'] < 2500]

# Define the seasonal groups
_wet = df['Season'] == 'wet'
_dry = df['Season'] == 'dry'
_annual = df['Season'] == 'annual'
_none = df['Season'].isnull()

# Plazuela distance plotting
def dist_season_plot(_season, _fmt, _label, _zorder=None):
    plt.errorbar(df['Runoff rate [mm/yr]'][_season],
                 df['Mean Plazuela Distance'][_season],
                 yerr=df['SD Plazuela Distance'][_season],
                 fmt=_fmt,
                 label=_label,
                 zorder=_zorder)

def area_season_plot(_season, _fmt, _label, _zorder=None):
    plt.plot(df['Runoff rate [mm/yr]'][_season],
             df['Fraction of basin with water access'][_season]*100,
             _fmt,
             label=_label,
             zorder=_zorder)

# Distances to plazuelas
fig = plt.figure(figsize=(8,10)) #figsize=(8,4))

plt.subplot(2,1,1)
dist_season_plot(_wet, 'bo', 'Wet season')
dist_season_plot(_dry, 'ro', 'Dry season')
dist_season_plot(_annual, 'go', 'Annual mean')
dist_season_plot(_none, 'ko', 'Additional simulations', -50)
_season = _none
plt.ylabel('Distance from plazuelas to\nnearest streams (mean, SD) [m]', fontsize=14)
#plt.xlabel('Specific discharge [mm yr$^{-1}$]', fontsize=14)
plt.xlim(0,2500)
plt.legend(fontsize=12)
plt.tight_layout()

# Buffer fraction of basin area
#fig = plt.figure()
plt.subplot(2,1,2)
area_season_plot(_wet, 'bo', 'Wet season')
area_season_plot(_dry, 'ro', 'Dry season')
area_season_plot(_annual, 'go', 'Annual mean')
area_season_plot(_none, 'ko', 'Additional simulations', -50)
plt.ylabel('Fraction of Rio Blanca catchment\nwith water access [%]', fontsize=14)
plt.xlim(0,2500)
plt.xlabel('Specific discharge [mm yr$^{-1}$]', fontsize=14)
plt.tight_layout()

plt.savefig('RioBlanco_Uxbenka_Hydro.png')

