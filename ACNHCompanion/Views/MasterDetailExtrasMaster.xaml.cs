using ACNHCompanion.Models;
using ACNHCompanion.ViewModels;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MasterDetailExtrasMaster : ContentPage
    {
        private MasterDetailExtrasMasterViewModel _view;

        public MasterDetailExtrasMaster()
        {
            InitializeComponent();

            MasterDetailExtrasMasterViewModel _view = new MasterDetailExtrasMasterViewModel();
            this.BindingContext = _view;

            _view = (MasterDetailExtrasMasterViewModel)this.BindingContext;

            Config hemisphereCurrent = App.Config.Where(c => c.Name == "hemisphere").FirstOrDefault();
            string hemisphereValue = hemisphereCurrent.Value;

            if (hemisphereValue.ToLower() == "south")
            {
                _view.Hemisphere = "South";
            }
            else
            {
                _view.Hemisphere = "North";
            }

            datePicker.PropertyChanged += DatePicker_PropertyChanged;
        }

        private void DatePicker_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            Debugger.Break();
        }

        private void RefreshTabPages()
        {
            MasterDetailPage parentPage = (MasterDetailPage)this.Parent;

            Home detailPage = (Home)parentPage.Detail;

            detailPage?.FishTab?.RefreshViewModel();
            detailPage?.BugsTab?.RefreshViewModel();
        }

        private void SetTimeButton_Clicked(object sender, EventArgs e)
        {
            datePicker.Focus();
        }

        async private void ResetButton_Clicked(object sender, EventArgs e)
        {
            bool isResetApplicationConfirmed = await DisplayAlert("Reset",
                                "Are you sure you want to reset the application? This will revert it back to it's original state when you first installed the application",
                                "Reset App",
                                "Cancel");
            
            if(isResetApplicationConfirmed)
            {
                DependencyService.Get<IDBInterface>().RestoreAppData();
                App.ApplicationDatabase = new Database();

                RefreshTabPages();
            }
        }

        private void HemisphereButton_Clicked(object sender, EventArgs e)
        {
            _view = (MasterDetailExtrasMasterViewModel)this.BindingContext;

            Config hemisphereCurrent = App.Config.Where(c => c.Name == "hemisphere").FirstOrDefault();
            string hemisphereValue = hemisphereCurrent.Value;

            if (hemisphereValue.ToLower() == "north")
            {
                _view.Hemisphere = "South";
                hemisphereCurrent.Value = "South";
            }
            else
            {
                _view.Hemisphere = "North";
                hemisphereCurrent.Value = "North";
            }

            App.ApplicationDatabase.UpdateConfigValue(hemisphereCurrent);
            App.Config = App.ApplicationDatabase.GetConfigValues();

            RefreshTabPages();
        }
    }
}