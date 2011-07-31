using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace XmlEmbed
{
	class Program
	{
		static void Main(string[] args)
		{
			if (args.Length != 2)	// if no arguments:
			{
				// show the help:
				//Console.WriteLine("ARGS:" + args.Length);
				Console.WriteLine("XmlEmbed 1.0 for FlashGameEngine");
				Console.WriteLine("--------------------------------");
				Console.WriteLine("How to use:");
				Console.WriteLine("xmlembed.exe --xml_path=./path1/xml/ --result_path=./path2/");
				// --xml_path=./xml/ --result_path=./result/
			}
			else
			{
				string xml_path = "";
				string result_path = "";

				for (int i = 0; i < args.Length; i++)
				{
					if (args[i].IndexOf("--xml_path=") == 0)
						xml_path = args[i].Substring( "--xml_path=".Length );
					else if (args[i].IndexOf("--result_path=") == 0)
						result_path = args[i].Substring("--result_path=".Length);
				}

				var generator = new EmbedClassGen();
				string result_class = generator.GenerateEmbedClass(xml_path);

				StreamWriter sw = new StreamWriter(result_path + "XmlEmbed.as");
				sw.Write(result_class);
				sw.Flush();
				sw.Close();

				Console.WriteLine("'XmlEmbed.as' was generated.");
			}
		}
	}
}
