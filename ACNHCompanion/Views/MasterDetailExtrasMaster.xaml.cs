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
        private MasterDetailExtrasMasterViewModel _masterView;

        public DashboardViewModel DashboardVM { get; set; }

        public MasterDetailExtrasMaster()
        {
            InitializeComponent();

            MasterDetailExtrasMasterViewModel _view = new MasterDetailExtrasMasterViewModel();
            this.BindingContext = _view;

            DateTime userCustomerDateTime = DateTime.Now;
            if (!DesignMode.IsDesignModeEnabled)
            {
                userCustomerDateTime = Helper.GetUserCustomDateTime();
            }

            datePicker.Date = userCustomerDateTime;
            timePicker.Time = userCustomerDateTime.TimeOfDay;

            datePicker.Unfocused += DatePicker_Unfocused;
            timePicker.PropertyChanged += TimePicker_PropertyChanged;
        }

        private void DatePicker_Unfocused(object sender, FocusEventArgs e)
        {
            if(!e.IsFocused)
            {
                //Why is _view null here the first time we reference it? When it is assigned in the ctor..
                if (_masterView is null) { _masterView = (MasterDetailExtrasMasterViewModel)BindingContext; }
                _masterView.SetDatePickerDate((DatePicker)sender);

                timePicker.Focus();
            }
        }

        private void TimePicker_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName != "Time") { return; }
            if (timePicker.Time == TimeSpan.Zero) { return; }

            if (_masterView is null) { _masterView = (MasterDetailExtrasMasterViewModel)BindingContext; }
            _masterView.SetTimePickerTime((TimePicker)sender);

            string totalMinutesDifference = _masterView.GetNewDateTimeMinutesInterval();
            Config timeDifferenceConfig = new Config
            {
                IsEnabled = 1,
                Name = Strings.Config.CUSTOM_USER_TIME_DIFFERENCE,
                Value = totalMinutesDifference
            };

            App.ApplicationDatabase.InsertOrReplaceConfigValue(timeDifferenceConfig);
            App.Config = App.ApplicationDatabase.GetConfigValues();

            timePicker.Time = TimeSpan.Zero;

            DashboardVM?.RefreshLocalTime();
            DashboardVM?.UpdateUpcomingEvent();

            RefreshTabPages();
        }

        private void DatePicker_DateSelected(object sender, DateChangedEventArgs e)
        {
            //Why is _view null here the first time we reference it? When it is assigned in the ctor..
            if (_masterView is null) { _masterView = (MasterDetailExtrasMasterViewModel)BindingContext; }
            _masterView.SetDatePickerDate((DatePicker)sender);

            timePicker.Focus();
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
            _masterView = (MasterDetailExtrasMasterViewModel)this.BindingContext;

            Config hemisphereCurrent = App.Config.Where(c => c.Name == "hemisphere").FirstOrDefault();
            string hemisphereValue = hemisphereCurrent.Value;

            if (hemisphereValue.ToLower() == "north")
            {
                _masterView.Hemisphere = "South";
                hemisphereCurrent.Value = "South";
            }
            else
            {
                _masterView.Hemisphere = "North";
                hemisphereCurrent.Value = "North";
            }

            App.ApplicationDatabase.UpdateConfigValue(hemisphereCurrent);
            App.Config = App.ApplicationDatabase.GetConfigValues();

            RefreshTabPages();
        }
    }
}