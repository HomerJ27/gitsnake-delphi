unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, game, ExtCtrls;

type
  TForm1 = class(TForm)
    tmr: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure tmrTimer(Sender: TObject);
    procedure NewGame;
    procedure MoveSnake;
    procedure Game;
    procedure GameOver;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  SnakeLen, Count : Integer;
  AHead: THead;
  AApple: TApple;
  ATails: array [1..100] of TTail;
  dir : string;
  HeadPic, ApplePic, TailPic: TBitmap;
implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.tmrTimer(Sender: TObject);
begin
  MoveSnake;
  Game;
  Caption := 'Your Score: '+IntToStr(SnakeLen)+'.';
  Refresh;
end;

procedure TForm1.NewGame;
begin
  SnakeLen := 2;

  ApplePic := TBitmap.Create;
  ApplePic.LoadFromFile('red.bmp');
  ApplePic.Transparent := True;
  HeadPic := TBitmap.Create;
  HeadPic.LoadFromFile('yellow.bmp');
  TailPic := TBitmap.Create;
  TailPic.LoadFromFile('green.bmp');

  Width := 24 * (Count+1);
  Height := Width;

  Randomize;
  AApple := TApple.Create(random(Count)*24,random(Count)*24,ApplePic);
  AHead := THead.Create(random(Count)*24,random(Count)*24,HeadPic);
  ATails[1] := TTail.Create(AHead.getX,AHead.getY-24,TailPic);
  ATails[2] := TTail.Create(AHead.getX,AHead.getY-48,TailPic);

  dir := 'Down';
  Tmr.Enabled := True;
  Tmr.Interval := 300;
end;

procedure TForm1.MoveSnake;
var i : Integer;
begin
  for i := SnakeLen downto 2 do
    begin
      ATails[i].setX(ATails[i-1].getX);
      ATails[i].setY(ATails[i-1].getY);
    end;

  ATails[1].setX(AHead.getX);
  ATails[1].setY(AHead.getY);

  If dir = 'Down' Then AHead.setY(AHead.getY + 24);
  If dir = 'Up' Then AHead.setY(AHead.getY - 24);
  If dir = 'Left' Then AHead.setX(AHead.getX - 24);
  If dir = 'Right' Then AHead.setX(AHead.getX + 24);
end;

procedure TForm1.Game;
var i : Integer;
begin
  if (AHead.getX = AApple.getX) and (AHead.getY = AApple.getY) Then
     begin
       Randomize;
       AApple.setX(random(Count)*24);
       AApple.setY(random(Count)*24);
       SnakeLen := SnakeLen + 1;
       ATails[SnakeLen] := TTail.Create(ATails[SnakeLen-1].getX,ATails[SnakeLen-1].getY,TailPic);
       if Tmr.Interval > 55 Then Tmr.Interval := Tmr.Interval - 5;
     end;
  for i := 1 to SnakeLen do
     if (AHead.getX = ATails[i].getX) and (AHead.getY = ATails[i].getY) Then
        GameOver;
  if AHead.getX < 0 Then GameOver;
  if AHead.getX > (Count+1) * 24 Then GameOver;
  if AHead.getY < 0 Then GameOver;
  if AHead.getY > (Count+1) * 24 Then GameOver;
end;

procedure TForm1.GameOver;
var i : Integer;
begin
  Tmr.Enabled := False;
  ShowMessage('LOOOOOOOOSSSEEEER!!!');
  for i := 1 to SnakeLen do
    ATails[i].Free;
  SnakeLen := 2;
  NewGame;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered:= True;
  Color := clBlack;
  Count := 20;
  NewGame;
end;

procedure TForm1.FormPaint(Sender: TObject);
var i: integer;
begin
  for i := 1 to SnakeLen do
    Canvas.Draw(ATails[i].getX,ATails[i].getY,Atails[i].getBitmap);
  Canvas.Draw(AApple.getX,AApple.getY,AApple.getBitmap);
  Canvas.Draw(AHead.getX,AHead.getY,AHead.getBitmap);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_LEFT) and (dir <> 'Right') Then dir := 'Left';
  if (Key = VK_RIGHT) and (dir <> 'Left') Then dir := 'Right';
  if (Key = VK_DOWN) and (dir <> 'Up') Then dir := 'Down';
  if (Key = VK_UP) and (dir <> 'Down') Then dir := 'Up';
end;

end.

