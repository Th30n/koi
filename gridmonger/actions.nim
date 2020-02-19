import options

import common
import map
import selection
import undomanager


using
  currMap: var Map
  um: var UndoManager[Map]

# {{{ cellAreaAction()
template cellAreaAction(currMap; rect: Rect[Natural], um;
                        actionMap, actionBody: untyped) =
  let action = proc (actionMap: var Map) =
    actionBody

  var undoMap = newMapFrom(currMap, rect)
  var undoAction = proc (m: var Map) =
    m.copyFrom(destCol=rect.x1, destRow=rect.y1,
               undoMap, rectN(0, 0, rect.width, rect.height))

  um.storeUndoState(undoAction, redoAction=action)
  action(currMap)

# }}}
# {{{ singleCellAction()
template singleCellAction(currMap; c, r: Natural, um;
                          actionMap, actionBody: untyped) =
  cellAreaAction(currMap, rectN(c, r, c+1, r+1), um, actionMap, actionBody)

# }}}

# {{{ eraseCellWallsAction*()
proc eraseCellWallsAction*(currMap; c, r: Natural, um) =
  singleCellAction(currMap, c, r, um, m):
    m.eraseCellWalls(c, r)

# }}}
# {{{ eraseCellAction*()
proc eraseCellAction*(currMap; c, r: Natural, um) =
  singleCellAction(currMap, c, r, um, m):
    m.eraseCell(c, r)

# }}}
# {{{ eraseSelectionAction*()
proc eraseSelectionAction*(currMap; sel: Selection, bbox: Rect[Natural], um) =
  cellAreaAction(currMap, bbox, um, m):
    for r in 0..<sel.rows:
      for c in 0..<sel.cols:
        if sel[c,r]:
          m.eraseCell(bbox.x1 + c, bbox.y1 + r)

# }}}
# {{{ pasteAction*()
proc pasteAction*(currMap; destCol, destRow: Natural, cb: CopyBuffer, um) =
  let rect = rectN(
    destCol,
    destRow,
    destCol + cb.map.cols,
    destRow + cb.map.rows
  ).intersect(
    rectN(0, 0, currMap.cols, currMap.rows)
  )
  if rect.isSome:
    cellAreaAction(currMap, rect.get, um, m):
      m.paste(destCol, destRow, cb.map, cb.selection)

# }}}
# {{{ setWallAction*()
proc setWallAction*(currMap; c, r: Natural, dir: Direction, w: Wall, um) =
  singleCellAction(currMap, c, r, um, m):
    m.setWall(c, r, dir, w)

# }}}
# {{{ setFloorAction*()
proc setFloorAction*(currMap; c, r: Natural, f: Floor, um) =
  singleCellAction(currMap, c, r, um, m):
    m.setFloor(c, r, f)

# }}}
# {{{ excavateAction*()
proc excavateAction*(currMap; c, r: Natural, um) =
  singleCellAction(currMap, c, r, um, m):
    if m.getFloor(c,r) == fNone:
      m.setFloor(c,r, fEmptyFloor)

    if r == 0 or m.getFloor(c,r-1) == fNone:
      m.setWall(c,r, North, wWall)
    else:
      m.setWall(c,r, North, wNone)

    if c == 0 or m.getFloor(c-1,r) == fNone:
      m.setWall(c,r, West, wWall)
    else:
      m.setWall(c,r, West, wNone)

    if r == m.rows-1 or m.getFloor(c,r+1) == fNone:
      m.setWall(c,r, South, wWall)
    else:
      m.setWall(c,r, South, wNone)

    if c == m.cols-1 or m.getFloor(c+1,r) == fNone:
      m.setWall(c,r, East, wWall)
    else:
      m.setWall(c,r, East, wNone)

# }}}
# {{{ toggleFloorOrientationAction*()
# TODO unnecessary
proc toggleFloorOrientationAction*(currMap; c, r: Natural, um) =
  singleCellAction(currMap, c, r, um, m):
    let newOt = if m.getFloorOrientation(c, r) == Horiz: Vert else: Horiz
    m.setFloorOrientation(c, r, newOt)

# }}}

# vim: et:ts=2:sw=2:fdm=marker
