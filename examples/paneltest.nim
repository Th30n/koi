import glad/gl
import glfw
from glfw/wrapper import showWindow
import nanovg

import koi

import ../gridmonger/src/theme
import ../gridmonger/src/common


# Global NanoVG context
var vg: NVGContext


### UI DATA ##################################################################
var
  sectionUserInterface = true
  sectionUserInterfaceGeneral = true
  sectionWidget = true
  sectionTextField = true
  sectionDialog = true
  sectionTitleBar = true
  sectionStatusBar = true
  sectionLeveldropDown = true
  sectionAboutButton = true

  sectionLevel = true
  sectionLevelGeneral = true
  sectionOutline = true
  sectionShadow = true
  sectionBackgroundHatch = true
  sectionFloorColors = true
  sectionNotes = true
  
  sectionPanes = true
  sectionNotesPane = true
  sectionToolbarPane = true

var currTheme = loadTheme("../gridmonger/themes/Default.cfg")

var
  themeName = "Default"
  themeAuthor = "chaos"

  section1 = true
  section2 = true

  dropDownVal1 = 0
  dropDownVal2 = 0
  dropDownVal3 = 0

  checkBoxVal1 = false
  checkBoxVal2 = false
  checkBoxVal3 = false
  checkBoxVal4 = false
  checkBoxVal5 = false
  checkBoxVal6 = false

##############################################################################

proc createWindow(): Window =
  var cfg = DefaultOpenglWindowConfig
  cfg.size = (w: 1000, h: 800)
  cfg.title = "Koi Test"
  cfg.resizable = true
  cfg.visible = false
  cfg.bits = (r: 8, g: 8, b: 8, a: 8, stencil: 8, depth: 16)
  cfg.debugContext = true
  cfg.nMultiSamples = 4

  when defined(macosx):
    cfg.version = glv32
    cfg.forwardCompat = true
    cfg.profile = opCoreProfile

  newWindow(cfg)


proc loadData(vg: NVGContext) =
  let regularFont = vg.createFont("sans", "data/Roboto-Regular.ttf")
  if regularFont == NoFont:
    quit "Could not add font italic.\n"

  let boldFont = vg.createFont("sans-bold", "data/Roboto-Bold.ttf")
  if boldFont == NoFont:
    quit "Could not add font italic.\n"


var propsSliderStyle = getDefaultSliderStyle()
propsSliderStyle.trackCornerRadius = 8.0
propsSliderStyle.valueCornerRadius = 6.0

