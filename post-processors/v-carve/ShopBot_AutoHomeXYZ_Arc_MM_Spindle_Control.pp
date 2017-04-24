+------------------------------------------------
|                                                
|  ShopBot configuration file 
|                                                
+------------------------------------------------
|                                                
| History                                        
|                                                
| Who    When       What                         
| ======== ========== ===========================
| Tony M  22/06/2005 Written
| Brian M 08/07/2005 Modified to output feed units correctly
| Brian M 14/07/2005 Modified to output 6 d.p
| Brian M 16/06/2006 Added NEW_SEGMENT section
|                    in case new tool has different 
|                    feedrates to first tool
| Brian M 14/07/2006 Added circular arc support
| ScottJ  31/10/2007 setup file for PartWorks to keep look consistant
| ScottJ  12/05/2009 Fixed issue with mutiple toolpaths not remaining at Safe Z 
| Jens Dyvik  28/03/2017 Added autohoming by loading custom .sbp file in header
+------------------------------------------------


POST_NAME = "ShopBot AutohomeXYZ (arcs)(MM)(w/speed)(*.sbp)"

FILE_EXTENSION = "sbp"

UNITS = "MM"

+------------------------------------------------
+    Line terminating characters                 
+------------------------------------------------

LINE_ENDING = "[13][10]"


+================================================
+                                                
+    Formating for variables                     
+                                                
+================================================


+------------------------------------------------
+ Spindle Speed
+------------------------------------------------

var SPINDLE_SPEED = [S|A||1.0]

+------------------------------------------------
+ Feed Rate
+------------------------------------------------

var CUT_RATE    = [FC|A||1.2|0.0166]
var PLUNGE_RATE = [FP|A||1.2|0.0166]

+------------------------------------------------
+ Tool position in x,y and z
+------------------------------------------------

var X_POSITION = [X|A||1.6]
var Y_POSITION = [Y|A||1.6]
var Z_POSITION = [Z|A||1.6]

+------------------------------------------------
+ Home tool positions 
+------------------------------------------------

var X_HOME_POSITION = [XH|A||1.6]
var Y_HOME_POSITION = [YH|A||1.6]
var Z_HOME_POSITION = [ZH|A||1.6]

+------------------------------------------------
+ Arc centre positions - incremental from arc start
+------------------------------------------------

VAR ARC_CENTRE_I_INC_POSITION = [I|A||1.6]
VAR ARC_CENTRE_J_INC_POSITION = [J|A||1.6]

+================================================
+                                                
+    Block definitions for toolpath output       
+                                                
+================================================

+---------------------------------------------------
+  Commands output at the start of the file
+---------------------------------------------------


begin HEADER
 "FP,C:\SbParts\XYandZzero.sbp 		'load the file that automatically sets X, Y and Z Zero"
 "'SHOPBOT FILE IN MM"
 "IF %(25)=0 THEN GOTO UNIT_ERROR	'check to see software is set to standard"
 "C#,90				 	'Lookup offset values"
  "'"
"TR,[S],1"
 "'Turning router ON"
 "SO,1,1"
 "PAUSE 2"

"'"

"'Toolpath Name = [TOOLPATH_NAME]"
"'Tool Name   = [TOOLNAME]"
"MS,[FC],[FP]"
"JZ,[ZH]"
+"J2,[XH],[YH]" commented out this line to skip jog home at begining of file



+---------------------------------------------------
+  Commands output for rapid moves 
+---------------------------------------------------

begin RAPID_MOVE

"J3,[X],[Y],[Z]"


+---------------------------------------------------
+  Commands output for the first feed rate move
+---------------------------------------------------

begin FIRST_FEED_MOVE

"M3,[X],[Y],[Z]"


+---------------------------------------------------
+  Commands output for feed rate moves
+---------------------------------------------------

begin FEED_MOVE

"M3,[X],[Y],[Z]"


+---------------------------------------------------
+  Commands output for clockwise arc  move
+---------------------------------------------------

begin CW_ARC_MOVE

"CG, ,[X],[Y],[I],[J],T,1"


+---------------------------------------------------
+  Commands output for counterclockwise arc  move
+---------------------------------------------------

begin CCW_ARC_MOVE

"CG, ,[X],[Y],[I],[J],T,-1"

+---------------------------------------------------
+  Commands output for a new segment - toolpath
+  with same toolnumber but maybe different feedrates
+---------------------------------------------------

begin NEW_SEGMENT

"'Toolpath Name = [TOOLPATH_NAME]"
"'Tool Name   = [TOOLNAME]"
"TR,[S],1"
"MS,[FC],[FP]"
"J3,[X],[Y],[ZH]"


+---------------------------------------------------
+  Commands output at the end of the file
+---------------------------------------------------

begin FOOTER

"JZ,[ZH]"
"'"
"'Turning router OFF"
"SO,1,0"
"J2,[XH],[YH]"
"END"
"UNIT_ERROR:"				
"C#,91					'Run file explaining unit error"
"END"


