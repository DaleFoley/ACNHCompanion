using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.ViewModels
{
    public class VillagerSummaryViewModel : ObservableObject
    {
        public List<SpeciesDistinct> DistinctVillagerSpecies { get; set; }
        public int TotalSpeciesCount { get; set; }

        private int _residentCount;
        public int ResidentCount { get { return _residentCount; } set { if (value != _residentCount) { _residentCount = value; OnNotifyPropertyChanged(nameof(ResidentCount)); } } }
        public VillagerSummaryViewModel()
        {
            DistinctVillagerSpecies = new List<SpeciesDistinct>();
            DistinctVillagerSpecies = App.ApplicationDatabase.GetDistinctSpecies();

            foreach (SpeciesDistinct distinctSpecies in DistinctVillagerSpecies)
            {
                TotalSpeciesCount += distinctSpecies.VillagerSpeciesCount;
            }

            SetResidentCount();
        }

        public void SetResidentCount()
        {
            ResidentCount = App.ApplicationDatabase.GetVillagerResidents().Count;
        }
    }
}