proc renderUI(winWidth, winHeight, pxRatio: float) =
  koi.beginFrame(winWidth.float, winHeight.float, pxRatio)

  ############################################################################

  koi.beginScrollView(x=100, y=100, w=314, h=600)

  if koi.sectionHeader("User Interface", sectionUserInterface):

    if koi.subSectionHeader("General", sectionUserInterfaceGeneral):
      koi.label("Background")
      koi.color(currTheme.general.backgroundColor)

      koi.label("Highlight")
      koi.color(currTheme.general.highlightColor)

    if koi.subSectionHeader("Widget", sectionWidget):
      koi.label("Background")
      koi.color(currTheme.widget.bgColor)

      koi.label("Background Hover")
      koi.color(currTheme.widget.bgColorHover)

      koi.label("Background Disabled")
      koi.color(currTheme.widget.bgColorDisabled)

      koi.label("Text")
      koi.color(currTheme.widget.textColor)

      koi.label("Text Disabled")
      koi.color(currTheme.widget.textColorDisabled)

    if koi.subSectionHeader("Text Field", sectionTextField):
      koi.label("Background Active")
      koi.color(currTheme.textField.bgColorActive)

      koi.label("Text Active")
      koi.color(currTheme.textField.textColorActive)

      koi.label("Cursor")
      koi.color(currTheme.textField.cursorColor)

      koi.label("Selection")
      koi.color(currTheme.textField.selectionColor)

    if koi.subSectionHeader("Dialog", sectionDialog):
      koi.label("Title Bar Background")
      koi.color(currTheme.dialog.titleBarBgColor)

      koi.label("Title Bar Text")
      koi.color(currTheme.dialog.titleBarTextColor)

      koi.label("Background")
      koi.color(currTheme.dialog.backgroundColor)

      koi.label("Text")
      koi.color(currTheme.dialog.textColor)

      koi.label("Warning Text")
      koi.color(currTheme.dialog.warningTextColor)

    if koi.subSectionHeader("Title Bar", sectionTitleBar):
      koi.label("Background")
      koi.color(currTheme.titleBar.backgroundColor)

      koi.label("Background Unfocused")
      koi.color(currTheme.titleBar.bgColorUnfocused)

      koi.label("Text")
      koi.color(currTheme.titleBar.textColor)

      koi.label("Text Unfocused")
      koi.color(currTheme.titleBar.textColorUnfocused)

      koi.label("Modified Flag")
      koi.color(currTheme.titleBar.modifiedFlagColor)

      koi.label("Button")
      koi.color(currTheme.titleBar.buttonColor)

      koi.label("Button Hover")
      koi.color(currTheme.titleBar.buttonColorHover)

      koi.label("Button Down")
      koi.color(currTheme.titleBar.buttonColorDown)

    if koi.subSectionHeader("Status Bar", sectionStatusBar):
      koi.label("Background")
      koi.color(currTheme.statusBar.backgroundColor)

      koi.label("Text")
      koi.color(currTheme.statusBar.textColor)

      koi.label("Command Background")
      koi.color(currTheme.statusBar.commandBgColor)

      koi.label("Command")
      koi.color(currTheme.statusBar.commandColor)

      koi.label("Coordinates")
      koi.color(currTheme.statusBar.coordsColor)

    if koi.subSectionHeader("Level Drop Down", sectionLeveldropDown):
      koi.label("Button")
      koi.color(currTheme.leveldropDown.buttonColor)

      koi.label("Button Hover")
      koi.color(currTheme.leveldropDown.buttonColorHover)

      koi.label("Text")
      koi.color(currTheme.leveldropDown.textColor)

      koi.label("Item List")
      koi.color(currTheme.leveldropDown.itemListColor)

      koi.label("Item")
      koi.color(currTheme.leveldropDown.itemColor)

      koi.label("Item Hover")
      koi.color(currTheme.leveldropDown.itemColorHover)

    if koi.subSectionHeader("About Button", sectionAboutButton):
      koi.label("Color")
      koi.color(currTheme.aboutButton.color)

      koi.label("Hover")
      koi.color(currTheme.aboutButton.colorHover)

      koi.label("Active")
      koi.color(currTheme.aboutButton.colorActive)


  if koi.sectionHeader("Level", sectionLevel):
    if koi.subSectionHeader("General", sectionLevelGeneral):
      group:
        koi.label("Background")
        koi.color(currTheme.level.backgroundColor)

        koi.label("Draw")
        koi.color(currTheme.level.drawColor)

        koi.label("Draw Light")
        koi.color(currTheme.level.lightDrawColor)

        koi.label("Line Width")
        koi.dropDown(LineWidth, currTheme.level.lineWidth)

      group:
        koi.label("Coordinates")
        koi.color(currTheme.level.coordsColor)

        koi.label("Coordinates Highlight")
        koi.color(currTheme.level.coordsHighlightColor)

        koi.label("Cursor")
        koi.color(currTheme.level.cursorColor)

        koi.label("Cursor Guides")
        koi.color(currTheme.level.cursorGuideColor)

      group:
        koi.label("Grid Style Background")
        koi.dropDown(GridStyle, currTheme.level.gridStyleBackground)

        koi.label("Grid Background")
        koi.color(currTheme.level.gridColorBackground)

        koi.label("Grid Style Floor")
        koi.dropDown(GridStyle, currTheme.level.gridStyleFloor)

        koi.label("Grid Floor")
        koi.color(currTheme.level.gridColorFloor)

      group:
        koi.label("Selection")
        koi.color(currTheme.level.selectionColor)

        koi.label("Paste Preview")
        koi.color(currTheme.level.pastePreviewColor)

      group:
        koi.label("Link Marker")
        koi.color(currTheme.level.linkMarkerColor)

    if koi.subSectionHeader("Background Hatch", sectionBackgroundHatch):
      koi.label("Background Hatch?")
      koi.checkBox(currTheme.level.bgHatchEnabled)

      koi.label("Hatch")
      koi.color(currTheme.level.bgHatchColor)

      koi.label("Hatch Stroke Width")
      koi.horizSlider(startVal=0, endVal=10, currTheme.level.bgHatchStrokeWidth,
                      style=propsSliderStyle)

      koi.label("Hatch Spacing")
      koi.horizSlider(startVal=0, endVal=10, currTheme.level.bgHatchSpacingFactor,
                      style=propsSliderStyle)

    if koi.subSectionHeader("Outline", sectionOutline):
      koi.label("Outline Style")
      koi.dropDown(OutlineStyle, currTheme.level.outlineStyle)

      koi.label("Outline Fill Style")
      koi.dropDown(OutlineFillStyle, currTheme.level.outlineFillStyle)

      koi.label("Outline Overscan")
      koi.checkBox(currTheme.level.outlineOverscan)

      koi.label("Outline")
      koi.color(currTheme.level.outlineColor)

      koi.label("Outline Width")
      koi.horizSlider(startVal=0, endVal=10, currTheme.level.outlineWidthFactor,
                      style=propsSliderStyle)

    if koi.subSectionHeader("Shadow", sectionShadow):
      group:
        koi.label("Inner Shadow?")
        koi.checkBox(currTheme.level.innerShadowEnabled)

        koi.label("Inner Shadow")
        koi.color(currTheme.level.innerShadowColor)

        koi.label("Inner Shadow Width")
        koi.horizSlider(startVal=0, endVal=10, currTheme.level.innerShadowWidthFactor,
                        style=propsSliderStyle)

      group:
        koi.label("Outer Shadow?")
        koi.checkBox(currTheme.level.outerShadowEnabled)

        koi.label("Outer Shadow")
        koi.color(currTheme.level.outerShadowColor)

        koi.label("Outer Shadow Width")
        koi.horizSlider(startVal=0, endVal=10, currTheme.level.outerShadowWidthFactor,
                        style=propsSliderStyle)

    if koi.subSectionHeader("Floor Colors", sectionFloorColors):
      koi.label("Floor 1")
      koi.color(currTheme.level.floorColor[0])

      koi.label("Floor 2")
      koi.color(currTheme.level.floorColor[1])

      koi.label("Floor 3")
      koi.color(currTheme.level.floorColor[2])

      koi.label("Floor 4")
      koi.color(currTheme.level.floorColor[3])

      koi.label("Floor 5")
      koi.color(currTheme.level.floorColor[4])

      koi.label("Floor 6")
      koi.color(currTheme.level.floorColor[5])

      koi.label("Floor 7")
      koi.color(currTheme.level.floorColor[6])

      koi.label("Floor 8")
      koi.color(currTheme.level.floorColor[7])

      koi.label("Floor 9")
      koi.color(currTheme.level.floorColor[8])

    if koi.subSectionHeader("Notes", sectionNotes):
      group:
        koi.label("Marker")
        koi.color(currTheme.level.noteMarkerColor)

        koi.label("Comment")
        koi.color(currTheme.level.noteCommentColor)

      group:
        koi.label("Index")
        koi.color(currTheme.level.noteIndexColor)

        koi.label("Index Background 1")
        koi.color(currTheme.level.noteIndexBgColor[0])

        koi.label("Index Background 2")
        koi.color(currTheme.level.noteIndexBgColor[1])

        koi.label("Index Background 3")
        koi.color(currTheme.level.noteIndexBgColor[2])

        koi.label("Index Background 4")
        koi.color(currTheme.level.noteIndexBgColor[3])

      group:
        koi.label("Tooltip Background")
        koi.color(currTheme.level.noteTooltipBgColor)

        koi.label("Tooltip Text")
        koi.color(currTheme.level.noteTooltipTextColor)

  if koi.sectionHeader("Panes", sectionPanes):
    if koi.subSectionHeader("Notes Pane", sectionNotesPane):
      koi.label("Text")
      koi.color(currTheme.notesPane.textColor)

      koi.label("Index")
      koi.color(currTheme.notesPane.indexColor)

      koi.label("Index Background 1")
      koi.color(currTheme.notesPane.indexBgColor[0])

      koi.label("Index Background 2")
      koi.color(currTheme.notesPane.indexBgColor[1])

      koi.label("Index Background 3")
      koi.color(currTheme.notesPane.indexBgColor[2])

      koi.label("Index Background 4")
      koi.color(currTheme.notesPane.indexBgColor[3])

    if koi.subSectionHeader("Toolbar Pane", sectionToolbarPane):
      koi.label("Button Background")
      koi.color(currTheme.toolbarPane.buttonBgColor)

      koi.label("Button Background Hover")
      koi.color(currTheme.toolbarPane.buttonBgColorHover)

  koi.endScrollView()


