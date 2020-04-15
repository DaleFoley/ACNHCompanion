using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
            List<CritterMonths> dbBugs = App.ApplicationDatabase.GetBugsNorthern();
            
            Title = "Bugs";
            CrittersToDisplay = GetCritterViewModelCollection(dbBugs);
        }
    }
}
