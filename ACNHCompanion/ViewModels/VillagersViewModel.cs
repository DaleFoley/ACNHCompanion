using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;
using System.Windows.Input;
using Xamarin.Forms;

namespace ACNHCompanion.ViewModels
{
    public class VillagersViewModel
    {
        public ICommand UpdateVillagerIsResident { private set; get; }

        public List<Villagers> Villagers { get; set; }
        public ObservableCollection<VillagerDisplay> VillagersDisplay { get; set; }

        public VillagersViewModel(string filterString = "")
        {
            Villagers = App.ApplicationDatabase.GetVillagers(filterString);
            VillagersDisplay = new ObservableCollection<VillagerDisplay>();

            foreach (Villagers villager in Villagers)
            {
                VillagerDisplay villagerToAdd = new VillagerDisplay
                {
                    ID = villager.ID,
                    VillagerName = villager.Name,
                    VillagerBirthday = villager.Birthday,
                    VillagerSpecies = villager.Species,
                    VillagerPersonality = villager.Personality,
                    VillagerCatchPhrase = villager.CatchPhrase,
                    VillagerIcon = villager.IconName,
                    VillagerImage = villager.ImageName,
                    IsResident = villager.IsResident
                };

                VillagersDisplay.Add(villagerToAdd);
            }

            UpdateVillagerIsResident = new Command(OnUpdateIsVillagerResident);
        }

        public void OnUpdateIsVillagerResident(object parameter)
        {
            if(parameter is null) { return; }
            VillagerDisplay selectedVillager = parameter as VillagerDisplay;

            //TODO: Change IsResident to bool data type.
            if (selectedVillager.IsResident == 0)
            {
                selectedVillager.IsResident = 1;
            }
            else
            {
                selectedVillager.IsResident = 0;
            }

            App.ApplicationDatabase.UpdatedVillagerIsResident(selectedVillager.ID, selectedVillager.IsResident);
        }
    }
}
