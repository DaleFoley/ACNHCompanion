using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;

using Android.App;
using Android.Content;
using Android.Content.PM;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using SQLite;

[assembly: Xamarin.Forms.Dependency(typeof(ACNHCompanion.Droid.DatabaseService))]
namespace ACNHCompanion.Droid
{
    public class DatabaseService : ACNHCompanion.IDBInterface
    {
        private const string APP_DATA = "app_data.db";

        private string _pathDocumentsDirectory;
        public DatabaseService()
        {
            _pathDocumentsDirectory = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Personal);
        }

        private void CopyAssetFileToLocation(string pathSourceAsset, string pathTargetFile)
        {
            using (var binaryReader = new BinaryReader(Application.Context.Assets.Open(pathSourceAsset)))
            {
                using (var binaryWriter = new BinaryWriter(new FileStream(pathTargetFile, FileMode.Create)))
                {
                    byte[] buffer = new byte[2048];
                    int length = 0;
                    while ((length = binaryReader.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        binaryWriter.Write(buffer, 0, length);
                    }
                }
            }
        }

        private void CopySQLiteDDLFiles()
        {
            Context context = Application.Context;

            PackageManager manager = context.PackageManager;
            PackageInfo info = manager.GetPackageInfo(context.PackageName, 0);

            int versionCode = info.VersionCode;

            string pathToDDLScriptsSource = "SQL/DDL";
            string pathToDDLScriptsTarget = Path.Combine(_pathDocumentsDirectory, pathToDDLScriptsSource);

            Directory.CreateDirectory(pathToDDLScriptsTarget);

            IEnumerable<string> sqlFiles = Application.Context.Assets.List(pathToDDLScriptsSource).Where(sqlFile => int.Parse(Path.GetFileNameWithoutExtension(sqlFile)) >= versionCode);

            foreach (string sqlDDLFile in sqlFiles)
            {
                pathToDDLScriptsTarget = Path.Combine(pathToDDLScriptsTarget, sqlDDLFile);
                CopyAssetFileToLocation(Path.Combine(pathToDDLScriptsSource, sqlDDLFile), pathToDDLScriptsTarget);
            }
        }

        public void RestoreAppData()
        {
            string pathToSQLDatabase = Path.Combine(_pathDocumentsDirectory, APP_DATA);
            CopyAssetFileToLocation(APP_DATA, pathToSQLDatabase);
        }

        public SQLiteConnection CreateConnection()
        {
            CopySQLiteDDLFiles();

            string pathToSQLDatabase = Path.Combine(_pathDocumentsDirectory, APP_DATA);

            if (!File.Exists(pathToSQLDatabase))
            {
                CopyAssetFileToLocation(APP_DATA, pathToSQLDatabase);
            }

            string db = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Personal) + "/app_data.db";
            System.IO.File.Copy(db, "/sdcard/app_data.db", true);

            return new SQLiteConnection(pathToSQLDatabase, SQLiteOpenFlags.ReadWrite);
        }
    }
}