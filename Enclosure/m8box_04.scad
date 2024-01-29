//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <../YAPP_BOX/library/YAPPgenerator_v19_RH.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
      padding-back|<------pcb length --->|<padding-front
                            RIGHT
        0    X-as ---> 
        +----------------------------------------+   ---
        |                                        |    ^
        |                                        |   padding-right 
        |                                        |    v
        |    -5,y +----------------------+       |   ---              
 B    Y |         | 0,y              x,y |       |     ^              F
 A    - |         |                      |       |     |              R
 C    a |         |                      |       |     | pcb width    O
 K    s |         |                      |       |     |              N
        |         | 0,0              x,0 |       |     v              T
      ^ |   -5,0  +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

//-- which half do you want to print?
printLidShell       = true;
printBaseShell      = false;

//-- Edit these parameters for your own board dimensions
wallThickness       = 2.0;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.5;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (baseWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 4;
lidWallHeight       = 23;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 1.5;
ridgeSlack          = 0.2;
roundRadius         = 2.0;


//-- pcb dimensions
pcbLength           = 153;
pcbWidth            = 102;
pcbThickness        = 1.80;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 2.5;
pinDiameter         = 2.0;
pinHoleSlack        = 0.5;
standoffDiameter    = 4;
standoffSupportHeight   = 2.0;
standoffSupportDiameter = 0.10;
                            
//-- padding between pcb and inside wall
paddingFront        = -0.75;
paddingBack         = -0.75;
paddingRight        = -0.75;
paddingLeft         = -0.75;



//-- D E B U G ----------------------------
showSideBySide      = true;       //-> true
onLidGap            = 0;
shiftLid            = 1;
hideLidWalls        = false;       //-> false
colorLid            = "yellow";   
hideBaseWalls       = false;       //-> false
colorBase           = "white";
showPCB             = false;      //-> false
showMarkers         = false;      //-> false
inspectX            = 0;  //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;



//-- D E B U G ----------------------------

// pcb connectors - instead of pins we can use screws to secure the PCB
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = pcbStandHeight   <--!
// (3) = screwDiameter
// (4) = screwHeadDiameter
// (5) = insertDiameter
// (6) = outsideDiameter
// (7) = flangeHeight
// (8) = flangeDiam
// (9) = { yappConnWithPCB }
// (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
                
                
connectors   =  [
                    [ 2.5, 25.4, 2.5, 2.75, 5.5, 1.5, 5, 3, 5.5, yappConnWithPCB,yappAllCorners],
                [ 24.3, 2.5, 2.5, 2.75, 5.5, 1.5, 5, 3, 5.5, yappConnWithPCB,yappAllCorners]
                ];
                

//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands = [
           //     [3,3,yappBoth,yappPin],
            //    [pcbLength-3,3,yappBoth,yappPin],
            //    [pcbLength-3,pcbWidth-3,yappBoth,yappPin],
           //     [3,pcbWidth-3,yappBoth,yappPin]
             ];


