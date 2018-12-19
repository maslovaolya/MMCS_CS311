%using ScannerHelper;
%namespace SimpleScanner

Alpha 	[a-zA-Z_]
Digit   [0-9] 
AlphaDigit {Alpha}|{Digit}
INTNUM  {Digit}+
REALNUM {INTNUM}\.{INTNUM}
ID {Alpha}{AlphaDigit}* 
DotChr [^\r\n]
OneLineCmnt \/\/{DotChr}*
Str \'[^']*\'

// Здесь можно делать описания типов, переменных и методов - они попадают в класс Scanner
%{
  public int LexValueInt;
  public double LexValueDouble;
  public string IDs;
%}

%x COMMENT

%%
{INTNUM} { 
  LexValueInt = int.Parse(yytext);
  return (int)Tok.INUM;
}

{REALNUM} { 
  LexValueDouble = double.Parse(yytext);
  return (int)Tok.RNUM;
}

begin { 
  return (int)Tok.BEGIN;
}

end { 
  return (int)Tok.END;
}

cycle { 
  return (int)Tok.CYCLE;
}

{ID}  { 
  return (int)Tok.ID;
}

// Дополнительные задания

{OneLineCmnt} {
  return (int)Tok.COMMENT;
}

"{" {
  BEGIN(COMMENT);
  IDs = "";
}

<COMMENT> begin {
  IDs += "";
}

<COMMENT> end {
  IDs += "";
}

<COMMENT> cycle {
  IDs += "";
}

<COMMENT> <<EOF>> {
  CommentError();
  return 0;
}

<COMMENT> {ID} {
  IDs += yytext + " ";
}

<COMMENT> "}" {
  BEGIN(INITIAL);
  return (int)Tok.LONGCOMMENT;
}

{Str} {
  return (int)Tok.STRINGAP;
}

":" { 
  return (int)Tok.COLON;
}

":=" { 
  return (int)Tok.ASSIGN;
}

";" { 
  return (int)Tok.SEMICOLON;
}

[^ \r\n] {
	LexError();
	return 0; // конец разбора
}

%%

// Здесь можно делать описания переменных и методов - они тоже попадают в класс Scanner

public void LexError()
{
	Console.WriteLine("({0},{1}): Неизвестный символ {2}", yyline, yycol, yytext);
}

public void CommentError()
{
	Console.WriteLine("Незакрытый комментарий, отсутствует }.");
}

public string TokToString(Tok tok)
{
	switch (tok)
	{
		case Tok.ID:
			return tok + " " + yytext;
		case Tok.INUM:
			return tok + " " + LexValueInt;
		case Tok.RNUM:
			return tok + " " + LexValueDouble;
		case Tok.LONGCOMMENT:
			return tok + " " + IDs;
		default:
			return tok + "";
	}
}

