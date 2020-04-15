using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using Xamarin.Forms;

using ACNHCompanion.Models;
using ACNHCompanion.Views;
using System.Linq;
using System.Diagnostics;

namespace ACNHCompanion.ViewModels
{
    public class FishViewModel : BaseViewModel
    {
        public FishViewModel()
        {
            RefreshViewModel();
        }

        private bool _isRefreshing = false;
        public bool IsRefreshing
        {
            get { return _isRefreshing; }
            set
            {
                _isRefreshing = value;
                OnNotifyPropertyChanged(nameof(IsRefreshing));
            }
        }

        public Command RefreshCommand
        {
            get
            {
                return new Command(async () =>
                {
                    IsRefreshing = true;

                    RefreshViewModel();

                    IsRefreshing = false;
                });
            }
        }

        public void RefreshViewModel()
        {
            Config hemisphereConfig = App.Config.Where(c => c.Name == "hemisphere").FirstOrDefault();
            List<CritterMonths> dbFish = null;

            if (hemisphereConfig.Value.ToLower() == "north")
            {
                dbFish = App.ApplicationDatabase.GetFishNorthern();
            }
            else
            {
                dbFish = App.ApplicationDatabase.GetFishSouthern();
            }

            Title = "Fish - " + hemisphereConfig.Value;
            CrittersToDisplay = GetCritterViewModelCollection(dbFish);
        }
    }
}
