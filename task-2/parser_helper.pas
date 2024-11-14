(*
 * Project: RationalNumbersCalculator
 * Date: 08.11.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit parser_helper;

interface

uses custom_types;

  function  CheckFihish(input: char;
                           var status: custom_types.status_t;
                           var finish_status: custom_types.finish_status_t
                         ): custom_types.status_t;

  function CheckHaveComment(input: char; var comment: Boolean): Boolean;

  function ConvertCharNumberToInteger(number: char): Integer;

  function CovertNumberToInteger(var input_buffer: custom_types.buffer_array_t;
                                    number_system: Word): Integer;

  function InputCommandSymbol(input: char;
                                 var command: custom_types.command_t
                               ): custom_types.status_t;

  function InputSpaceAfterCommand(input: char): custom_types.status_t;

  function InputSpaceAfterColomn(input: char): custom_types.status_t;

  function InputNumbersNumerator(input: char;
                                    var numerator_first_num: Boolean;
                                    var input_buffer: custom_types.buffer_array_t;
                                    var numerator: LongWord; var number_system: word;
                                    var pointer: Integer
                                  ): custom_types.status_t;

  function InputSignOrFirstNumbersNumerator(input: char;
                                               var sign: custom_types.sign_t;
                                               var numerator_first_num: Boolean;
                                               var input_buffer: custom_types.buffer_array_t;
                                               var numerator: LongWord;
                                               var number_system: Word;
                                               var pointer: Integer
                                             ): custom_types.status_t;

  function  InputNumbersDenominator(input: char;
                                       var input_buffer: custom_types.buffer_array_t;
                                       var denominator: LongWord;
                                       var denominator_first_num: Boolean;
                                       var number_system: Word;
                                       var pointer: Integer
                                     ): custom_types.status_t;

  function InputFirstSymbolsNumberSystems(input: char;
                                             var number_system: Word
                                           ): custom_types.status_t;

  function InputSymbolsNumberSystems(input: char;
                                        var number_system: Word
                                      ): custom_types.status_t;


implementation

uses limits_helper, sysutils;

{
 ������� ��� �������� ������������ ����� ������� "finish" � ��� ������������
 ������ ����� ���� �������.
 ������� ����������� �������, �������� �������������, ����� ���������,
 ��� ��� ������������� ���������� ������������������ ��� ������� "finish".
 ���� ������������������ ��������, ������� �������� ��������� � �������.

 input - ������, ������� ������������ ������ � �������.
 status - ������� ��������� �������� �������. ���� �������� 
            ������������, ����� ������, �� ����� ����� ��������� ������� �����.
 finish_status - ����������, ������� �������� ������� 
                  ���� ����� ������� "finish" (�� 0 �� 6).

 ������� ���������� ��������� ������:
   -1 - ���� ������ ������� ��������� � ������� ������������.
   -2 - ���� ���� �������� ������� � ������� "finish" ���������.
   status - ���� ������� �� ���� ������� � ������� ���� �������
                                                      ������������( + 10: ...)
}
function CheckFihish(input: char; var status: custom_types.status_t;
                        var finish_status: custom_types.finish_status_t
                      ): custom_types.status_t;
begin
  {
    ���� ������ ����� 0 ��� -1, ��� ��������, ��� ������� "finish" ����� ���� �������.
    ��������� ������������������ �������� �� ������ ����� �����.
  }
  if (status = 0) or (status = -1) then
  begin
    {
      ���� �� ������� ����� ������ ������ 'f' � finish_status = 0 (��������� ����),
      �� ������� ����������, � ��������� finish_status ����������� �� 1.
    }
    if (input = 'f') and (finish_status = 0) then
    begin
      finish_status := 1;  // ������� �� ������ ���� ������� "finish"
      exit(-1);  // ��������� ��������� ������� �� ���� ����
    end;

    {
      ���� �� ����� 1 ������ ������ 'i', ��������� �� ��������� ���� (finish_status = 2).
    }
    if (input = 'i') and (finish_status = 1) then
    begin
      finish_status := 2;  // ������� �� ������ ���� �������
      exit(-1);  // ��������� ��������� ������� �� ���� ����
    end;

    {
      ���� �� ����� 2 ������ ������ 'n', ��������� �� ��������� ���� (finish_status = 3).
    }
    if (input = 'n') and (finish_status = 2) then
    begin
      finish_status := 3;  // ������� �� ������ ���� �������
      exit(-1);  // ��������� ��������� ������� �� ���� ����
    end;

    {
      ���� �� ����� 3 ������ ������ 'i', ��������� �� ��������� ���� (finish_status = 4).
    }
    if (input = 'i') and (finish_status = 3) then
    begin
      finish_status := 4;  // ������� �� ��������� ���� �������
      exit(-1);  // ��������� ��������� ������� �� ���� ����
    end;

    {
      ���� �� ����� 4 ������ ������ 's', ��������� �� ��������� ���� (finish_status = 5).
    }
    if (input = 's') and (finish_status = 4) then
    begin
      finish_status := 5;  // ������� �� ����� ���� �������
      exit(-1);  // ��������� ��������� ������� �� ���� ����
    end;

    {
      ���� �� ����� 5 ������ ������ 'h', ������� ���������, � �� ��������� ������ ������������.
    }
    if (input = 'h') and (finish_status = 5) then
    begin
      finish_status := 6;  // ���������� ������� "finish"
      exit(-2);  // ��������� ���� ������� � ���������� ������ ���������� ������ ������������
    end;

    {
      ���� ������� �� ���� ������� ��� ������, ���������� ������ 0.
      ��� ����� �����������, ���� ����� ������� ������������(+-*.).
    }
    if (finish_status = 0) then
    begin
      exit(0);  // ������� �� ���� ������, ������ 0
    end else begin
      // ���� ������������������ ������ ��������, ������� ������ � ��������� ���������� ���������.
      WriteLn('finish_structure_error');
      Halt;
    end;
  end else
  begin
    // ���� ������ �� ����� 0 ��� -1 (��������, �������(+-*/) ��� ���� �������), ���������� ������� ������.
    exit(status);
  end;
end;

{
  ������� ��� �������� ������� ����������� � ������
  ��� ������� ��������� ������ �� ������� ������ ����������� (������ '#').
  ���� ����������� ��� �� �������, ������ '#' ��������� ���, ������������ ����
                                                            'comment' � true.
  ���� ����������� ��� �������, ������� ���������� true, ����� �����������,
                                                  ��� ��������� � �����������.
  
  input - ������, ������� ������������ ������ � �������.
  comment - ���� ����������, ��� ����������� ��� �������
}
function CheckHaveComment(input: char; var comment: Boolean): Boolean;
begin
  {
    ���� ���� comment ��� ���������� � true, ��� ��������, ��� �����������
    ��� �������, � ������� ����� ���������� true, ��������, ��� �� ��������� 
                                                                  � �����������.
  }
  if comment then exit(true);

  {
    ���� ������� ������ ����� '#', ��� ������ �����������.
    � ���� ������ �� ������������� ���� comment � true � ���������� true, �����
    �����������, ��� ����������� �������.
  }
  if (input = '#') then
  begin
    comment := true;  // �������� �����������
    CheckHaveComment := true;  // ���������� true, ��� ����������� �������
  end
  else
      {
        ���� ������ �� ����� '#', ����������� �� ����������, � �������
        ���������� false. ��� ��������, ��� �� ��� �� ��������� � �����������.
      }
    CheckHaveComment := false;
end;

{
   ������� ��� �������������� �������, ��������������� ����� � �����������������
   �������, � ����� �����. ������� ������������ ������� �� '0' �� '9' � 
   �� 'a' �� 'f'.
  
   ����������:
     - ������� ������������� �������� ������ � ������� �������� � ������� 
         ������� LowerCase, ��� ��������� ������������ ��� ���������,
                                                          ��� � �������� �����.
}
function ConvertCharNumberToInteger(number: char): Integer;
begin
  case LowerCase(number) of
    '0': ConvertCharNumberToInteger := 0;
    '1': ConvertCharNumberToInteger := 1;
    '2': ConvertCharNumberToInteger := 2;
    '3': ConvertCharNumberToInteger := 3;
    '4': ConvertCharNumberToInteger := 4;
    '5': ConvertCharNumberToInteger := 5;
    '6': ConvertCharNumberToInteger := 6;
    '7': ConvertCharNumberToInteger := 7;
    '8': ConvertCharNumberToInteger := 8;
    '9': ConvertCharNumberToInteger := 9;
    'a': ConvertCharNumberToInteger := 10;
    'b': ConvertCharNumberToInteger := 11;
    'c': ConvertCharNumberToInteger := 12;
    'd': ConvertCharNumberToInteger := 13;
    'e': ConvertCharNumberToInteger := 14;
    'f': ConvertCharNumberToInteger := 15;
  end;
end;

{
    ������� ��� ����������� ���� ��������, ���������� ����� � ������� ���������,
    � ����� ����� � 10 ������� ��������. ������� ���������, ��� ����� �� 
    ��������� ��������� ������� ���������.
    
    input_buffer - ������, ���������� ��� �������, �������������� ����� �
                    ������� ���������.
    number_system - ������� ���������, � ������� ��������� ����� (�� 256).
}
function CovertNumberToInteger(var input_buffer: custom_types.buffer_array_t; number_system: Word): Integer;
var
  number: Integer;
begin
  // ������������ ��� ������� � �����. ������ ������ ���������� �� 16, ������ � ������ �����������.
  // 16 - ����������� ����������� �������� ������� �������� 1 ������
  number := ConvertCharNumberToInteger(input_buffer[1]) * 16 + ConvertCharNumberToInteger(input_buffer[2]);

  // ��������, ��� ����� �� ������ ��� ����� ������� ���������.
  if number >= number_system then
  begin
    // ���� ����� ������ ��� ����� ������� ���������, ��������� ������.
    WriteLn('incorrect_number (number_bigger_than_number_system)');
    Halt;  // ��������� ����������� � �������.
  end;

  // ���������� ���������������� �����.
  CovertNumberToInteger := number;
end;

{
    ������� ��� ��������� ����� ������� ������� ������������. 
    ��� ������� ������������ ������ �������� (+, -, *, /), �����������
    ��������������� ������� 
    � ��������� ������������ �����. ���� ������ ������������ ������, ��������� 
    ��������� ����������.
    
    input - ������, ��������� �������������, ������� ���������� ����������. 
            ��� ����� ���� ���� �� �������� ��������:
                  '+', '-', '*', '/'.
    command - ���������� ���� command_t, � ������� ����� ��������� �������, 
              ��������������� ���������� �������. ������� ������� �������� 
              ������������� �������� ��������:
                      '+' - 1
                      '-' - 2
                      '*' - 3
                      '/' - 4
    
    ������� ����������:
        0 - ���� ������ ������ (������ ������������).
        1 - ���� ������� ��������� ������ ��������.
        � ������ ������ (��������, ���� ������� ����� ��� �������������� ������),
          ��������� ��������� �� ������ � ��������� �����������.
}
function InputCommandSymbol(input: char; var command: custom_types.command_t): custom_types.status_t;
begin
  // ���� ������ ������, �� ������ �� ������ � ������� � ����� 0
  if input = ' ' then exit(0);

  // ������������ ������� �������� ������������ � ����������� ��������������� �������� ���������� command
  case input of
    '+': command := 1;  // �������� ��������
    '-': command := 2;  // �������� ���������
    '*': command := 3;  // �������� ���������
    '/': command := 4;  // �������� �������
  else
  begin
    // ���� ������ ������, ������� �������� ������, �� �������� �� �������, ������� ������
    if ('0' <= input) and (input <= '9') then
    begin
      WriteLn('missing_operation');  // ������: �������� �� �������
      Halt;  // ��������� ���������� � �������
    end;

    // ���� ������ �� �������� ���������� ��������� ��� ������, ������� ��������� �� ������
    WriteLn('invalid_operation_symbol');  // ������: ������������ ������ ��������
    Halt;  // ��������� ���������� � �������
  end;
  end;

  // ���������� ������ 1, ���� ������ ������� ���������
  InputCommandSymbol := 1;
end;

{
    ������� ��� �������� ������� ������� ����� ����� ������� ������������. 
    ��� ������� ���������, ��� �� ������ ������ ����� ����� ������� ��������.
    ���� ������ �����������, ��������� ������� ������ � ��������� ����������.
    
    input - ������, ��������� ������������� ����� ����� ��������.               
    
    ������� ����������:
        2 - ���� ������ ������, ��� ��������, ��� ������ ����� �������� ��� ������.
        � ������ ������ (���� ������� ��� ����� ��������), ��������� ��������� 
              �� ������, � ��������� �����������.
}
function InputSpaceAfterCommand(input: char): custom_types.status_t;
begin
  // ���� ������ ������, ���������� ��� 2, ��� ��������, ��� ������ ����� �������� ������.
  if input = ' ' then
  begin
    InputSpaceAfterCommand := 2;
  end
  else
  begin
    // ���� ������� ���, ������� ��������� �� ������.
    WriteLn('missing_required_whitespace_after_operation');
    Halt;  // ��������� ���������� ���������.
  end;
end;

{
    ������� ��� ��������� ������� �������, ���������� ��� ������� ���������.
    ��� ������� ���������, �������� �� ��������� ������ ���������� ���
    ����������� ������� ���������. ���� ������ �������� ��������, ���������
    ���������� ����������. ���� ������ ��������, ��������� ��������� 
    ���������� � �������.
    
    input - ������, ��������� �������������, ������� ������ ���� ������ ������
                                                ������� ��������� ��� ��������.
    number_system - ���������� ���� Word, � ������� ����� �������� �������
                              ���������, ���� ������ ������ �������� ����������.
    
    ������� ����������:
        2 - ���� ������ ������ (������ ������������).
        3 - ���� ������ ������ �������� ���������� ������, ���������� ���������.
        � ������ ������ (��������, ���� ������ �� ����� ��� ���������), 
                          ��������� ��������� �� ������ � ��������� ����������.
}
function InputFirstSymbolsNumberSystems(input: char; var number_system: Word): custom_types.status_t;
begin
  // ���� ������ ������, �� ������ �� ������ � ������� � ����� 2
  if input = ' ' then exit(2);

  // ���� ������ ������ ":", �� ������� ������
  if input = ':' then
  begin
    WriteLn('missing_radix');  // ������: ����������� ��������� ������� ���������
    Halt;  // ��������� ���������� ���������
  end;

  // ���� ������ ���������� ������, ������� ������
  if not (('0' <= input) and (input <= '9')) then
  begin
    WriteLn('invalid_radix_format');  // ������: �������� ������ ���������
    Halt;  // ��������� ���������� ���������
  end;

  // ���� ������ ����������, ���������� ��� 3 � ���������� ���������
  InputFirstSymbolsNumberSystems := 3;

  // �������� �������������� ������� ��� ��������� �������� ������� ���������
  InputSymbolsNumberSystems(input, number_system);
end;

{
    ������� ��� ��������� ��������, �������������� ����� ������� ���������.
    ��� ������� ��������� ������� ��������� (number_system) �� ������ ���������
    ��������.���� ������ �������� ������ ��� ������� ��������� ������� ��
    ���������� �������, ��������� �������� ���������� � �������.
    
    input - ������, ������� ���� ������������, �������������� ����� �������
                                                        ��������� ��� ���������.
    number_system - ���������� ���� Word, ������� ������ ������� �������
                         ���������. ��� ���������� ����������� � �������� �����.
    
    ������� ����������:
        4 - ���� ������ ������ ":", ��� ��������� �� ���������� ����� ������� ���������.
        � ������ ������ (��������, ���� ������� ������������ ����� ��� ������), 
                    ��������� ��������������� ���������, � ��������� ����������.
}
function InputSymbolsNumberSystems(input: char; var number_system: Word): custom_types.status_t;
begin
  // ���� ������ ������, ������� ������ "missing_colomn"
  if input = ' ' then
  begin
    WriteLn('missing_colomn');  // ������: �������� ���������
    Halt;  // ��������� ���������� ���������
  end;

  // ���� ������ ������ ":", ��������� ������������ ����� ������� ���������.
  if input = ':' then
  begin
    // ���� ������� ��������� ������ 2 ��� ������ 256, ������� ������ "radix_out_of_range"
    if (number_system < 2) or (number_system > 256) then
    begin
      WriteLn('radix_out_of_range');  // ������: ��������� ������� ��������� ������� �� ���������� �������
      Halt;  // ��������� ���������� ���������
    end;

    // ���� ��� ������� ���������, ���������� ������ 4, ��� �������� ���������� ����� ������� ���������
    exit(4);
  end;

  // ���� ������ ���������� ������, ������� ������ "invalid_radix_format"
  if not (('0' <= input) and (input <= '9')) then
  begin
    WriteLn('invalid_radix_format');  // ������: �������� ������ �����
    Halt;  // ��������� ���������� ���������
  end;

  // ��������� ������� ��������� �� ������ ��������� �����.
  number_system := number_system * 10 + StrToInt(input);

  // ���� ������� ��������� ������� �� ������� 256, ������� ������
  if number_system > 256 then
  begin
    WriteLn('radix_out_of_range');  // ������: ��������� ������� ��������� ������� ������
    Halt;  // ��������� ���������� ���������
  end;
end;

{
    ������� ��� �������� ������� ������� ����� ���������, ������� ��������� 
    ��� ����������� ����� ������. ���� ����� ��������� ������ ������, ������� 
    ���������� ������ 5, ����� ��������� ���������� � �������.
    
    input - ������, ������� ���� ������������, ������� ������ ����
                                                      �������� ����� ���������.
    
    ������� ����������:
        5 - ���� ������ ������ ����� ���������.
        � ������ ������ (���� ��� �������), ��������� ������� 
                         ��������� � ����������� ������� � ��������� ����������.
}
function InputSpaceAfterColomn(input: char): custom_types.status_t;
begin
  // ���������, ��� ����� ��������� ������ ������.
  if input = ' ' then
  begin
    // ���� ��� ������, ���������� ������ 5, ������� ��������� �� �������� ���� �������.
    InputSpaceAfterColomn := 5;
  end
  else
  begin
    // ���� ������ ������� ������ ������ ������, ������� ������ "missing_required_whitespace_after_colomn" � ��������� ���������.
    WriteLn('missing_required_whitespace_after_colomn');  // ������: �������� ������������ ������ ����� ���������.
    Halt;  // ��������� ���������� ���������.
  end;
end;

{
    ������� ��� ��������� ����� ����� (���������) � ������������.
    ��� ��������� ������������ ����� ����� ��� ���������, �������� ������
    ������� � �������� �� ������������.

    input - ������, ��������� �������������, ������� ������ ���� ������ ���������.
    numerator_first_num - ����, ������������, �������� �� ��������� ����� ������ ������ ���������.
    input_buffer - ����� ��� �������� ��������� �������� ���������.
    numerator - ���������� ��� �������� ���������� ���������.
    number_system - ������� ��������� (��������, ����������, ����������������� � �.�.).
    pointer - ��������� �� ������� ������� � ������ ��� ���������.

    ������� ����������:
        6 - ���� ��������� ������� ���� ��������, �� ��������� ���������� ����.
        7 - ���� �������� ���� ��������� � �������� ���� �����������
        � ������ ������ ��������� ������� ��������� � ��������� ����������.
}
function InputNumbersNumerator(input: char; var numerator_first_num: Boolean;
                                  var input_buffer: custom_types.buffer_array_t;
                                  var numerator: LongWord; var number_system: word;
                                  var pointer: Integer): custom_types.status_t;
begin
  // �������� �� ������: ���� ������ ������ '/' � ��� ������ ���� ���������, �� ��������� ������.
  if (input = '/') and numerator_first_num then
  begin
    WriteLn('missing_numerator');  // ������: �������� ��������� ����� ������ "/".
    Halt;  // ��������� ���������� ���������.
  end;

  // ������: ���� ����� ������ ������, ��� ����������� ��������� ��� ����� ���������.
  if (pointer = 1) and (input = ' ') and numerator_first_num then
  begin
    WriteLn('unexpected_whitespace_after_sign');  // ������: ����������� ������ ����� �����.
    Halt;  // ��������� ���������� ���������.
  end;

  // ������: ���� ����� ������� ������� � ���� �������� ������, ��� �����������.
  if (pointer = 2) and (input = ' ') then
  begin
    WriteLn('unexpected_whitespace_in_number(numerator)');  // ������: ����������� ������ � ���� ��������
    Halt;  // ��������� ���������� ���������.
  end;

  // ���� ����� ���� �������� ������ ������, ������� ����������� �����.
  if (pointer = 1) and (input = ' ') then
  begin
    exit(6);  // ������� ����������� �����.
  end;

  // ���� ������ ������ '/', � ��������� ��� ������, �������� ���� �����������.
  if (input = '/') and not numerator_first_num then
  begin
    exit(7);  // ������� ���� �����������.
  end;

  // ������ ��������� ������ �� �������� ������ ������, ���������� ���������.
  numerator_first_num := false;

  // ��������, ��� ��������� ������ �������� ������ ��� �������� � ��������� 'a'..'f'
  if ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f'))) and (pointer < 3) then
  begin
    input_buffer[pointer] := input;  // ��������� ��������� ������ � �����.
    pointer := pointer + 1;  // ����������� ��������� �� ��������� ������� � ������.
  end;

  // ����� ����� ���������� (2 �������), ���������, ��� ���������� ����� �� ��������� ����������� LongInt.
  if (pointer = 3) then
  begin
    if not IsWithinLongIntLimits(numerator, number_system, CovertNumberToInteger(input_buffer, number_system)) then
    begin
      WriteLn('limit_longint');  // ������: ������������ ������ LongInt.
      Halt;  // ��������� ���������� ���������.
    end;

    // ����������� ��������� ������� � ����� � ��������� ��� � ���������.
    numerator := numerator * number_system + CovertNumberToInteger(input_buffer, number_system);
    pointer := 1;  // ���������� ��������� ��� ���������� �����.
  end;

  // ���������� ������ 6, ��� ��������, ��� ��������� ������� ��������� � ��������� ���������� ����.
  InputNumbersNumerator := 6;
end;

{
    ������� ��� ��������� ����� ����� ��� ������� ����� ���������.
    ��� ��������� ������������ �������, ������� ���� ������������, � � 
    ����������� �� ����� ��������� ���������� ���������.

    input - ������, ������� ��� ������ �������������.
    sign - ����������, � ������� ����������� ���� ���������: 0 ��� "+" � 1 ��� "-".
    numerator_first_num - ����, ������� ���������, �������� �� ���� ������ ������ ���������.
    input_buffer - ����� ��� �������� ��������� �������� ���������.
    numerator - ����������, � ������� �������� ���������.
    number_system - ������� ��������� (��������, ���������� ��� �����������������).
    pointer - ��������� �� ������� ������� � ������ ���������.

    ������� ����������:
        6 - �������� ��������� �������, ����������� ����� ���������.
}
function InputSignOrFirstNumbersNumerator(input: char;
                                             var sign: custom_types.sign_t;
                                             var numerator_first_num: Boolean;
                                             var input_buffer: custom_types.buffer_array_t;
                                             var numerator: LongWord;
                                             var number_system: Word;
                                             var pointer: Integer): custom_types.status_t;
begin
  // �������� �� ������������ ������ (����� ����, ���� 'a'..'f', ������ '+' � '-').
  if not ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f')) or (input = '+') or (input = '-')) then
  begin
    // ���� ������ ������, ������� ������ � ���, ��� ����� ��������� �� ����� ���� ����� ������ �������.
    if input = ' ' then
    begin
      WriteLn('max_one_whitespace_after_colon');  // ������: ������ ���� ������ ����� ���������.
      Halt;  // ��������� ���������� ���������.
    end;
    // ���� ������ ������ '/', ������� ������ � ����������� ���������.
    if input = '/' then
    begin
      WriteLn('missing_numerator');  // ������: �������� ���������.
      Halt;  // ��������� ���������� ���������.
    end;
    // ���� ������ ������������ ������, ������� ������.
    WriteLn('invalid_sign_or_numerator_symbol');  // ������: ������������ ������ ��� ����� ��� ���������.
    Halt;  // ��������� ���������� ���������.
  end;

  // ��������� ������ '+' � '-', ����������� �������� � ���������� sign.
  case input of
    '+': sign := 0;  // ���� "+" ����������� ��� 0.
    '-': sign := 1;  // ���� "-" ����������� ��� 1.
  else sign := 0;  // ���� ���� �� "+" � �� "-", �� ��������� ����� ���� "+"
  end;

  // ���� ������ ������ ����� ��� ����� � �������� '0'..'9' ��� 'a'..'f',
  // �������� ������� ��� ��������� ���������.
  if (('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f')) then
  begin
    // �������� ������� ��� ��������� ����� ���������.
    InputNumbersNumerator(input, numerator_first_num, input_buffer, numerator, number_system, pointer);
    // ���������� ������ 6, ��� �������� �������� ��������� � ����������� ����� ���������.
    InputSignOrFirstNumbersNumerator := 6;
  end
  else begin
    // ���� ��� ����, ���������� ������ 6 ��� ������ ����� ���������.
    InputSignOrFirstNumbersNumerator := 6;
  end;
end;

{
    ������� ��� ��������� ����� ����� �����������. ��� ������� ������������ ����
    �������� ��� ��������� � ����������� �� ��������� ��������� � �������� 
    �������. ���� ������� �����, ��� �������������� � ����������� � �����������.

    input - ������, ������� ��� ������ �������������.
    input_buffer - ����� ��� �������� ��������� �������� �����������.
    denominator - ���������� ��� �������� ��������� �����������.
    denominator_first_num - ����, ������� ���������, �������� �� ���� ������ ������ �����������.
    number_system - ������� ���������, � ������� �������� �����.
    pointer - ��������� �� ������� ������� � ������ �����������.

    ������� ����������:
        7 - �������� ��������� ������� � ����������� �����.
}
function InputNumbersDenominator(input: char;
                                    var input_buffer: custom_types.buffer_array_t;
                                    var denominator: LongWord;
                                    var denominator_first_num: Boolean;
                                    var number_system: Word;
                                    var pointer: Integer): custom_types.status_t;
begin
  // ���� ��������� �� ������ ������� � ������ ������, ������� ������.
  if (pointer = 2) and (input = ' ') then
  begin
    WriteLn('unexpected_whitespace_in_number(denominator)');  // ������: ����������� ������ � ����� �����������.
    Halt;  // ��������� ���������� ���������.
  end;

  // ���� ��������� �� ������ ������� � ������ ������, ������� ���� �������.
  if (pointer = 1) and (input = ' ') then
  begin
    exit(7);  // ������� ���������, ������� ���� �������.
  end;

  // ���� ������ ���������� ������ (����� ��� ����� a..f) � ��������� ������ 3,
  // ��������� ������ � ����� � ����������� ���������.
  if ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f'))) and (pointer < 3) then
  begin
    input_buffer[pointer] := input;  // ��������� ������ � �����.
    pointer := pointer + 1;  // ����������� ���������.
  end;

  // ���� ��������� ����� 3, ��� ��������, ��� ������� ��� �������.
  if (pointer = 3) then
  begin
    // ��������, ����� ����� �� �������� �� ������� LongWord.
    if not IsWithinLongWordLimits(denominator, number_system, CovertNumberToInteger(input_buffer, number_system)) then
    begin
      WriteLn('limit_longword');  // ������: ����� ������� �� ������� LongWord.
      Halt;  // ��������� ���������� ���������.
    end;

    // ���� ��� ������ ����� �����������, �������������� ��� ��������� 0.
    if denominator_first_num then
      denominator := 0;  // ������������� ����������� � 0.

    // ���������� ���� ������� �����.
    denominator_first_num := false;

    // ����������� ��������� ������� � ����� � ��������� ��� � �����������.
    denominator := denominator * number_system + CovertNumberToInteger(input_buffer, number_system);
    pointer := 1;  // ���������� ��������� ��� ���������� �����.
  end;

  // ���������� ������ 7, ������� ��������� �� �������� ���������.
  InputNumbersDenominator := 7;
end;


end.