using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Permissions;

namespace LabTools
{
    class RenRheedConsole
    {
        public static void Main(string[] args)
        {
            Watch();
        }

        [PermissionSet(SecurityAction.Demand, Name = "FullTrust")]
        public static void Watch()
        {
            string[] args = System.Environment.GetCommandLineArgs();
            /// args:
            /// "C:/Users/wsh/Desktop"
            /// "C:\users\wsh\Desktop\RHEED\1[d]0"
            /// "d C"
            /// "07_Au_[h]h[mm]m[ss]s_[C]C.tif"
            /// "2015/10/12 20:50:00"
            
            // If a directory is not specified, exit program.
            if (args.Length != 6)
            {
                // Display the proper way to call the program.
                Console.WriteLine("Wrong arguments");
                return;
            }

            FileSystemWatcher watcher = new FileSystemWatcher();
            watcher.Path = args[1];
            watcher.NotifyFilter = NotifyFilters.LastAccess | NotifyFilters.LastWrite
                      | NotifyFilters.FileName | NotifyFilters.DirectoryName;
            watcher.Filter = "*.tif";

            // Add event handlers.
            watcher.Created += new FileSystemEventHandler(OnCreated);
            watcher.Renamed += new RenamedEventHandler(OnRenamed);

            // Begin watching.
            watcher.EnableRaisingEvents = true;
            
            // Wait for the user to quit the program.
            Console.WriteLine("Press \'q\' to quit the sample.");
            while (Console.Read() != 'q') ;
        }
        private static void OnCreated(object source, FileSystemEventArgs e)
        {
            string[] args = System.Environment.GetCommandLineArgs();

            //string moveFrom = args[1];
            string moveTo = args[2];
            string renFrom = args[3];
            string renTo = args[4];
            string time = args[5];  // 2015/10/12 

            string[] tokens = renFrom.Split(new[] { ' ' });
            string fileName = e.Name;
            string[] tokenValues = fileName.Replace(".tif", "").Split(new[] { ' ' });

            if (tokens.Length != tokenValues.Length)
            {
                Console.WriteLine(
                    $"Rename from: {tokens.Length} given," +
                    $"but filename: {tokenValues.Length}.");
                return;
            }

            for (int i = 0; i < tokens.Length; i++)
            {
                moveTo = moveTo.Replace($"[{tokens[i]}]", tokenValues[i]);
                renFrom = renFrom.Replace($"[{tokens[i]}]", tokenValues[i]);
                renTo = renTo.Replace($"[{tokens[i]}]", tokenValues[i]);
            }

            var dt = DateTime.Parse(args[5]);
            // [h][m][mm][ss]
            //DateTime.Now
            TimeSpan ts = DateTime.Now.Subtract(dt);
            renTo = renTo.
                Replace("[h]", ts.Hours.ToString()).
                Replace("[m]", ts.Minutes.ToString()).
                Replace("[mm]", ts.Minutes.ToString().PadLeft(2, '0')).
                Replace("[ss]", ts.Seconds.ToString().PadLeft(2, '0'));
            try
            {
                string moveToFullPath = moveTo + "\\" + renTo;
                File.Move(e.FullPath, moveToFullPath);
                Console.WriteLine($"Move: {e.FullPath} to {moveToFullPath}");
            }
            catch (DirectoryNotFoundException)
            {
                Console.WriteLine($"directory not found: {moveTo}");
            }
        }
        private static void OnRenamed(object source, RenamedEventArgs e)
        {
            OnCreated(source, (FileSystemEventArgs)e);
        }
    }
}
