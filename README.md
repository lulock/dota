# Dota 2 Bots
Dota 2 MAS designed using OperA and BOD.

🚧 **WIP**: currently building on top of Valve's default bots by overriding select functions (but will eventually be a complete takeover). 


## Preliminary TODO

- [x] Draft heroes (hero_selection.lua)
  - [x] Hero selection (Sorted into Positions 1 through 5)
  - [x] Lane assignment (Determined by position)
  
- [ ] Reactive planner
  - [x] JSON plan structure
  - [x] Plan elements
  - [x] Plan builder
  - [ ] Behaviour library

## How to run

1. With Dota 2 already installed, locate and navigate to the installation directory, e.g. the default would be 'C:\Program Files (x86)\Steam\SteamApps\common\dota 2 beta' if the game was installed during beta.
2. In the 'dota 2 beta\game\dota\scripts\vscripts' directory, clone this repository and rename it 'bots'.This is where all bot scripts are read from.
3. Launch dota 2 and create a custom lobby by selecting 'Play Dota > Custom Lobby > Create'.
4. Tick enable cheats and list yourself as either a coach or unassigned player.
5. Edit the lobby settings and in your chosen team's section (can be either Radiant, Dire, or both) select from the bot difficulty dropdown any option but 'None'. From the bots dropdown, select 'Local Dev Script'.
6. Start the match.
