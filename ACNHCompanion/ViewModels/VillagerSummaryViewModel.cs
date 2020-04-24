using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.ViewModels
{
    public class VillagerSummaryViewModel
    {
        public List<SpeciesDistinct> DistinctVillagerSpecies { get; set; }
        public int TotalSpeciesCount { get; set; }
        public VillagerSummaryViewModel()
        {
            DistinctVillagerSpecies = new List<SpeciesDistinct>();
            DistinctVillagerSpecies = App.ApplicationDatabase.GetDistinctSpecies();

            foreach (SpeciesDistinct distinctSpecies in DistinctVillagerSpecies)
            {
                TotalSpeciesCount += distinctSpecies.VillagerSpeciesCount;
            }
        }
    }
}
