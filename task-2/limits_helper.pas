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

function GCD(a, b: longword): longword;
{
  �������� ������� ��� ���������� ����������� ������ �������� (���)
}
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

function LCM(a, b: longword): longword;
const
  MAX_LONGWORD = 4294967295; // ������������ �������� ��� ���� longword
{
    ������� ��� ���������� ����������� ������ �������� (���)
}
begin
  // ���������� ����� ������� ����� ��� � ��������� �� ������������
  if a > MAX_LONGWORD div b then
  begin
    WriteLn('������������ ��� ���������� ���');
    Halt;
  end;
  LCM := (a div GCD(a, b)) * b;
end;

function IsMultiplicationWithinLongIntLimits(a: longint; b: longword): boolean;
const
  MIN_LONGINT = -2147483648;  // ����������� �������� ��� longint
  MAX_LONGINT = 2147483647;   // ������������ �������� ��� longint
{
  �������� ������������ ��� ��������� longint � longword
}
begin
  // ���� ���� �� ����� ����� ����, �� ������������ �� �����
  if (a = 0) or (b = 0) then
    Exit(true);

  // ���� `a` �������������, ���������, ����� ��������� �� �������� MAX_LONGINT
  if a > 0 then
    Exit(a <= MAX_LONGINT div longint(b));

  // ���� `a` �������������, ���������, ����� ��������� �� ��� ������ MIN_LONGINT
  if a < 0 then
    Exit(a >= MIN_LONGINT div longint(b));

  // ���� ��� �������� ��������, ������������ ���
  IsMultiplicationWithinLongIntLimits := true;
end;


function IsMultiplicationWithinLongWordLimits(a, b: longword): boolean;
const
  MAX_LONGWORD = 4294967295;  // ������������ �������� ��� longword

{
  �������� ������������ ��� ��������� longword � longword
}
begin
  // ���� ���� �� ����� ����� ����, �� ������������ �� �����
  if (a = 0) or (b = 0) then
    Exit(true);

  // ���������, ����� ��������� ��������� �� �������� MAX_LONGWORD
  if a > MAX_LONGWORD div b then
    Exit(false);

  // ���� �������� ��������, ������������ ���
  IsMultiplicationWithinLongWordLimits := true;
end;


function IsWithinLongIntLimits(numerator: longint; number_system: integer; num: integer): boolean;
const
  MIN_LONGINT = -2147483648;  // ����������� �������� ��� longint
  MAX_LONGINT = 2147483647;   // ������������ �������� ��� longint
{
  �������� ������������ ��� �������� � longint (��������� � ��������)
}
begin
  // �������� ������������ ��� ���������
  if (numerator > 0) and (numerator > MAX_LONGINT div number_system) then
    exit(false)
  else if (numerator < 0) and (numerator < MIN_LONGINT div number_system) then
    exit(false);

  // ���� ������������ � ��������, ����� ��������� ���������
  numerator := numerator * number_system;

  // �������� ������������ ��� ��������
  if (num > 0) and (numerator > MAX_LONGINT - num) then
    exit(false)
  else if (num < 0) and (numerator < MIN_LONGINT - num) then
    exit(false);

  // ���� ��� �������� ������, �� ������������ �� �����
  IsWithinLongIntLimits := true;
end;


function IsWithinLongWordLimits(denominator: longword; number_system: integer; num: integer): boolean;
const
  MAX_LONGWORD = 4294967295;  // ������������ �������� ��� longword
{
  �������� ������������ ��� �������� � longword (��������� � ��������)
}
begin
  // �������� ������������ ��� ���������
  if (number_system > 0) and (denominator > MAX_LONGWORD div number_system) then
    exit(false);

  // ���� ������������ � ��������, ����� ��������� ���������
  denominator := denominator * number_system;

  // �������� ������������ ��� ��������
  if (num > 0) and (denominator > MAX_LONGWORD - num) then
    exit(false);

  // ���� ��� �������� ������, �� ������������ �� �����
  IsWithinLongWordLimits := true;
end;

function IsAdditionWithinLongIntLimits(a: longint; b: longword): boolean;
const
  MIN_LONGINT = -2147483648;  // ����������� �������� ��� longint
  MAX_LONGINT = 2147483647;   // ������������ �������� ��� longint
{
  �������� ������������ ��� �������� longint � longword
}
begin
  // ���� b = 0, ������������ �� ����� ���������
  if b = 0 then
    Exit(true);

  // ���� a �������������, ���������, ����� ��������� �� �������� MAX_LONGINT
  if a > 0 then
    Exit(a + b <= MAX_LONGINT);

  // ���� a �������������, ���������, ����� ��������� �� ��������� ���� MIN_LONGINT
  if a < 0 then
    Exit(a + b >= MIN_LONGINT);

  // ���� a = 0, ������������ �� ����� ���������, ��� ��� b �� ������� �� ������� longint
  IsAdditionWithinLongIntLimits := true;
end;

function IsSubtractionWithinLongIntLimits(a: longint; b: longword): boolean;
const
  MIN_LONGINT = -2147483648;  // ����������� �������� ��� longint
  MAX_LONGINT = 2147483647;   // ������������ �������� ��� longint
{
  �������� ������������ ��� ��������� longint � longword
}
begin
  // ���� b = 0, ������������ �� ����� ���������
  if b = 0 then
    Exit(true);

  // ���� a �������������, ���������, ����� ��������� �� ���� ������ MIN_LONGINT
  if a > 0 then
    Exit(a - b >= MIN_LONGINT);

  // ���� a �������������, ���������, ����� ��������� �� ���� ������ MAX_LONGINT
  if a < 0 then
    Exit(a - b <= MAX_LONGINT);

  // ���� a = 0, ������������ �� ����� ���������, ��� ��� b �� ������� �� ������� longint
  IsSubtractionWithinLongIntLimits := true;
end;

end.