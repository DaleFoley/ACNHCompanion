using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;

namespace ACNHCompanion.ViewModels
{
    public class VillagersViewModel : INotifyPropertyChanged
    {
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
        }
               
        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnNotifyPropertyChanged([CallerMemberName] string memberName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(memberName));
        }
    }
}
