using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using Xamarin.Forms;

namespace ACNHCompanion.ViewModels
{
    public class MasterDetailExtrasMasterViewModel : ObservableObject
    {
        private DateTime _selectedDate;
        private TimeSpan _selectedTime;

        private string _hemisphere;

        public string Hemisphere
        {
            get
            {
                return _hemisphere;
            }
            set
            {
                if(value != _hemisphere)
                {
                    _hemisphere = value;
                    OnNotifyPropertyChanged(nameof(Hemisphere));
                }
            }
        }

        public MasterDetailExtrasMasterViewModel()
        {
            SetHemipshere();
        }

        public void SetHemipshere()
        {
            Config hemisphere = App.Config.Where(config => config.Name == Strings.Config.HEMISPHERE).FirstOrDefault();
            string hemisphereValue = hemisphere.Value;

            if (hemisphereValue.ToLower() == "south")
            {
                Hemisphere = "South";
            }
            else
            {
                Hemisphere = "North";
            }
        }

        public void SetDatePickerDate(DatePicker datePicker)
        {
            _selectedDate = datePicker.Date;
        }

        public void SetTimePickerTime(TimePicker timePicker)
        {
            _selectedTime = timePicker.Time;
        }

        public string GetNewDateTimeMinutesInterval()
        {
            _selectedDate = new DateTime(_selectedDate.Year,
                 _selectedDate.Month, _selectedDate.Day, _selectedTime.Hours, _selectedTime.Minutes, 0);

            DateTime currentDateTime = DateTime.Now;
            TimeSpan newDateTimeInterval = _selectedDate.Subtract(currentDateTime);

            string totalMinutesDifference;
            if (newDateTimeInterval.TotalMinutes < 0)
            {
                totalMinutesDifference = newDateTimeInterval.TotalMinutes.ToString() + " minute";
            }
            else
            {
                totalMinutesDifference = "+" + newDateTimeInterval.TotalMinutes.ToString() + " minute";
            }

            return totalMinutesDifference;
        }
    }
}
