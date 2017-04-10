# spacewarships
A Swift command line program to query the Star Wars API at https://swapi.co

# Usage
Run this project in Xcode. After downloading starship data from the Star Wars API, the program will prompt you to input the number of mega lights. The program will output a list of starship names with the number of stops they need to make.

# TODO
- Program should cache API output so subsequent instances can read data locally
- Internet reachability check
- Handle other HTTP status codes (301, 404, etc.)

# Sample output
`Loading starship data...
Please enter the number of mega lights or any other key to quit: 
1000000
Sentinel-class landing craft: 19
Death Star: 3
Millennium Falcon: 9
Y-wing: 74
X-wing: 59
TIE Advanced x1: 79
Executor: 0
Slave 1: 19
Imperial shuttle: 13
EF76 Nebulon-B escort frigate: 1
Calamari Cruiser: 0
A-wing: 49
B-wing: 65
Republic Cruiser: 0
Naboo fighter: 0
Naboo Royal Starship: 0
Scimitar: 0
J-type diplomatic barge: 0
AA-9 Coruscant freighter: 0
Jedi starfighter: 0
H-type Nubian yacht: 0
Star Destroyer: 0
Trade Federation cruiser: 0
Theta-class T-2c shuttle: 0
T-70 X-wing fighter: 0
Rebel transport: 11
Droid control ship: 0
Republic Assault ship: 0
Solar Sailer: 0
Republic attack cruiser: 0
Naboo star skiff: 0
Jedi Interceptor: 0
arc-170: 83
Banking clan frigte: 0
Belbullab-22 starfighter: 0
V-wing: 0
CR90 corvette: 1
Please enter the number of mega lights or any other key to quit: 
q
Program ended with exit code: 0`
