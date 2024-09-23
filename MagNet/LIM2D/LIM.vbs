const PI = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067

'Geometry Parameters Setup'
width_core = 920      'core width (motion direction)
thick_core = 120       'core thickness (away from track)
length_core = 50      'core length (into the page)
core_endlengths = 30  'core end width
slots = 24            'number of slots
slot_pitch = 40       'slot pitch
slot_gap = 10         'slot gap width (teeth_width is generated with slot_pitch and slot_gap)
slot_height = 75      'slot height
end_ext = 15          'one sided winding extension value (TODO: replace with dynamic sizing)
air_gap = 14          'distance between DLIM cores

'Problem Variables'
slip = 0.01         'Per unit slip'
v_r = 25            'Relative speed of pod'
motion_length = 2   'track_length (in meters)'
phase = 3           'Number of phases'
speed = 1           'Speed of pod'
time_start = 0      'Starting time (default: 0)'
sim_time = 150      'Simulation time in ms'
time_step = 5       'Time step in ms'
core_offset = 0     'Offset distance between '

'Build Flags'
const SHOW_FORBIDDEN_AIR = False	  	' Show forbidden zones for design purposes (as red air regions)
const SHOW_FULL_GEOMETRY = False	   	' Build with flanges of track
const BUILD_WITH_SYMMETRY = False   	' Build only half of the track and one wheel, with symmetry conditions
const BUILD_WITH_CIRCUIT = True       ' Build simulation with drive circuitry (useful to turn off for debugging)'
const BUILD_STATIC = False            ' Build simulation with no motion components
const BUILD_WITH_EECOMP = False
const AUTO_RUN = False                ' Run simulation as soon as problam definition is complete
const RECORD_TRANSIENT_POWER = True   ' Run simulation with transient average power loss'

'Save Flags'
'Note: Save flags match result tabs in Simcenter MagNet (open the results window and look at top bar)'
const SAVE_ENERGY = True             ' Save the Magnetic Energy/Coenergy'
const SAVE_BODY_FORCE = True          ' Save body force results'
const SAVE_COMPONENT_FORCE = True    ' Save component force results'
const SAVE_FLUX_LINKAGE = True        ' Save flux linkage results'
const SAVE_OHMIC_LOSS = True          ' Save ohmic loss (winding loss) results'
const SAVE_IRON_LOSS = True           ' Save iron loss (core loss) results'
const SAVE_CURRENT = True             ' Save current results'
const SAVE_VOLTAGE = True             ' Save voltage results'
const SAVE_TEMPERATURE = True        ' Save temperature results'
const SAVE_MOTION = True              ' Save motion results'

'Run Flags'
'Describe the simulation type'
const RUN_UPON_BUILD = True          ' Run the simulation when MagNet finishes building script'
const RUN_TRANSIENT = True            ' Run 2D simulation (Transient)'
const RUN_MOTION = True               ' Run 2D simulation (Transient with Motion)'

'Winding Setup'
winding_configuration = "s"
coil_core_separation_x = 0  'minimum separation between core and coil (one-sided, x-direction)'
coil_core_separation_y = 0  'minimum separation between core and coil (one-sided, y-direction)'
distribute_distance = 2     'distributed winding distance, in # of slots'
v_max = 120                 'input voltage'
a_max = 120                 'input amplitude (use ONE of a_max or v_max, check power class for which one)'
freq = 60                   'source frequency'
awg = 20                    'winding gauge'
nt = 50                     'number of coil turns (set nt=1 for solid winding)'

'Motion Setup'
motion_driver = "vel"      'options: "load" or "vel", for load or velocity driven. Numbers below only apply if the motion is velocity driven'


'Material Setup'
core_material = "M330-35A"
coil_material = "Copper: 5.77e7 Siemens/meter"
track_material = "Aluminum: 3.8e7 Siemens/meter"
air_material = "AIR"

'Mesh Resolution Setup'
air_rail_boundary = 1
air_resolution = 6
aluminium_resolution = 5
core_resolution = 3
winding_resolution = 4
rail_surface_resolution = 2
plate_surface_resolution = 3
use_H_adaption = False
use_P_adaption = False

'Track Constants'
const rail_height = 127
const rail_width = 127
const web_thickness = 10.4902
const flange_thickness = 10.4648
const plate_thickness = 12.7
const plate_gap = 12.7
const bottom_forbidden_height = 29.6672
const top_forbidden_height = 19.05
const top_forbidden_width = 46.0502

'Internal Variables'
core_endlengths = core_endlengths + slot_gap
teeth_width = slot_pitch-slot_gap
slot_teeth_width = (slots-1)*slot_pitch+slot_gap
core_track_gap = (air_gap-web_thickness)/2
num_coils = slots-distribute_distance
coil_width = slot_gap-2*coil_core_separation_x
coil_height = (slot_height-3*coil_core_separation_y)/2
v_s = v_r/(1-slip)
slip_speed = v_s-v_r
motion_length = motion_length*1000
track_length = motion_length
remesh_padding = 0.25
airbox_padding = 1
copperdiam = 0.127*92^((36-awg)/39)
copperarea = PI*(copperdiam/2)^2

'End Effect Compensator Variables'
n = 32
r1 = 60 / 2
r2 = 120 / 2
ra = 45 * PI / 180
gap = 20.5
thickness = 60
rail_thickness = 10.5
rpm = 2*pi*freq
core_separation = 5

'Problem Bounds'
x_padding = 1000
y_padding = 10
z_padding = 5

'Document Setup'
Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()
Set app = getDocument().getApplication()
cur_time = 123123 'get_current_timestamp()

'Ids Class Setup
Set ids_o = new ids.init()


'Parameter Sweep'
'change parameter name and value according the "Geometry Parameters Setup" (line 3)'
'"Step #" is not required if incrementing by 1'
'input to export_data function should be same as parameter name'

' For air_gap = 12 to 16 Step 2
'   Call make_airbox()
'   Call make_track()
'   Call make_core_component()
'   Call make_single_side_windings()
'   Call make_single_side_coils()
'   Call make_ee_compensator()
'   Set drive = new power2.init()
'   Call setup_motion()
'   Call setup_sim()
'   Call run_sim()
'   Call export_data(air_gap)
'   'Call setup_parameters()
' Next


'Main Code'

Call make_airbox()
Call make_track()
Call make_core_component()
Call make_single_side_windings()
Call make_single_side_coils()
Call make_ee_compensator()
Set drive = new power2.init()
Call setup_motion()
Call setup_sim()
Call run_sim()
' Call export_data(0)
' Call setup_parameters()

'end main'

