using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using Xamarin.Forms;

using ACNHCompanion.Models;
using ACNHCompanion.Views;

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
            List<CritterMonths> dbFish = App.ApplicationDatabase.GetFishNorthern();

            Title = "Fish";
            CrittersToDisplay = GetCritterViewModelCollection(dbFish);
        }
    }
}
