using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using Xamarin.Forms;

namespace ACNHCompanion.ViewModels
{
    public class BugsViewModel : BaseViewModel
    {
        public BugsViewModel()
        {
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
            Config hemisphereConfig = App.Config.Where(c => c.Name == "hemisphere").FirstOrDefault();
            List<CritterMonths> dbBugs = null;

            if (hemisphereConfig.Value.ToLower() == "north")
            {
                dbBugs = App.ApplicationDatabase.GetBugsNorthern();
            }
            else
            {
                dbBugs = App.ApplicationDatabase.GetBugsSouthern();
            }

            Title = "Bugs - " + hemisphereConfig.Value;
            CrittersToDisplay = GetCritterViewModelCollection(dbBugs);
        }
    }
}
