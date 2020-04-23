using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;

namespace ACNHCompanion.ViewModels
{
    public class GlobalSearchViewModel : BaseViewModel
    {
        private string _searchCriteria;

        public List<CritterMonths> Fish { get; set; }
        public List<CritterMonths> Bugs { get; set; }
        public ObservableCollection<Critter> BugsDisplay { get; set; }
        public ObservableCollection<Critter> FishDisplay { get; set; }

        public GlobalSearchViewModel(string searchCriteria)
        {
            _searchCriteria = searchCriteria;

            Bugs = App.ApplicationDatabase.GetBugsNorthernSearch(_searchCriteria);
            Fish = App.ApplicationDatabase.GetFishNorthernSearch(_searchCriteria);

            BugsDisplay = GetCritterViewModelCollection(Bugs);
            FishDisplay = GetCritterViewModelCollection(Fish);
        }

    }
}
