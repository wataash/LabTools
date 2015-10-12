using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.IO;

namespace RenRHEED
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            Watch();
        }
        FileSystemWatcher watcher = new FileSystemWatcher();
        public void Watch()
        {
            watcher.Path = textBoxMoveFrom.Text;  // TODO change path text changed
            watcher.NotifyFilter = NotifyFilters.LastAccess | NotifyFilters.LastWrite
                      | NotifyFilters.FileName | NotifyFilters.DirectoryName;
            watcher.Filter = "*";

            // Add event handlers.
            watcher.Created += new FileSystemEventHandler(OnCreated);
            watcher.Renamed += new RenamedEventHandler(OnRenamed);

            // Begin watching.
            watcher.EnableRaisingEvents = true;
        }
        private void OnCreated(object source, FileSystemEventArgs e)
        {
            string renFrom = textBoxRenameFrom.Text;
            string renTo = textBoxRenameTo.Text;
            string moveFrom = textBoxMoveFrom.Text;
            string moveTo = textBoxMoveTo.Text;

            string[] tokens = renFrom.Split(new[] { ' ' });
            string fileName = e.Name;
            string[] tokenValues = fileName.Split(new[] { ' ' });

            if (tokens.Length != tokenValues.Length){
                throw new ArgumentException(
                    $"Rename from: {tokens.Length} given," +
                    $"but filename: {fileName.Length}.");
            }

            for (int i = 0; i < tokens.Length; i++)
            {
                renFrom  = renFrom.Replace($"[{tokens[i]}]", tokenValues[i]);
                renTo    = renTo.Replace($"[{tokens[i]}]", tokenValues[i]);
                moveFrom = moveFrom.Replace($"[{tokens[i]}]", tokenValues[i]);
                moveTo   = moveTo.Replace($"[{tokens[i]}]", tokenValues[i]);
            }
            Console.Write("");
        }
        private void OnRenamed(object source, RenamedEventArgs e)
        {
            OnCreated(source, (FileSystemEventArgs)e);
        }
        private void textBoxFileName_TextChanged(object sender, TextChangedEventArgs e)
        {
        }
        private void textBoxMoveFrom_TextChanged(object sender, TextChangedEventArgs e)
        {
            //if (e.Key == Key.Return)
            //{
            //    watcher.Path = textBoxMoveFrom.Text;
            //    MessageBox.Show(watcher.Path);

            //}
        }

        private void button_Click(object sender, RoutedEventArgs e)
        {

        }

        private void buttonUpdate_Click(object sender, RoutedEventArgs e)
        {
            watcher.Path = textBoxMoveFrom.Text;
        }
    }
}
