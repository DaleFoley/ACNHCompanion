﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

using ACNHCompanion.Models;
using ACNHCompanion.Views;
using ACNHCompanion.ViewModels;
using System.Diagnostics;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CrittersPage : ContentPage
    {
        public CrittersPage()
        {
            InitializeComponent();
        }

        void OnDonatedTapped(object sender, EventArgs args)
        {
            try
            {
                TappedEventArgs e = (TappedEventArgs)args;

                Critter critterSelected = (Critter)e.Parameter;
                critterSelected.IsDonated = critterSelected.IsDonated ? false : true;

                Critters critterToUpdate = new Critters
                {
                    CritterName = critterSelected.Name,
                    ID = critterSelected.Id,
                    ImageName = critterSelected.Icon,
                    IsDonated = critterSelected.IsDonated,
                    Location = critterSelected.Location,
                    Rarity = critterSelected.Rarity,
                    SellPrice = (int)critterSelected.SellPrice,
                    ShadowSize = critterSelected.ShadowSize,
                    Time = critterSelected.Time,
                    Type = critterSelected.Type
                };

                App.ApplicationDatabase.UpdateCritterIsDonated(critterToUpdate);
            }
            catch (Exception)
            {
                Debugger.Break();
                throw;
            }
        }
    }
}