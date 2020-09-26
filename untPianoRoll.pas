{
  untPianoRoll v1.0.0 - a simple pianoroll editor like found in FL Studio
  for Delphi 2010 - 10.4 by Ernst Reidinga
  https://erdesigns.eu

  This unit is part of the ERDesigns Midi Components Pack.

  (c) Copyright 2020 Ernst Reidinga <ernst@erdesigns.eu>

  Bugfixes / Updates:
  - Initial Release 1.0.0

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.

  ToDo:
  - Add velocity editor
  - Add custom scrollbars
  - Add zoom bars / controls
}

unit untPianoRoll;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, Vcl.Menus, GDIPlus;

type
  TPianoRollMode = (prmInsert, prmErase, prmSelect);

  TPianoRollItem = class(TCollectionItem)
  private
    FRow      : Integer;
    FCol      : Integer;
    FOffset   : Single;
    FLength   : Single;
    FColor    : TColor;
    FSelected : Boolean;
    FCaption  : TCaption;
    FRect     : TRect;

    procedure SetRow(const I: Integer);
    procedure SetCol(const I: Integer);
    procedure SetOffset(const S: Single);
    procedure SetLength(const S: Single);
    procedure SetColor(const C: TColor);
    procedure SetSelected(const B: Boolean);
    procedure SetCaption(const C: TCaption);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(AOWner: TCollection); override;

    procedure Assign(Source: TPersistent); override;

    property Selected: Boolean read FSelected write SetSelected;
    property ItemRect: TRect read FRect write FRect;
  published
    property Row: Integer read FRow write SetRow default 0;
    property Col: Integer read FCol write SetCol default 0;
    property OffSet: Single read FOffset write SetOffset;
    property Length: Single read FLength write SetLength;
    property Color: TColor read FColor write SetColor default clNone;
    property Caption: TCaption read FCaption write SetCaption;
  end;

  TPianoRollItems = class(TOwnedCollection)
  private
    FOnChange : TNotifyEvent;

    procedure ItemChanged(Sender: TObject);

    function GetItem(Index: Integer): TPianoRollItem;
    procedure SetItem(Index: Integer; const Value: TPianoRollItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TPianoRollItem;
    procedure Assign(Source: TPersistent); override;

    property Items[Index: Integer]: TPianoRollItem read GetItem write SetItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TPianoRollNotes = class(TPersistent)
  private
    { Private declarations }
    FColor           : TColor;
    FToColor         : TColor;
    FSelectedColor   : TColor;
    FSelectedToColor : TColor;
    FLineColor       : TColor;
    FFont            : TFont;
    FShowCaptions    : Boolean;
    FInsertLength    : Single;
    FOffsetStep      : Single;
    FShowGhostNotes  : Boolean;
    FGhostColor      : TColor;
    FCornerRadius    : Integer;

    FOnChange   : TNotifyEvent;

    procedure SetColor(const C: TColor);
    procedure SetToColor(const C: TColor);
    procedure SetSelectedColor(const C: TColor);
    procedure SetSelectedToColor(const C: TColor);
    procedure SetLineColor(const C: TColor);
    procedure SetFont(const F: TFont);
    procedure SetShowCaptions(const B: Boolean);
    procedure SetGhostNotes(const B: Boolean);
    procedure SetGhostColor(const C: TColor);
    procedure SetCornerRadius(const I: Integer);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Color: TColor read FColor write SetColor default $00C7F3C0;
    property ToColor: TColor read FToColor write SetToColor default $00ABD4A4;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default $009D9DFC;
    property SelectedToColor: TColor read FSelectedToColor write SetSelectedToColor default $008587DF;
    property LineColor: TColor read FLineColor write SetLineColor default $00433B3C;
    property Font: TFont read FFont write SetFont;
    property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions default True;
    property InsertLength: Single read FInsertLength write FInsertLength;
    property OffsetStep: Single read FOffsetStep write FOffsetStep;
    property ShowGhostNotes: Boolean read FShowGhostNotes write SetGhostNotes;
    property GhostColor: TColor read FGhostColor write SetGhostColor default $006B6151;
    property CornerRadius: Integer read FCornerRadius write SetCornerRadius default 5;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TPianoRollPositionIndicator = class(TPersistent)
  private
    { Private declarations }
    FHeight     : Integer;
    FWidth      : Integer;
    FColor      : TColor;
    FLineColor  : TColor;

    FOnChange   : TNotifyEvent;

    procedure SetHeight(const I: Integer);
    procedure SetWidth(const I: Integer);
    procedure SetColor(const C: TColor);
    procedure SetLineColor(const C: TColor);
  public
    { Public declarations }
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Height: Integer read FHeight write SetHeight default 8;
    property Width: Integer read FWidth write SetWidth default 12;
    property Color: TColor read FColor write SetColor default $0067D7AE;
    property LineColor: TColor read FLineColor write SetLineColor default $0067D7AE;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TPianoRollRuler = class(TPersistent)
  private
    { Private declarations }
    FHeight     : Integer;
    FColor      : TColor;
    FToColor    : TColor;
    FLineColor  : TColor;
    FFont       : TFont;
    FShowLines  : Boolean;
    FShowNumbers: Boolean;

    FOnChange   : TNotifyEvent;

    procedure SetHeight(const I: Integer);
    procedure SetColor(const C: TColor);
    procedure SetToColor(const C: TColor);
    procedure SetLineColor(const C: TColor);
    procedure SetFont(const F: TFont);
    procedure SetShowLines(const B: Boolean);
    procedure SetShowNumbers(const B: Boolean);
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Height: Integer read FHeight write SetHeight default 32;
    property Color: TColor read FColor write SetColor default $00322A1D;
    property ToColor: TColor read FToColor write SetToColor default $00453C2F;
    property LineColor: TColor read FLineColor write SetLineColor default $00676456;
    property Font: TFont read FFont write SetFont;
    property ShowLines: Boolean read FShowLines write SetShowLines default False;
    property ShowNumbers: Boolean read FShowNumbers write SetShowNumbers default True;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TPianoRollGrid = class(TPersistent)
  private
    { Private declarations }
    FColor1     : TColor;
    FColor2     : TColor;
    FLineColor1 : TColor;
    FLineColor2 : TColor;
    FFadedSides : Boolean;
    FFadeColor  : TColor;

    FOnChange   : TNotifyEvent;

    procedure SetColor1(const C: TColor);
    procedure SetColor2(const C: TColor);
    procedure SetLineColor1(const C: TColor);
    procedure SetLineColor2(const C: TColor);
    procedure SetFadedSides(const B: Boolean);
    procedure SetFadeColor(const C: TColor);
  public
    { Public declarations }
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Color1: TColor read FColor1 write SetColor1 default $004E4335;
    property Color2: TColor read FColor2 write SetColor2 default $00483E2D;
    property LineColor1: TColor read FLineColor1 write SetLineColor1 default $00231908;
    property LineColor2: TColor read FLineColor2 write SetLineColor2 default $0043382A;
    property Shadow: Boolean read FFadedSides write SetFadedSides default True;
    property ShadowColor: TColor read FFadeColor write SetFadeColor default $00231908;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TPianoRollLoopBar = class(TPersistent)
  private
    { Private declarations }
    FStart     : Single;
    FStop      : Single;
    FColor     : TColor;
    FLineColor : TColor;
    FPopup     : TPopupMenu;

    FOnChange   : TNotifyEvent;

    procedure SetStart(const S: Single);
    procedure SetStop(const S: Single);
    procedure SetColor(const C: TColor);
    procedure SetLineColor(const C: TColor);
  public
    { Public declarations }
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Start: Single read FStart write SetStart;
    property Stop: Single read FStop write SetStop;
    property Color: TColor read FColor write SetColor default $004A47CF;
    property LineColor: TColor read FLineColor write SetLineColor default $004A47CF;
    property PopupMenu: TPopupMenu read FPopup write FPopup;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TPianoRollSelection = class(TPersistent)
  private
    { Private declarations }
    FColor     : TColor;
    FLineColor : TColor;

    FOnChange   : TNotifyEvent;

    procedure SetColor(const C: TColor);
    procedure SetLineColor(const C: TColor);
  public
    { Public declarations }
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    { Published declarations }
    property Color: TColor read FColor write SetColor default $004A47CF;
    property LineColor: TColor read FLineColor write SetLineColor default $004A47CF;

    property OnChange: TNotifyEvent read FOnChange write FonChange;
  end;

  TPianoRoll = class(TCustomControl)
  private
    { Private declarations }
    HBlockSize  : Single;
    VBlockSize  : Integer;
    SubColWidth : Integer;

    { Buffer - Avoid flickering }
    FBuffer           : TBitmap;
    FRulerBuffer      : TBitmap;
    FUpdateRect       : TRect;

    { Redraw part }
    FRedrawRuler: Boolean;

    { Scroll Positions and Max }
    FScrollPosX : Integer;
    FScrollPosY : Integer;
    FScrollMaxX : Integer;
    FScrollMaxY : Integer;
    FOldScrollX : Integer;
    FOldScrollY : Integer;

    { Selection }
    FIsSelecting     : Boolean;
    FSelectFrom      : TPoint;
    FSelectTo        : TPoint;
    FIsLoopSelecting : Boolean;
    FIsDragging      : Boolean;
    FIsResizing      : Boolean;
    FIsErasing       : Boolean;

    { Settings }
    FPositionIndicator  : TPianoRollPositionIndicator;
    FRuler              : TPianoRollRuler;
    FGrid               : TPianoRollGrid;
    FLoopBar            : TPianoRollLoopBar;
    FSelection          : TPianoRollSelection;
    FNotes              : TPianoRollNotes;

    { Notes - Items }
    FItems              : TPianoRollItems;
    FGhostItems         : TPianoRollItems;

    { Zoom factor }
    FZoomHorizontal : Integer;
    FZoomVertical   : Integer;

    { Player position }
    FPlayerPosition : Single;

    { Rows and Columns }
    FMaxRows : Integer;
    FMaxCols : Integer;

    { Piano Roll Mode }
    FMode : TPianoRollMode;

    { Popup Menu's }
    FPopup : TPopupMenu;

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;

    procedure SetScrollPosX(const I: Integer);
    procedure SetScrollPosY(const I: Integer);

    procedure SetItems(I: TPianoRollItems);
    procedure SetGhostItems(I: TPianoRollItems);

    procedure SetZoomHorizontal(const Z: Integer);
    procedure SetZoomVertical(const Z: Integer);

    procedure SetPlayerPosition(const S: Single);
    procedure SetMaxRows(const I: Integer);
    procedure SetMaxCols(const I: Integer);
    procedure SetMode(const M: TPianoRollMode);
  protected
    { Protected declarations }
    procedure SettingsChanged(Sender: TObject);
    function PxToPos(const I: Integer) : Single;
    function MouseIsOnNote(const X, Y: Integer; var Note: Integer) : Boolean;
    function MouseInRow(const I : Integer) : Integer;
    function MouseInCol(const I : Integer) : Integer;
    procedure ClearNoteSelection;

    procedure Paint; override;
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Clipboard }
    function CanPaste : Boolean;
    function CopySelection : Boolean;
    function CutSelection : Boolean;
    function Paste : Boolean;

    { Scroll by code - used by the Velicity Editor }
    procedure UpdateHorizontalScrollbar(const I: Integer);

    property UpdateRect: TRect read FUpdateRect write FUpdateRect;
    property RedrawRuler: Boolean read FRedrawRuler write FRedrawRuler;
  published
    { Published declarations }
    property PositionIndicator: TPianoRollPositionIndicator read FPositionIndicator write FPositionIndicator;
    property Ruler: TPianoRollRuler read FRuler write FRuler;
    property Grid: TPianoRollGrid read FGrid write FGrid;
    property LoopBar: TPianoRollLoopBar read FLoopBar write FLoopBar;
    property Selection: TPianoRollSelection read FSelection write FSelection;
    property Notes: TPianoRollNotes read FNotes write FNotes;

    property Items: TPianoRollItems read FItems write SetItems;
    property GhostItems: TPianoRollItems read FGhostItems write SetGhostItems;

    property ZoomHorizontal: Integer read FZoomHorizontal write SetZoomHorizontal default 100;
    property ZoomVertical: Integer read FZoomVertical write SetZoomVertical default 100;

    property MaxRows: Integer read FMaxRows write SetMaxRows default 64;
    property MaxCols: Integer read FMaxCols write SetMaxCols default 32;

    property PlayerPosition: Single read FPlayerPosition write SetPlayerPosition;
    property Mode: TPianoRollMode read FMode write SetMode default prmSelect;
    property Popupmenu: TPopupMenu read FPopup write FPopup;

    property Align;
    property Anchors;
    property Enabled;
    property TabOrder;
    property Visible;
  end;

procedure Register;

implementation

uses System.Math, Vcl.Forms, Vcl.Clipbrd, System.StrUtils;

{ Zoom defaults }
const
  { Block width @ 100% zoom = 56px (div 4 = 14px per small block) }
  BlockWidth100 = 56;
  { Block height @ 100% zoom = 14px }
  BlockHeight100 = 14;

{ Cursor Identifiers }
const
  crPencil = 1000;

{ Clipboard Format }
const
  ClipboarFormatIdentifier = 'ERDesigns Piano Roll';
var
  CF_EPR : Word;

(******************************************************************************)
(*
(*  Piano Roll Collection Item (TPianoRollItem)
(*
(******************************************************************************)

constructor TPianoRollItem.Create(AOWner: TCollection);
begin
  inherited Create(AOwner);
  FColor   := clNone;
  FLength  := 1;
  FRow     := 1;
  FCol     := 1;
  FCaption := '';
end;

procedure TPianoRollItem.SetRow(const I: Integer);
begin
  if (I <> Row) then
  begin
    if (I > 0) then
      FRow := I
    else
      FRow := 1;
    Changed(False);
  end;
end;

procedure TPianoRollItem.SetCol(const I: Integer);
begin
  if I <> Col then
  begin
    if (I > 0) then
      FCol := I
    else
      FCol := 1;
    Changed(False);
  end;
end;

procedure TPianoRollItem.SetOffset(const S: Single);
begin
  if S <> OffSet then
  begin
    FOffSet := S;
    if FOffSet >= 1.0 then 
    begin
      FCol := FCol +1;
      FOffset := 0;
    end else
    if FOffSet <= -0.1 then
    begin
      FCol := FCol -1;
      FOffset := 0.9;
    end;
    Changed(False);
  end;
end;

procedure TPianoRollItem.SetLength(const S: Single);
begin
  if S <> Length then
  begin
    FLength := S;
    Changed(False);
  end;
end;

procedure TPianoRollItem.SetColor(const C: TColor);
begin
  if C <> Color then
  begin
    FColor := C;
    Changed(False);
  end;
end;

procedure TPianoRollItem.SetSelected(const B: Boolean);
begin
  if B <> Selected then
  begin
    FSelected := B;
    Changed(False);
  end;
end;

procedure TPianoRollItem.SetCaption(const C: TCaption);
begin
  if C <> Caption then
  begin
    FCaption := C;
    Changed(False);
  end;
end;

function TPianoRollItem.GetDisplayName : string;
begin
  { Maybe change this to the corresponding notes ? }
  if (Caption <> '') then
    Result := Caption
  else
    Result := Format('Row %d - Col %d', [Row, Col]);
end;

procedure TPianoRollItem.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TPianoRollItem then
  begin
    Row    := TPianoRollItem(Source).Row;
    Col    := TPianoRollItem(Source).Col;
    OffSet := TPianoRollItem(Source).OffSet;
    Length := TPianoRollItem(Source).Length;
    Color  := TPianoRollItem(Source).Color;
    Changed(False);
  end else Inherited;
end;

(******************************************************************************)
(*
(*  Piano Roll Item Collection (TPianoRollItems)
(*
(******************************************************************************)
constructor TPianoRollItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TPianoRollItem);
end;

procedure TPianoRollItems.ItemChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TPianoRollItems.SetItem(Index: Integer; const Value: TPianoRollItem);
begin
  inherited SetItem(Index, Value);
  ItemChanged(Self);
end;

procedure TPianoRollItems.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TPianoRollItems.GetItem(Index: Integer) : TPianoRollItem;
begin
  Result := inherited GetItem(Index) as TPianoRollItem;
end;

function TPianoRollItems.Add : TPianoRollItem;
begin
  Result := TPianoRollItem(inherited Add);
end;

procedure TPianoRollItems.Assign(Source: TPersistent);
var
  LI   : TPianoRollItems;
  Loop : Integer;
begin
  if (Source is TPianoRollItems)  then
  begin
    LI := TPianoRollItems(Source);
    Clear;
    for Loop := 0 to LI.Count - 1 do
        Add.Assign(LI.Items[Loop]);
  end else inherited;
end;

(******************************************************************************)
(*
(*  Piano Roll Notes (TPianoRollNotes)
(*
(******************************************************************************)
constructor TPianoRollNotes.Create;
begin
  inherited Create;
  FFont            := TFont.Create;
  FFont.OnChange   := FOnChange;
  FFont.Name       := 'Segoe UI';
  FFont.Color      := $00433B3C;
  FFont.Size       := 8;
  FColor           := $00C7F3C0;
  FToColor         := $00ABD4A4;
  FSelectedColor   := $009D9DFC;
  FSelectedToColor := $008587DF;
  FLineColor       := $00433B3C;
  FShowCaptions    := True;
  FInsertLength    := 4;
  FOffsetStep      := 0.1;
  FShowGhostNotes  := True;
  FGhostColor      := $006B6151;
  FCornerRadius    := 5;
end;

destructor TPianoRollNotes.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TPianoRollNotes.Assign(Source: TPersistent);
begin
  if Source is TPianoRollNotes then
  begin
    FFont.Assign(TPianoRollNotes(Source).Font);
    FColor           := TPianoRollNotes(Source).Color;
    FToColor         := TPianoRollNotes(Source).ToColor;
    FSelectedColor   := TPianoRollNotes(Source).SelectedColor;
    FSelectedToColor := TPianoRollNotes(Source).SelectedToColor;
    FLineColor       := TPianoRollNotes(Source).LineColor;
    FShowCaptions    := TPianoRollNotes(Source).ShowCaptions;
    FInsertLength    := TPianoRollNotes(Source).InsertLength;
    FOffsetStep      := TPianoRollNotes(Source).OffsetStep;
    FShowGhostNotes  := TPianoRollNotes(Source).ShowGhostNotes;
    FGhostColor      := TPianoRollNotes(Source).GhostColor;
    FCornerRadius    := TPianoRollNotes(Source).CornerRadius;
  end else
    inherited;
end;

procedure TPianoRollNotes.SetColor(const C: TColor);
begin
  if C <> Color then
  begin
    FColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollNotes.SetToColor(const C: TColor);
begin
  if C <> ToColor then
  begin
    FToColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollNotes.SetSelectedColor(const C: TColor);
begin
  if C <> SelectedColor then
  begin
    FSelectedColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollNotes.SetSelectedToColor(const C: TColor);
begin
  if C <> SelectedToColor then
  begin
    FSelectedToColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollNotes.SetLineColor(const C: TColor);
begin
  if C <> LineColor then
  begin
    FLineColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollNotes.SetFont(const F: TFont);
begin
  FFont.Assign(F);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TPianoRollNotes.SetShowCaptions(const B: Boolean);
begin
  if B <> ShowCaptions then
  begin
    FShowCaptions := B;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollNotes.SetGhostNotes(const B: Boolean);
begin
  if B <> ShowGhostNotes then
  begin
    FShowGhostNotes := B;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollNotes.SetGhostColor(const C: TColor);
begin
  if C <> GhostColor then
  begin
    FGhostColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollNotes.SetCornerRadius(const I: Integer);
begin
  if (I <> CornerRadius) and (I >= 0) then
  begin
    FCornerRadius := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

(******************************************************************************)
(*
(*  Piano Roll Position Indicator (TPianoRollPositionIndicator)
(*
(******************************************************************************)

constructor TPianoRollPositionIndicator.Create;
begin
  inherited Create;
  FHeight    := 8;
  FWidth     := 12;
  FColor     := $0067D7AE;
  FLineColor := $0067D7AE;
end;

procedure TPianoRollPositionIndicator.Assign(Source: TPersistent);
begin
  if Source is TPianoRollPositionIndicator then
  begin
    FHeight    := TPianoRollPositionIndicator(Source).Height;
    FWidth     := TPianoRollPositionIndicator(Source).Width;
    FColor     := TPianoRollPositionIndicator(Source).Color;
    FLineColor := TPianoRollPositionIndicator(Source).LineColor;
  end else
    inherited;
end;

procedure TPianoRollPositionIndicator.SetHeight(const I: Integer);
begin
  if I <> FHeight then
  begin
    FHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollPositionIndicator.SetWidth(const I: Integer);
begin
  if I <> FWidth then
  begin
    FWidth := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollPositionIndicator.SetColor(const C: TColor);
begin
  if C <> FColor then
  begin
    FColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollPositionIndicator.SetLineColor(const C: TColor);
begin
  if C <> FLineColor then
  begin
    FLineColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

(******************************************************************************)
(*
(*  Piano Roll Ruler (TPianoRollRuler)
(*
(******************************************************************************)

constructor TPianoRollRuler.Create;
begin
  inherited Create;
  FFont          := TFont.Create;
  FFont.OnChange := FOnChange;
  FFont.Color    := $00676456;
  FFont.Name     := 'Segoe UI';
  FHeight        := 32;
  FColor         := $00322A1D;
  FToColor       := $00453C2F;
  FLineColor     := $00676456;
  FShowLines     := False;
  FShowNumbers   := True;
end;

destructor TPianoRollRuler.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TPianoRollRuler.Assign(Source: TPersistent);
begin
  if Source is TPianoRollRuler then
  begin
    FFont.Assign(TPianoRollRuler(Source).Font);
    FHeight        := TPianoRollRuler(Source).Height;
    FColor         := TPianoRollRuler(Source).Color;
    FToColor       := TPianoRollRuler(Source).ToColor;
    FLineColor     := TPianoRollRuler(Source).LineColor;
    FShowLines     := TPianoRollRuler(Source).ShowLines;
    FShowNumbers   := TPianoRollRuler(Source).ShowNumbers;
  end else
    inherited;
end;

procedure TPianoRollRuler.SetHeight(const I: Integer);
begin
  if I <> FHeight then
  begin
    FHeight := I;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollRuler.SetColor(const C: TColor);
begin
  if C <> FColor then
  begin
    FColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollRuler.SetToColor(const C: TColor);
begin
  if C <> FToColor then
  begin
    FToColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollRuler.SetLineColor(const C: TColor);
begin
  if C <> FLineColor then
  begin
    FLineColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollRuler.SetFont(const F: TFont);
begin
  if F <> FFont then
  begin
    FFont.Assign(F);
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollRuler.SetShowLines(const B: Boolean);
begin
  if B <> FShowLines then
  begin
    FShowLines := B;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollRuler.SetShowNumbers(const B: Boolean);
begin
  if B <> FShowNumbers then
  begin
    FShowNumbers := B;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

(******************************************************************************)
(*
(*  Piano Roll Grid (TPianoRollGrid)
(*
(******************************************************************************)

constructor TPianoRollGrid.Create;
begin
  inherited Create;
  FColor1     := $004E4335;
  FColor2     := $00483E2D;
  FLineColor1 := $00231908;
  FLineColor2 := $0043382A;
  FFadedSides := True;
  FFadeColor  := $00231908;
end;

procedure TPianoRollGrid.Assign(Source: TPersistent);
begin
  if Source is TPianoRollGrid then
  begin
    FColor1     := TPianoRollGrid(Source).Color1;
    FColor2     := TPianoRollGrid(Source).Color2;
    FLineColor1 := TPianoRollGrid(Source).LineColor1;
    FLineColor2 := TPianoRollGrid(Source).LineColor2;
    FFadedSides := TPianoRollGrid(Source).Shadow;
    FFadeColor  := TPianoRollGrid(Source).ShadowColor;
  end else
    inherited;
end;

procedure TPianoRollGrid.SetColor1(const C: TColor);
begin
  if C <> FColor1 then
  begin
    FColor1 := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollGrid.SetColor2(const C: TColor);
begin
  if C <> FColor2 then
  begin
    FColor2 := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollGrid.SetLineColor1(const C: TColor);
begin
  if C <> FLineColor1 then
  begin
    FLineColor1 := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollGrid.SetLineColor2(const C: TColor);
begin
  if C <> FLineColor2 then
  begin
    FLineColor2 := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollGrid.SetFadedSides(const B: Boolean);
begin
  if B <> FFadedSides then
  begin
    FFadedSides := B;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollGrid.SetFadeColor(const C: TColor);
begin
  if C <> FFadeColor then
  begin
    FFadeColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

(******************************************************************************)
(*
(*  Piano Roll Loop Bar (TPianoRollLoopBar)
(*
(******************************************************************************)

constructor TPianoRollLoopBar.Create;
begin
  inherited Create;
  FStart     := 0;
  FStop      := 0;
  FColor     := $004A47CF;
  FLineColor := $004A47CF;
end;

procedure TPianoRollLoopBar.Assign(Source: TPersistent);
begin
  if Source is TPianoRollLoopBar then
  begin
    FStart     := TPianoRollLoopBar(Source).Start;
    FStop      := TPianoRollLoopBar(Source).Stop;
    FColor     := TPianoRollLoopBar(Source).Color;
    FLineColor := TPianoRollLoopBar(Source).LineColor;
  end else
    inherited;
end;

procedure TPianoRollLoopBar.SetStart(const S: Single);
begin
  if S <> FStart then
  begin
    FStart := S;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollLoopBar.SetStop(const S: Single);
begin
  if S <> FStop then
  begin
    FStop := S;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollLoopBar.SetColor(const C: TColor);
begin
  if C <> FColor then
  begin
    FColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollLoopBar.SetLineColor(const C: TColor);
begin
  if C <> FLineColor then
  begin
    FLineColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

(******************************************************************************)
(*
(*  Piano Roll Selection (TPianoRollSelection)
(*
(******************************************************************************)

constructor TPianoRollSelection.Create;
begin
  inherited Create;
  FColor     := $004A47CF;
  FLineColor := $004A47CF;
end;

procedure TPianoRollSelection.Assign(Source: TPersistent);
begin
  if Source is TPianoRollSelection then
  begin
    FColor     := TPianoRollSelection(Source).Color;
    FLineColor := TPianoRollSelection(Source).LineColor;
  end else
    inherited;
end;

procedure TPianoRollSelection.SetColor(const C: TColor);
begin
  if C <> FColor then
  begin
    FColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TPianoRollSelection.SetLineColor(const C: TColor);
begin
  if C <> FLineColor then
  begin
    FLineColor := C;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

(******************************************************************************)
(*
(*  Piano Roll (TPianoRoll)
(*
(******************************************************************************)

constructor TPianoRoll.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { If the ControlStyle property includes csOpaque, the control paints itself
    directly. We dont want the control to accept controls - but this might
    change in the future so we leave it here commented out. offcourse we
    like to get click, double click and mouse events. }
  ControlStyle := ControlStyle + [csOpaque{, csAcceptsControls},
    csCaptureMouse, csClickEvents, csDoubleClicks];

  { We want to get focus }
  TabStop := True;

  { Create persistent classes }
  FPositionIndicator := TPianoRollPositionIndicator.Create;
  FPositionIndicator.OnChange := SettingsChanged;
  FRuler := TPianoRollRuler.Create;
  FRuler.OnChange := SettingsChanged;
  FGrid := TPianoRollGrid.Create;
  FGrid.OnChange := SettingsChanged;
  FLoopBar := TPianoRollLoopBar.Create;
  FLoopBar.OnChange := SettingsChanged;
  FSelection := TPianoRollSelection.Create;
  FSelection.OnChange := SettingsChanged;
  FNotes := TPianoRollNotes.Create;
  FNotes.OnChange := SettingsChanged;

  { Notes - Items }
  FItems := TPianoRollItems.Create(Self);
  FItems.OnChange := SettingsChanged;
  FGhostItems := TPianoRollItems.Create(Self);
  FGhostItems.OnChange := SettingsChanged;
    
  { Create Buffers }
  FBuffer := TBitmap.Create;
  FBuffer.PixelFormat := pf32bit;
  FRulerBuffer := TBitmap.Create;
  FRulerBuffer.PixelFormat := pf32bit;

  { Zoomfactor }
  FZoomHorizontal := 100;
  FZoomVertical   := 100;

  { Max Rows, Cols }
  MaxRows := 64;
  MaxCols := 32;

  { Initial Repaint }
  RedrawRuler := True;

  { Default mode is select }
  FMode := prmSelect;

  { Load Cursors }
  Screen.Cursors[crPencil] := LoadCursor(HInstance, 'PENCIL');

  { Register Clipboard Format }
  CF_EPR := RegisterClipboardFormat(ClipboarFormatIdentifier);

  { Width / Height }
  Width  := 473;
  Height := 265;
end;

destructor TPianoRoll.Destroy;
begin
  { Free Buffers }
  FBuffer.Free;
  FRulerBuffer.Free;

  { Free Persistent classes }
  FPositionIndicator.Free;
  FRuler.Free;
  FGrid.Free;
  FSelection.Free;
  FItems.Free;
  FNotes.Free;
  inherited Destroy;
end;

function TPianoRoll.CanPaste : Boolean;
begin
  Result := Clipboard.HasFormat(CF_EPR);
end;

function TPianoRoll.CopySelection : Boolean;

  function ImplodeItem(const Item: TPianoRollItem) : string;
  begin
    Result := Format('%s|%d|%s|%f|%f|%d', [
      StringReplace(Item.Caption, '|', '', [rfReplaceAll]),
      Item.Col,
      ColorToString(Item.Color),
      Item.Length,
      Item.OffSet,
      Item.Row
    ]);
  end;

var
  I, C      : Integer;
  Clip      : string;
  MemHandle : HGLOBAL;
  MemPtr    : Pointer;
begin
  Clip  := 'ERDPR';
  C     := 0;
  for I := 0 to Items.Count -1 do
  if Items.Items[I].Selected then
  begin
    Inc(C);
    Clip := Clip + #9 + ImplodeItem(Items.Items[I]);
  end;
  if (C > 0) then
  begin
    MemHandle := GlobalAlloc(GMEM_MOVEABLE, (Length(Clip) + 1) * SizeOf(Char));
    MemPtr    := GlobalLock(MemHandle);
    try
      StrCopy(MemPtr, PChar(Clip));
    finally
      GlobalUnlock(MemHandle);
    end;
    Clipboard.SetAsHandle(CF_EPR, MemHandle);
  end;
  Result := (C > 0);
end;

function TPianoRoll.CutSelection : Boolean;
var
  I : Integer;
begin
  Result := CopySelection;
  if Result then
  for I := Items.Count -1 downto 0 do
  if Items.Items[I].Selected then Items.Delete(I);
end;

function TPianoRoll.Paste : Boolean;
var
  MemHandle  : THandle;
  MemPtr     : Pointer;
  PasteItems : TStringDynArray;
  ItemParts  : TStringDynArray;
  I          : Integer;
begin
  Result := Clipboard.HasFormat(CF_EPR);
  if not Result then Exit(False);
  { Read the clipboard }
  Clipboard.Open;
  try
    MemHandle  := Clipboard.GetAsHandle(CF_EPR);
    MemPtr     := GlobalLock(MemHandle);
    PasteItems := SplitString(String(PChar(MemPtr)), #9);
    GlobalUnlock(MemHandle);
  finally
    Clipboard.Close;
  end;
  { Check if its a valid format }
  if Length(PasteItems) = 0 then Exit(False);
  Result := PasteItems[0] = 'ERDPR';
  ClearNoteSelection;
  { Loop through the items and add them }
  for I := 1 to Length(PasteItems) -1 do
  begin
    ItemParts := SplitString(PasteItems[I], '|');
    with Items.Add do
    begin
      Caption  := ItemParts[0];
      Col      := StrToInt(ItemParts[1]);
      Color    := StringToColor(ItemParts[2]);
      Length   := StrToFloat(ItemParts[3]);
      OffSet   := StrToFloat(ItemParts[4]);
      Row      := StrToInt(ItemParts[5]);
      Selected := True;
    end;
  end;
end;

procedure TPianoRoll.UpdateHorizontalScrollbar(const I: Integer);
begin
  SetScrollPosX(I);
end;

procedure TPianoRoll.WMPaint(var Msg: TWMPaint);
begin
  GetUpdateRect(Handle, FUpdateRect, False);
  inherited;
end;

procedure TPianoRoll.SetZoomHorizontal(const Z: Integer);
begin
  if Z <> FZoomHorizontal then
  begin
    if (Z < 50) then
      FZoomHorizontal := 50
    else
    begin
      FZoomHorizontal := Z;
      RedrawRuler := True;
      Invalidate;
    end;
  end;
end;

procedure TPianoRoll.SetZoomVertical(const Z: Integer);
begin
  if Z <> FZoomVertical then
  begin
    if (Z < 50) then
       FZoomVertical := 50
    else
    begin
      FZoomVertical := Z;
      Invalidate;
    end;
  end;
end;

procedure TPianoRoll.SetPlayerPosition(const S: Single);
begin
  if (S >= 0) then
  begin
    FPlayerPosition := S;
    Invalidate;
  end;
end;

procedure TPianoRoll.SetMaxRows(const I: Integer);
begin
  if (I <> MaxRows) then
  begin
    RedrawRuler := True;
    FMaxRows := I;
    Invalidate;
  end;
end;

procedure TPianoRoll.SetMaxCols(const I: Integer);
begin
  if (I <> MaxCols) then
  begin
    RedrawRuler  := True;
    FMaxCols := I;
    Invalidate;
  end;
end;

procedure TPianoRoll.SetMode(const M: TPianoRollMode);
begin
  if (M <> FMode) then
  begin
    ClearNoteSelection;
    FMode := M;
    Invalidate;
  end;
end;

procedure TPianoRoll.SettingsChanged(Sender: TObject);
begin
  { Settings changed - repaint }
  RedrawRuler := True;
  Invalidate;
end;

function TPianoRoll.PxToPos(const I: Integer) : Single;
begin
  { We start at 1 second }
  Result := 1 + (I / ((SubColWidth * 4) * 4));
end;

function TPianoRoll.MouseIsOnNote(const X, Y: Integer; var Note: Integer) : Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := Items.Count -1 downto 0 do
  if PtInRect(Items.Items[I].ItemRect, Point(X, Y)) then
  begin
    Result := True;
    Note   := I;
    Break;
  end;
end;

function TPianoRoll.MouseInRow(const I: Integer) : Integer;
begin
  Result := Ceil((I - Ruler.Height) / VBlockSize);
end;

function TPianoRoll.MouseInCol(const I: Integer) : Integer;
begin
  Result := Ceil(I / SubColWidth);
end;

procedure TPianoRoll.ClearNoteSelection;
var
  I : Integer;
begin
  for I := 0 to Items.Count -1 do
  Items.Items[I].Selected := False;
end;

procedure TPianoRoll.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  { Draw Buffer to the Control }
  BitBlt(Msg.DC, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
  Msg.Result := -1;
end;

procedure TPianoRoll.SetScrollPosX(const I: Integer);
begin
  FScrollPosX := I;
  FScrollPosX := EnsureRange(FScrollPosX, 0, FScrollMaxX);
  FRedrawRuler := True;
  if FOldScrollX <> FScrollPosX then Invalidate;
  FOldScrollX := FScrollPosX;
end;

procedure TPianoRoll.SetScrollPosY(const I: Integer);
begin
  FScrollPosY := I;
  FScrollPosY := EnsureRange(FScrollPosY, 0, FScrollMaxY);
  FRedrawRuler := True;
  if FOldScrollY <> FScrollPosY then Invalidate;
  FOldScrollY := FScrollPosY;
end;

procedure TPianoRoll.SetItems(I: TPianoRollItems);
begin
  FItems.Assign(I);
  Invalidate;
end;

procedure TPianoRoll.SetGhostItems(I: TPianoRollItems);
begin
  FGhostItems.Assign(I);
  Invalidate;
end;

procedure TPianoRoll.Paint;

  procedure RepaintRuler;
  var
    FClientRect    : TGPRect;
    FGraphics      : IGPGraphics;
    FSolidBrush    : IGPSolidBrush;
    FFontBrush     : IGPSolidBrush;
    FGradientBrush : IGPLinearGradientBrush;
    FPen           : IGPPen;
    FFont          : TGPFont;
    FFontRect      : TGPRectF;
  var
    I, C, T : Integer;
  begin
    RedrawRuler := False;
    FRulerBuffer.SetSize(ClientWidth, Ruler.Height);
    FGraphics := TGPGraphics.Create(FRulerBuffer.Canvas.Handle);
    FGraphics.SmoothingMode     := SmoothingModeAntiAlias;
    FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;
    { Draw Ruler background }
    FClientRect := TGPRect.Create(0, 0, FRulerBuffer.Width, FRulerBuffer.Height);
    if Ruler.ToColor <> clNone then
    begin
      FGradientBrush := TGPLinearGradientBrush.Create(FClientRect,
        TGPColor.CreateFromColorRef(Ruler.Color),
        TGPColor.CreateFromColorRef(Ruler.ToColor), 90);
      FGraphics.FillRectangle(FGradientBrush, FClientRect);
    end else
    begin
      FSolidBrush := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(Ruler.Color));
      FGraphics.FillRectangle(FSolidBrush, FClientRect);
    end;
    { Draw ruler outline }
    FClientRect.Width  := FClientRect.Width - 1;
    FClientRect.Height := FClientRect.Height -1;
    FPen := TGPPen.Create(TGPColor.CreateFromColorRef(Ruler.LineColor));
    FPen.Alignment := PenAlignmentInset;
    FGraphics.DrawRectangle(FPen, FClientRect);
    { Draw ruler lines }
    if Ruler.ShowLines then
    begin
      T := Ceil(Ruler.Height / 2);
      for I := 0 to Ceil(ClientWidth / HBlockSize) do
      FGraphics.DrawLine(FPen, (I * HBlockSize) - FScrollPosX, T, (I * HBlockSize) - FScrollPosX, FClientRect.Bottom);
    end;
    { Draw ruler numbers }
    if Ruler.ShowNumbers then
    begin
      FFontBrush := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(Ruler.Font.Color));
      FFont      := TGPFont.Create(Ruler.Font.Name, Ruler.Font.Size, [{FontStyleBold}]);
      FFontRect  := FGraphics.MeasureString('123456789', FFont, TGPPointF.Create(0, 0));
      T := Ceil(FClientRect.Height - (FFontRect.Height +2));
      C := 0;
      for I := 0 to Ceil((MaxCols * ((SubColWidth * 4) * 4)) / (SubColWidth * 4)) do if (I mod 4) = 0 then
      begin
        Inc(C);
        FGraphics.DrawString(IntToStr(C), FFont, TGPPointF.Create(((I * (SubColWidth * 4)) - FScrollPosX) +2, T), FFontBrush);
      end;
    end;
  end;

  procedure RepaintPositionIndicator;
  var
    FGraphics      : IGPGraphics;
    FSolidBrush    : IGPSolidBrush;
    FPen           : IGPPen;
    FLineFade      : TGPColor;
    FLineFadePen   : IGPPen;
  var
    I, P : Integer;
  begin
    FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
    FGraphics.SmoothingMode     := SmoothingModeAntiAlias;
    FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;
    FSolidBrush := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(PositionIndicator.Color));
    P := Round(((PlayerPosition -1) * ((SubColWidth * 4) * 4)) - FScrollPosX);
    if (PlayerPosition > 0) then
    begin
      FPen := TGPPen.Create(TGPColor.CreateFromColorRef(PositionIndicator.LineColor));
      FPen.Alignment := PenAlignmentInset;
      FGraphics.DrawLine(FPen, P, Ruler.Height, P, ClientHeight);
      FLineFade := TGPColor.CreateFromColorRef(PositionIndicator.LineColor);
      for I := 1 to 6 do
      begin
        FLineFade.Alpha := 30 - (I *3);
        FLineFadePen := TGPPen.Create(FLineFade, I);
        FlineFadePen.LineJoin := LineJoinRound;
        FGraphics.DrawLine(FLineFadePen, (P +1) - I, Ruler.Height, (P +1) - I, ClientHeight -1);
      end;
    end;
    FGraphics.FillPolygon(FSolidBrush, [
      TGPPoint.Create(P, 1 + PositionIndicator.Height),
      TGPPoint.Create(P + Round(PositionIndicator.Width / 2), 1),
      TGPPoint.Create(P - Round(PositionIndicator.Width / 2), 1)
    ]);
  end;

  procedure RepaintLoopBar;
  var
    FGraphics      : IGPGraphics;
    FBrushColor    : TGPColor;
    FSolidBrush    : IGPSolidBrush;
    FPen           : IGPPen;
    FLoopRect      : TGPRect;
  var
    S, E : Integer;
  begin
    FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
    FGraphics.SmoothingMode     := SmoothingModeAntiAlias;
    FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;
    FBrushColor := TGPColor.CreateFromColorRef(LoopBar.Color);
    FBrushColor.Alpha := 125;
    FSolidBrush := TGPSolidBrush.Create(FBrushColor);
    FPen := TGPPen.Create(TGPColor.CreateFromColorRef(LoopBar.LineColor));
    FPen.Alignment := PenAlignmentInset;
    S := Round((LoopBar.Start -1) * (SubColWidth * 4) * 4);
    E := Round((LoopBar.Stop -1) * (SubColWidth * 4) * 4);
    FLoopRect := TGPRect.Create(S, 1, E - S, Ruler.Height -3);
    FGraphics.FillRectangle(FSolidBrush, FLoopRect);
    FGraphics.DrawRectangle(FPen, FLoopRect);
  end;

  procedure DrawGrid;
  var
    FClientRect  : TGPRect;
    FRowRect     : TGPRect;
    FGraphics    : IGPGraphics;
    FSolidBrush1 : IGPSolidBrush;
    FSolidBrush2 : IGPSolidBrush;
    FPen1        : IGPPen;
    FPen2        : IGPPen;
    FPen3        : IGPPen;
  var
    XI, YI, T, L : Integer;
  begin
    FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
    FGraphics.SmoothingMode     := SmoothingModeAntiAlias;
    FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;
    FClientRect := TGPRect.Create(0, 0, ClientWidth, ClientHeight);
    { Create brushes and pens }
    FSolidBrush1 := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(Grid.Color1));
    FSolidBrush2 := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(Grid.Color2));
    FPen1        := TGPPen.Create(TGPColor.CreateFromColorRef(Grid.LineColor1));
    FPen2        := TGPPen.Create(TGPColor.CreateFromColorRef(Grid.LineColor2));
    FPen3        := TGPPen.Create(TGPColor.CreateFromColorRef(Grid.LineColor1), 2);

    { Draw Horizontal Rows }
    YI := 0;
    repeat
      T := (Ruler.Height - FScrollPosY) + (YI * VBlockSize);
      FRowRect := TGPRect.Create(0, T, FClientRect.Width, VBlockSize);
      if Odd(YI) then
        FGraphics.FillRectangle(FSolidBrush2, FRowRect)
      else
        FGraphics.FillRectangle(FSolidBrush1, FRowRect);
      Inc(YI);
    until (T >= ClientRect.Bottom);

    { Draw Grid Horizontal }
    YI := 0;
    repeat
      T := (Ruler.Height - FScrollPosY) + (YI * VBlockSize);
      if (YI mod 4) = 0 then
        FGraphics.DrawLine(FPen1, 0, T, ClientWidth, T)
      else
        FGraphics.DrawLine(FPen2, 0, T, ClientWidth, T);
      Inc(YI);
    until (T >= ClientRect.Bottom);

    { Draw Grid Vertical }
    XI := 0;
    repeat
      L := (XI * SubColWidth) - FScrollPosX;
      if (XI mod 16) = 0 then
        FGraphics.DrawLine(FPen3, L, Ruler.Height, L, ClientHeight)
      else
      if (XI mod 4) = 0 then
        FGraphics.DrawLine(FPen1, L, Ruler.Height, L, ClientHeight)
      else
        FGraphics.DrawLine(FPen2, L, Ruler.Height, L, ClientHeight);
      Inc(XI);
    until (L >= ClientRect.Right);
  end;

  function RoundRect(Rect: TGPRectF; Corner: Integer) : IGPGraphicsPath;
  var
    RoundRectPath : IGPGraphicsPath;
    I             : Integer;
  begin
    RoundRectPath := TGPGraphicsPath.Create;
    if Corner <> 0 then I := Corner else I := 10;
    RoundRectPath.AddArc(Rect.Left, Rect.Top, I, I, 180, 90);
    RoundRectPath.AddArc(Rect.Right - I, Rect.Top, I, I, 270, 90);
    RoundRectPath.AddArc(Rect.Right - I, Rect.Bottom - I, I, I, 0, 90);
    RoundRectPath.AddArc(Rect.Left, Rect.Bottom - I, I, I, 90, 90);
    RoundRectPath.CloseFigure;
    Result := RoundRectPath;
  end;

  procedure DrawGhostItems;
  var
    FGraphics  : IGPGraphics;
    FPen       : IGPPen;

    procedure DrawNote(const Brush: IGPBrush; const Rect: TGPRectF);
    var
      Path : IGPGraphicsPath;
    begin
      if Notes.CornerRadius > 0 then
      begin
        Path := RoundRect(Rect, Notes.CornerRadius);
        FGraphics.FillPath(Brush, Path);
        FGraphics.DrawPath(FPen, Path);
      end else
      begin
        FGraphics.FillRectangle(Brush, Rect);
        FGraphics.DrawRectangle(FPen, Rect);
      end;
    end;

  var
    FSolidBrush1    : IGPSolidBrush;
    FNoteRect       : TGPRectF;
    FGhostColor     : TGPColor;
    FGhostLineColor : TGPColor;
  var
    I : Integer;
    B : Integer;
  begin
    FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
    FGraphics.SmoothingMode     := SmoothingModeAntiAlias;
    FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;
    { Grid is subdivided in 4 parts - 4X4 }
    B := SubColWidth;
    { Create solid brushes and pen }
    FGhostColor  := TGPColor.CreateFromColorRef(Notes.GhostColor);
    FGhostColor.Alpha := 155;
    FSolidBrush1 := TGPSolidBrush.Create(FGhostColor);
    FGhostLineColor := TGPColor.CreateFromColorRef(Notes.LineColor);
    FGhostLineColor.Alpha := 155;
    FPen := TGPPen.Create(FGhostLineColor);
    { Create Note Rect }
    FNoteRect := TGPRectF.Create(0, Ruler.Height, ClientWidth, VBlockSize);
    { Draw Notes }
    for I := 0 to GhostItems.Count -1 do
    begin
      { Calculate the Note Rect }
      FNoteRect := TGPRectF.Create(
        (((GhostItems.Items[I].Col -1) * B) + (GhostItems.Items[I].OffSet * B)) - FScrollPosX,
         (Ruler.Height - FScrollPosY) + ((GhostItems.Items[I].Row -1) * VBlockSize),
         (GhostItems.Items[I].Length * B),
         VBlockSize
        );
      GhostItems.Items[I].ItemRect := Rect(
        Round(FNoteRect.Left), Round(FNoteRect.Top), Round(FNoteRect.Right), Round(FNoteRect.Bottom)
      );
      { If the note is visible we want to draw it }
      if (GhostItems.Items[I].ItemRect.Bottom > (ClientRect.Top + Ruler.Height)) and (GhostItems.Items[I].ItemRect.Top < ClientRect.Bottom) then
        DrawNote(FSolidBrush1, FNoteRect);
    end;
  end;

  procedure DrawFadedSides;
  var
    FGraphics    : IGPGraphics;
    FLineFade    : TGPColor;
    FLineFadePen : IGPPen;
    I, R         : Integer;
  begin
    if Grid.Shadow then
    begin
      FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
      FGraphics.SmoothingMode     := SmoothingModeAntiAlias;
      FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;
      FLineFade := TGPColor.CreateFromColorRef(Grid.ShadowColor);
      { Draw fade from the left }
      R := ClientRect.Left - 4;
      for I := 0 to 10 do
      begin
        FLineFade.Alpha := 30 - I;
        FLineFadePen := TGPPen.Create(FLineFade, I);
        FlineFadePen.LineJoin := LineJoinRound;
        FGraphics.DrawLine(FLineFadePen, R + I, Ruler.Height, R + I, ClientHeight);
      end;

      { Draw fade from the right }
      R := ClientRect.Right +4;
      for I := 0 to 10 do
      begin
        FLineFade.Alpha := 30 - I;
        FLineFadePen := TGPPen.Create(FLineFade, I);
        FlineFadePen.LineJoin := LineJoinRound;
        FGraphics.DrawLine(FLineFadePen, R -I, Ruler.Height, R -I, ClientHeight);
      end;
    end;
  end;

  procedure DrawItems;
  var
    FGraphics  : IGPGraphics;
    FPen       : IGPPen;
    FFontBrush : IGPSolidBrush;
    FFont      : TGPFont;

    procedure DrawNote(const Brush: IGPBrush; const Caption: string; const Rect: TGPRectF);
    var
      Path : IGPGraphicsPath;
    begin
      if Notes.CornerRadius > 0 then
      begin
        Path := RoundRect(Rect, Notes.CornerRadius);
        FGraphics.FillPath(Brush, Path);
        FGraphics.DrawPath(FPen, Path);
      end else
      begin
        FGraphics.FillRectangle(Brush, Rect);
        FGraphics.DrawRectangle(FPen, Rect);
      end;
      if (Caption <> '') and Notes.ShowCaptions then
        FGraphics.DrawString(Caption, FFont, Rect, nil, FFontBrush);
    end;

  var
    FSolidBrush1    : IGPSolidBrush;
    FSolidBrush2    : IGPSolidBrush;
    FSolidBrush3    : IGPSolidBrush;
    FGradBrush1     : IGPLinearGradientBrush;
    FGradBrush2     : IGPLinearGradientBrush;
    FNoteRect       : TGPRectF;
  var
    I : Integer;
    B : Integer;
  begin
    FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
    FGraphics.SmoothingMode     := SmoothingModeAntiAlias;
    FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;
    { Grid is subdivided in 4 parts - 4X4 }
    B := SubColWidth;

    { Create Gradient Brushes }
    FNoteRect   := TGPRectF.Create(0, Ruler.Height - FScrollPosY, ClientWidth, VBlockSize);
    FGradBrush1 := TGPLinearGradientBrush.Create(FNoteRect,
        TGPColor.CreateFromColorRef(Notes.Color),
        TGPColor.CreateFromColorRef(Notes.ToColor), 90);
    FGradBrush2 := TGPLinearGradientBrush.Create(FNoteRect,
        TGPColor.CreateFromColorRef(Notes.SelectedColor),
        TGPColor.CreateFromColorRef(Notes.SelectedToColor), 90);
    { Create solid brushes and pen }
    FSolidBrush1 := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(Notes.Color));
    FSolidBrush2 := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(Notes.SelectedColor));
    FPen         := TGPPen.Create(TGPColor.CreateFromColorRef(Notes.LineColor));
    { Create font }
    FFontBrush := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(Notes.Font.Color));
    FFont      := TGPFont.Create(Notes.Font.Name, Notes.Font.Size, [{FontStyleBold}]);
    { Draw Notes }
    for I := 0 to Items.Count -1 do
    begin
      { Calculate the Note Rect }
      FNoteRect := TGPRectF.Create(
        (((Items.Items[I].Col -1) * B) + (Items.Items[I].OffSet * B)) - FScrollPosX,
         (Ruler.Height - FScrollPosY) + ((Items.Items[I].Row -1) * VBlockSize),
         (Items.Items[I].Length * B),
         VBlockSize
        );
      Items.Items[I].ItemRect := Rect(
        Round(FNoteRect.Left), Round(FNoteRect.Top), Round(FNoteRect.Right), Round(FNoteRect.Bottom)
      );
      { If the note is visible we want to draw it }
      if (Items.Items[I].ItemRect.Bottom > (ClientRect.Top + Ruler.Height)) and (Items.Items[I].ItemRect.Top < ClientRect.Bottom) then
      begin
        { Check if the note is selected }
        if Items.Items[I].Selected then
        begin
          if Notes.SelectedToColor <> clNone then
            DrawNote(FGradBrush2, Items.Items[I].Caption, FNoteRect)
          else
            DrawNote(FSolidBrush2, Items.Items[I].Caption, FNoteRect);
        end else
        { Custom color? }
        if (Items.Items[I].Color <> clNone) then
        begin
          FSolidBrush3 := TGPSolidBrush.Create(TGPColor.CreateFromColorRef(Items.Items[I].Color));
          DrawNote(FSolidBrush3, Items.Items[I].Caption, FNoteRect);
        end else
        { Draw normal }
        begin
          if Notes.ToColor <> clNone then
            DrawNote(FGradBrush1, Items.Items[I].Caption, FNoteRect)
          else
            DrawNote(FSolidBrush1, Items.Items[I].Caption, FNoteRect)
        end;
      end;
    end;
  end;

  procedure DrawSelectionFrame;
  var
    FGraphics   : IGPGraphics;
    FSolidBrush : IGPSolidBrush;
    FPen        : IGPPen;
    FBrushColor : TGPColor;
    FSelectRect : TGPRect;
  begin
    FGraphics := TGPGraphics.Create(FBuffer.Canvas.Handle);
    FGraphics.SmoothingMode     := SmoothingModeAntiAlias;
    FGraphics.InterpolationMode := InterpolationModeHighQualityBicubic;
    FBrushColor := TGPColor.CreateFromColorRef(Selection.Color);
    FBrushColor.Alpha := 100;
    FSolidBrush := TGPSolidBrush.Create(FBrushColor);
    FPen        := TGPPen.Create(TGPColor.CreateFromColorRef(Selection.LineColor));
    if FSelectTo.Y < FSelectFrom.Y then
    begin
      if FSelectTo.X < FSelectFrom.X then
        FSelectRect := TGPRect.Create(FSelectTo.X, FSelectTo.Y, FSelectFrom.X - FSelectTo.X, FSelectFrom.Y - FSelectTo.Y)
      else
        FSelectRect := TGPRect.Create(FSelectFrom.X, FSelectTo.Y, FSelectTo.X - FSelectFrom.X, FSelectFrom.Y - FSelectTo.Y);
    end else
    begin
      if FSelectTo.X < FSelectFrom.X then
        FSelectRect := TGPRect.Create(FSelectTo.X, FSelectFrom.Y, FSelectFrom.X - FSelectTo.X, FSelectTo.Y - FSelectFrom.Y)
      else
        FSelectRect := TGPRect.Create(FSelectFrom.X, FSelectFrom.Y, FSelectTo.X - FSelectFrom.X, FSelectTo.Y - FSelectFrom.Y);
    end;
    FGraphics.FillRectangle(FSolidBrush, FSelectRect);
    FGraphics.DrawRectangle(FPen, FSelectRect);
  end;

var
  X, Y, W, H : Integer;
  SI         : TScrollInfo;
begin
  { Horizontal block size - calculate it here so we can use it for drawing the
    rulerbar, but also for drawing the grid and the tones }
  HBlockSize := (ZoomHorizontal * (BlockWidth100 / 100));
  { Vertical block size - height of the bars }
  VBlockSize := Round(ZoomVertical * (BlockHeight100 / 100));
  { Calculate width (4x4 grid) }
  SubColWidth  := Ceil(HBlockSize / 4);

  { Set Max Scrollbar }
  FScrollMaxX := ((SubColWidth * 4) * 4) * MaxCols;
  FScrollMaxY := (VBlockSize * 4) * MaxRows;

  { Set Buffer size }
  FBuffer.SetSize(ClientWidth, ClientHeight);

  { Ruler }
  if RedrawRuler then RepaintRuler;

  { Draw everything to the buffer }
  DrawGrid;
  { During designtime there is no need for the Ghost Notes to be drawn }
  if (not (csDesigning in ComponentState)) and Notes.ShowGhostNotes then DrawGhostItems;
  { Draw faded sides on the grid - we want the ghost items under this "shadow" }
  DrawFadedSides;
  { During designtime there is no need for the items to be drawn }
  if not (csDesigning in ComponentState) then DrawItems;
  { Draw the ruler to the buffer }
  BitBlt(FBuffer.Canvas.Handle, ClientRect.Left, ClientRect.Top, ClientWidth, Ruler.Height,
    FRulerBuffer.Canvas.Handle, 0,  0, SRCCOPY);
  { During designtime there is no need for the loopbar }
  if not (csDesigning in ComponentState) then RepaintLoopBar;
  { During designtime there is no need for the Position Indicator }
  if not (csDesigning in ComponentState) then RepaintPositionIndicator;
  { Do we want a selectionframe? }
  if FIsSelecting and (Mode = prmSelect) then DrawSelectionFrame;
  
  { Now draw the Buffer to the components surface }
  X := UpdateRect.Left;
  Y := UpdateRect.Top;
  W := UpdateRect.Right - UpdateRect.Left;
  H := UpdateRect.Bottom - UpdateRect.Top;
  if (W <> 0) and (H <> 0) then
    { Only update part - invalidated }
    BitBlt(Canvas.Handle, X, Y, W, H, FBuffer.Canvas.Handle, X,  Y, SRCCOPY)
  else
    { Repaint the whole buffer to the surface }
    BitBlt(Canvas.Handle, 0, 0, ClientWidth, ClientHeight, FBuffer.Canvas.Handle, X,  Y, SRCCOPY);

  { Vertical Scrollbar }
  SI.cbSize := Sizeof(SI);
  SI.fMask  := SIF_ALL;
  SI.nMin   := 0;
  SI.nMax   := FScrollMaxY;
  SI.nPage  := 100;
  SI.nPos   := FScrollPosY;
  SI.nTrackPos := SI.nPos;
  SetScrollInfo(Handle, SB_VERT, SI, True);

  { Horizontal Scrollbar }
  SI.cbSize := Sizeof(SI);
  SI.fMask  := SIF_ALL;
  SI.nMin   := 0;
  SI.nMax   := FScrollMaxX;
  SI.nPage  := 100;
  SI.nPos   := FScrollPosX;
  SI.nTrackPos := SI.nPos;
  SetScrollInfo(Handle, SB_HORZ, SI, True);
end;

procedure TPianoRoll.Resize;
begin
  RedrawRuler := True;
end;

procedure TPianoRoll.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style or WS_HSCROLL or WS_VSCROLL and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TPianoRoll.WndProc(var Message: TMessage);
var
  SI : TScrollInfo;
begin
  inherited;
  case Message.Msg of
    // Capture Keystrokes
    WM_GETDLGCODE:
      Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTALLKEYS;

    // Horizontal Scrollbar
    WM_HSCROLL:
      begin
        case Message.WParamLo of
          SB_LEFT      : SetScrollPosX(0);
          SB_RIGHT     : SetScrollPosX(FScrollMaxX);
          SB_LINELEFT  : SetScrollPosX(FScrollPosX - 10);
          SB_LINERIGHT : SetScrollPosX(FScrollPosX + 10);
          SB_PAGELEFT  : SetScrollPosX(FScrollPosX - ClientWidth);
          SB_PAGERIGHT : SetScrollPosX(FScrollPosX + ClientWidth);
          SB_THUMBTRACK:
            begin
              ZeroMemory(@SI, SizeOf(SI));
              SI.cbSize := Sizeof(SI);
              SI.fMask := SIF_TRACKPOS;
              if GetScrollInfo(Handle, SB_HORZ, SI) then
                SetScrollPosX(SI.nTrackPos);
            end;
        end;
        Message.Result := 0;
      end;

    // Vertical Scrollbar
    WM_VSCROLL:
      begin
        case Message.WParamLo of
          SB_TOP      : SetScrollPosY(0);
          SB_BOTTOM   : SetScrollPosY(FScrollMaxY);
          SB_LINEUP   : SetScrollPosY(FScrollPosY - 10);
          SB_LINEDOWN : SetScrollPosY(FScrollPosY + 10);
          SB_PAGEUP   : SetScrollPosY(FScrollPosY - ClientHeight);
          SB_PAGEDOWN : SetScrollPosY(FScrollPosY + ClientHeight);
          SB_THUMBTRACK:
            begin
              ZeroMemory(@SI, SizeOf(SI));
              SI.cbSize := Sizeof(SI);
              SI.fMask := SIF_TRACKPOS;
              if GetScrollInfo(Handle, SB_VERT, SI) then
                SetScrollPosY(SI.nTrackPos);
            end;
        end;
        Message.Result := 0;
      end;

    { Enabled/Disabled - Redraw }
    CM_ENABLEDCHANGED:
      begin
        ClearNoteSelection;
        Invalidate;
      end;

    { Focus is lost }
    WM_KILLFOCUS:
      begin
        { Maybe gray out the nodes and selected nodes }
      end;

    WM_SETFOCUS:
      begin
        { Focus returned so redraw - if we use graying out of nodes }
      end;
    
  end;
end;

function TPianoRoll.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  { During designtime there is no need for these events }
  if (csDesigning in ComponentState) then Exit;
  { Ignore when the component is disabled }
  if not Enabled then Exit;
  if (ssCtrl in Shift) then ZoomHorizontal := ZoomHorizontal + (WheelDelta div 10)
  else
  begin
    if (ssShift in Shift) then
      SetScrollPosX(FScrollPosX - (WheelDelta div 10))
    else
      SetScrollPosY(FScrollPosY - (WheelDelta div 10));
  end;
  Result := True;
  inherited;
end;

procedure TPianoRoll.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  function MouseResize(X: Integer; R: TRect) : Boolean;
  begin
    Result := (X >= R.Right - 5) and (X <= R.Right);
  end;

var
  N, I : Integer;
  S, C : Integer;
  P    : TPoint;
begin
  if not Enabled then Exit;
  if (not Focused) and CanFocus then SetFocus;
  if Button = mbLeft then
  begin
    { Are we over the ruler - then we want to set the loop }
    if PtInRect(Rect(ClientRect.Left, ClientRect.Top, ClientRect.Right, Ruler.Height), Point(X, Y))  then
    begin
      FIsLoopSelecting := True;
      LoopBar.Stop  := PxToPos(X);
      LoopBar.Start := PxToPos(X);
    end else
    { Check if we are selecting a note }
    if MouseIsOnNote(X, Y, N) then
    begin
      { Mode: Select }
      if (Mode = prmSelect) then
      begin
        { Resize note? }
        if Items.Items[N].Selected and MouseResize(X, Items.Items[N].ItemRect) then
        begin
          FIsResizing := True;
          FSelectFrom := Point(X, Y);
          Cursor := crSizeWE;
        end else
        { Make a copy of the notes? }
        if Items.Items[N].Selected and (ssCtrl in Shift) then
        begin
          S := -1;
          C := 0;
          for I := 0 to Items.Count -1 do
          if Items.Items[I].Selected then
          begin
            with Items.Add do
            begin
              if (S = -1) then S := Index;
              Col     := Items.Items[I].Col;
              Row     := Items.Items[I].Row;
              Length  := Items.Items[I].Length;
              Offset  := Items.Items[I].Offset;
              Caption := Items.Items[I].Caption;
              Color   := Items.Items[I].Color;
            end;
            Inc(C);
          end;
          if (C > 0) then
          begin
            ClearNoteSelection;
            for I := S to (S + C) -1 do Items.Items[I].Selected := True;
            FIsDragging := True;
            FSelectFrom := Point(X, Y);
          end;
        end else
        { Start dragging action ? }
        if Items.Items[N].Selected then
        begin
          FIsDragging := True;
          FSelectFrom := Point(X, Y);
        end;
      end;
      { Mode: Delete }
      if (Mode = prmErase) then Items.Delete(N);
    end else
    { If no note is selected then we want to show a selection frame }
    if (Mode = prmSelect) and PtInRect(Rect(ClientRect.Left, Ruler.Height, ClientRect.Right, ClientRect.Bottom), Point(X, Y)) then
    begin
      FSelectFrom  := Point(X, Y);
      FSelectTo    := Point(X, Y);
      FIsSelecting := True;
      if (not (ssShift in Shift)) or (not (ssCtrl in Shift)) then ClearNoteSelection;
    end else
    { Mode: Insert }
    if (Mode = prmInsert) and (Button = mbLeft) then
    begin
      // Check position and insert new note
      with Items.Add do
      begin
        Col := MouseInCol(X);
        Row := MouseInRow(Y);
        Length := Notes.InsertLength;
      end;
    end else
    { Mode: Erase }
    if (Mode = prmErase) then FIsErasing := True;
  end else
  { Right click on insert mode deletes note }
  if (MouseIsOnNote(X, Y, N) and ((Mode = prmInsert) or (Mode = prmErase)) and (Button = mbRight)) then
  begin
    Items.Delete(N);
    FIsErasing := True;
  end else
  if PtInRect(Rect(ClientRect.Left, ClientRect.Top, ClientRect.Right, Ruler.Height), Point(X, Y)) and (Button = mbRight) then
  begin
    { Loopbar Popup ? }
    if ((PxToPos(X) >= LoopBar.Start) and (PxToPos(X) <= LoopBar.Stop)) or ((LoopBar.Stop - LoopBar.Start) = 0) and Assigned(LoopBar.PopupMenu) then
    begin
      P := ClientToScreen(Point(X, Y));
      LoopBar.PopupMenu.Popup(P.X, P.Y);
    end else
    { Clear loopbar selection }
    begin
      FIsLoopSelecting := False;
      LoopBar.Start := 0;
      LoopBar.Stop  := 0;
    end;
  end else
  { Popup? }
  if (Mode = prmSelect) and (Button = mbRight) and Assigned(PopupMenu) then
  begin
    P := ClientToScreen(Point(X, Y));
    PopupMenu.Popup(P.X, P.Y);
  end;
  inherited;
end;

procedure TPianoRoll.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  N : Integer;
begin
  {}
  if not Enabled then Exit;
  { Stop erasing }
  if FIsErasing then
  begin
    FIsErasing := False;
  end else
  { Stop resizing }
  if FIsResizing then
  begin
    FIsResizing := False;
    Cursor := crDefault;
  end else
  { Stop dragging }
  if FIsDragging then
  begin
    FIsDragging := False;
    Cursor := crDefault
  end else
  { Stop the loop selection }
  if FIsLoopSelecting then
  begin
    if ((LoopBar.Stop - Loopbar.Start) < 0.0625) then
    begin
      LoopBar.Start := 0;
      LoopBar.Stop  := 0;
    end;
    FIsLoopSelecting := False;
    Invalidate;
  end else
  { Stop the selection rectangle }
  if FIsSelecting then
  begin
    FIsSelecting := False;
    Invalidate;
  end else
  { Check if we are over a note }
  if MouseIsOnNote(X, Y, N) then
  begin
    { Mode: Select }
    if (Mode = prmSelect) then
    begin
      if (not (ssShift in Shift)) and (not (ssCtrl in Shift)) then ClearNoteSelection;
      Items.Items[N].Selected := not Items.Items[N].Selected;
    end;
  end;
  inherited;
end;

procedure TPianoRoll.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);

  {
    ** Check if the Selection Rectangle collides with the given Note Rect **
    Found on Torry.net: https://www.swissdelphicenter.ch/en/showcode.php?id=1791 

  }
  function CheckBoundryCollision( R1, R2 : TRect; pR : PRect = nil; OffSetY : LongInt = 0; OffSetX : LongInt = 0) : Boolean;
  begin
     // Rectangle R1 can be the rectangle of the character (player)
     // Rectangle R2 can be the rectangle of the enemy
    if( pR <> nil ) then
     begin
      // Simple collision test based on rectangles. We use here the
      // API function IntersectRect() which returns the intersection rectangle.
      with (R1) do
       R1 := Rect(Left+OffSetX, Top+OffSetY, Right-(OffSetX * 2), Bottom-(OffSetY * 2));
      with (R2) do
       R2 := Rect(Left+OffSetX, Top+OffSetY, Right-(OffSetX * 2), Bottom-(OffSetY * 2));

      Result:=IntersectRect( pR^, R1, R2 );
     end
    else begin
          // Simple collision test based on rectangles. We can also use the
          // API function IntersectRect() but i believe this is much faster.
          Result := (NOT ((R1.Bottom - (OffSetY * 2) < R2.Top + OffSetY)
            or(R1.Top + OffSetY > R2.Bottom - (OffSetY * 2))
             or( R1.Right - (OffSetX * 2) < R2.Left + OffSetX)
              or( R1.Left + OffSetX > R2.Right - (OffSetX * 2))));
         end;
  end;

  function MouseResize(X: Integer; R: TRect) : Boolean;
  begin
    Result := (X >= R.Right - 5) and (X <= R.Right);
  end;

var
  I  : Integer;
  R  : TRect;
  DR : Integer;
  DC : Integer;
  S  : Single;
  N  : Integer;
begin
  { Set Cursor? }
  if (not FIsResizing) and (not FIsDragging) and (not FIsLoopSelecting) and (not FIsSelecting) then
  begin
    if MouseIsOnNote(X, Y, N) then
    begin
      { Mode: Select }
      if (Mode = prmSelect) then
      begin
        { Resize note? }
        if Items.Items[N].Selected and MouseResize(X, Items.Items[N].ItemRect) then
        begin
          if (Cursor <> crSizeWE) then Cursor := crSizeWE;
        end else
        { Start dragging action ? }
        if Items.Items[N].Selected then
        begin
          if (Cursor <> crSizeAll) then Cursor := crSizeAll;
        end;
      end;
    end else
    if (Cursor <> crDefault) then Cursor := crDefault;
  end else
  { Are we resizing notes? }
  if (Mode = prmSelect) and FIsResizing then
  begin
    S := ((X - FSelectFrom.X) / (SubColWidth * 4) * 4);
    FSelectFrom := Point(X, Y);
    for I := 0 to Items.Count -1 do
    if Items.Items[I].Selected then
    begin
      Items.Items[I].Length := Items.Items[I].Length + S;
    end;
  end else
  { Are we dragging notes? }
  if (Mode = prmSelect) and FIsDragging then
  begin
    DR := MouseInRow(Y) - MouseInRow(FSelectFrom.Y);
    DC := MouseInCol(X) - MouseInCol(FSelectFrom.X);
    FSelectFrom := Point(X, Y);
    for I := 0 to Items.Count -1 do
    if Items.Items[I].Selected then
    begin
      Items.Items[I].Row := Items.Items[I].Row + DR;
      Items.Items[I].Col := Items.Items[I].Col + DC;
    end;
  end else
  { Are we selecting the loop? }
  if FIsLoopSelecting then
  begin
    LoopBar.Stop := PxToPos(X);
  end else
  { Are we selecting notes with a selection rectangle }
  if (Mode = prmSelect) and FIsSelecting then
  begin
    FSelectTo := Point(X, Y);
    { Calculate the selection rect }
    if FSelectFrom.X > FSelectTo.X then
    begin
      if FSelectTo.Y > FSelectFrom.Y then
        R := Rect(FSelectTo.X, FSelectFrom.Y, FSelectFrom.X, FSelectTo.Y)
      else
        R := Rect(FSelectTo.X, FSelectTo.Y, FSelectFrom.X, FSelectFrom.Y);
    end else
    begin
      if FSelectTo.Y < FSelectFrom.Y then
        R := Rect(FSelectFrom.X, FSelectTo.Y, FSelectTo.X, FSelectFrom.Y)
      else
        R := Rect(FSelectFrom.X, FSelectFrom.Y, FSelectTo.X, FSelectTo.Y);
    end;
    { Check if the note collides / intersects with the selection rect }
    for I := 0 to Items.Count -1 do
    begin
      Items.Items[I].Selected := CheckBoundryCollision(Items.Items[I].ItemRect, R);
    end;
    Invalidate;
  end;
  { Are we erasing notes? }
  if ((Mode = prmErase) or (Mode = prmInsert)) and FIsErasing then
  begin
    if MouseIsOnNote(X, Y, N) then Items.Delete(N);
  end;
  inherited;
end;

procedure TPianoRoll.KeyDown(var Key: Word; Shift: TShiftState);
var
  I : Integer;
begin
  { Mode: Select - Delete note(s) }
  if (Mode = prmSelect) and (Key = VK_DELETE) then
  begin
    for I := Items.Count -1 downto 0 do
    if Items.Items[I].Selected then
    Items.Delete(I);
  end else
  { Mode: Select - Move note(s) }
  if (Mode = prmSelect) and (not (ssCtrl in Shift)) and (not (ssShift in Shift)) and 
    ((Key = VK_LEFT) or (Key = VK_UP) or (Key = VK_RIGHT) or (Key = VK_DOWN)) then
  begin
    case Key of
      VK_LEFT  : for I := Items.Count -1 downto 0 do if Items.Items[I].Selected then Items.Items[I].Col := Items.Items[I].Col -1;
      VK_UP    : for I := Items.Count -1 downto 0 do if Items.Items[I].Selected then Items.Items[I].Row := Items.Items[I].Row -1;
      VK_RIGHT : for I := Items.Count -1 downto 0 do if Items.Items[I].Selected then Items.Items[I].Col := Items.Items[I].Col +1;
      VK_DOWN  : for I := Items.Count -1 downto 0 do if Items.Items[I].Selected then Items.Items[I].Row := Items.Items[I].Row +1;
    end;
  end else
  { Mode: Select - Offset note(s) }
  if (Mode = prmSelect) and (ssCtrl in Shift) and (not (ssShift in Shift)) and ((Key = VK_LEFT) or (Key = VK_RIGHT)) then
  begin
    case Key of
      VK_LEFT  : for I := Items.Count -1 downto 0 do if Items.Items[I].Selected then Items.Items[I].OffSet := Items.Items[I].OffSet -Notes.OffsetStep;
      VK_RIGHT : for I := Items.Count -1 downto 0 do if Items.Items[I].Selected then Items.Items[I].OffSet := Items.Items[I].OffSet +Notes.OffsetStep;
    end;
  end else
  { Mode: Select - Resize note(s) }
  if (Mode = prmSelect) and (not (ssCtrl in Shift)) and (ssShift in Shift) and ((Key = VK_LEFT) or (Key = VK_RIGHT)) then
  begin
    case Key of
      VK_LEFT  : for I := Items.Count -1 downto 0 do if Items.Items[I].Selected then Items.Items[I].Length := Items.Items[I].Length -1;
      VK_RIGHT : for I := Items.Count -1 downto 0 do if Items.Items[I].Selected then Items.Items[I].Length := Items.Items[I].Length +1;
    end;
  end else
  { Mode: Select - Ctrl + A }
  if (Mode = prmSelect) and (ssCtrl in Shift) and (not (ssShift in Shift)) and (UpCase(Char(Key)) = 'A') then
  begin
    for I := 0 to Items.Count -1 do
    Items.Items[I].Selected := True;
  end else
  { Mode: Select - Ctrl + C }
  if (Mode = prmSelect) and (ssCtrl in Shift) and (not (ssShift in Shift)) and (UpCase(Char(Key)) = 'C') then
  begin
    CopySelection;
  end else
  { Mode: Select - Ctrl + X }
  if (Mode = prmSelect) and (ssCtrl in Shift) and (not (ssShift in Shift)) and (UpCase(Char(Key)) = 'X') then
  begin
    CutSelection;
  end else
  { Mode: Select - Ctrl + V }
  if (Mode = prmSelect) and (ssCtrl in Shift) and (not (ssShift in Shift)) and (UpCase(Char(Key)) = 'V') then
  begin
    if CanPaste then Paste;
  end;
  inherited;
end;

procedure TPianoRoll.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

(******************************************************************************)
(*
(*  Register Piano Roll Components (TPianoRoll, TPianoRollVelocity)
(*
(*  note: Move this part to a serpate register unit!
(*
(******************************************************************************)

procedure Register;
begin
  RegisterComponents('ERDesigns MIDI', [TPianoRoll]);
end;

end.
