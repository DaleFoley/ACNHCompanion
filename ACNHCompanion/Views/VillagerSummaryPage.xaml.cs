﻿using ACNHCompanion.ViewModels;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class VillagerSummaryPage : ContentPage
    {
        private VillagerSummaryViewModel _villagersSummaryViewModel;
        public VillagerSummaryPage()
        {
            InitializeComponent();

            _villagersSummaryViewModel = new VillagerSummaryViewModel();
            BindingContext = _villagersSummaryViewModel;
        }

        private void AllVillagersTapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            VillagersViewModel villagerViewModel = new VillagersViewModel();
            Navigation.PushModalAsync(new VillagersPage(villagerViewModel));
        }

        private void VillagerSpeciesTapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            Frame frame = (Frame)sender;
            Grid frameGrid = (Grid)frame.Children[0];
            Label speciesLabel = (Label)frameGrid.Children[1];

            string villagerSpecies = "and Species = '" + speciesLabel.Text + "'";

            VillagersViewModel villagerViewModel = new VillagersViewModel(villagerSpecies);
            Navigation.PushModalAsync(new VillagersPage(villagerViewModel));
        }
    }
}
