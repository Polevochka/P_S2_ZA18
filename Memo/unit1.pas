unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

  // Делаем матрицу и её размерность глобальными переменными
  // чтобы они были видны во всех функциях -
  // обработчиков нажатия кнопок
  a: Ar2;       // матрица
  n,m : integer; // число строк и столбцов

implementation

{$R *.lfm}

{ TForm1 }

{Процедура добавления ОДНОЙ строки чисел в Memo(Печатаем одномерный массив)}
// row - одномерный массив -СТРОКА МАТРИЦЫ(Поэтому Ar1, а не Ar2)
// m - число столбцов
// aMemo - Объект мемо куда записываем строку матрицы(var т.к. изменяем его)
procedure PrintAr1(row: Ar1; m: integer; var aMemo: TMemo);
var
   // строковое представление одного числа
   el_str: string;
   // Строкое представление одномерного массива row
   // то есть это сумма строковых представлений каждого элемента(el_str)
   // одномерного массива 'row'
   row_str: string;
   j: integer; // для перебора столбцов
begin
  row_str:='';
  for j:=1 to m do
  begin
    // преобразуем ЕЛЕМЕНТ СТРОКИ(одномерного массива) в строку
    // число 4 - так же как и в writeln - ширина поля под число
    // чтобы не замарачиваться с пробелами при выводе
    str(row[j]:4, el_str);
    // по одному элементы Одномерного массива 'row' собираем в одну строку
    row_str := row_str + el_str;
  end;
  // собрали одну строку, теперь добавляем её в Memo
  aMemo.Append(row_str);
end;

{Вывод МАТРИЦЫ в Memo}
// a - наша матрица - двухмерный массив(поэтому тип Ar2, а не A1)
// n - число строк
// m - число столбцов
// 'var aMemo:TMemo' так как мы будем изменять объект Memo - записывать в него
// Хотя это не обязательно, работает и без, тупо для приличия делаем так
procedure PrintAr2(a: Ar2; n: integer; m: integer; var aMemo: TMemo);
var
  i: integer;
begin
  // перед записью чего-то в Memo очищаем его
  aMemo.Clear;

  // Оюходим все строки
  for i:=1 to n do
      // И печатаем каждую строку в переданный объект mem типа TMemo
      PrintAr1(a[i], m, aMemo);
end;

{Нажали 'Закрыть'}
procedure TForm1.Button1Click(Sender: TObject);
begin
  close;
end;

{Нажали 'Создать матрицу'}
procedure TForm1.Button2Click(Sender: TObject);
begin
  // Получаем размерность матрицы от пользователя
  // InputBox возвращает строку, но ГЛОБАЛЬНЫЕ переменные n и m типа integer
  // поэтому преобразуем возвращаем значение в целое число при помощи StrToInt
  n := StrToInt(InputBox('Ввод числа', 'Сколько строк?', '5'));
  m := StrToInt(InputBox('Ввод числа', 'Сколько столбцов?', '5'));

  // Теперь так как УЖЕ ЕСТЬ число строк и столбцов
  // Заполняем матрицу
  CreateAr2(a, n, m);

  // выводим матрицу в Memo1 - исходная матрица
  PrintAr2(a, n, m, Memo1);

end;

{Нажали 'Обработка'}
procedure TForm1.Button3Click(Sender: TObject);
var i: integer;
    ave: real; // Среднее арифметическое одной строки матрицы
    ave_str: string; // СТРОКОВОЕ представление среднего арифметического
    k: integer; // число которое вводит пользователь (Среднее должно быть БОЛЬШЕ него)
begin

  // Переменные a, n, m - глобальне переменны, которые видны во всех процедурах
  // их значения должны быть УЖЕ ЗАДАНЫ при нажатии кнопки {Создать матрицу}

  {Добавляем столбик со Средними арифметическими числами каждой строки в Memo1}
  // обходим строки матрицы
  for i:=1 to n do
  begin
    // Находим Среднее арифметическое чисел в i-ой строке
    ave := FindAverage(a[i], m);
    // В Мемо можно записать только строки
    // FindAverage - возвращет вещественно число
    // Нужно преобразовать это число к типу строк при помощи процедуры str
    // ave:10:2 - числа после функции - тоже самое, что и
    // при выводе при помощи writeln
    // 10 - сколько отводится места на всё число
    // 2 - количество значащих чиел после запятой
    // например writeln(float_number:10:2);
    // float_number в нашем случае - то,
    // что вернёт вызов функции FindAverage(a[i], m) - значение переменной 'ave'
    str(ave:10:2, ave_str);
    // добавляем к каждой строке в Memo справа - это число
    Memo1.Lines[i-1] := Memo1.Lines[i-1] + ave_str;
  end;


   // Получаем число, от польователя, чтобы понять
   // какие строки печатать в Memo2
   // Среднее Арифметическое этих строк БОЛЬШЕ этого числа
   k := StrToInt(InputBox('Обработка', 'Введите число', '50'));

   // Делаем это именно после добавления столбца СРЕДНИХ в Memo1
   // Чтобы можно было посмотреть СРЕДНЕЕ каждой строки и подобрать число K
   // Хотя можно было и вначале получить это число
   // И проверять строки матрицы в цикле выше
   // НИЖЕ же мы повторно вызываем FindAverage,
   // но ЗАТО можем видеть СРЕДНЕЕ строки

   // теперь добавляем строки в Memo2
   for i:=1 to n do
   begin
     // Получаем Среднее для i-ой строки
     ave := FindAverage(a[i], m);
     // Если СРЕДНЕЕ больше K - то это строка должна быть в Memo2
     if (ave > k) then
        PrintAr1(a[i], m, Memo2);
   end;

end;

{Нажали 'Очистить'}
procedure TForm1.Button4Click(Sender: TObject);
begin
  // Нужно очистить два текстовых поля
  // реализация очистки есть внутри этих объектов
  Memo1.Clear;
  Memo2.Clear;
end;

end.

