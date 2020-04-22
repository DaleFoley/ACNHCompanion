using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Text;
using Xamarin.Forms;

namespace ACNHCompanion.ViewModels
{
    public class MasterDetailExtrasMasterViewModel : INotifyPropertyChanged
    {
        public MasterDetailExtrasMasterViewModel()
        {
            _hemisphere = "North";
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnNotifyPropertyChanged([CallerMemberName] string memberName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(memberName));
        }

        private string _hemisphere;
        public string Hemisphere
        {
            get
            {
                return _hemisphere;
            }
            set
            {
                _hemisphere = value;
                OnNotifyPropertyChanged();
            }
        }

    }
}
