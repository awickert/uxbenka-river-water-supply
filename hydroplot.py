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
def dist_season_plot(_season, _marker, _color, _label, _zorder=None):
    if _color[1] == 'f':
        _linecolor = 'k'
    else:
        _linecolor = _color
    plt.errorbar(df['Runoff rate [mm/yr]'][_season],
                 df['Mean Plazuela Distance'][_season],
                 yerr=df['SD Plazuela Distance'][_season],
                 marker=_marker,
                 markerfacecolor=_color,
                 markeredgecolor=_linecolor,
                 ecolor=_linecolor,
                 label=_label,
                 zorder=_zorder,
                 linestyle='None')

def area_season_plot(_season, _marker, _color, _label, _zorder=None):
    if _color[1] == 'f':
        _linecolor = 'k'
    else:
        _linecolor = _color
    plt.plot(df['Runoff rate [mm/yr]'][_season],
             df['Fraction of basin with water access'][_season]*100,
             marker=_marker,
             markerfacecolor=_color,
             markeredgecolor=_linecolor,
             label=_label,
             zorder=_zorder,
             linestyle='None')

# Distances to plazuelas
fig = plt.figure(figsize=(6,6)) #figsize=(8,4))

plt.subplot(2,1,1)
dist_season_plot(_wet, 'o', '#67a9cf', 'Wet season')
dist_season_plot(_dry, '^', '#ef8a62', 'Dry season')
dist_season_plot(_annual, 'd', 'black', 'Annual mean')
dist_season_plot(_none, 's', '#f7f7f7', 'Additional simulations', -50)
_season = _none
plt.ylabel('Distance from plazuelas to\nnearest streams (mean, SD) [m]', fontsize=10)
#plt.xlabel('Specific discharge [mm yr$^{-1}$]', fontsize=14)
plt.xlim(0,2500)
plt.ylim(0,2300)
plt.legend(fontsize=10)
plt.text(0.026, 0.04, 'a', transform=plt.gca().transAxes, fontsize=14,
         horizontalalignment='left', verticalalignment='bottom', 
         fontweight='bold' )
plt.tight_layout()

# Buffer fraction of basin area
#fig = plt.figure()
plt.subplot(2,1,2)
area_season_plot(_wet, 'o', '#67a9cf', 'Wet season')
area_season_plot(_dry, '^', '#ef8a62', 'Dry season')
area_season_plot(_annual, 'd', 'black', 'Annual mean')
area_season_plot(_none, 's', '#f7f7f7', 'Additional simulations', -50)
plt.ylabel('Fraction of Rio Blanca catchment\nwith water access [%]', fontsize=10)
plt.xlim(0,2500)
plt.ylim(0,45)
plt.xlabel('Specific discharge [mm yr$^{-1}$]', fontsize=10)
plt.tight_layout()
plt.text(0.026, 0.96, 'b', transform=plt.gca().transAxes, fontsize=14,
         horizontalalignment='left', verticalalignment='top', 
         fontweight='bold' )
plt.savefig('RioBlanco_Uxbenka_Hydro.png')

