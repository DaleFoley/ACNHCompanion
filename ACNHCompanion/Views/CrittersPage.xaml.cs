using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

using ACNHCompanion.Models;
using ACNHCompanion.Views;
using ACNHCompanion.ViewModels;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CrittersPage : ContentPage
    {
        public CrittersPage()
        {
            InitializeComponent();
        }

        void OnImageNameTapped(object sender, EventArgs args)
        {
            try
            {
                TappedEventArgs e = (TappedEventArgs)args;

                Critter critterSelected = (Critter)e.Parameter;
                critterSelected.IsDonated = critterSelected.IsDonated ? false : true;

                DBModels.Critters critterToUpdate = new DBModels.Critters
                {
                    critter_name = critterSelected.Name,
                    id = critterSelected.Id,
                    image_name = critterSelected.Icon,
                    is_donated = critterSelected.IsDonated,
                    location = critterSelected.Location,
                    rarity = critterSelected.Rarity,
                    sell_price = (int)critterSelected.SellPrice,
                    shadow_size = critterSelected.ShadowSize,
                    time = critterSelected.Time,
                    type = critterSelected.Type
                };

                App.ApplicationDatabase.UpdateCritterIsDonated(critterToUpdate);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}