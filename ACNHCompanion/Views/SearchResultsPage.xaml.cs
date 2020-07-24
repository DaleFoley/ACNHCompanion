using ACNHCompanion.Models;
using ACNHCompanion.ViewModels;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class SearchResultsPage : ContentPage
    {
        public GlobalSearchViewModel GlobalSearchViewModel { get; set; }
        public SearchResultsPage(string searchCriteria)
        {
            InitializeComponent();

            GlobalSearchViewModel = new GlobalSearchViewModel(searchCriteria);
            BindingContext = GlobalSearchViewModel;

            if (GlobalSearchViewModel.BugsDisplay.Count == 0)
            {
                bugResultLabel.IsVisible = true;
                bugButton.IsVisible = false;
            }
            else
            {
                ContentView bugsContentView = new CritterContentView();
                bugsContentView.Content.SetBinding(ItemsView.ItemsSourceProperty, "BugsDisplay");

                collectionBugs.Children.Add(bugsContentView);

                bugsHeaderLabel.Text += " (" + GlobalSearchViewModel.BugsDisplay.Count + ")";
            }

            if (GlobalSearchViewModel.FishDisplay.Count == 0)
            {
                fishResultLabel.IsVisible = true;
                fishButton.IsVisible = false;
            }
            else
            {
                ContentView fishContentView = new CritterContentView();
                fishContentView.Content.SetBinding(ItemsView.ItemsSourceProperty, "FishDisplay");

                collectionFish.Children.Add(fishContentView);

                fishHeaderLabel.Text += " (" + GlobalSearchViewModel.FishDisplay.Count + ")";
            }

            if(GlobalSearchViewModel.VillagersViewModel.VillagersDisplay.Count == 0)
            {
                villagerResultLabel.IsVisible = true;
                villagerButton.IsVisible = false;
            }
            else
            {
                ContentView villagerContentView = new VillagersContentView(GlobalSearchViewModel.VillagersViewModel);
                villagerContentView.Content.SetBinding(ItemsView.ItemsSourceProperty, "VillagersDisplay");

                collectionVillagers.Children.Add(villagerContentView);

                villagerHeaderLabel.Text += " (" + GlobalSearchViewModel.VillagersViewModel.VillagersDisplay.Count + ")";
            }
        }

        private void ToggleHideShowBugs_Clicked(object sender, EventArgs e)
        {
            ToggleStackLayoutDisplay(collectionBugs, (Button)sender);
        }

        private void ToggleHideShowFish_Clicked(object sender, EventArgs e)
        {
            ToggleStackLayoutDisplay(collectionFish, (Button)sender);
        }
        private void ToggleHideShowVillagers_Clicked(object sender, EventArgs e)
        {
            ToggleStackLayoutDisplay(collectionVillagers, (Button)sender);
        }

        private void ToggleStackLayoutDisplay(StackLayout collection, Button button)
        {
            Grid grid = (Grid)collection.Parent;
            object rowID = collection.GetValue(Grid.RowProperty);

            GridLength gridLengthShown = new GridLength(0, GridUnitType.Auto);
            GridLength gridLengthHidden = new GridLength(0, GridUnitType.Absolute);

            if (collection.IsVisible)
            {
                collection.IsVisible = false;
                grid.RowDefinitions[(int)rowID].Height = gridLengthHidden;

                button.Text = "Show";
            }
            else
            {
                collection.IsVisible = true;
                grid.RowDefinitions[(int)rowID].Height = gridLengthShown;

                button.Text = "Hide";
            }
        }
    }
}