Function draw_core_geometry()
  y_offset = air_gap/2
  Call view.newLine(-width_core/2-core_endlengths,thick_core+y_offset,width_core/2+core_endlengths,thick_core+y_offset)
  Call view.newLine(width_core/2+core_endlengths,y_offset,width_core/2+core_endlengths,thick_core+y_offset)
  Call view.newLine(-width_core/2-core_endlengths,y_offset,-width_core/2-core_endlengths,thick_core+y_offset)
  ' Call view.newLine()

  For i=0 to slots-1
    delta = slot_pitch*i
    Call view.newLine(-slot_teeth_width/2+delta,y_offset,-slot_teeth_width/2+delta,slot_height+y_offset)
    Call view.newLine(-slot_teeth_width/2+slot_gap+delta,y_offset,-slot_teeth_width/2+slot_gap+delta,slot_height+y_offset)
    Call view.newLine(-slot_teeth_width/2+delta,slot_height+y_offset,-slot_teeth_width/2+slot_gap+delta,slot_height+y_offset)
    If(i < slots-1) Then
      Call view.newLine(-slot_teeth_width/2+slot_gap+delta,y_offset,-slot_teeth_width/2+slot_gap+delta+teeth_width,y_offset)
    End If
  Next

  Call view.newLine(-width_core/2-core_endlengths,y_offset,-slot_teeth_width/2,y_offset)
  Call view.newLine(slot_teeth_width/2,y_offset,width_core/2+core_endlengths,y_offset)

  Call view.newLine(-width_core/2-core_endlengths,-(thick_core+y_offset),width_core/2+core_endlengths,-(thick_core+y_offset))
  Call view.newLine(width_core/2+core_endlengths,-y_offset,width_core/2+core_endlengths,-(thick_core+y_offset))
  Call view.newLine(-width_core/2-core_endlengths,-y_offset,-width_core/2-core_endlengths,-(thick_core+y_offset))
  ' Call view.newLine()

  For i=0 to slots-1
    delta = slot_pitch*i
    Call view.newLine(-slot_teeth_width/2+delta,-y_offset,-slot_teeth_width/2+delta,-(slot_height+y_offset))
    Call view.newLine(-slot_teeth_width/2+slot_gap+delta,-y_offset,-slot_teeth_width/2+slot_gap+delta,-(slot_height+y_offset))
    Call view.newLine(-slot_teeth_width/2+delta,-(slot_height+y_offset),-slot_teeth_width/2+slot_gap+delta,-(slot_height+y_offset))
    If(i < slots-1) Then
      Call view.newLine(-slot_teeth_width/2+slot_gap+delta,-y_offset,-slot_teeth_width/2+slot_gap+delta+teeth_width,-y_offset)
    End If
  Next

  Call view.newLine(-width_core/2-core_endlengths,-y_offset,-slot_teeth_width/2,-y_offset)
  Call view.newLine(slot_teeth_width/2,-y_offset,width_core/2+core_endlengths,-y_offset)

End Function

