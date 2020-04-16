using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using ACNHCompanion.Views;
using System.Collections.Generic;
using ACNHCompanion.Models;
using System.Diagnostics;

//Current thoughts on controlling DB Schema:

//Option A:
//DB version controlling. Add row to config to define DBVersion. With every publish add new SQL script file using version number
//scheme 1.x.x. This string is compared with DBVersion in config. If the value in config does not equal the file name, apply the SQL in that file.

//Option B:
//Always overwrite the database, but make a backup first. Use the old backup to re-update the new rows to their appropriate values. This would slow down startup.

//Option C:
//Kind of a combination of A and B. Check the DBVersion in config. If it is less than the app version, perform the operations defined in Option B.
namespace ACNHCompanion
{
    public partial class App : Application
    {
        public static DatabaseManager ApplicationDatabase;
        public static List<Config> Config;
        public App()
        {
            InitializeComponent();

            ApplicationDatabase = new DatabaseManager();
            Config = ApplicationDatabase.GetConfigValues();

            MainPage = new MasterDetailExtras();
        }

        protected override void OnStart()
        {
        }

        protected override void OnSleep()
        {
        }

        protected override void OnResume()
        {
        }
    }
}
