using System;
using System.IO;
using SimpleScanner;
using ScannerHelper;
using System.Collections.Generic;

namespace  GeneratedLexer
{
    
    public class LexerAddon
    {
        public Scanner myScanner;
        private byte[] inputText = new byte[255];

        public int idCount = 0;
        public int idSum = 0;
        public int minIdLength = Int32.MaxValue;
        public double avgIdLength = 0;
        public int maxIdLength = 0;
        public int sumInt = 0;
        public double sumDouble = 0.0;
        public List<string> idsInComment = new List<string>();
        

        public LexerAddon(string programText)
        {
            
            using (StreamWriter writer = new StreamWriter(new MemoryStream(inputText)))
            {
                writer.Write(programText);
                writer.Flush();
            }
            
            MemoryStream inputStream = new MemoryStream(inputText);
            
            myScanner = new Scanner(inputStream);
        }

        public void Lex()
        {
            // Чтобы вещественные числа распознавались и отображались в формате 3.14 (а не 3,14 как в русской Culture)
            System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-US");

            int tok = 0;
            do {
                tok = myScanner.yylex();

                // Задание 2
                if (tok == (int)Tok.ID)
                {
                    ++idCount;
                    int l = myScanner.yytext.Length;
                    idSum += l;
                    if (l > maxIdLength)
                        maxIdLength = l;
                    if (l < minIdLength)
                        minIdLength = l;
                }

                // Задание 3
                else if (tok == (int)Tok.INUM)
                    sumInt += myScanner.LexValueInt;
                else if (tok == (int)Tok.RNUM)
                    sumDouble += myScanner.LexValueDouble;

                // Дополнительное задание 4
                else if (tok == (int)Tok.LONGCOMMENT)
                {
                    var words = myScanner.TokToString((Tok)tok).Split(' ');
                    for (int i = 1; i < words.Length - 1; ++i)
                        idsInComment.Add(words[i]);
                }

                if (tok == (int)Tok.EOF)
                {
                    avgIdLength = idSum / (double)idCount;
                    break;
                }
            } while (true);
        }
    }
}

