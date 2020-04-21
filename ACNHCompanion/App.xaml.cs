using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using ACNHCompanion.Views;
using System.Collections.Generic;
using ACNHCompanion.Models;
using System.Diagnostics;

namespace ACNHCompanion
{
    public partial class App : Application
    {
        public static Database ApplicationDatabase;
        public static List<Config> Config;
        public App()
        {
            InitializeComponent();

            if (!DesignMode.IsDesignModeEnabled)
            {
                ApplicationDatabase = new Database();
                ApplicationDatabase.ApplySchemaChangesBasedOnAppVersion();

                Config = ApplicationDatabase.GetConfigValues();
            }

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
