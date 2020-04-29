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
            MaxCritterCount = App.ApplicationDatabase.GetFishNorthern().Count.ToString();
            RefreshViewModel();
        }

        public Command RefreshCommand
        {
            get
            {
                return new Command(() =>
                {
                    IsRefreshing = true;

                    RefreshViewModel();

                    IsRefreshing = false;
                });
            }
        }

        public void RefreshViewModel()
        {
            Config hemisphereConfig = App.Config.Where(c => c.Name == Strings.Config.HEMISPHERE).FirstOrDefault();
            List<CritterMonths> dbFish = null;

            if (hemisphereConfig.Value.ToLower() == "north")
            {
                dbFish = App.ApplicationDatabase.GetFishNorthern(FilterString);
            }
            else
            {
                dbFish = App.ApplicationDatabase.GetFishSouthern(FilterString);
            }

            FilterCount = dbFish.Count.ToString();
            Title = "Fish - " + hemisphereConfig.Value + " (" + FilterCount + "/" + MaxCritterCount + ")";

            CrittersToDisplay = GetCritterViewModelCollection(dbFish);
        }
    }
}
