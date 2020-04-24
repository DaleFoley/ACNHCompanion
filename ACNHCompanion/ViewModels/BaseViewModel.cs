using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;

using Xamarin.Forms;

using ACNHCompanion.Models;
using System.Windows.Input;
using System.Diagnostics;
using System.Collections.ObjectModel;

namespace ACNHCompanion.ViewModels
{
    public class BaseViewModel : INotifyPropertyChanged
    {
        public string FilterString;

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnNotifyPropertyChanged([CallerMemberName] string memberName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(memberName));
        }

        private ObservableCollection<Critter> _crittersToDisplay;
        public ObservableCollection<Critter> CrittersToDisplay 
        {
            get
            {
                return _crittersToDisplay;
            }
            set
            {
                _crittersToDisplay = value;
                OnNotifyPropertyChanged(nameof(CrittersToDisplay));
            }
        }

        private string _title;
        public string Title 
        {
            get
            {
                return _title;
            }

            set
            {
                _title = value;
                OnNotifyPropertyChanged(nameof(Title));
            }
        }

        public BaseViewModel()
        {
            CrittersToDisplay = new ObservableCollection<Critter>();
        }

        private bool _isRefreshing = false;
        public bool IsRefreshing
        {
            get { return _isRefreshing; }
            set
            {
                _isRefreshing = value;
                OnNotifyPropertyChanged(nameof(IsRefreshing));
            }
        }

        private string GetShadowSizeIcon(string shadowSize)
        {
            //TODO: Get better looking images for shadow size.
            switch (shadowSize)
            {
                case "1":
                    return "fish_shadow_size_1.png";
                case "2":
                    return "fish_shadow_size_2.png";
                case "3":
                    return "fish_shadow_size_3.png";
                case "4":
                    return "fish_shadow_size_4.png";
                case "5":
                    return "fish_shadow_size_5.png";
                case "6":
                    return "fish_shadow_size_6.png";
                case "6 (Fin)":
                    return "fish_shadow_size_6.png";
                default:
                    return "";
            }
        }

        public ObservableCollection<Critter> GetCritterViewModelCollection(List<CritterMonths> dbCritters)
        {
            ObservableCollection<Critter> crittersToDisplay = new ObservableCollection<Critter>();
            foreach (CritterMonths dbCritter in dbCritters)
            {
                Critter critterToAdd = new Critter
                {
                    Id = dbCritter.ID,
                    Name = dbCritter.CritterName,
                    SellIcon = "BellCoin.png",
                    SellPrice = dbCritter.SellPrice,
                    Time = dbCritter.Time,
                    Location = dbCritter.Location,
                    IsDonated = dbCritter.IsDonated,
                    IsSculpted = dbCritter.IsSculpted,
                    Months = dbCritter.Months,
                    Rarity = dbCritter.Rarity,
                    Icon = dbCritter.ImageName,
                    Type = dbCritter.Type
                };

                if(!string.IsNullOrEmpty(dbCritter.ShadowSize))
                {
                    critterToAdd.ShadowSize = dbCritter.ShadowSize;
                    critterToAdd.ShadowSizeIcon = GetShadowSizeIcon(dbCritter.ShadowSize);
                }

                crittersToDisplay.Add(critterToAdd);
            }

            return crittersToDisplay;
        }
    }
}
