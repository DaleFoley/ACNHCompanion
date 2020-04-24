using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace ACNHCompanion.ViewModels
{
    public class DashboardViewModel : INotifyPropertyChanged
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
                _localTime = value;
                OnNotifyPropertyChanged(nameof(LocalTime));
            }
        }

        public DashboardViewModel()
        {
            Device.StartTimer(TimeSpan.FromSeconds(1), () => UpdateLocalTime());
        }

        public bool UpdateLocalTime()
        {
            this.LocalTime = DateTime.Now;
            return true;
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnNotifyPropertyChanged([CallerMemberName] string memberName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(memberName));
        }

    }
}
