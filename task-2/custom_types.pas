(*
 * Project: RationalNumbersCalculator
 * Date: 08.11.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit custom_types;

interface

const
  MAX_NUMBER_SYSTEM = 256;     // ������������ ���������� �������������� ������ ���������
  MAX_LONGWORD = 4294967295;   // ������������ �������� ��� ���� longword
  MIN_LONGINT = -2147483648;   // ����������� �������� ��� longint
  MAX_LONGINT = 2147483647;    // ������������ �������� ��� longint
type
  {
    ��� ������ ��� �������� �������� ������ ��������� (�� 256 ���������� ��������)
  }
  number_system_t = array[1..MAX_NUMBER_SYSTEM] of Int16;

  {
    ��� ������ ��� �������� ������� ������������
    ������ �������� ������������� ���������� �������� ��������:
        0 - ��������� ��������, �� ������������� ������� ��������
        1 - �������� ('+')
        2 - ��������� ('-')
        3 - ��������� ('*')
        4 - ������� ('/')
  }
  command_t = 0..4;

  {
    ��� ������ ��� �������� ��� �������� ��� ����� ��������� ��� ����������� �����
  }
  buffer_array_t = array[1..2] of Char;

  {
    ��� ������ ��� �������� ����� ��������� ������������
    ���� ��������� �������� ��� ����� �����:
        0 - ������������� ���� ('+')
        1 - ������������� ���� ('-')
  }
  sign_t = 0..1;

  {
    ��� ������ ��� �������� ������� ��� �������� �������
    ������ ����� ��������� �������� � ��������� �� -3 �� 7, ��� ������ ��������
    ������������ ������������ ���� ��� ��������� � �������� �������� �������.
    �������� ��������:
      -3 - ��������� �������, � �������� �������� ������� ���� ����� �������
      -2 - ��������� ������ ������������.
      -1 - ������ ���� ����� "finish". ������� ���� ������������������ �� �����.
       0 - ������� ���� ������� �������(+-*/) ��� �������(��)
       1 - ������� ���� 1 ������������� �������
       2 - ������� ���� ������ ����� ������� �������� ��� �������(��)
       3 - ������� ���� ��������� ���� ������ �������� ��� ":" ��� 
                                              ��������� ����� ������� ���������
       4 - ������� ���� 1 ������������� ������� ����� ":"
       5 - ������� ���� ���� ���������, ���� ������ ����� ���������
       6 - ������� ���� ������-�� ����������� ��� ��������,
           ������� ��������� ���������� � �������� ������� ���������.
           ����� ������� "\" ��� �������� �� ��������� � �����������
       7 - ������� ���� ������-�� ����������� ��� ��������,
           ������� ��������� ������������ � �������� ������� ���������.
  }
  status_t = -3..7;

  {
    ��� ������ ��� �������� ������� ��� ����� "finish:
    ������ ����� ��������� �������� � ��������� �� 1 �� 6, ��� ������ �������� 
    �������� ������������ �������� � ����� "finish".
  }
  finish_status_t = 0..6;

implementation

end.