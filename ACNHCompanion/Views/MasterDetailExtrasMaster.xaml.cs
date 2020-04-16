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
                _view.Hemisphere = "south_hemi_selected";
            }
            else
            {
                _view.Hemisphere = "north_hemi_selected";
            }
        }

        void TapGestureRecognizer_Tapped(object sender, EventArgs args)
        {
            _view = (MasterDetailExtrasMasterViewModel)this.BindingContext;

            Config hemisphereCurrent = App.Config.Where(c => c.Name == "hemisphere").FirstOrDefault();
            string hemisphereValue = hemisphereCurrent.Value;

            if(hemisphereValue.ToLower() == "north")
            {
                _view.Hemisphere = "south_hemi_selected";
                hemisphereCurrent.Value = "South";
            }
            else
            {
                _view.Hemisphere = "north_hemi_selected";
                hemisphereCurrent.Value = "North";
            }

            App.ApplicationDatabase.UpdateConfigValue(hemisphereCurrent);
            App.Config = App.ApplicationDatabase.GetConfigValues();

            //Refresh the detail page tab pages.
            MasterDetailPage parentPage = (MasterDetailPage)this.Parent;
            Home detailPage = (Home)parentPage.Detail;

            detailPage.FishTab.RefreshViewModel();
            detailPage.BugsTab.RefreshViewModel();
        }
    }
}