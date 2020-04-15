using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;

namespace ACNHCompanion.ViewModels
{
    public class BugsViewModel : BaseViewModel
    {
        public BugsViewModel()
        {
            RefreshViewModel();
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
