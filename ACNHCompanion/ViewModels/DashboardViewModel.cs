using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace ACNHCompanion.ViewModels
{
    public class DashboardViewModel : ObservableObject
    {
        private DateTime _localTime;
        public DateTime LocalTime
        {
            get
            {
                return _localTime;
            }

            set
            {
                if(value != _localTime)
                {
                    _localTime = value;
                    OnNotifyPropertyChanged(nameof(LocalTime));
                }
            }
        }

        public DashboardViewModel()
        {
            RefreshLocalTime();
            Device.StartTimer(TimeSpan.FromSeconds(1), () => UpdateLocalTime());
        }

        public void RefreshLocalTime()
        {
            _localTime = Helper.GetUserCustomDateTime();
        }

        public bool UpdateLocalTime()
        {
            this.LocalTime = this.LocalTime.AddSeconds(1);
            return true;
        }
    }
}
