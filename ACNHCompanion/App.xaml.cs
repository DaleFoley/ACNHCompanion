using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using ACNHCompanion.Views;
using System.Collections.Generic;
using ACNHCompanion.Models;
using System.Diagnostics;
using Plugin.Permissions.Abstractions;
using Plugin.Permissions;

namespace ACNHCompanion
{
    public partial class App : Application
    {
        public static Database ApplicationDatabase;
        public static List<Config> Config;
        public App()
        {
            InitializeComponent();

            TestPermissions();

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

        async private void TestPermissions()
        {
            PermissionStatus status = await CrossPermissions.Current.RequestPermissionAsync<StoragePermission>();
        }
    }
}
