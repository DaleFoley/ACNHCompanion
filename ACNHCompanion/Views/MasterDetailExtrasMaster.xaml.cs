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

        private DateTime _selectedDate;
        private TimeSpan _selectedTime;

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

            datePicker.DateSelected += DatePicker_DateSelected;
            timePicker.PropertyChanged += TimePicker_PropertyChanged;
        }

        private void TimePicker_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            //TODO: Fix logic in SQL views to account month based on current time for critters
            TimePicker timePickerControl = (TimePicker)sender;
            if (timePickerControl.Time == TimeSpan.Zero) { return; }

            TimeSpan s = timePickerControl.Time;

            _selectedDate = new DateTime(_selectedDate.Year, _selectedDate.Month, _selectedDate.Day, s.Hours, s.Minutes, 0);

            DateTime now = DateTime.Now;
            TimeSpan newDateTimeInterval = _selectedDate.Subtract(now);

            string totalMinutesDifference;
            if(newDateTimeInterval.TotalMinutes < 0)
            {
                totalMinutesDifference = newDateTimeInterval.TotalMinutes.ToString();
            }
            else
            {
                totalMinutesDifference = "+" + newDateTimeInterval.TotalMinutes.ToString();
            }

            timePickerControl.Time = TimeSpan.Zero;

            Config timeDifferenceConfig = new Config
            {
                IsEnabled = 1,
                Name = "customUserTimeDifference",
                Value = totalMinutesDifference
            };

            App.ApplicationDatabase.InsertOrReplaceConfigValue(timeDifferenceConfig);
        }

        private void DatePicker_DateSelected(object sender, DateChangedEventArgs e)
        {
            DatePicker datePickerControl = (DatePicker)sender;
            _selectedDate = datePickerControl.Date;

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