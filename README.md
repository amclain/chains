# Chains

```java
(!**********************************************************
    Example of how the Chains syntax should look.
    
    File extension = .axs.chains
***********************************************************!)

PROGRAM_NAME = 'NetLinx Preparser'
(^*********************************************************^)
(^                        DEVICES                          ^)
(^*********************************************************^)

// Single device.
dvTP        = 33000:1:0   'touchpanel-file[.tp4]'


// Device combine.
vdvTP       = 34000:1:0   'file-for-all-panels[.tp4]'
    dvTP1   = 10001:1:0
    dvTP2   = 10002:1:0
    
    
// Optional device file paths can instruct a tool on how
// to transfer the file without needing a workspace definition.

(^*********************************************************^)
(^                       CONSTANTS                         ^)
(^*********************************************************^)

MY_CONSTANT_INTEGER	    = 1
MY_CONSTANT_STRING	    = 'a string'

MY_CONSTANT_COMPOSITION = "#[var type]{MY_CONSTANT_STRING} plus another string"

(^*********************************************************^)
(^                        INCLUDES                         ^)
(^*********************************************************^)

#include 'amx-lib-log'

(^*********************************************************^)
(^                       STRUCTURES                        ^)
(^*********************************************************^)

volume:
    ui	lvl
    ch	mute
    ui	max
    ui	min
    ui	step
    ch	dim
    ui	dimAmount

(^*********************************************************^)
(^                       VARIABLES                         ^)
(^*********************************************************^)

ui myVar = 123

/*
// Variable types:
ui	unsigned int
si	signed int
ul	unsigned long
sl	signed long
ch	character
wc	wide character
st	string (char[255])
st[#]	string (char[#])
dv  device
dc  devchan
[named]	user-defined type
*/

// Split after equals.
ui myVar2 =
	456

(^*********************************************************^)
(^                       FUNCTIONS                         ^)
(^*********************************************************^)

volumeUp (ui chan) ->
    doStuff chan
    
// Split parameters on open parenthesis.
sinteger setVolume(
	ui channel
	ui level
) ->
	doStuff channel, level
	

(^*********************************************************^)
(^                         EVENTS                          ^)
(^*********************************************************^)

startup =>

mainline =>

data => vdvTP
	string ->
		doStuff
	
	online ->

// How to handle multiple channels / dev-chans.
// List kind of like an array?

button => vdvTP, CHANNEL_NUMBER
	push ->
		doStuff
	
	release ->
		doStuff


button =>
	vdvTP, CHANNEL_NUMBER_1
	vdvTP, CHANNEL_NUMBER_2
	DEV-CHAN

	push ->
		doStuff

	release ->
		doStuff

(^*********************************************************^)

// Header: (! *)

// Comments: //, /* */, (* *)

// Comments omitted from NetLinx: //^, /^ */, (^ *)

// Ranges:
	[1..5]		// [1, 2, 3, 4, 5]
	[1...5]		// [1, 2, 3, 4]

// Loops:
	for i in items
		doStuff i

	for i in [1..5]
		doStuff i

// Ternary:
	a = i > 3 ? x : y

// Switch, Case
	switch i
	case 1
		doStuff
	case 2
		doStuff

	case 3: doStuff
	case 4: doStuff

// Case, When

	case i
	when 1
		doStuff
	when 2: doStuff
	when x

	
(^*********************************************************^)
(^                     END OF PROGRAM                      ^)
(^          DO NOT PUT ANY CODE BELOW THIS COMMENT         ^)
(^*********************************************************^)

```
