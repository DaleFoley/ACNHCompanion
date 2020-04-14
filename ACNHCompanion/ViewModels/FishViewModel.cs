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
            List<DBModels.CritterMonth> dbCritters = App.ApplicationDatabase.GetFishNorthern();

            Title = "Fish";

            //TODO: DRY
            foreach (DBModels.CritterMonth dbCritter in dbCritters)
            {
                Models.Critter critterToAdd = new Models.Critter
                {
                    Id = dbCritter.id,
                    Name = dbCritter.critter_name,
                    SellIcon = "BellCoin",
                    SellPrice = dbCritter.sell_price,
                    Time = dbCritter.time,
                    Location = dbCritter.location,
                    IsDonated = dbCritter.is_donated,
                    Months = dbCritter.months,
                    Rarity = dbCritter.rarity,
                    Icon = dbCritter.image_name,
                    ShadowSize = dbCritter.shadow_size,
                    Type = dbCritter.type
                };

                critterToAdd.ShadowSizeIcon = GetShadowSizeIcon(critterToAdd.ShadowSize);

                Critters.Add(critterToAdd);
            }
        }

        private string GetShadowSizeIcon(string shadowSize)
        {
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
    }
}
