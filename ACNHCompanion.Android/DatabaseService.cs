﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;

using Android.App;
using Android.Content;
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
        public DatabaseService()
        {
        }

        public SQLiteConnection CreateConnection()
        {
            string sqliteFilename = "app_data.db";
            string documentsDirectoryPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Personal);
            
            string pathToSQLDatabase = Path.Combine(documentsDirectoryPath, sqliteFilename);

            //Uncomment when publishing to prod, once a base release is settled the database shouldn't be overwritten on startup..
            if (!File.Exists(pathToSQLDatabase))
            {
                using (var binaryReader = new BinaryReader(Application.Context.Assets.Open(sqliteFilename)))
                {
                    using (var binaryWriter = new BinaryWriter(new FileStream(pathToSQLDatabase, FileMode.Create)))
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

            var conn = new SQLiteConnection(pathToSQLDatabase, SQLiteOpenFlags.ReadWrite);

            return conn;
        }
    }
}