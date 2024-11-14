(*
 * Project: RationalNumbersCalculator
 * Date: 08.11.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit limits_helper;

interface

  function GCD(a, b: longword): longword; // ������� ��� ���������� ����������� ������ �������� (���)

  function LCM(a, b: longword): longword; // ������� ��� ���������� ����������� ������ �������� (���)

  function IsMultiplicationWithinLongIntLimits(a: longint; b: longword): boolean; // �������� ������������ ��� ��������� ��� longint

  function IsMultiplicationWithinLongWordLimits(a, b: longword): boolean; // �������� ������������ ��� ��������� ��� longword

  function IsWithinLongIntLimits(numerator: longint; number_system: integer; num: integer): boolean; // �������� ������������ ��� ��������� � longint

  function IsWithinLongWordLimits(denominator: longword; number_system: integer; num: integer): boolean; // �������� ������������ ��� ��������� � longword

  function IsAdditionWithinLongIntLimits(a: longint; b: longword): boolean; // �������� ������������ ��� �������� longint � longword

  function IsSubtractionWithinLongIntLimits(a: longint; b: longword): boolean; // �������� ������������ ��� ��������� longint � longword

implementation

uses custom_types;
{
  �������� ������� ��� ���������� ����������� ������ �������� (���)
}
function GCD(a, b: longword): longword;
begin
  while b <> 0 do
  begin
    a := a mod b;
    a := a + b;
    b := a - b;
    a := a - b;
  end;
  GCD := a; // ���������� ���
end;

{
  ������� ��� ���������� ����������� ������ �������� (���)
}
function LCM(a, b: longword): longword;
begin
  // ���������� ����� ������� ����� ��� � ��������� �� ������������
  if a > custom_types.MAX_LONGWORD div b then
  begin
    WriteLn('overflow_when_calculating_LCM');
    Halt;
  end;
  LCM := (a div GCD(a, b)) * b;
end;

{
  �������� ������������ ��� ��������� longint � longword
}
function IsMultiplicationWithinLongIntLimits(a: longint; b: longword): boolean;
begin
  // ���� ���� �� ����� ����� ����, �� ������������ �� �����
  if (a = 0) or (b = 0) then
    Exit(true);

  // ���� `a` �������������, ���������, ����� ��������� �� �������� custom_types.MAX_LONGINT
  if a > 0 then
    Exit(a <= custom_types.MAX_LONGINT div longint(b));

  // ���� `a` �������������, ���������, ����� ��������� �� ��� ������ custom_types.MIN_LONGINT
  if a < 0 then
    Exit(a >= custom_types.MIN_LONGINT div longint(b));

  // ���� ��� �������� ��������, ������������ ���
  IsMultiplicationWithinLongIntLimits := true;
end;

{
  �������� ������������ ��� ��������� longword � longword
}
function IsMultiplicationWithinLongWordLimits(a, b: longword): boolean;
begin
  // ���� ���� �� ����� ����� ����, �� ������������ �� �����
  if (a = 0) or (b = 0) then
    Exit(true);

  // ���������, ����� ��������� ��������� �� �������� custom_types.MAX_LONGWORD
  if a > custom_types.MAX_LONGWORD div b then
    Exit(false);

  // ���� �������� ��������, ������������ ���
  IsMultiplicationWithinLongWordLimits := true;
end;

{
  �������� ������������ ��� �������� � longint (��������� � ��������)
}
function IsWithinLongIntLimits(numerator: longint; number_system: integer; num: integer): boolean;
begin
  // �������� ������������ ��� ���������
  if (numerator > 0) and (numerator > custom_types.MAX_LONGINT div number_system) then
    exit(false)
  else if (numerator < 0) and (numerator < custom_types.MIN_LONGINT div number_system) then
    exit(false);

  // ���� ������������ � ��������, ����� ��������� ���������
  numerator := numerator * number_system;

  // �������� ������������ ��� ��������
  if (num > 0) and (numerator > custom_types.MAX_LONGINT - num) then
    exit(false)
  else if (num < 0) and (numerator < custom_types.MIN_LONGINT - num) then
    exit(false);

  // ���� ��� �������� ������, �� ������������ �� �����
  IsWithinLongIntLimits := true;
end;

{
  �������� ������������ ��� �������� � longword (��������� � ��������)
}
function IsWithinLongWordLimits(denominator: longword; number_system: integer; num: integer): boolean;
begin
  // �������� ������������ ��� ���������
  if (number_system > 0) and (denominator > custom_types.MAX_LONGWORD div number_system) then
    exit(false);

  // ���� ������������ � ��������, ����� ��������� ���������
  denominator := denominator * number_system;

  // �������� ������������ ��� ��������
  if (num > 0) and (denominator > custom_types.MAX_LONGWORD - num) then
    exit(false);

  // ���� ��� �������� ������, �� ������������ �� �����
  IsWithinLongWordLimits := true;
end;

{
    �������� ������������ ��� �������� longint � longword
}
function IsAdditionWithinLongIntLimits(a: longint; b: longword): boolean;
begin
  // ���� b = 0, ������������ �� ����� ���������
  if b = 0 then
    Exit(true);

  // ���� a �������������, ���������, ����� ��������� �� �������� custom_types.MAX_LONGINT
  if a > 0 then
    Exit(a + b <= custom_types.MAX_LONGINT);

  // ���� a �������������, ���������, ����� ��������� �� ��������� ���� custom_types.MIN_LONGINT
  if a < 0 then
    Exit(a + b >= custom_types.MIN_LONGINT);

  // ���� a = 0, ������������ �� ����� ���������, ��� ��� b �� ������� �� ������� longint
  IsAdditionWithinLongIntLimits := true;
end;

{
  �������� ������������ ��� ��������� longint � longword
}
function IsSubtractionWithinLongIntLimits(a: longint; b: longword): boolean;
begin
  // ���� b = 0, ������������ �� ����� ���������
  if b = 0 then
    Exit(true);

  // ���� a �������������, ���������, ����� ��������� �� ���� ������ custom_types.MIN_LONGINT
  if a > 0 then
    Exit(a - b >= custom_types.MIN_LONGINT);

  // ���� a �������������, ���������, ����� ��������� �� ���� ������ custom_types.MAX_LONGINT
  if a < 0 then
    Exit(a - b <= custom_types.MAX_LONGINT);

  // ���� a = 0, ������������ �� ����� ���������, ��� ��� b �� ������� �� ������� longint
  IsSubtractionWithinLongIntLimits := true;
end;

end.