Function make_core_component()
  Call view.getSlice().moveInALine(-length_core/2)
  Call draw_core_geometry()

  Call view.selectAt(0,(thick_core+slot_height)/2,infoSetSelection,Array(infoSliceSurface))
  core_name = "Core 1"
  REDIM component_name(0)
  component_name(0) = core_name
  Call view.makeComponentInALine(length_core,component_name,format_material(core_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize(core_name,core_resolution)

  Call view.selectAt(0,-(thick_core+slot_height)/2,infoSetSelection,Array(infoSliceSurface))
  core_name = "Core 2"
  REDIM component_name(0)
  component_name(0) = core_name
  Call view.makeComponentInALine(length_core,component_name,format_material(core_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize(core_name,core_resolution)

  'Call clear_construction_lines()
  Call view.getSlice().moveInALine(length_core/2)
End Function

Function make_ee_compensator()

  If(BUILD_WITH_EECOMP) Then
    y_offset = r2+air_gap/2
    x_offset = width_core/2+r2+core_separation+core_endlengths
    z_offset = (thickness-length_core)/2+length_core/2

    rotation_axis = Array(0,0,-1)

    Call view.getSlice().moveInALine(-z_offset)

    'Magnet 1'
    Dim x_hat
    Dim y_hat
    Call view.newCircle(x_offset, y_offset, r1)
    Call view.newCircle(x_offset, y_offset, r2)

    For i = 1 To n
    	x_hat = Sin(PI * 2.0 * (i + 0.5) / n)
    	y_hat = Cos(PI * 2.0 * (i + 0.5) / n)

    	Call view.newLine(x_offset + x_hat*r1, y_hat*r1+y_offset, x_offset + x_hat*r2, y_hat*r2+y_offset)
    Next

    ReDim Magnets(n - 1)
    Dim mid
    Dim direction

    For i = 1 To n
    	x_hat = Sin(PI * 2.0 * i / n)
    	y_hat = Cos(PI * 2.0 * i / n)
    	mid = (r1 + r2) / 2.0

    	Call view.selectAt(x_offset + x_hat*mid, y_hat*mid+y_offset, infoSetSelection, Array(infoSliceSurface))

    	x_hat = Sin(PI * 2.0 * i / n - i * ra)
    	y_hat = Cos(PI * 2.0 * i / n - i * ra)

    	direction = "[" & x_hat & "," & y_hat & ",0]"

    	REDIM ArrayOfValues(0)
    	ArrayOfValues(0)= ids_o.get_magnet_keyword()&"1#" & i
    	Call view.makeComponentInALine(thickness, ArrayOfValues, "Name=N50;Type=Uniform;Direction=" & direction, True)

    	Call getDocument().setMaxElementSize(ids_o.get_magnet_keyword()&"1#" & i, 1)

    	Magnets(i - 1) = ids_o.get_magnet_keyword()&"1#" & i
    Next

    if not (BUILD_STATIC) then
      Call getDocument().makeMotionComponent(Magnets)
      Call getDocument().setMotionSourceType("Motion#1", infoVelocityDriven)
      Call getDocument().setMotionRotaryCenter("Motion#1", Array(x_offset, y_offset, 0))
      Call getDocument().setMotionRotaryAxis("Motion#1",rotation_axis)

      Call getDocument().setMotionPositionAtStartup("Motion#1", 0)
      Call getDocument().setMotionSpeedAtStartup("Motion#1", 0)
      REDIM ArrayOfValues1(0)
      ArrayOfValues1(0)= 0
      REDIM ArrayOfValues2(0)
      ArrayOfValues2(0)= rpm*6.0
      Call getDocument().setMotionSpeedVsTime("Motion#1", ArrayOfValues1, ArrayOfValues2)
    end if
    'Magnet 2'
    Call view.newCircle(x_offset, -y_offset, r1)
    Call view.newCircle(x_offset, -y_offset, r2)

    For i = 1 To n
    	x_hat = Sin(PI * 2.0 * (i + 0.5) / n)
    	y_hat = Cos(PI * 2.0 * (i + 0.5) / n)

    	Call view.newLine(x_offset + x_hat*r1,y_hat*r1-y_offset, x_offset + x_hat*r2,y_hat*r2-y_offset)
    Next

    ReDim Magnets(n - 1)
    For i = 1 To n
    	x_hat = Sin(PI * 2.0 * i / n)
    	y_hat = Cos(PI * 2.0 * i / n)
    	mid = (r1 + r2) / 2.0

    	Call view.selectAt(x_offset + x_hat*mid,y_hat*mid-y_offset, infoSetSelection, Array(infoSliceSurface))

      x_hat = Sin(PI * 2.0 * i / n - i * ra - PI)
    	y_hat = Cos(PI * 2.0 * i / n - i * ra - PI)

    	direction = "[" & x_hat & "," & y_hat & ",0]"

    	REDIM ArrayOfValues(0)
    	ArrayOfValues(0)= ids_o.get_magnet_keyword()&"2#" & i
    	Call view.makeComponentInALine(thickness, ArrayOfValues, "Name=N50;Type=Uniform;Direction=" & direction, True)

    	Call getDocument().setMaxElementSize(ids_o.get_magnet_keyword()&"2#" & i, 1)

    	Magnets(i - 1) = ids_o.get_magnet_keyword()&"2#" & i
    Next

    if not (BUILD_STATIC) then
      Call getDocument().makeMotionComponent(Magnets)
      Call getDocument().setMotionSourceType("Motion#2", infoVelocityDriven)
      Call getDocument().setMotionRotaryCenter("Motion#2", Array(x_offset, -y_offset, 0))
      Call getDocument().setMotionRotaryAxis("Motion#2",rotation_axis)

      Call getDocument().setMotionPositionAtStartup("Motion#2", 0)
      Call getDocument().setMotionSpeedAtStartup("Motion#2", 0)
      REDIM ArrayOfValues1(0)
      ArrayOfValues1(0)= 0
      REDIM ArrayOfValues2(0)
      ArrayOfValues2(0)= -rpm*6.0
      Call getDocument().setMotionSpeedVsTime("Motion#2", ArrayOfValues1, ArrayOfValues2)
    end if

    Call view.getSlice().moveInALine(z_offset)
  End If
End Function

'MAKE DISTRIBUTED WINDING'
'returns:
'winding A component name
'winding B component name
'winding C component name
'winding D component name
'number of duplicates down core length
'duplicate distance'
Function make_single_d_winding()
  Call view.getSlice().moveInALine(-length_core/2)

  y_offset = air_gap/2

  lx1 = -slot_teeth_width/2+coil_core_separation_x
  rx1 = -slot_teeth_width/2+coil_core_separation_x+coil_width
  by1 = coil_core_separation_y
  ty1 = coil_core_separation_y+coil_height
  lx2 = lx1+distribute_distance*slot_pitch
  rx2 = rx1+distribute_distance*slot_pitch
  by2 = slot_height-ty1
  ty2 = slot_height-by1

  numcoils = (slots-distribute_distance-1)
  dist = slot_pitch

  For i = 0 To numcoils
    Call draw_square(lx1+i*dist,rx1+i*dist,by1+y_offset,ty1+y_offset)
    Call draw_square(lx2+i*dist,rx2+i*dist,by2+y_offset,ty2+y_offset)
    Call draw_square(lx1+i*dist,rx1+i*dist,-by1-y_offset,-ty1-y_offset)
    Call draw_square(lx2+i*dist,rx2+i*dist,-by2-y_offset,-ty2-y_offset)
  Next

  Dim windings(3)

  Set coilbuild_a = new build.init(ids_o.get_winding_keyword()+"1#1.1")
  Call view.selectAt((lx1+rx1)/2,(ty1+by1)/2+y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_a.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_a.increment_component_num()
  Call unselect()
  windings(0) = coilbuild_a.end_component_build()

  set coilbuild_b = new build.init(ids_o.get_winding_keyword()+"1#1.2")
  Call view.selectAt((lx2+rx2)/2,(ty2+by2)/2+y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_b.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_b.increment_component_num()
  Call unselect()
  windings(1) = coilbuild_b.end_component_build()

  Set coilbuild_c = new build.init(ids_o.get_winding_keyword()+"2#1.1")
  Call view.selectAt((lx1+rx1)/2,-(ty1+by1)/2-y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_c.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_c.increment_component_num()
  Call unselect()
  windings(2) = coilbuild_c.end_component_build()

  set coilbuild_d = new build.init(ids_o.get_winding_keyword()+"2#1.2")
  Call view.selectAt((lx2+rx2)/2,-(ty2+by2)/2-y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_d.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_d.increment_component_num()
  Call unselect()
  windings(3) = coilbuild_d.end_component_build()

  make_single_d_winding = Array(windings(0),windings(1),windings(2),windings(3),numcoils,dist)
  Call view.getSlice().moveInALine(length_core/2)
End Function

'MAKE TOOTH COIL WINDING'
'returns:
'winding A component name
'winding B component name
'winding C component name
'winding D component name
'number of duplicates down core length
'duplicate distance'
Function make_single_t_winding()
  Call view.getSlice().moveInALine(-length_core/2)

  y_offset = air_gap/2

  lx1 = -slot_teeth_width/2+coil_core_separation_x+coil_width/2
  rx1 = -slot_teeth_width/2+coil_core_separation_x+coil_width
  by1 = coil_core_separation_y
  ty1 = coil_core_separation_y+slot_height
  lx2 = lx1+slot_pitch-coil_width/2
  rx2 = rx1+slot_pitch-coil_width/2
  by2 = by1
  ty2 = ty1

  numcoils = slots-2
  dist = slot_pitch

  For i = 0 To numcoils
    Call draw_square(lx1+i*dist,rx1+i*dist,by1+y_offset,ty1+y_offset)
    Call draw_square(lx2+i*dist,rx2+i*dist,by2+y_offset,ty2+y_offset)
    Call draw_square(lx1+i*dist,rx1+i*dist,-by1-y_offset,-ty1-y_offset)
    Call draw_square(lx2+i*dist,rx2+i*dist,-by2-y_offset,-ty2-y_offset)
  Next

  Dim windings(3)

  Set coilbuild_a = new build.init(ids_o.get_winding_keyword()+"1#1.1")
  Call view.selectAt((lx1+rx1)/2,(ty1+by1)/2+y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_a.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_a.increment_component_num()
  Call unselect()
  windings(0) = coilbuild_a.end_component_build()

  set coilbuild_b = new build.init(ids_o.get_winding_keyword()+"1#1.2")
  Call view.selectAt((lx2+rx2)/2,(ty2+by2)/2+y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_b.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_b.increment_component_num()
  Call unselect()
  windings(1) = coilbuild_b.end_component_build()

  Set coilbuild_c = new build.init(ids_o.get_winding_keyword()+"2#1.1")
  Call view.selectAt((lx1+rx1)/2,-(ty1+by1)/2-y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_c.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_c.increment_component_num()
  Call unselect()
  windings(2) = coilbuild_c.end_component_build()

  set coilbuild_d = new build.init(ids_o.get_winding_keyword()+"2#1.2")
  Call view.selectAt((lx2+rx2)/2,-(ty2+by2)/2-y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_d.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_d.increment_component_num()
  Call unselect()
  windings(3) = coilbuild_d.end_component_build()

  make_single_t_winding = Array(windings(0),windings(1),windings(2),windings(3),numcoils,dist)
  Call view.getSlice().moveInALine(length_core/2)

End Function

'MAKE SLOT COIL WINDING'
'returns:
'winding A component name
'winding B component name
'winding C component name
'winding D component name
'number of duplicates down core length
'duplicate distance'
Function make_single_s_winding()
  Call view.getSlice().moveInALine(-length_core/2)

  y_offset = air_gap/2

  lx1 = -slot_teeth_width/2+coil_core_separation_x
  rx1 = -slot_teeth_width/2+coil_core_separation_x+coil_width
  by1 = coil_core_separation_y
  ty1 = coil_core_separation_y+slot_height

  numcoils = slots-1
  dist = slot_pitch

  For i = 0 To numcoils
    Call draw_square(lx1+i*dist,rx1+i*dist,by1+y_offset,ty1+y_offset)
    Call draw_square(lx1+i*dist,rx1+i*dist,-by1-y_offset,-ty1-y_offset)
  Next

  Dim windings(3)

  Set coilbuild_a = new build.init(ids_o.get_winding_keyword()+"1#1.1")
  Call view.selectAt((lx1+rx1)/2,(ty1+by1)/2+y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_a.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_a.increment_component_num()
  Call unselect()
  windings(0) = coilbuild_a.end_component_build()

  Set coilbuild_b = new build.init(ids_o.get_winding_keyword()+"2#1.1")
  Call view.selectAt((lx1+rx1)/2,-(ty1+by1)/2-y_offset, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(length_core,Array(coilbuild_b.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call coilbuild_b.increment_component_num()
  Call unselect()
  windings(2) = coilbuild_b.end_component_build()

  windings(1) = ""
  windings(3) = ""

  make_single_s_winding = Array(windings(0),windings(1),windings(2),windings(3),numcoils,dist)
  Call view.getSlice().moveInALine(length_core/2)

End Function

'MAKE GRAMME RING WINDING'
'returns:
'winding A component name
'winding B component name
'winding C component name'
'winding D component name'
'number of duplicates down core length
'duplicate distance'
Function make_single_g_winding()

End Function

Function make_single_side_windings()

  If(winding_configuration = "d") Then
    params = make_single_d_winding()
  ElseIf(winding_configuration = "g") Then
    params = make_single_g_winding()
  ElseIf(winding_configuration = "t") Then
    params = make_single_t_winding()
  ElseIf(winding_configuration = "s") Then
    params = make_single_s_winding()
  ElseIf(winding_configuration = "s2") Then
    params = make_single_s_winding()
  End If

  Dim component_name
  copy_keyword = " Copy#1"
  
  winding1 = params(0)
  winding2 = params(1)
  winding3 = params(2)
  winding4 = params(3)
  numcoils = params(4)
  dist = params(5)
  
  Call getDocument().beginUndoGroup("Transform Component")
  Call view.getSlice().moveInALine(-length_core/2)
  
  For i=1 to numcoils
    If(winding1<>"") Then
      Call getDocument().shiftComponent(getDocument().copyComponent(Array(winding1),1),dist*i, 0, 0, 1)
      copy_component = ids_o.get_copy_components()(0)
      component_name = Replace(winding1,"1#1.1","1#"&(i+2)&".1")
      Call getDocument().renameObject(copy_component,component_name)
    End If
  
    If(winding2<>"") Then
      Call getDocument().shiftComponent(getDocument().copyComponent(Array(winding2),1),dist*i, 0, 0, 1)
      copy_component = ids_o.get_copy_components()(0)
      component_name = Replace(winding2,"1#1.2","1#"&(i+2)&".2")
      Call getDocument().renameObject(copy_component,component_name)
    End If
  
    If(winding3<>"") Then
      Call getDocument().shiftComponent(getDocument().copyComponent(Array(winding3),1),dist*i, 0, 0, 1)
      copy_component = ids_o.get_copy_components()(0)
      component_name = Replace(winding3,"2#1.1","2#"&(i+2)&".1")
      Call getDocument().renameObject(copy_component,component_name)
    End If
  
    If(winding4<>"") Then
      Call getDocument().shiftComponent(getDocument().copyComponent(Array(winding4),1),dist*i, 0, 0, 1)
      copy_component = ids_o.get_copy_components()(0)
      component_name = Replace(winding4,"2#1.2","2#"&(i+2)&".2")
      Call getDocument().renameObject(copy_component,component_name)
    End If
  Next
  
  Call getDocument().endUndoGroup()
  Call view.getSlice().moveInALine(length_core/2)
  ' Call clear_construction_lines()
End Function

Function make_single_side_coils()
  Call getDocument.beginUndoGroup("Create Coils")
  match = ids_o.get_winding_paths()
  match = ids_o.find_with_not_match(match,Array("A"))

  Set re = new RegExp
  re.Pattern = "[^\d]"
  re.Global = True

  For i=0 to UBound(match)
    coil_path = match(i)
    coil_name = ids_o.remove_substrings(match(i))
    coil_num = CInt(re.Replace(coil_name,""))
    coil_side = Right(coil_name,1)

    excitation_center = get_global((lx1+rx1)/2+slot_pitch*i,(by1+ty1)/2)
    excitation_volume = Array(coil_path)

    Call getDocument().getView().selectObject(coil_path, infoSetSelection)
    Call getDocument().makeSimpleCoil(1, Array(coil_path))
  Next
  Call getDocument.endUndoGroup()
End Function

Function make_track()
  Call view.getSlice().moveInALine(-rail_height/2)
  Call view.newLine(-track_length,-web_thickness/2,-track_length,web_thickness/2)
  Call view.newLine(track_length,-web_thickness/2,track_length,web_thickness/2)
  Call view.newLine(-track_length,web_thickness/2,track_length,web_thickness/2)
  Call view.newLine(-track_length,-web_thickness/2,track_length,-web_thickness/2)

  Call view.selectAt(0, 0, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(rail_height, Array(ids_o.get_track_keyword), format_material(track_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize(ids_o.get_track_keyword, aluminium_resolution)

  Call view.getSlice().moveInALine(rail_height/2)
End Function

Function make_airbox()
  Call view.getSlice().moveInALine(-rail_height/2-z_padding)

  airbox = ids_o.get_airbox_keyword()

  Call draw_square(-track_length-x_padding,track_length+x_padding,-(r2*2+air_gap/2+y_padding),(r2*2+air_gap/2+y_padding))
  Call view.selectAt(0, (length_core+r2*2)/2+air_gap+y_padding, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(rail_height+2*z_padding, Array(ids_o.get_airbox_keyword), format_material(air_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize(airbox, air_resolution)
  Call getDocument().getView().setObjectVisible(airbox, False)

  Call view.getSlice().moveInALine(rail_height/2+z_padding)

End Function


Class ids
  Public copy_replace_strings

  Private core_matches
  Private remove_strings
  Private a_postfix
  Private b_postfix
  Private copper_keyword
  Private magnet_keyword
  Private track_keyword
  Private airbox_keyword
  Private cores

  'Constructor
  Public Default Function init()
    copper_keyword = "CoilGeometry"
    magnet_keyword = "Magnet"
    track_keyword = "Track"
    airbox_keyword = "AirBox"
    core_matches = Array("Core",copper_keyword,magnet_keyword)
    remove_strings = Array(",","Body#1")
    copy_replace_strings = Array("Copy#1","Copy#9")

    a_postfix = "A"
    b_postfix = "B"
    cores = Array(a_postfix,b_postfix)
    Set init = Me
  End Function

  Public Function find_all_components_with_match(find)
    components = getDocument().getAllComponentPaths()
    find_all_components_with_match = find_with_match(components,find)
  End Function

  Public Function find_all_components_with_match_replace(find)
    components = getDocument().getAllComponentPaths()
    find_all_components_with_match_replace = find_with_match_replace(components,find)
  End Function

  Public Function find_with_match(arr,find)
    ReDim matches(-1)
    For i=0 to UBound(arr)
      For z=0 to UBound(find)
        If InStr(arr(i),find(z)) Then
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = (arr(i))
        End if
      Next
    Next
    find_with_match = matches
  End Function

  Public Function find_with_match_replace(arr,find)
    ReDim matches(-1)
    For i=0 to UBound(arr)
      For z=0 to UBound(find)
        If InStr(remove_substrings(arr(i)),find(z)) Then
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = remove_substrings(arr(i))
        End if
      Next
    Next
    find_with_match_replace = matches
  End Function

  Public Function find_with_not_match(arr,find)
    ReDim matches(-1)
    For i=0 to UBound(arr)
      For z=0 to UBound(find)
        If InStr(arr(i),find(z)) Then
          asdf=0
        Else
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = (arr(i))
        End if
      Next
    Next
    find_with_not_match = matches
  End Function

  'Update core components to have postfix'
  'Called only when BUILD_WITH_SYMMETRY true'
  Public Function rename_mirror()
    matches = find_all_components_with_match_replace(copy_replace_strings)
    For i=0 to UBound(matches)
      new_name = replace_substrings(matches(i),b_postfix)
      Call rename_components(matches(i),replace_substrings(matches(i),b_postfix))
    Next
  End Function

  'Update core components to have postfix'
  'Need to call regardless of BUILD_WITH_SYMMETRY'
  Public Function update_names(append)
    matches = get_core_components()
    For i=0 to UBound(cores)
      If cores(i)<>append Then
        matches = find_with_not_match(matches,Array(cores(i)))
      End If
    Next
    For i=0 to UBound(matches)
      If InStr(matches(i),b_postfix)=0 Then
        Call rename_components(matches(i),append_substrings(matches(i)," "+append))
      End If
    Next
  End Function

  'Gets component names for A side'
  Public Function get_a_components()
    get_a_components = find_all_components_with_match_replace(Array(a_postfix))
  End Function

  'Gets component names for B side'
  Public Function get_b_components()
    get_b_components = find_all_components_with_match_replace(Array(b_postfix))
  End Function

  Public Function get_num_coils()
    match = ids_o.get_winding_paths()
    match = ids_o.find_with_not_match(match,Array("A"))
    get_num_coils = UBound(match)+1
  End Function

  'Gets component names for all coil elements'
  Public Function get_coil_components()
    get_coil_components = find_all_components_with_match_replace(Array("Coil"))
  End Function

  Public Function get_coil_paths()
    get_coil_paths = find_all_components_with_match(Array("Coil"))
  End Function

  Public Function get_winding_components()
    get_winding_components = find_all_components_with_match_replace(Array(copper_keyword))
  End Function

  Public Function get_winding_paths()
    get_winding_paths = find_all_components_with_match(Array(copper_keyword))
  End Function

  Public Property Get get_core_components()
    get_core_components = find_all_components_with_match_replace(core_matches)
  End Property

  Public Property Get get_copy_components()
    get_copy_components = get_spec_components(Array("Copy"))
  End Property

  Public Property Get get_union_components()
    get_union_components = get_spec_components(Array("Union"))
  End Property

  Public Property Get get_spec_components(arr_comps)
    get_spec_components = find_all_components_with_match_replace(arr_comps)
  End Property

  Public Property Get get_spec_paths(arr_comps)
    get_spec_paths = find_all_components_with_match(arr_comps)
  End Property

  'Removes predetermined substrings from (param) string '
  Public Function remove_substrings(str)
    For i=0 to UBound(remove_strings)
      str = Replace(str,remove_strings(i),"")
    Next
    remove_substrings = str
  End Function

  Public Function subtract_strings(str1,str2)
    diff = ""
    If (len(str1)>len(str2)) Then
      diff = Replace(str1,str2,"")
    Else
      diff = Replace(str2,str1,"")
    End If
    subtract_strings = diff
  End Function

  'Replaces (param) substring in (param) string'
  Public Function replace_substrings(str,repl)
    temp = str
    For i=0 to UBound(copy_replace_strings)
      If InStr(str,copy_replace_strings(i)) Then
        temp = Replace(temp,copy_replace_strings(i),repl)
      End If
    Next
    replace_substrings = temp
  End Function

  'Appends (param) substring to (param) string'
  Public Function append_substrings(str,app)
    append_substrings = str+app
  End Function

  Public Property Get get_winding_keyword()
    get_winding_keyword = copper_keyword
  End Property

  Public Property Get get_magnet_keyword()
    get_magnet_keyword = magnet_keyword
  End Property

  Public Property Get get_track_keyword()
    get_track_keyword = track_keyword
  End Property

  Public Property Get get_airbox_keyword()
    get_airbox_keyword = airbox_keyword
  End Property

End Class


Class build

  Private name
  Private final_name
  Private build_step
  Private component_number

  Public Default Function init(target_name)
    Call start_component_build(target_name)
    Set init = Me
  End Function

  Public Function start_component_build(target_name)
    name = "comp"
    final_name = target_name
    component_number=0
    build_step=0
  End Function

  Public Function update()
    temp_comps = up_complist()
  End Function

  Public Function union_all()
    temp_comps = up_complist()
    temp = temp_comps(0)
    For i=1 to UBound(temp_comps)
      Call union_components(temp,temp_comps(i))
      union_comps = ids_o.get_spec_components(Array("Union"))
      temp = component_name()
      Call rename_components(union_comps(0),temp)
    Next
    temp_comps = up_complist()
    Call rename_components(temp_comps(0),component_name())
  End Function

  Public Function mirror(normal)
    temp_comps = up_complist()
    Call mirror_components(temp_comps,normal)
  End Function

  Public Function mirror_copy(normal)
    temp_comps = up_complist()
    Call mirror_components_copy(temp_comps,normal)
  End Function

  Public Function end_component_build()
    temp_comps = up_complist()
    Call rename_components(temp_comps(0),final_name)
    end_component_build = final_name
  End Function

  Public Function component_name()
    component_name = name&component_number
  End Function

  Public Function increment_component_num()
    component_number=component_number+1
  End Function

  Public Function set_build_step(val)
    build_step = val
  End Function

  Public Function increment_step()
    build_step = build_step+1
  End Function

  Public Function get_build_step()
    get_build_step = build_step
  End Function

  Private Function up_complist()
    up_complist = ids_o.find_all_components_with_match_replace(Array(name))
  End Function

End Class

'CONTROL/DRIVE CIRCUITRY'
Class power

  Private coil_comps
  Private num_coils
  Private start_x
  Private start_y
  Private offset_x
  Private offset_y
  Private connection_offset

  Public Default Function init()
    coil_comps = ids_o.get_coil_components()
    num_coils = CInt(UBound(coil_comps)+1)

    start_x = 100
    start_y = 100
    offset_y = 150
    offset_x = 100
    connection_offset = 25

    if(BUILD_WITH_CIRCUIT) then
      Call getDocument().newCircuitWindow()
      draw_circuit()
    end if
    Set init = Me
  End Function

  Public Function draw_circuit()
    If(winding_configuration = "d") Then
      circuit_d()
    ElseIf(winding_configuration = "g") Then
      circuit_d()
    ElseIf(winding_configuration = "t") Then
      circuit_s()
    ElseIf(winding_configuration = "s") Then
      circuit_s()
    ElseIf(winding_configuration = "s2") Then
      circuit_s2()
    End If
  End Function

  Public Function circuit_s()
    For i=0 to num_coils-1
      base = int(i/8)
      'Print(base)
      phase_num = (base mod phase)
      coil_orientation = -2*(base mod 2)+1
      Call draw_single_winding(i+1,phase_num,coil_orientation)
    Next
  End Function

  Public Function circuit_s2()
    For i=0 to num_coils-1
      base = int(i/4)
      'Print(base)
      phase_num = (base mod phase)
      'coil_orientation = -2*(base mod 2)+1
      coil_orientation = 1
      Call draw_single_winding(i+1,phase_num,coil_orientation)
    Next
  End Function

  'unused (old code)'
  'might be useful for distributed winding simulations'
  Public Function circuit_d()
    For i=1 to num_coils
      phase_num = 120*((i-1) mod phase)
      coil_orientation = 1
      Call draw_single_winding(i,phase_num,coil_orientation)
    Next
  End Function

  Public Function draw_single_winding(i,phase_num,coil_orientation)
    Set circ = getDocument().getCircuit()

    coil_name = "Coil#"&i
    source_name = "I"&i

    If(coil_orientation=-1) Then
      flip_coil_direction(coil_name)
    End If

    Call circ.insertCoil(coil_name, start_x, start_y+i*offset_y)
    Call circ.insertCurrentSource(start_x+offset_x, start_y+i*offset_y)

    DIM ctx,cty,vstx,vsty
    Call circ.getPositionOfTerminal(coil_name&",T2",ctx,cty)
    Call circ.getPositionOfTerminal(source_name&",T1",vstx,vsty)
    xconn = Array(ctx,vstx)
    yconn = Array(cty,vsty)
    Call circ.insertConnection(xconn, yconn)

    Call circ.getPositionOfTerminal(coil_name&",T1",ctx,cty)
    Call circ.getPositionOfTerminal(source_name&",T2",vstx,vsty)
    xconn = Array(ctx,ctx,vstx,vstx)
    yconn = Array(cty,cty+connection_offset,vsty+connection_offset,vsty)
    Call circ.insertConnection(xconn, yconn)

    Call getDocument().beginUndoGroup("Set V Source Properties", true)

    phase_ang = phase_num*120 'phase_num is an integer [1,2,3]'
    props = Array(0,v_max,freq,0,0,phase_ang)

    If(nt > 1) Then
      Call getDocument().setCoilType(coil_name, infoStrandedCoil)
      Call getDocument().setCoilNumberOfTurns(coil_name, nt)
      Call getDocument().setParameter(coil_name, "StrandArea", CStr(copperarea/(1000^2)), infoNumberParameter)
    End If

    Call getDocument().setSourceWaveform(source_name,"SIN", props)
    'Call getDocument().setParameter(source_name, "WaveFormValues", "[0, %sourceSteps, 15, 1, 0, 0]", infoArrayParameter)
    'Call getDocument().setParameter(source_name, "WaveFormValues", "[0, %sourceSteps,"&freq&", 0, 0, 0, "&phase_ang&"]", infoArrayParameter)
    Call getDocument().endUndoGroup()
  End Function

  Public Function flip_coil_direction(coil_name)
    Call getDocument().reverseCoilDirection(coil_name)
  End Function

End Class

Class power2

  Private coil_comps
  Private num_coils
  Private start_x
  Private start_y
  Private offset_x
  Private offset_y
  Private current_x
  Private current_y
  Private connection_offset

  Public Default Function init()
    coil_comps = ids_o.get_coil_components()
    num_coils = CInt(UBound(coil_comps)+1)

    start_x = 500
    start_y = 100
    offset_y = 150
    offset_x = 250
    current_x = start_x
    current_y = start_y
    connection_offset = 25

    if(BUILD_WITH_CIRCUIT) then
      Call getDocument().newCircuitWindow()
      draw_circuit()
    end if
    Set init = Me
  End Function

  Public Function draw_circuit()
    Call setup_coils()
    Call make_winding()
  End Function

  Public Function increment_y()
    current_y = current_y+offset_y
    increment_y = current_y
  End Function

  Public Function reset_y()
    current_y = start_y
  End Function

  Public Function flip_coil_direction(coil_name)
    Call getDocument().reverseCoilDirection(coil_name)
  End Function

  Private Function setup_coils()
    If(nt > 1) Then
      For i=0 to num_coils-1
        coil_name = "Coil#"&(i+1)

        base = int(i/8)
        coil_orientation = -2*(base mod 2)+1

        If(coil_orientation=-1) Then
          flip_coil_direction(coil_name)
        End If

        Call getDocument().setCoilType(coil_name, infoStrandedCoil)
        Call getDocument().setCoilNumberOfTurns(coil_name, nt)
        Call getDocument().setParameter(coil_name, "StrandArea", CStr(copperarea/(1000^2)), infoNumberParameter)
      Next
    End If
  End Function

  Private Function make_winding()
    Set circ = getDocument().getCircuit()

    If(winding_configuration = "s") Then

      'Make three phase coil windings'
      LIM_1_U = getDocument().makeWinding(Array("Coil#1","Coil#3","Coil#5","Coil#7","Coil#25","Coil#27","Coil#29","Coil#31"))
      LIM_1_V = getDocument().makeWinding(Array("Coil#9","Coil#11","Coil#13","Coil#15","Coil#33","Coil#35","Coil#37","Coil#39"))
      LIM_1_W = getDocument().makeWinding(Array("Coil#17","Coil#19","Coil#21","Coil#23","Coil#41","Coil#43","Coil#45","Coil#47"))
      LIM_2_U = getDocument().makeWinding(Array("Coil#2","Coil#4","Coil#6","Coil#8","Coil#26","Coil#28","Coil#30","Coil#32"))
      LIM_2_V = getDocument().makeWinding(Array("Coil#10","Coil#12","Coil#14","Coil#16","Coil#34","Coil#36","Coil#38","Coil#40"))
      LIM_2_W = getDocument().makeWinding(Array("Coil#18","Coil#20","Coil#22","Coil#24","Coil#42","Coil#44","Coil#46","Coil#48"))

      'Insert winding U1 (Phase 1, Core 1) and current source'
      Call circ.insertSubCircuit(LIM_1_U, start_x, increment_y())
      Call circ.insertCurrentSource(start_x-offset_x, current_y)

      'Insert winding V1 (Phase 2, Core 1) and current source'
      Call circ.insertSubCircuit(LIM_1_V, start_x, increment_y())
      Call circ.insertCurrentSource(start_x-offset_x, current_y)

      'Insert star/wye ground for Core 1 windings'
      Call circ.insertGround(start_x+offset_x,current_y)

      'Insert winding W1 (Phase 3, Core 1) and current source'
      Call circ.insertSubCircuit(LIM_1_W, start_x, increment_y())
      Call circ.insertCurrentSource(start_x-offset_x, current_y)

      'Insert winding U2 (Phase 1, Core 2) and current source'
      Call circ.insertSubCircuit(LIM_2_U, start_x, increment_y())
      Call circ.insertCurrentSource(start_x-offset_x, current_y)

      'Insert winding V2 (Phase 2, Core 2) and current source'
      Call circ.insertSubCircuit(LIM_2_V, start_x, increment_y())
      Call circ.insertCurrentSource(start_x-offset_x, current_y)

      'Insert star/wye ground for Core 2 windings'
      Call circ.insertGround(start_x+offset_x,current_y)

      'Insert winding W2 (Phase 3, Core 2) and current source'
      Call circ.insertSubCircuit(LIM_2_W, start_x, increment_y())
      Call circ.insertCurrentSource(start_x-offset_x, current_y)

      reset_y()

      ' Get x,y coordinates for ground nodes'
      DIM g1_node_x, g1_node_y, g2_node_x, g2_node_y

      Call circ.getPositionOfTerminal("G1,T1", g1_node_x, g1_node_y)
      Call circ.getPositionOfTerminal("G1,T1", g2_node_x, g2_node_y)

      ' Set current source values and perform wiring'
      For i=0 to 5

        DIM gtx,gty,vstx,vsty,wtx,wty

        winding_name = "Winding#"&(i+1)
        source_name = "I"&(i+1)
        ground_name = "G"&(i+3)

        'Set current source amplitude, freq, phase angle'
        phase_ang = (i mod phase)*120
        props = Array(0,v_max,freq,0,0,phase_ang)
        Call getDocument().setSourceWaveform(source_name,"SIN", props)

        ' Create grounds for current sources'
        Call circ.insertGround(start_x-offset_x-connection_offset, start_y+offset_y*(i+1))

        ' Create connection between source terminal 1 and ground'
        Call circ.getPositionOfTerminal(ground_name&",T1",gtx,gty)
        Call circ.getPositionOfTerminal(source_name&",T1",vstx,vsty)
        xconn = Array(gtx,vstx)
        yconn = Array(gty,vsty)
        Call circ.insertConnection(xconn,yconn)

        ' Create connection between source terminal 2 and winding terminal 1'
        Call circ.getPositionOfTerminal(source_name&",T2",vstx,vsty)
        Call circ.getPositionOfTerminal(winding_name&",T1,T2",wtx,wty)
        xconn = Array(vstx,wtx)
        yconn = Array(vsty,wty)
        Call circ.insertConnection(xconn,yconn)

        ' Create connection between winding terminal 2 and common ground'
        Call circ.getPositionOfTerminal(winding_name&",T2,T2",wtx,wty)
        'Call print("G"&(int(i/3)+1))
        Call circ.getPositionOfTerminal("G"&(int(i/3)+1)&",T1",gtx,gty)
        xconn = Array(wtx,gtx)
        yconn = Array(wty,gty)
        Call circ.insertConnection(xconn,yconn)

        'Perform wiring'
        Call circ.getPositionOfTerminal(source_name&",T2",vstx,vsty)
        Call circ.getPositionOfTerminal(source_name&",T1",vstx,vsty)

      Next

    End If
  End Function

End Class

'MOTION SETUP'

Function setup_motion()
  m = ""
  tm = "TrackMotion"
  if(BUILD_WITH_EECOMP) Then
    m = "Motion#3"
  else
    m = "Motion#1"
  end if

  target_speed = 750 'kmph'
  target_speed_mps = target_speed/3.6
  accel = 9.8 'm/s^2'
  sim_time_motion = (target_speed_mps)/accel
  time_steps = Array(0)
  vel_steps = Array(1)

  if not (BUILD_STATIC) then
    Call getDocument().makeMotionComponent(Array("Track"))
    Call getDocument().renameObject(m, tm)

    If(motion_driver = "load") then
      Call getDocument().setMotionSourceType(tm, infoLoadDriven)
      Call getDocument().setMotionType(tm, infoLinear)
      Call getDocument().setMotionLinearDirection(tm, Array(1, 0, 0))
    ElseIf(motion_driver = "vel") then
      Call getDocument().setMotionSourceType(tm, infoVelocityDriven)
      Call getDocument().setMotionType(tm, infoLinear)
      Call getDocument().setMotionLinearDirection(tm, Array(1, 0, 0))
      Call getDocument().setMotionPositionAtStartup(tm, 0)
      'Call getDocument().setMotionSpeedAtStartup(m1, speed)
      Call getDocument().setMotionSpeedVsTime(tm,time_steps,vel_steps)
    End If
  End If

End Function



'SIMULATION RUN SETUP'

Function test_sim()


End Function


Function setup_sim()
  Call getDocument().beginUndoGroup("Set Transient Options", true)
  Call getDocument().setFixedIntervalTimeSteps(time_start, sim_time, time_step)
  Call getDocument().deleteTimeStepMaximumDelta()
  Call getDocument().setParameter("", "TransientAveragePowerLossStartTime", CStr(time_start)&"%ms", infoNumberParameter)
  Call getDocument().setParameter("", "TransientAveragePowerLossStopTime", CStr(sim_time)&"%ms", infoNumberParameter)
  Call getDocument().endUndoGroup()
End Function

Function run_sim()
  Call getDocument().setNumberOfMultiCoreSolveThreads(16)
  if(RUN_UPON_BUILD) then
    if(RUN_MOTION) then
      Call getDocument().solveTransient2dWithMotion()
    elseif (RUN_TRANSIENT) then
      Call getDocument().solveTransient2D()
    else
      Call getDocument().solveStatic2D()
    end if
  end if
End Function

'DOCUMENT PARAMETER SETUP'

Function setup_parameters()
  Call getDocument().setParameter("", "sourceSteps", v_max&", "&v_max*2&", "&v_max*3, infoNumber)
End Function




'DATA EXPORTING SETUP'

'exports the data as .csv files in a new directory with name current timestamp'
'params:'
'(int) current simulation number. Use 0 for single run simulations'
Function export_data(num)
  'Create file system object directory'
  Set fso = CreateObject("Scripting.FileSystemObject")


  cur_location = fso.GetAbsolutePathName(".")

  'cur_time defined at simulation/parameter sweep startup'
  save_path = cur_location+"\"+cur_time+"\"

  save_postfix = "-"+CStr(num)+".csv"
  'print(save_postfix)

  'Create a new folder with timestamp as name if does not exist'
  If Not fso.FolderExists(save_path) Then
    fso.CreateFolder(save_path)
  End If

  'Save data'
  If(SAVE_ENERGY) Then
    Call getGlobalResultsView().exportData(infoDataEnergy,save_path+"energy"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_BODY_FORCE) Then
    Call getGlobalResultsView().exportData(infoDataForce,save_path+"force"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_COMPONENT_FORCE) Then
    Call getGlobalResultsView().exportData(infoDataComponentForce,save_path+"component_force"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_FLUX_LINKAGE) Then
    Call getGlobalResultsView().exportData(infoDataFluxLinkage,save_path+"flux_linkage"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_OHMIC_LOSS) Then
    Call getGlobalResultsView().exportData(infoDataOhmicLoss,save_path+"ohmic_loss"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_IRON_LOSS) Then
    Call getGlobalResultsView().exportData(infoDataIronLoss,save_path+"iron_loss"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_CURRENT) Then
    Call getGlobalResultsView().exportData(infoDataCurrent,save_path+"current"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_VOLTAGE) Then
    Call getGlobalResultsView().exportData(infoDataVoltage,save_path+"voltage"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_TEMPERATURE) Then
    Call getGlobalResultsView().exportData(infoDataTemperature,save_path+"temperature"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_MOTION) Then
    Call getGlobalResultsView().exportData(infoDataMotion,save_path+"motion"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

End Function

'UTIL FUNCTIONS'

'Format material name to match that of MagNet magnet parameters'
Function format_material(material)
  format_material = "Name="+material
End Function

'Draw a square with opposing nodes (x1,y1) (x2,y2)'
Function draw_square(x1,x2,y1,y2)
  tx1 = x1
  tx2 = x2
  ty1 = y1
  ty2 = y2
  If(tx1 > tx2) Then
    temp = tx1
    tx1 = tx2
    tx2 = temp
  End If
  If(ty1 > ty2) Then
    temp = ty1
    ty1 = ty2
    ty2 = temp
  End If
  Call view.newLine(tx1,ty1,tx2,ty1)
  Call view.newLine(tx1,ty2,tx2,ty2)
  Call view.newLine(tx1,ty1,tx1,ty2)
  Call view.newLine(tx2,ty1,tx2,ty2)
End Function

'Combines two contacting components into 1'
Function union_components(component_1,component_2)
  parts = Array(component_1,component_2)
  Call getDocument().beginUndoGroup("Union Components")
  If (getDocument().unionComponents(parts,2,ErrorMessages) <> "") Then
    Call getDocument().getView().selectObject(component_1, infoSetSelection)
    Call getDocument().getView().selectObject(component_2, infoAddToSelection)
    Call getDocument().getView().deleteSelection()
    union_components = 1
  Else
    Call getDocument().getView().unselectAll()
    Call getApplication().MsgBox("An error occurred doing the union operation:" & vbLf & ErrorMessages, vbOKOnly)
    union_components = 0
  End If
  Call getDocument().endUndoGroup()
End Function

'Renames a component with given name'
Function rename_components(component,name)
  Call getDocument().beginUndoGroup("Rename Component", true)
  Call getDocument().renameObject(component,name)
  Call getDocument().endUndoGroup()
End Function

'Performs a union on two components, and then renames to given name'
Function union_and_rename(component_1,component_2,name)
  Call union_components(component_1,component_2)
  union_name = component_1+"+"+component_2+" Union#1"
  Call rename_components(union_name,name)
End Function

'Renames a substring to a new substring in a components name'
Function rename_copies(components,substr,newsubstr)
  temp = components
  For i=0 to num_coils-1
    temp(i) = Replace(components(i),substr,newsubstr)
    'app.MsgBox(components(i))
    Call rename_components(components(i),temp(i))
  Next
End Function

'Mirrors components accross a plane WITH copy'
'params:'
'name of the components in object window'
'normal vector of the mirror plane'
Function mirror_components_copy(components,normal)
  Call getDocument().beginUndoGroup("Mirror Component")
  Call getDocument().copyComponent(components, 1)
  Call getDocument().mirrorComponent(components,0,0,0,normal(0),normal(1),normal(2),1)
  Call getDocument().endUndoGroup()
End Function

'Mirrors components accross a plane WITHOUT copy'
'params:'
'name of the components in object window'
'normal vector of the mirror plane'
Function mirror_components(components,normal)
  Call getDocument().beginUndoGroup("Mirror Component")
  Call getDocument().mirrorComponent(components,0,0,0,normal(0),normal(1),normal(2),1)
  Call getDocument().endUndoGroup()
End Function

'Unselects currently selected components'
Function unselect()
  Call getDocument().getView().unselectAll()
End Function

'Prints an input array'
'params:'
'(Array) Array to be printed'
Function print_arr(input_arr)
  Dim output_str
  output_str = output_str&"["
  For each x in input_arr
    output_str = output_str&x&","
  Next
  print_arr = output_str&"]"
End Function

'Prints a given variable'
'Supports integer, string, and array'
'params:'
'(Array, int, string)' variable to be printed
Function print(input)
  If(IsArray(input)) Then
    Call app.MsgBox(print_arr(input))
  ElseIf(IsNumeric(input)) Then
    Call app.MsgBox(Cstr(input))
  Else
    Call app.MsgBox(input)
  End If
End Function

'Returns the value of local (x,y) coordinate pair with respect to the global coordinate plane'
'params:'
'(int) coordinate x'
'(int) coordinate y'
Function get_global(local_x,local_y)
  Set view = getDocument().getView()
  Dim global_points(2)
  Call view.getSlice().convertLocalToGlobal(local_x,local_y,global_points(0),global_points(1),global_points(2))
  get_global = global_points
End Function

'Returns the current time in yyyyMMddhhmmss format'
' Function get_current_timestamp()
'   get_current_timestamp = sprintf("{0:yyyyMMddhhmmss}", Array(now()))
' End Function

' 'sprintf function, like in C'
' Function sprintf(sFmt, aData)
'    Set sb = CreateObject("System.Text.StringBuilder")
'    Call sb.AppendFormat_4(sFmt, (aData))
'    sprintf = sb.ToString()
'    sb.Length = 0
' End Function