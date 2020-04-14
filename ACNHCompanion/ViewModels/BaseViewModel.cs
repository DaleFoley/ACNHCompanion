using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;

using Xamarin.Forms;

using ACNHCompanion.Models;
using ACNHCompanion.Services;
using System.Windows.Input;
using System.Diagnostics;
using System.Collections.ObjectModel;

namespace ACNHCompanion.ViewModels
{
    public class BaseViewModel
    {
        public ObservableCollection<Critter> Critters { get; set; }
        public string Title { get; set; }

        public BaseViewModel()
        {
            Critters = new ObservableCollection<Critter>();
        }
    }
}
