using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using Xamarin.Forms;

using ACNHCompanion.Models;
using ACNHCompanion.Views;
using System.Linq;

namespace ACNHCompanion.ViewModels
{
    public class FishViewModel : BaseViewModel
    {
        public FishViewModel()
        {
            RefreshViewModel();
        }

        public void RefreshViewModel()
        {
            Config hemisphereConfig = App.Config.Where(c => c.Name == "hemisphere").FirstOrDefault();
            List<CritterMonths> dbFish = null;

            if (hemisphereConfig.Value == "north")
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