#[


#-----------------------------------------------------------------------------

[toolbarPane]
]#




  koi.beginScrollView(x=600, y=150, w=300, h=300)

  if koi.sectionHeader("First section", section1):
    koi.beginGroup()
    koi.label("CheckBox 1")
    koi.checkBox(checkBoxVal1, tooltip = "Checkbox 1")

    koi.label("CheckBox 2")
    koi.checkBox(checkBoxVal2, tooltip = "Checkbox 2")

    koi.label("CheckBox 3")
    koi.checkBox(checkBoxVal3, tooltip = "Checkbox 3")

    koi.label("CheckBox 4")
    koi.checkBox(checkBoxVal4, tooltip = "Checkbox 4")
    koi.endGroup()

    koi.beginGroup()
    koi.label("dropDown 1")
    koi.dropDown(items = @["Orange", "Banana", "Blueberry", "Apricot", "Apple"],
                 dropDownVal1,
                 tooltip = "Select a fruit")

    koi.label("dropDown 2")
    koi.dropDown(items = @["One", "Two", "Three"],
                 dropDownVal2,
                 tooltip = "Select a number")
    koi.endGroup()

  if koi.sectionHeader("Second section", section2):
    koi.label("dropDown 1")
    koi.dropDown(items = @["Orange", "Banana", "Blueberry", "Apricot", "Apple"],
                 dropDownVal3,
                 tooltip = "Select a fruit")

    koi.beginGroup()
    koi.label("CheckBox 1")
    koi.checkBox(checkBoxVal5, tooltip = "Checkbox 1")

    koi.label("CheckBox 2")
    koi.checkBox(checkBoxVal6, tooltip = "Checkbox 2")
    koi.endGroup()

  koi.endScrollView()

  ############################################################################

  koi.endFrame()


