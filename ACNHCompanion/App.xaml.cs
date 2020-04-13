using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using ACNHCompanion.Services;
using ACNHCompanion.Views;

namespace ACNHCompanion
{
    public partial class App : Application
    {
        public static DatabaseManager ApplicationDatabase;
        public App()
        {
            InitializeComponent();

            ApplicationDatabase = new DatabaseManager();

            DependencyService.Register<MockDataStore>();
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