//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLid =  [ 

                [10, 10, 1, 50, 0, yappRectangle] // back vents
                ,[10, 13, 1, 50, 0, yappRectangle]
                ,[10, 16, 1, 50, 0, yappRectangle]
                ,[10, 19, 1, 50, 0, yappRectangle]
                ,[10, 22, 1, 50, 0, yappRectangle]
                ,[10, 25, 1, 50, 0, yappRectangle]
                ,[10, 28, 1, 50, 0, yappRectangle]
                ,[10, 31, 1, 50, 0, yappRectangle]
                ,[10, 34, 1, 50, 0, yappRectangle]
                ,[10, 37, 1, 50, 0, yappRectangle]
                ,[10, 40, 1, 50, 0, yappRectangle]
                ,[10, 43, 1, 50, 0, yappRectangle]
                ,[10, 46, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-10, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-13, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-16, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-19, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-22, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-25, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-28, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-31, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-34, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-37, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-40, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-43, 1, 50, 0, yappRectangle]
                ,[10, pcbWidth-46, 1, 50, 0, yappRectangle]
                
            //        [10, 10, 10, 15, 30, yappRectangle]
            //      , [10, 10, 5, 0, 0, yappCircle]
            //      , [pcbLength/2, pcbWidth/2, 10, 15, 45, yappRectangle, yappCenter]
            //      , [pcbLength/2, pcbWidth/2, 5, 0, 0, yappCircle]
              ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBase = [
            //        [10, 10, 10, 15, 30, yappRectangle]
            //      , [10, 10, 5, 0, 0, yappCircle]
           //       , [pcbLength/2, pcbWidth/2, 10, 15, 45, yappRectangle, yappCenter]
          //        , [pcbLength/2, pcbWidth/2, 5, 0, 0, yappCircle]
              ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsFront =  [
                   [8, 5, 1.0, 13.0, 0, yappRectangle] // vent top right
                 ,[11, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[14, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[17, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[20, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-8, 5, 1.0, 13.0, 0, yappRectangle] // vent top left
                 ,[pcbWidth-11, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-14, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-17, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-20, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-31, 5, 1.0, 13.0, 0, yappRectangle] // vent middle section
                 ,[pcbWidth-34, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-37, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-40, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-43, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-46, 5, 1.0, 13.0, 0, yappRectangle] // 
                // ,[pcbWidth-49, 5, 1.0, 13.0, 0, yappRectangle] // 
                 ,[31, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[34, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[37, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[40, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[43, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[46, 5, 1.0, 13.0, 0, yappRectangle] // vent
                // ,[49, 5, 1.0, 13.0, 0, yappRectangle] // vent
          //           [10, 10, 12, 15, 10, yappRectangle]
          //         , [10, 10, 5, 0, 0, yappCircle]
         //          , [40, 10, 10, 8, 0, yappRectangle, yappCenter]
         //          , [40, 10, 5, 0, 0, yappCircle]
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBack = [
                     [40.0, 3, 15, 5, 0, yappRectangle] // sd card
                   , [33, 13, 6, 0, 0, yappCircle] // headphone jack
                   ,[8, 5, 1.0, 13.0, 0, yappRectangle] // vent top right
                 ,[11, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[14, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[17, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[20, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-8, 5, 1.0, 13.0, 0, yappRectangle] // vent top left
                 ,[pcbWidth-11, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-14, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-17, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-20, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-31, 5, 1.0, 13.0, 0, yappRectangle] // vent middle section
                 ,[pcbWidth-34, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-37, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-40, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-43, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[pcbWidth-46, 11, 1.0, 7.0, 0, yappRectangle] // vents under SD
                 ,[pcbWidth-49, 11, 1.0, 7.0, 0, yappRectangle] // vents under SD
                 ,[pcbWidth-52, 11, 1.0, 7.0, 0, yappRectangle] // vent
                 ,[pcbWidth-55, 11, 1.0, 7.0, 0, yappRectangle] // vent
                 ,[pcbWidth-58, 11, 1.0, 7.0, 0, yappRectangle] // vent
                 ,[pcbWidth-61, 11, 1.0, 7.0, 0, yappRectangle] // vent
                 ,[pcbWidth-64, 11, 1.0, 7.0, 0, yappRectangle] // vent

         //          , [40, 10, 10, 8, 0, yappRectangle, yappCenter]
         //          , [40, 10, 5, 0, 0, yappCircle]
              ];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLeft = [
                  [70, 12, 7.5, 5.0, 0, yappRectangle] // switch slot
                  , [70-3.75, 12+2.5, 2.5, 0, 0, yappCircle]   // switch mounting holes
                  , [70+3.75+7.5, 12+2.5, 2.5, 0, 0, yappCircle]   // switch mounting holes
                // , [75, 12, 7.5, 0, 0, yappCircle] // charging jack
                , [69, -1.5, 10, 5, 0, yappRectangle] // type C charging jack
                 ,[8, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[11, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[14, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[17, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[30, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[33, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[36, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[39, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[42, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[45, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[48, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[51, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[54, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[57, 5, 1.0, 13.0, 0, yappRectangle] // vent
      //            [10, 10, 12, 15, 10, yappRectangle]
       //         , [10, 10, 5, 0, 0, yappCircle]
      //          , [50, 10, 10, 8, 20, yappRectangle, yappCenter]
      //          , [50, 10, 5, 0, 0, yappCircle]
              ];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsRight = [
                 [8, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[11, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[14, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[17, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[30, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[33, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[36, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[39, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[42, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[45, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[48, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[51, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[54, 5, 1.0, 13.0, 0, yappRectangle] // vent
                 ,[57, 5, 1.0, 13.0, 0, yappRectangle] // vent


      //          , [50, 10, 10, 8, 20, yappRectangle, yappCenter]
     //           , [50, 10, 5, 0, 0, yappCircle]
               ];




//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   = [
                //     [60, 3.3, 20, 3, yappBack, yappLeft]
                //   , [50, 3.3, 30, 3, yappRight, yappFront, yappCenter]
                //   , [20, 3, 5, 3, yappRight]
                //   , [10, 3, 5, 3, yappBack]
                //   , [4, 3, 34, 3, yappFront]
                //   , [25, 3, 3, 3, yappBack]
                //   , [5, 3.2, shellWidth-10, 3, yappFront]
               ];

               
//-- snapJons -- origen = shell[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =   [
              //      [15,  5, yappLeft, yappRight, yappSymmetric]
             //     , [5,  5, yappFront, yappBack, yappSymmetric]
                ];

 
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
labelsPlane =  [
            //      [0, 0, 0, "lid", "Liberation Mono:style=bold", 5, "Text-label" ]
            //    , [10, 20, 90, "lid", "Liberation Mono:style=bold", 5, "YAPP Box" ]
                ];

//-- pushButtons  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = capLength
// (3) = capWidth
// (4) = capAboveLid
// (5) = switchHeight
// (6) = switchTrafel
// (7) = poleDiameter
// (8) = buttonType  {yappCircle|yappRectangle}
pushButtons = [

              ];     
  
  
module lidHook()
{
  %translate([-20, -20, 0]) cube(5);
}

//--- this is where the magic hapens ---
YAPPgenerate();
