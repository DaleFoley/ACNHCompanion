using ACNHCompanion.Models;
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

        private List<Villagers> _villagersWithBirthdays;
        public List<Villagers> VillagersWithBirthdays
        {
            get { return _villagersWithBirthdays; }
            set { if (value != _villagersWithBirthdays) { _villagersWithBirthdays = value; OnNotifyPropertyChanged(nameof(VillagersWithBirthdays)); } }
        }

        public DashboardViewModel()
        {
            RefreshLocalTime();
            Device.StartTimer(TimeSpan.FromSeconds(1), () => UpdateLocalTime());

            _villagersWithBirthdays = App.ApplicationDatabase.GetVillagersWithUpcomingBirthdays();
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