proc renderFrame(win: Window, res: tuple[w, h: int32] = (0,0)) =
  let
    (winWidth, winHeight) = win.size
    (fbWidth, fbHeight) = win.framebufferSize
    pxRatio = fbWidth / winWidth

  # Update and render
  glViewport(0, 0, fbWidth, fbHeight)

  glClearColor(0.3, 0.3, 0.3, 1.0)

  glClear(GL_COLOR_BUFFER_BIT or
          GL_DEPTH_BUFFER_BIT or
          GL_STENCIL_BUFFER_BIT)

  renderUI(winWidth.float, winHeight.float, pxRatio)

  glfw.swapBuffers(win)


proc windowPosCb(win: Window, pos: tuple[x, y: int32]) =
  renderFrame(win)

proc framebufSizeCb(win: Window, size: tuple[w, h: int32]) =
  renderFrame(win)

proc init(): Window =
  glfw.initialize()

  var win = createWindow()

  var flags = {nifStencilStrokes, nifAntialias, nifDebug}
  vg = nvgInit(getProcAddress, flags)
  if vg == nil:
    quit "Error creating NanoVG context"

  if not gladLoadGL(getProcAddress):
    quit "Error initialising OpenGL"

  loadData(vg)

  koi.init(vg, getProcAddress)

  win.windowPositionCb = windowPosCb
  win.framebufferSizeCb = framebufSizeCb

  glfw.swapInterval(1)

  win.pos = (400, 150)  # TODO for development
  wrapper.showWindow(win.getHandle())

  result = win


proc cleanup() =
  koi.deinit()
  nvgDeinit(vg)
  glfw.terminate()


proc main() =
  let win = init()

  while not win.shouldClose: # TODO key buf, like char buf?
    if koi.shouldRenderNextFrame():
      glfw.pollEvents()
    else:
      glfw.waitEvents()
    renderFrame(win)

  cleanup()


main()

# vim: et:ts=2:sw=2:fdm=marker
